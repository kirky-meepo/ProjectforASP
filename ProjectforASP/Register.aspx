<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="CloudMoney.Register" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>User Registration</title>
</head>

<body style="
    font-family:'Times New Roman';
    font-size:11pt;
    margin:0;
    padding:0;
    background-image:url('Images/Cebu Technological University.jpg');
    background-size:cover;
    background-position:center;
    background-repeat:no-repeat;
    overflow:hidden;">

<form id="form1" runat="server">

    <div style="
        width:100%;
        height:100vh;
        display:flex;
        justify-content:center;
        align-items:center;
        background:rgba(0,0,0,0.35);">

        <div style="
            width:430px;
            padding:35px;
            border-radius:18px;
            text-align:center;
            background:rgba(255,255,255,0.12);
            border:1px solid rgba(255,255,255,0.30);
            box-shadow:0px 8px 32px rgba(0,0,0,0.40);
            backdrop-filter:blur(10px);
            -webkit-backdrop-filter:blur(10px);">

            <h1 style="
                margin-top:0;
                margin-bottom:25px;
                color:white;
                font-size:36px;
                font-weight:bold;">
                Register
            </h1>

            <asp:TextBox ID="txtFirstName" runat="server"
                placeholder="First Name"
                style="width:320px; padding:13px 18px; margin-bottom:12px; border-radius:30px; border:none; background:rgba(255,255,255,0.25); color:white; font-family:'Times New Roman'; font-size:12pt;">
            </asp:TextBox>

            <br />

            <asp:TextBox ID="txtLastName" runat="server"
                placeholder="Last Name"
                style="width:320px; padding:13px 18px; margin-bottom:12px; border-radius:30px; border:none; background:rgba(255,255,255,0.25); color:white; font-family:'Times New Roman'; font-size:12pt;">
            </asp:TextBox>

            <br />

            <asp:TextBox ID="txtUsername" runat="server"
                placeholder="Username"
                style="width:320px; padding:13px 18px; margin-bottom:12px; border-radius:30px; border:none; background:rgba(255,255,255,0.25); color:white; font-family:'Times New Roman'; font-size:12pt;">
            </asp:TextBox>

            <br />

            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password"
                placeholder="Password"
                style="width:320px; padding:13px 18px; margin-bottom:12px; border-radius:30px; border:none; background:rgba(255,255,255,0.25); color:white; font-family:'Times New Roman'; font-size:12pt;">
            </asp:TextBox>

            <br />

            <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password"
                placeholder="Confirm Password"
                style="width:320px; padding:13px 18px; margin-bottom:18px; border-radius:30px; border:none; background:rgba(255,255,255,0.25); color:white; font-family:'Times New Roman'; font-size:12pt;">
            </asp:TextBox>

            <br />

            <asp:Button ID="btnRegister" runat="server" Text="Register"
                OnClick="btnRegister_Click"
                style="width:355px; padding:13px; border:none; border-radius:30px; background:white; color:#333333; font-weight:bold; cursor:pointer; font-family:'Times New Roman'; font-size:12pt;" />

            <br /><br />

            <asp:Label ID="lblMessage" runat="server" ForeColor="#ffcccc" style="font-weight:bold;"></asp:Label>

            <br /><br />

            <span style="color:white;">Already have an account?</span>

            <asp:HyperLink ID="lnkLogin" runat="server" NavigateUrl="~/Default.aspx"
                style="color:white; font-weight:bold; text-decoration:none;">
                Login
            </asp:HyperLink>

        </div>

    </div>

</form>

</body>
</html>