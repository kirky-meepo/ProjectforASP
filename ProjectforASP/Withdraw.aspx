<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Withdraw.aspx.cs" Inherits="CloudMoney.Withdraw" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Withdraw</title>
</head>

<body style="font-family:'Times New Roman'; font-size:11pt; margin:0; background:#d9d9d9;">

<form id="form1" runat="server">

<div style="width:100%; min-height:100vh; display:flex; justify-content:center; align-items:center;">

    <div style="width:1180px; min-height:700px; background:#eeeeee; border-radius:18px; box-shadow:0px 10px 35px rgba(0,0,0,0.25); display:flex; overflow:visible;">

        <!-- SIDEBAR -->
        <div style="width:210px; background:white; margin:22px; border-radius:18px; padding:25px 18px;">

            <h1 style="margin:0 0 35px 10px; font-size:28px;">
                Your Account
            </h1>

            <asp:HyperLink runat="server"
                NavigateUrl="~/Dashboard.aspx"
                style="display:block; color:#111; padding:11px 18px; text-decoration:none; font-weight:bold;">
                Dashboard
            </asp:HyperLink>

            <asp:HyperLink runat="server"
                NavigateUrl="~/SendCloudMoney.aspx"
                style="display:block; color:#111; padding:11px 18px; text-decoration:none; font-weight:bold;">
                Send CloudMoney
            </asp:HyperLink>

            <asp:HyperLink runat="server"
                NavigateUrl="~/ChangePassword.aspx"
                style="display:block; color:#111; padding:11px 18px; text-decoration:none; font-weight:bold;">
                Change Password
            </asp:HyperLink>

            <p style="font-weight:bold; margin:35px 0 10px 18px; color:#555;">
                REPORTS
            </p>

            <asp:HyperLink runat="server"
                NavigateUrl="~/StatementOfAccount.aspx"
                style="display:block; color:#111; padding:11px 18px; text-decoration:none; font-weight:bold;">
                Statement
            </asp:HyperLink>

            <asp:HyperLink runat="server"
                NavigateUrl="~/DepositWithdrawalReport.aspx"
                style="display:block; color:#111; padding:11px 18px; text-decoration:none; font-weight:bold;">
                Deposits / Withdrawals
            </asp:HyperLink>

            <asp:HyperLink runat="server"
                NavigateUrl="~/SentReceivedReport.aspx"
                style="display:block; color:#111; padding:11px 18px; text-decoration:none; font-weight:bold;">
                Sent / Received
            </asp:HyperLink>

            <asp:HyperLink runat="server"
                NavigateUrl="~/Logout.aspx"
                style="display:block; color:#b60000; padding:11px 18px; text-decoration:none; font-weight:bold; margin-top:25px;">
                Logout
            </asp:HyperLink>

        </div>

        <!-- CONTENT -->
        <div style="flex:1; padding:50px 35px 35px 5px; overflow:auto;">

            <h1 style="margin:0 0 25px 0; font-size:34px;">
                Withdraw Money
            </h1>

            <div style="display:flex; gap:22px; align-items:flex-start;">

                <!-- LEFT CARD -->
                <div style="width:430px; background:white; border-radius:18px; padding:35px; box-shadow:0px 3px 12px rgba(0,0,0,0.08);">

                    <h2 style="margin-top:0;">
                        Enter Amount
                    </h2>

                    <p style="color:#555;">
                        Withdraw money from your CloudMoney account.
                    </p>

                    <div style="background:#111; color:white; padding:20px; border-radius:14px; margin-bottom:22px;">

                        <p style="margin:0; color:#cccccc;">
                            Current Balance
                        </p>

                        <h1 style="margin:8px 0 0 0;">
                            ₱ <asp:Label ID="lblBalance" runat="server"></asp:Label>
                        </h1>

                    </div>

                    <asp:TextBox ID="txtAmount" runat="server"
                        placeholder="Enter amount"
                        style="width:360px; padding:15px; border-radius:12px; border:1px solid #cccccc; font-size:13pt;">
                    </asp:TextBox>

                    <br /><br />

                    <asp:Button ID="btnWithdraw" runat="server"
                        Text="Withdraw"
                        OnClick="btnWithdraw_Click"
                        style="width:390px; background:#111; color:white; border:none; padding:14px; border-radius:12px; font-weight:bold; cursor:pointer; font-size:12pt;" />

                    <br /><br />

                    <asp:Label ID="lblMessage" runat="server"
                        style="font-weight:bold;">
                    </asp:Label>

                </div>

                <!-- RIGHT CARD -->
                <div style="width:400px; background:white; border-radius:18px; padding:35px; box-shadow:0px 3px 12px rgba(0,0,0,0.08);">

                    <h2 style="margin-top:0;">
                        Withdrawal Rules
                    </h2>

                    <div style="display:flex; gap:16px; margin-top:25px;">

                        <div style="background:#eeeeee; border-radius:14px; padding:20px; width:135px;">

                            <p style="margin:0; color:#555;">
                                Minimum
                            </p>

                            <h1 style="margin:10px 0 0 0;">
                                ₱100
                            </h1>

                        </div>

                        <div style="background:#eeeeee; border-radius:14px; padding:20px; width:135px;">

                            <p style="margin:0; color:#555;">
                                Maximum
                            </p>

                            <h1 style="margin:10px 0 0 0;">
                                ₱50,000
                            </h1>

                        </div>

                    </div>

                    <div style="background:#111; color:white; border-radius:14px; padding:22px; margin-top:22px; line-height:1.8;">

                        <p>
                            Amount must be divisible by ₱100.00.
                        </p>

                        <p>
                            Withdrawal is not allowed if funds are insufficient.
                        </p>

                        <p style="margin-bottom:0;">
                            Your current balance is shown before you continue.
                        </p>

                    </div>

                </div>

            </div>

        </div>

    </div>

</div>

</form>

</body>
</html>