<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="CloudMoney.Dashboard" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Dashboard</title>
</head>

<body style="font-family:'Times New Roman'; font-size:11pt; margin:0; background:#d9d9d9;">

<form id="form1" runat="server">

<div style="width:100%; min-height:100vh; display:flex; justify-content:center; align-items:center;">

    <div style="width:1180px; min-height:700px; background:#eeeeee; border-radius:18px; box-shadow:0px 10px 35px rgba(0,0,0,0.25); display:flex; overflow:hidden;">

        <div style="width:210px; background:white; margin:22px; border-radius:18px; padding:25px 18px;">
            <h1 style="margin:0 0 35px 10px; font-size:28px;">Your Account</h1>

            <asp:HyperLink runat="server" NavigateUrl="~/Dashboard.aspx" style="display:block; background:#111; color:white; padding:13px 18px; border-radius:10px; text-decoration:none; font-weight:bold; margin-bottom:12px;">Dashboard</asp:HyperLink>
            <asp:HyperLink runat="server" NavigateUrl="~/SendCloudMoney.aspx" style="display:block; color:#111; padding:11px 18px; text-decoration:none; font-weight:bold;">Send CloudMoney</asp:HyperLink>
            <asp:HyperLink runat="server" NavigateUrl="~/ChangePassword.aspx" style="display:block; color:#111; padding:11px 18px; text-decoration:none; font-weight:bold;">Change Password</asp:HyperLink>

            <p style="font-weight:bold; margin:35px 0 10px 18px; color:#555;">REPORTS</p>

            <asp:HyperLink runat="server" NavigateUrl="~/StatementOfAccount.aspx" style="display:block; color:#111; padding:11px 18px; text-decoration:none; font-weight:bold;">Statement</asp:HyperLink>
            <asp:HyperLink runat="server" NavigateUrl="~/DepositWithdrawalReport.aspx" style="display:block; color:#111; padding:11px 18px; text-decoration:none; font-weight:bold;">Deposits / Withdrawals</asp:HyperLink>
            <asp:HyperLink runat="server" NavigateUrl="~/SentReceivedReport.aspx" style="display:block; color:#111; padding:11px 18px; text-decoration:none; font-weight:bold;">Sent / Received</asp:HyperLink>

            <asp:HyperLink runat="server" NavigateUrl="~/Logout.aspx" style="display:block; color:#b60000; padding:11px 18px; text-decoration:none; font-weight:bold; margin-top:25px;">Logout</asp:HyperLink>
        </div>

        <div style="flex:1; padding:45px 35px 30px 0;">

            <h1 style="margin:0 0 25px 0; font-size:30px;">
                Hi, <asp:Label ID="lblName" runat="server"></asp:Label>!
            </h1>

            <div style="display:flex; gap:18px; margin-bottom:18px;">

                <div style="width:300px; background:#111; color:white; border-radius:15px; padding:25px;">
                    <h3 style="margin-top:0;">Account Overview</h3>

                    <p style="color:#cccccc; margin-bottom:5px;">Account No.</p>
                    <h2 style="margin-top:0;"><asp:Label ID="lblAccountNo" runat="server"></asp:Label></h2>

                    <p style="color:#cccccc; margin-bottom:5px;">Date Registered</p>
                    <h3 style="margin-top:0;"><asp:Label ID="lblDateRegistered" runat="server"></asp:Label></h3>
                </div>

                <div style="width:240px; background:white; border-radius:15px; padding:25px;">
                    <h3 style="margin-top:0;">Current Balance</h3>
                    <p style="font-size:35px; font-weight:bold; margin:20px 0 0 0;">
                        ₱ <asp:Label ID="lblBalance" runat="server"></asp:Label>
                    </p>
                    <p style="color:#666;">Available balance</p>
                </div>

                <div style="width:240px; background:white; border-radius:15px; padding:25px;">
                    <h3 style="margin-top:0;">Total Sent</h3>
                    <p style="font-size:35px; font-weight:bold; margin:20px 0 0 0;">
                        ₱ <asp:Label ID="lblTotalSent" runat="server"></asp:Label>
                    </p>
                    <p style="color:#666;">CloudMoney sent</p>
                </div>

            </div>

            <div style="display:flex; gap:18px; margin-bottom:18px;">

                <asp:HyperLink runat="server" NavigateUrl="~/Deposit.aspx"
                    style="width:170px; background:white; color:#111; border-radius:15px; padding:22px; text-decoration:none; font-weight:bold;">
                    + Deposit<br /><span style="font-weight:normal; color:#666;">Add balance</span>
                </asp:HyperLink>

                <asp:HyperLink runat="server" NavigateUrl="~/Withdraw.aspx"
                    style="width:170px; background:white; color:#111; border-radius:15px; padding:22px; text-decoration:none; font-weight:bold;">
                    - Withdraw<br /><span style="font-weight:normal; color:#666;">Cash out</span>
                </asp:HyperLink>

            </div>

            <div style="display:flex; gap:18px;">

                <div style="width:100%; background:white; border-radius:15px; padding:25px; box-shadow:0px 3px 12px rgba(0,0,0,0.08);">

                    <h3 style="margin-top:0; margin-bottom:18px;">Recent Notifications</h3>

                    <asp:GridView ID="gvNotifications" runat="server"
                        AutoGenerateColumns="False"
                        GridLines="Horizontal"
                        CellPadding="10"
                        Width="100%"
                        BorderColor="#eeeeee"
                        HeaderStyle-Font-Bold="true"
                        HeaderStyle-BackColor="#f5f5f5"
                        HeaderStyle-ForeColor="#111"
                        RowStyle-BackColor="White"
                        style="border-collapse:collapse;">

                        <Columns>
                            <asp:BoundField 
                                DataField="DateCreated" 
                                HeaderText="Date" 
                                DataFormatString="{0:MM/dd/yyyy hh:mm tt}" />

                             <asp:BoundField 
                                DataField="ReferenceNo" 
                                HeaderText="Reference No." />

                            <asp:BoundField 
                                DataField="Message" 
                                HeaderText="Notification" />

                            <asp:BoundField 
                                DataField="Amount" 
                                HeaderText="Amount" 
                                DataFormatString="₱ {0:N2}" />

                        </Columns>

                    </asp:GridView>

                </div>

            </div>

        </div>

    </div>

</div>

</form>

</body>
</html>