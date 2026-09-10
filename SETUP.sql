-- ProjectforASP Database Setup Script
-- SQL Server / LocalDB
-- Creates all necessary tables for the Cloud Money Transfer System

-- =============================================================================
-- 1. USERS TABLE
-- =============================================================================
CREATE TABLE Users (
    UserId INT PRIMARY KEY IDENTITY(1,1),
    AccountNo VARCHAR(20) NOT NULL UNIQUE,
    FirstName NVARCHAR(MAX) NOT NULL,
    LastName NVARCHAR(MAX) NOT NULL,
    Username NVARCHAR(MAX) NOT NULL UNIQUE,
    Password NVARCHAR(MAX) NOT NULL,  -- Store hashed password (BCrypt)
    DateRegistered DATETIME DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1
);

-- =============================================================================
-- 2. ACCOUNTS TABLE
-- =============================================================================
CREATE TABLE Accounts (
    AccountId INT PRIMARY KEY IDENTITY(1,1),
    UserId INT NOT NULL FOREIGN KEY REFERENCES Users(UserId) ON DELETE CASCADE,
    Balance DECIMAL(18, 2) DEFAULT 0,
    LastModified DATETIME DEFAULT GETDATE()
);

-- =============================================================================
-- 3. TRANSACTIONS TABLE
-- =============================================================================
CREATE TABLE Transactions (
    TransactionId INT PRIMARY KEY IDENTITY(1,1),
    UserId INT NOT NULL FOREIGN KEY REFERENCES Users(UserId) ON DELETE CASCADE,
    TransactionType VARCHAR(20) NOT NULL,  -- 'Sent', 'Received', 'Deposit', 'Withdrawal'
    Amount DECIMAL(18, 2) NOT NULL,
    Debit DECIMAL(18, 2),                   -- Amount deducted (for outgoing)
    Credit DECIMAL(18, 2),                  -- Amount added (for incoming)
    BalanceAfter DECIMAL(18, 2) NOT NULL,
    SentTo VARCHAR(20),                     -- Recipient account number
    ReceivedFrom VARCHAR(20),               -- Sender account number
    DateCreated DATETIME DEFAULT GETDATE()
);

-- =============================================================================
-- 4. NOTIFICATIONS TABLE
-- =============================================================================
CREATE TABLE Notifications (
    NotificationId INT PRIMARY KEY IDENTITY(1,1),
    UserId INT NOT NULL FOREIGN KEY REFERENCES Users(UserId) ON DELETE CASCADE,
    Message NVARCHAR(MAX) NOT NULL,
    IsRead BIT DEFAULT 0,
    DateCreated DATETIME DEFAULT GETDATE()
);

-- =============================================================================
-- 5. USER SESSIONS TABLE
-- =============================================================================
CREATE TABLE UserSessions (
    SessionId INT PRIMARY KEY IDENTITY(1,1),
    UserId INT NOT NULL FOREIGN KEY REFERENCES Users(UserId) ON DELETE CASCADE,
    SessionToken NVARCHAR(256),
    CreatedAt DATETIME DEFAULT GETDATE(),
    ExpiresAt DATETIME
);

-- =============================================================================
-- 6. AUDIT LOG TABLE (for security tracking)
-- =============================================================================
CREATE TABLE AuditLog (
    AuditId INT PRIMARY KEY IDENTITY(1,1),
    UserId INT FOREIGN KEY REFERENCES Users(UserId) ON DELETE SET NULL,
    Action VARCHAR(50) NOT NULL,           -- 'LOGIN', 'SEND_MONEY', 'WITHDRAW', etc.
    Details NVARCHAR(MAX),
    IPAddress VARCHAR(45),
    Timestamp DATETIME DEFAULT GETDATE()
);

-- =============================================================================
-- CREATE INDEXES FOR PERFORMANCE
-- =============================================================================

-- Users indexes
CREATE INDEX IX_Users_Username ON Users(Username);
CREATE INDEX IX_Users_AccountNo ON Users(AccountNo);
CREATE INDEX IX_Users_IsActive ON Users(IsActive);

-- Accounts indexes
CREATE INDEX IX_Accounts_UserId ON Accounts(UserId);

-- Transactions indexes
CREATE INDEX IX_Transactions_UserId ON Transactions(UserId);
CREATE INDEX IX_Transactions_DateCreated ON Transactions(DateCreated);
CREATE INDEX IX_Transactions_TransactionType ON Transactions(TransactionType);

-- Notifications indexes
CREATE INDEX IX_Notifications_UserId ON Notifications(UserId);
CREATE INDEX IX_Notifications_DateCreated ON Notifications(DateCreated);

-- AuditLog indexes
CREATE INDEX IX_AuditLog_UserId ON AuditLog(UserId);
CREATE INDEX IX_AuditLog_Action ON AuditLog(Action);
CREATE INDEX IX_AuditLog_Timestamp ON AuditLog(Timestamp);

-- =============================================================================
-- STORED PROCEDURES (OPTIONAL - For improved security)
-- =============================================================================

