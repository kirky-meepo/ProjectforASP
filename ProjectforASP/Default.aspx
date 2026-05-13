<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="CloudMoney.Login" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>CloudMoney Login</title>
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

    <!-- DARK OVERLAY -->
    <div style="
        width:100%;
        height:100vh;
        display:flex;
        justify-content:center;
        align-items:center;
        background:rgba(0,0,0,0.35);">

        <!-- FLOATING LOGIN BOX -->
        <div style="
            width:400px;
            padding:38px;
            border-radius:18px;
            text-align:center;

            background:rgba(255,255,255,0.12);

            border:1px solid rgba(255,255,255,0.30);

            box-shadow:0px 8px 32px rgba(0,0,0,0.40);

            backdrop-filter:blur(10px);
            -webkit-backdrop-filter:blur(10px);">

            <!-- TITLE -->
            <h1 style="
                margin-top:0;
                margin-bottom:30px;
                color:white;
                font-size:40px;
                font-weight:bold;
                letter-spacing:1px;">
                Login
            </h1>

            <!-- USERNAME -->
            <div style="margin-bottom:18px;">

                <asp:TextBox ID="txtUsername" runat="server"
                    placeholder="Username"

                    style="
                    width:320px;
                    padding:14px 18px;
                    border-radius:30px;
                    border:none;

                    background:rgba(255,255,255,0.22);

                    color:white;
                    outline:none;

                    font-family:'Times New Roman';
                    font-size:12pt;">
                </asp:TextBox>

            </div>

            <!-- PASSWORD -->
            <div style="margin-bottom:20px;">

                <asp:TextBox ID="txtPassword" runat="server"
                    TextMode="Password"
                    placeholder="Password"

                    style="
                    width:320px;
                    padding:14px 18px;
                    border-radius:30px;
                    border:none;

                    background:rgba(255,255,255,0.22);

                    color:white;
                    outline:none;

                    font-family:'Times New Roman';
                    font-size:12pt;">
                </asp:TextBox>

            </div>

            <!-- LOGIN BUTTON -->
            <asp:Button ID="btnLogin" runat="server"
                Text="Login"
                OnClick="btnLogin_Click"

                style="
                width:355px;
                padding:13px;
                border:none;
                border-radius:30px;

                background:white;

                color:#333333;
                font-weight:bold;

                cursor:pointer;

                font-family:'Times New Roman';
                font-size:12pt;" />

            <br /><br />

            <!-- ERROR MESSAGE -->
            <asp:Label ID="lblMessage" runat="server"
                ForeColor="#ffcccc"
                style="font-weight:bold;">
            </asp:Label>

            <br /><br />

            <!-- REGISTER -->
            <span style="color:white;">
                Don't have an account?
            </span>

            <asp:HyperLink ID="lnkRegister" runat="server"
                NavigateUrl="~/Register.aspx"
                style="color:#ffffff; font-weight:bold; text-decoration:none;">
                    Register
            </asp:HyperLink>

        </div>

    </div>

</form>

</body>
</html>