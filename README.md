# ProjectforASP - Cloud Money Transfer System

A web-based financial transaction platform built with ASP.NET Web Forms that enables users to deposit funds, withdraw money, send funds to other users, and view detailed transaction reports.

## Features

- **User Authentication** - Secure login and registration system
- **Account Management** - User profiles with account numbers and balances
- **Money Transfer** - Send funds between user accounts with validation
- **Deposit & Withdrawal** - Add or remove funds from accounts
- **Transaction Reports** - View detailed deposit/withdrawal and sent/received transaction histories
- **Dashboard** - Real-time account overview with balance and notifications
- **Notifications** - Receive alerts for incoming transactions

## Tech Stack

| Component | Technology |
|-----------|-----------|
| **Framework** | ASP.NET Web Forms (.NET Framework 4.7.2) |
| **Language** | C#, JavaScript, HTML/CSS |
| **Database** | SQL Server (LocalDB) |
| **UI Library** | Bootstrap 5.2.3 |
| **Scripting** | jQuery 3.7.0 |
| **ORM/Data Access** | ADO.NET (SqlClient) |

## Project Structure

```
ProjectforASP/
├── Default.aspx(.cs)                  Login page with authentication
├── Dashboard.aspx(.cs)                Main user dashboard
├── Register.aspx(.cs)                 New user registration
├── 
├── Deposit.aspx(.cs)                  Deposit funds interface
├── Withdraw.aspx(.cs)                 Withdraw funds interface
├── SendCloudMoney.aspx(.cs)           Money transfer between accounts
├── ChangePassword.aspx(.cs)           Change user password
├── 
├── DepositWithdrawalReport.aspx       Deposit/withdrawal transaction history
├── SentReceivedReport.aspx            Sent/received transaction history
├── StatementOfAccount.aspx            Full account statement
├── 
├── Site.Master(.cs)                   Main layout template
├── Site.Mobile.Master(.cs)            Mobile responsive template
├── ViewSwitcher.ascx(.cs)             Desktop/mobile toggle control
├── 
├── App_Code/
│   └── DBHelper.cs                    Database connection helper
├── App_Start/
│   ├── BundleConfig.cs                CSS/JS bundling configuration
│   └── RouteConfig.cs                 URL routing configuration
├── Content/                           Bootstrap CSS files
├── Scripts/                           jQuery, Bootstrap, WebForms utilities
├── Images/                            UI images (CTU branding)
├── App_Data/
│   └── CloudMoneyDbss.mdf             SQL Server database file
└── Web.config                         Configuration settings
```

## Database Schema

### Users Table
```sql
CREATE TABLE Users (
    UserId INT PRIMARY KEY IDENTITY(1,1),
    AccountNo VARCHAR(20) NOT NULL,
    FirstName NVARCHAR(MAX),
    LastName NVARCHAR(MAX),
    Username NVARCHAR(MAX) NOT NULL UNIQUE,
    Password NVARCHAR(MAX),
    DateRegistered DATETIME DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1
);
```

### Accounts Table
```sql
CREATE TABLE Accounts (
    AccountId INT PRIMARY KEY IDENTITY(1,1),
    UserId INT FOREIGN KEY REFERENCES Users(UserId),
    Balance DECIMAL(18, 2) DEFAULT 0
);
```

### Transactions Table
```sql
CREATE TABLE Transactions (
    TransactionId INT PRIMARY KEY IDENTITY(1,1),
    UserId INT FOREIGN KEY REFERENCES Users(UserId),
    TransactionType VARCHAR(20),
    Amount DECIMAL(18, 2),
    Debit DECIMAL(18, 2),
    Credit DECIMAL(18, 2),
    BalanceAfter DECIMAL(18, 2),
    SentTo VARCHAR(20),
    ReceivedFrom VARCHAR(20),
    DateCreated DATETIME DEFAULT GETDATE()
);
```

## Getting Started

### Prerequisites

- **Visual Studio** 2019 or later
- **.NET Framework** 4.7.2
- **SQL Server** 2016 or later (or LocalDB for development)
- **IIS Express** (included with Visual Studio)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/kirky-meepo/ProjectforASP.git
   cd ProjectforASP
   ```

2. **Open in Visual Studio**
   ```bash
   start ProjectforASP.slnx
   ```

3. **Restore NuGet Packages**
   - Right-click solution → **Restore NuGet Packages**

4. **Setup Database**
   - Open SQL Server Management Studio
   - Attach `App_Data/CloudMoneyDbss.mdf`

5. **Configure Connection String in Web.config**
   ```xml
   <connectionStrings>
       <add name="CloudMoneyDBss"
            connectionString="Data Source=(LocalDB)\MSSQLLocalDB;Initial Catalog=CloudMoneyDBss;Integrated Security=True"
            providerName="System.Data.SqlClient" />
   </connectionStrings>
   ```

6. **Run the Application**
   - Press **F5** or click **Run**
   - Navigate to `https://localhost:44377/`

## ⚠️ SECURITY VULNERABILITIES & FIXES