-- Procedure to create new user
CREATE PROCEDURE sp_CreateUser
    @FirstName NVARCHAR(MAX),
    @LastName NVARCHAR(MAX),
    @Username NVARCHAR(MAX),
    @PasswordHash NVARCHAR(MAX),
    @AccountNo VARCHAR(20)
AS
BEGIN
    BEGIN TRANSACTION
    BEGIN TRY
        INSERT INTO Users (FirstName, LastName, Username, Password, AccountNo)
        VALUES (@FirstName, @LastName, @Username, @PasswordHash, @AccountNo);
        
        DECLARE @UserId INT = SCOPE_IDENTITY();
        
        INSERT INTO Accounts (UserId, Balance)
        VALUES (@UserId, 0);
        
        COMMIT TRANSACTION
        SELECT @UserId AS UserId;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        THROW
    END CATCH
END;

-- Procedure to transfer money (ATOMIC TRANSACTION)
CREATE PROCEDURE sp_TransferMoney
    @SenderUserId INT,
    @ReceiverUserId INT,
    @Amount DECIMAL(18, 2),
    @SenderAccountNo VARCHAR(20),
    @ReceiverAccountNo VARCHAR(20)
AS
BEGIN
    BEGIN TRANSACTION
    BEGIN TRY
        -- Check sender balance
        DECLARE @SenderBalance DECIMAL(18, 2);
        SELECT @SenderBalance = Balance FROM Accounts WHERE UserId = @SenderUserId;
        
        IF @SenderBalance < @Amount
        BEGIN
            ROLLBACK TRANSACTION
            RAISERROR('Insufficient funds', 16, 1);
        END
        
        -- Deduct from sender
        UPDATE Accounts SET Balance = Balance - @Amount WHERE UserId = @SenderUserId;
        
        -- Add to receiver
        UPDATE Accounts SET Balance = Balance + @Amount WHERE UserId = @ReceiverUserId;
        
        -- Get new balances
        DECLARE @SenderNewBalance DECIMAL(18, 2);
        DECLARE @ReceiverNewBalance DECIMAL(18, 2);
        
        SELECT @SenderNewBalance = Balance FROM Accounts WHERE UserId = @SenderUserId;
        SELECT @ReceiverNewBalance = Balance FROM Accounts WHERE UserId = @ReceiverUserId;
        
        -- Record sender transaction
        INSERT INTO Transactions (UserId, TransactionType, Amount, Debit, BalanceAfter, SentTo)
        VALUES (@SenderUserId, 'Sent', @Amount, @Amount, @SenderNewBalance, @ReceiverAccountNo);
        
        -- Record receiver transaction
        INSERT INTO Transactions (UserId, TransactionType, Amount, Credit, BalanceAfter, ReceivedFrom)
        VALUES (@ReceiverUserId, 'Received', @Amount, @Amount, @ReceiverNewBalance, @SenderAccountNo);
        
        -- Create notification for receiver
        INSERT INTO Notifications (UserId, Message)
        VALUES (@ReceiverUserId, 'You received ' + CONVERT(VARCHAR, @Amount, 1) + ' CloudMoney from account ' + @SenderAccountNo);
        
        -- Log transaction
        INSERT INTO AuditLog (UserId, Action, Details)
        VALUES (@SenderUserId, 'SEND_MONEY', 'Sent ' + CONVERT(VARCHAR, @Amount) + ' to ' + @ReceiverAccountNo);
        
        COMMIT TRANSACTION
        SELECT 1 AS Success;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        RAISERROR('Money transfer failed', 16, 1);
    END CATCH
END;

-- Procedure to verify user login
CREATE PROCEDURE sp_VerifyLogin
    @Username NVARCHAR(MAX),
    @UserId INT OUTPUT,
    @PasswordHash NVARCHAR(MAX) OUTPUT
AS
BEGIN
    SELECT 
        @UserId = UserId,
        @PasswordHash = Password
    FROM Users
    WHERE Username = @Username AND IsActive = 1;
    
    IF @UserId IS NULL
    BEGIN
        RAISERROR('User not found', 16, 1);
    END
END;

-- =============================================================================
-- SAMPLE DATA (OPTIONAL - for testing)
-- =============================================================================

-- Note: Replace these password hashes with actual BCrypt hashes
-- Use: BCrypt.HashPassword("password") in C#
-- Example BCrypt hash for "Password123!": $2a$11$slYQmyNdGzin7olVN3p5be

/*
INSERT INTO Users (AccountNo, FirstName, LastName, Username, Password, IsActive)
VALUES 
    ('20260910001001', 'John', 'Doe', 'johndoe', '$2a$11$slYQmyNdGzin7olVN3p5be', 1),
    ('20260910001002', 'Jane', 'Smith', 'janesmith', '$2a$11$slYQmyNdGzin7olVN3p5be', 1);

INSERT INTO Accounts (UserId, Balance)
VALUES 
    (1, 5000.00),
    (2, 3000.00);
*/

-- =============================================================================
-- VERIFICATION QUERIES
-- =============================================================================

-- Check all tables created
SELECT 
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'dbo'
ORDER BY TABLE_NAME;

-- Check table structure
-- SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Users';
