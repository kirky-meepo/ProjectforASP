<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DepositWithdrawalReport.aspx.cs" Inherits="CloudMoney.DepositWithdrawalReport" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>My Deposits or Withdrawals</title>
</head>

<body style="font-family:'Times New Roman'; font-size:11pt; margin:0; background:#d9d9d9;">

<form id="form1" runat="server">

<div style="width:100%; min-height:100vh; display:flex; justify-content:center; align-items:center;">

    <div style="width:1180px; min-height:700px; background:#eeeeee; border-radius:18px; box-shadow:0px 10px 35px rgba(0,0,0,0.25); display:flex; overflow:visible;">

        <div style="width:210px; background:white; margin:22px; border-radius:18px; padding:25px 18px;">
            <h1 style="margin:0 0 35px 10px; font-size:28px;">Your Account</h1>

            <asp:HyperLink runat="server" NavigateUrl="~/Dashboard.aspx" style="display:block; color:#111; padding:11px 18px; text-decoration:none; font-weight:bold;">Dashboard</asp:HyperLink>
            <asp:HyperLink runat="server" NavigateUrl="~/SendCloudMoney.aspx" style="display:block; color:#111; padding:11px 18px; text-decoration:none; font-weight:bold;">Send CloudMoney</asp:HyperLink>
            <asp:HyperLink runat="server" NavigateUrl="~/ChangePassword.aspx" style="display:block; color:#111; padding:11px 18px; text-decoration:none; font-weight:bold;">Change Password</asp:HyperLink>

            <p style="font-weight:bold; margin:35px 0 10px 18px; color:#555;">REPORTS</p>

            <asp:HyperLink runat="server" NavigateUrl="~/StatementOfAccount.aspx" style="display:block; color:#111; padding:11px 18px; text-decoration:none; font-weight:bold;">Statement</asp:HyperLink>
            <asp:HyperLink runat="server" NavigateUrl="~/DepositWithdrawalReport.aspx" style="display:block; background:#111; color:white; padding:13px 18px; border-radius:10px; text-decoration:none; font-weight:bold;">Deposits / Withdrawals</asp:HyperLink>
            <asp:HyperLink runat="server" NavigateUrl="~/SentReceivedReport.aspx" style="display:block; color:#111; padding:11px 18px; text-decoration:none; font-weight:bold;">Sent / Received</asp:HyperLink>

            <asp:HyperLink runat="server" NavigateUrl="~/Logout.aspx" style="display:block; color:#b60000; padding:11px 18px; text-decoration:none; font-weight:bold; margin-top:25px;">Logout</asp:HyperLink>
        </div>

        <div style="flex:1; padding:50px 35px 35px 5px; overflow:auto;">

            <h1 style="margin:0 0 25px 0; font-size:34px;">My Deposits or Withdrawals</h1>

            <div style="background:white; border-radius:18px; padding:28px; box-shadow:0px 3px 12px rgba(0,0,0,0.08); margin-bottom:22px;">

                <div style="display:flex; gap:18px; align-items:end;">
                    <div>
                        <p style="font-weight:bold; margin:0 0 8px 0;">From</p>
                        <asp:TextBox ID="txtFrom" runat="server" placeholder="MM/DD/YYYY"
                            style="width:200px; padding:13px; border-radius:10px; border:1px solid #cccccc; font-size:11pt;">
                        </asp:TextBox>
                    </div>

                    <div>
                        <p style="font-weight:bold; margin:0 0 8px 0;">To</p>
                        <asp:TextBox ID="txtTo" runat="server" placeholder="MM/DD/YYYY"
                            style="width:200px; padding:13px; border-radius:10px; border:1px solid #cccccc; font-size:11pt;">
                        </asp:TextBox>
                    </div>

                    <div>
                        <p style="font-weight:bold; margin:0 0 8px 0;">Type</p>
                        <asp:DropDownList ID="ddlType" runat="server"
                            style="width:190px; padding:13px; border-radius:10px; border:1px solid #cccccc; font-size:11pt;">
                            <asp:ListItem>All</asp:ListItem>
                            <asp:ListItem>Deposit</asp:ListItem>
                            <asp:ListItem>Withdrawal</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <asp:Button ID="btnList" runat="server" Text="List"
                        OnClick="btnList_Click"
                        style="background:#111; color:white; border:none; padding:14px 35px; border-radius:10px; font-weight:bold; cursor:pointer;" />
                </div>

                <br />
                <asp:Label ID="lblMessage" runat="server" ForeColor="Red" style="font-weight:bold;"></asp:Label>

            </div>

            <div style="background:white; border-radius:18px; padding:28px; box-shadow:0px 3px 12px rgba(0,0,0,0.08);">

                <asp:GridView ID="gvReport" runat="server"
                    AutoGenerateColumns="False"
                    Width="100%"
                    CellPadding="10"
                    GridLines="Horizontal"
                    BorderColor="#eeeeee"
                    HeaderStyle-Font-Bold="true"
                    HeaderStyle-BackColor="#f5f5f5"
                    HeaderStyle-ForeColor="#111"
                    HeaderStyle-HorizontalAlign="Left"
                    RowStyle-HorizontalAlign="Left"
                    style="border-collapse:collapse;">

                    <Columns>
                        <asp:BoundField DataField="Seq" HeaderText="Seq. #" />
                        <asp:BoundField DataField="Type" HeaderText="Type" />
                        <asp:BoundField DataField="Date" HeaderText="Date" />
                        <asp:BoundField DataField="Amount" HeaderText="Amount" />
                    </Columns>

                </asp:GridView>

            </div>

        </div>

    </div>

</div>

</form>

</body>
</html>