### 🔴 CRITICAL: Password Hashing

**Problem:** Passwords stored in plain text in database

**Solution:** Use BCrypt hashing

```bash
# Install BCrypt via NuGet Package Manager
Install-Package BCrypt.Net-Next
```

**In Register.aspx.cs:**
```csharp
using BCrypt.Net;

protected void btnRegister_Click(object sender, EventArgs e)
{
    string password = txtPassword.Text.Trim();
    
    // Hash the password before storing
    string hashedPassword = BCrypt.HashPassword(password);
    
    userCmd.Parameters.AddWithValue("@Password", hashedPassword);
    // ... rest of code
}
```

**In Default.aspx.cs (Login):**
```csharp
SqlCommand cmd = new SqlCommand(
    "SELECT UserId, Password FROM Users WHERE Username=@Username AND IsActive=1", db);
cmd.Parameters.AddWithValue("@Username", username);

SqlDataReader dr = cmd.ExecuteReader();
if (dr.Read())
{
    string storedHash = dr["Password"].ToString();
    
    // Verify password against hash
    if (BCrypt.Verify(password, storedHash))
    {
        // Password is correct - proceed with login
        int userId = Convert.ToInt32(dr["UserId"]);
        Session["UserId"] = userId;
        Response.Redirect("Dashboard.aspx");
    }
    else
    {
        lblMessage.Text = "Invalid username or password.";
    }
}
```

---

### 🔴 CRITICAL: Transaction Control in Money Transfer

**Problem:** Balance updates not atomic - data corruption risk

**Solution:** Wrap updates in SQL transaction

**In SendCloudMoney.aspx.cs (Replace balance update section):**
```csharp
SqlTransaction transaction = db.BeginTransaction();
try
{
    // Deduct from sender
    SqlCommand updateSender = new SqlCommand(
        "UPDATE Accounts SET Balance=@Balance WHERE UserId=@UserId", db);
    updateSender.Transaction = transaction;
    updateSender.Parameters.AddWithValue("@Balance", senderNewBalance);
    updateSender.Parameters.AddWithValue("@UserId", senderUserId);
    updateSender.ExecuteNonQuery();

    // Add to receiver
    SqlCommand updateReceiver = new SqlCommand(
        "UPDATE Accounts SET Balance=@Balance WHERE UserId=@UserId", db);
    updateReceiver.Transaction = transaction;
    updateReceiver.Parameters.AddWithValue("@Balance", receiverNewBalance);
    updateReceiver.Parameters.AddWithValue("@UserId", receiverUserId);
    updateReceiver.ExecuteNonQuery();

    // Record transactions (kept in transaction for data consistency)
    SqlCommand sentTrans = new SqlCommand(
        @"INSERT INTO Transactions(UserId, TransactionType, Amount, Debit, BalanceAfter, SentTo)
          VALUES(@UserId, 'Sent', @Amount, @Amount, @BalanceAfter, @SentTo)", db);
    sentTrans.Transaction = transaction;
    sentTrans.Parameters.AddWithValue("@UserId", senderUserId);
    sentTrans.Parameters.AddWithValue("@Amount", amount);
    sentTrans.Parameters.AddWithValue("@BalanceAfter", senderNewBalance);
    sentTrans.Parameters.AddWithValue("@SentTo", recipientAccountNo);
    sentTrans.ExecuteNonQuery();

    SqlCommand receivedTrans = new SqlCommand(
        @"INSERT INTO Transactions(UserId, TransactionType, Amount, Credit, BalanceAfter, ReceivedFrom)
          VALUES(@UserId, 'Received', @Amount, @Amount, @BalanceAfter, @ReceivedFrom)", db);
    receivedTrans.Transaction = transaction;
    receivedTrans.Parameters.AddWithValue("@UserId", receiverUserId);
    receivedTrans.Parameters.AddWithValue("@Amount", amount);
    receivedTrans.Parameters.AddWithValue("@BalanceAfter", receiverNewBalance);
    receivedTrans.Parameters.AddWithValue("@ReceivedFrom", senderAccountNo);
    receivedTrans.ExecuteNonQuery();

    // All succeeded - commit
    transaction.Commit();
    lblMessage.Text = "CloudMoney sent successfully.";
}
catch (Exception ex)
{
    // Something failed - rollback everything
    transaction.Rollback();
    lblMessage.Text = "Transaction failed. No funds were transferred.";
    System.Diagnostics.Debug.WriteLine("Money transfer error: " + ex.Message);
}
```

---

### 🔴 CRITICAL: Enable HTTPS

**Problem:** Passwords transmitted over HTTP

**Solution:** Add to Web.config**

```xml
<configuration>
  <system.webServer>
    <rewrite>
      <rules>
        <rule name="Redirect to HTTPS" stopProcessing="true">
          <match url="(.*)" />
          <conditions>
            <add input="{HTTPS}" pattern="off" ignoreCase="true" />
          </conditions>
          <action type="Redirect" url="https://{HTTP_HOST}{REQUEST_URI}" redirectType="Permanent" />
        </rule>
      </rules>
    </rewrite>
    <security>
      <requestFiltering>
        <fileExtensions>
          <add fileExtension=".config" allowed="false" />
        </fileExtensions>
      </requestFiltering>
    </security>
  </system.webServer>
</configuration>
```

