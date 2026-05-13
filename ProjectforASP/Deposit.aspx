<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Deposit.aspx.cs" Inherits="CloudMoney.Deposit" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Deposit</title>
</head>

<body style="font-family:'Times New Roman'; font-size:11pt; margin:0; background:#d9d9d9;">

<form id="form1" runat="server">

<div style="width:100%; min-height:100vh; display:flex; justify-content:center; align-items:center;">

    <div style="width:1180px; min-height:700px; background:#eeeeee; border-radius:18px; box-shadow:0px 10px 35px rgba(0,0,0,0.25); display:flex; overflow:hidden;">

        <div style="width:210px; background:white; margin:22px; border-radius:18px; padding:25px 18px;">
            <h1 style="margin:0 0 35px 10px; font-size:28px;">Your Account</h1>

            <asp:HyperLink runat="server" NavigateUrl="~/Dashboard.aspx" style="display:block; color:#111; padding:11px 18px; text-decoration:none; font-weight:bold;">Dashboard</asp:HyperLink>
            <asp:HyperLink runat="server" NavigateUrl="~/SendCloudMoney.aspx" style="display:block; color:#111; padding:11px 18px; text-decoration:none; font-weight:bold;">Send CloudMoney</asp:HyperLink>
            <asp:HyperLink runat="server" NavigateUrl="~/ChangePassword.aspx" style="display:block; color:#111; padding:11px 18px; text-decoration:none; font-weight:bold;">Change Password</asp:HyperLink>

            <p style="font-weight:bold; margin:35px 0 10px 18px; color:#555;">REPORTS</p>

            <asp:HyperLink runat="server" NavigateUrl="~/StatementOfAccount.aspx" style="display:block; color:#111; padding:11px 18px; text-decoration:none; font-weight:bold;">Statement</asp:HyperLink>
            <asp:HyperLink runat="server" NavigateUrl="~/DepositWithdrawalReport.aspx" style="display:block; color:#111; padding:11px 18px; text-decoration:none; font-weight:bold;">Deposits / Withdrawals</asp:HyperLink>
            <asp:HyperLink runat="server" NavigateUrl="~/SentReceivedReport.aspx" style="display:block; color:#111; padding:11px 18px; text-decoration:none; font-weight:bold;">Sent / Received</asp:HyperLink>

            <asp:HyperLink runat="server" NavigateUrl="~/Logout.aspx" style="display:block; color:#b60000; padding:11px 18px; text-decoration:none; font-weight:bold; margin-top:25px;">Logout</asp:HyperLink>
        </div>

        <div style="flex:1; padding:50px 45px 35px 5px;">

            <h1 style="margin:0 0 25px 0; font-size:34px;">Deposit Money</h1>

            <div style="display:flex; gap:22px;">

                <div style="width:430px; background:white; border-radius:18px; padding:35px; box-shadow:0px 3px 12px rgba(0,0,0,0.08);">
                    <h2 style="margin-top:0;">Enter Amount</h2>
                    <p style="color:#555;">Add CloudMoney to your account balance.</p>

                    <asp:TextBox ID="txtAmount" runat="server"
                        placeholder="Enter amount"
                        style="width:360px; padding:15px; border-radius:12px; border:1px solid #cccccc; font-size:13pt;">
                    </asp:TextBox>

                    <br /><br />

                    <asp:Button ID="btnDeposit" runat="server" Text="Deposit"
                        OnClick="btnDeposit_Click"
                        style="width:390px; background:#111; color:white; border:none; padding:14px; border-radius:12px; font-weight:bold; cursor:pointer; font-size:12pt;" />

                    <br /><br />
                    <br /><br />

                    <asp:Label ID="lblMessage" runat="server" style="font-weight:bold;"></asp:Label>
                </div>

                <div style="flex:1; background:#111; color:white; border-radius:18px; padding:35px; box-shadow:0px 3px 12px rgba(0,0,0,0.12);">
                    <h2 style="margin-top:0;">Deposit Rules</h2>

                    <p style="font-size:18px; margin-top:25px;">Minimum Amount</p>
                    <h1 style="margin-top:0;">₱100.00</h1>

                    <p style="font-size:18px;">Maximum Amount</p>
                    <h1 style="margin-top:0;">₱50,000.00</h1>

                    <p style="font-size:18px;">Other Rules</p>
                    <p>Amount must be divisible by ₱100.00.</p>
                    <p>Total current balance must not exceed ₱50,000.00.</p>
                </div>

        </div>

    </div>

</div>

</form>

</body>
</html>