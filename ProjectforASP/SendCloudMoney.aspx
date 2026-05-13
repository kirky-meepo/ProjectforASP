<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SendCloudMoney.aspx.cs" Inherits="CloudMoney.SendCloudMoney" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Send CloudMoney</title>
</head>

<body style="font-family:'Times New Roman'; font-size:11pt; margin:0; background:#d9d9d9;">

<form id="form1" runat="server">

<div style="width:100%; min-height:100vh; display:flex; justify-content:center; align-items:center;">

    <div style="width:1180px; min-height:700px; background:#eeeeee; border-radius:18px; box-shadow:0px 10px 35px rgba(0,0,0,0.25); display:flex; overflow:visible;">

        <div style="width:210px; background:white; margin:22px; border-radius:18px; padding:25px 18px;">
            <h1 style="margin:0 0 35px 10px; font-size:28px;">Your Account</h1>

            <asp:HyperLink runat="server" NavigateUrl="~/Dashboard.aspx" style="display:block; color:#111; padding:11px 18px; text-decoration:none; font-weight:bold;">Dashboard</asp:HyperLink>

            <asp:HyperLink runat="server" NavigateUrl="~/SendCloudMoney.aspx"
                style="display:block; background:#111; color:white; padding:13px 18px; border-radius:10px; text-decoration:none; font-weight:bold;">
                Send CloudMoney
            </asp:HyperLink>

            <asp:HyperLink runat="server" NavigateUrl="~/ChangePassword.aspx"
                style="display:block; color:#111; padding:11px 18px; text-decoration:none; font-weight:bold;">
                Change Password
            </asp:HyperLink>

            <p style="font-weight:bold; margin:35px 0 10px 18px; color:#555;">REPORTS</p>

            <asp:HyperLink runat="server" NavigateUrl="~/StatementOfAccount.aspx"
                style="display:block; color:#111; padding:11px 18px; text-decoration:none; font-weight:bold;">
                Statement
            </asp:HyperLink>

            <asp:HyperLink runat="server" NavigateUrl="~/DepositWithdrawalReport.aspx"
                style="display:block; color:#111; padding:11px 18px; text-decoration:none; font-weight:bold;">
                Deposits / Withdrawals
            </asp:HyperLink>

            <asp:HyperLink runat="server" NavigateUrl="~/SentReceivedReport.aspx"
                style="display:block; color:#111; padding:11px 18px; text-decoration:none; font-weight:bold;">
                Sent / Received
            </asp:HyperLink>

            <asp:HyperLink runat="server" NavigateUrl="~/Logout.aspx"
                style="display:block; color:#b60000; padding:11px 18px; text-decoration:none; font-weight:bold; margin-top:25px;">
                Logout
            </asp:HyperLink>
        </div>

        <div style="flex:1; padding:55px 5px 35px 5px; overflow:auto;">

            <h1 style="margin:0 0 25px 0; font-size:34px;">Send CloudMoney</h1>

            <div style="display:flex; gap:22px; align-items:flex-start;">

                <!-- LEFT -->
                <div style="width:480px; background:white; border-radius:18px; padding:35px; box-shadow:0px 3px 12px rgba(0,0,0,0.08);">

                    <h2 style="margin-top:0;">Recipient Details</h2>

                    <p style="color:#555;">
                        Enter recipient account number first to verify the account.
                    </p>

                    <div style="display:flex; gap:12px; margin-top:20px;">

                        <asp:TextBox ID="txtRecipientAccount" runat="server"
                            placeholder="Recipient Account No."
                            style="width:290px; padding:14px; border-radius:12px; border:1px solid #cccccc; font-size:12pt;">
                        </asp:TextBox>

                        <asp:Button ID="btnCheck" runat="server"
                            Text="Check"
                            OnClick="btnCheck_Click"
                            style="background:#111; color:white; border:none; padding:14px 24px; border-radius:12px; font-weight:bold; cursor:pointer;" />

                    </div>

                    <div style="background:#f3f3f3; border-radius:14px; padding:22px; margin-top:25px; line-height:1.8;">

                        <p style="margin:0; color:#555;">Account No.</p>

                        <h3 style="margin:0 0 18px 0;">
                            <asp:Label ID="lblAccountNo" runat="server"></asp:Label>
                        </h3>

                        <p style="margin:0; color:#555;">Recipient Name</p>

                        <h3 style="margin:0;">
                            <asp:Label ID="lblRecipientName" runat="server"></asp:Label>
                        </h3>

                    </div>

                </div>

                <!-- RIGHT -->
                <div style="width:360px; background:white; border-radius:18px; padding:35px; box-shadow:0px 3px 12px rgba(0,0,0,0.08); height:fit-content;">

                    <h2 style="margin-top:0;">Transfer Information</h2>

                    <p style="color:#555;">
                        Enter amount and your password to complete sending.
                    </p>

                    <asp:TextBox ID="txtAmount" runat="server"
                        placeholder="Amount"
                        style="width:300px; padding:14px; border-radius:12px; border:1px solid #cccccc; font-size:12pt;">
                    </asp:TextBox>

                    <br /><br />

                    <asp:TextBox ID="txtPassword" runat="server"
                        TextMode="Password"
                        placeholder="Your Password"
                        style="width:300px; padding:14px; border-radius:12px; border:1px solid #cccccc; font-size:12pt;">
                    </asp:TextBox>

                    <br /><br />

                    <asp:Button ID="btnSend" runat="server"
                        Text="Send CloudMoney"
                        OnClick="btnSend_Click"
                        style="width:330px; background:#111; color:white; border:none; padding:14px; border-radius:12px; font-weight:bold; cursor:pointer; font-size:12pt;" />

                    <br /><br />

                    <asp:Label ID="lblMessage" runat="server" style="font-weight:bold;"></asp:Label>

                </div>

            </div>

            <!-- RULES -->
            <div style="background:#111; color:white; border-radius:18px; padding:30px; margin-top:22px; max-width:900px; line-height:1.9;">

                <h2 style="margin-top:0;">Sending Rules</h2>

                <p>Minimum amount: ₱100.00</p>
                <p>Maximum amount: ₱50,000.00</p>
                <p>Amount must be divisible by ₱100.00</p>
                <p style="margin-bottom:0;">
                    Password is required before sending for security verification.
                </p>

            </div>

        </div>

    </div>

</div>

</form>

</body>
</html> 