---

### 🟠 HIGH: CSRF Protection

**In Page_Init of login and form pages:**
```csharp
protected override void OnInit(EventArgs e)
{
    base.OnInit(e);
    if (!IsPostBack)
    {
        ViewStateUserKey = Session.SessionID;
    }
}
```

---

### 🟠 HIGH: Session Regeneration

**In Default.aspx.cs (Login):**
```csharp
if (result != null)
{
    int userId = Convert.ToInt32(result);
    
    // Clear old session
    Session.Clear();
    Session.Abandon();
    
    // Create new session
    Session["UserId"] = userId;
    Session["Username"] = username;
    
    Response.Redirect("Dashboard.aspx");
}
```

---

### 🟠 HIGH: Login Rate Limiting

**In Default.aspx.cs:**
```csharp
protected void btnLogin_Click(object sender, EventArgs e)
{
    string username = txtUsername.Text.Trim();
    string cacheKey = "LoginAttempts_" + username;
    
    // Check attempts
    int attempts = Cache[cacheKey] != null ? Convert.ToInt32(Cache[cacheKey]) : 0;
    if (attempts >= 5)
    {
        lblMessage.Text = "Too many login attempts. Try again in 15 minutes.";
        return;
    }
    
    // Validate login...
    bool loginValid = ValidateLogin(username, password);
    
    if (loginValid)
    {
        Cache.Remove(cacheKey);  // Clear on success
        // Proceed with login
    }
    else
    {
        // Increment attempts
        Cache[cacheKey] = attempts + 1;
        Cache.Insert(cacheKey, attempts + 1, null, 
            DateTime.Now.AddMinutes(15), TimeSpan.Zero);
        lblMessage.Text = "Invalid username or password.";
    }
}
```

---

### 🟡 MEDIUM: Password Complexity

**Create App_Code/ValidationHelper.cs:**
```csharp
using System;
using System.Text.RegularExpressions;
using System.Linq;

public static class ValidationHelper
{
    public static bool IsValidPassword(string password)
    {
        // At least 8 characters
        if (password.Length < 8) return false;
        
        // At least one uppercase letter
        if (!password.Any(char.IsUpper)) return false;
        
        // At least one lowercase letter
        if (!password.Any(char.IsLower)) return false;
        
        // At least one digit
        if (!password.Any(char.IsDigit)) return false;
        
        // At least one special character
        if (!Regex.IsMatch(password, @"[!@#$%^&*()_+\-=\[\]{};':""\\|,.<>\/?]"))
            return false;
        
        return true;
    }
}
```

**In Register.aspx.cs:**
```csharp
if (!ValidationHelper.IsValidPassword(password))
{
    lblMessage.Text = "Password must be 8+ characters with uppercase, lowercase, digit, and special character.";
    return;
}
```

---

### 🟡 MEDIUM: Protect Connection String

**Create App_Code/ConfigHelper.cs:**
```csharp
using System;
using System.Configuration;

public static class ConfigHelper
{
    public static string GetConnectionString()
    {
        // Try environment variable first (production)
        string connString = Environment.GetEnvironmentVariable("CloudMoneyDBss");
        
        if (string.IsNullOrEmpty(connString))
        {
            // Fall back to Web.config (development)
            connString = ConfigurationManager.ConnectionStrings["CloudMoneyDBss"]?.ConnectionString;
        }
        
        if (string.IsNullOrEmpty(connString))
        {
            throw new ConfigurationErrorsException("Connection string not configured.");
        }
        
        return connString;
    }
}
```

**Update App_Code/DBHelper.cs:**
```csharp
using System.Data.SqlClient;

public class DBHelper
{
    public static SqlConnection GetConnection()
    {
        string conn = ConfigHelper.GetConnectionString();
        return new SqlConnection(conn);
    }
}
```

---

## Implementation Checklist

- [ ] Install BCrypt.Net-Next package
- [ ] Hash passwords in Register.aspx.cs
- [ ] Verify passwords in Default.aspx.cs (login)
- [ ] Add transaction control to SendCloudMoney.aspx.cs
- [ ] Enable HTTPS in Web.config
- [ ] Add CSRF protection (ViewStateUserKey)
- [ ] Implement session regeneration on login
- [ ] Add login rate limiting
- [ ] Create ValidationHelper for password complexity
- [ ] Create ConfigHelper for secure connection strings
- [ ] Test all changes locally
- [ ] Deploy to production with HTTPS enabled

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/security-improvements`)
3. Implement and test changes
4. Commit with clear messages
5. Push and open a Pull Request

## Support

For security issues, please report responsibly to the maintainers.
For other issues, open a GitHub Issue.

---

**⚠️ WARNING:** Do NOT deploy to production without implementing the critical security fixes (Password Hashing, Transaction Control, HTTPS).
