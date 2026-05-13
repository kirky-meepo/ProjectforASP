using System;
using System.Data.SqlClient;
using System.Configuration;

namespace CloudMoney
{
    public partial class Register : System.Web.UI.Page
    {
        protected void btnRegister_Click(object sender, EventArgs e)
        {
            string firstName = txtFirstName.Text.Trim();
            string lastName = txtLastName.Text.Trim();
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();
            string confirmPassword = txtConfirmPassword.Text.Trim();

            if (firstName == "" || lastName == "" || username == "" || password == "" || confirmPassword == "")
            {
                lblMessage.Text = "All fields are required.";
                return;
            }

            if (password != confirmPassword)
            {
                lblMessage.Text = "Password and Confirm Password do not match.";
                return;
            }

            using (SqlConnection db = DBHelper.GetConnection())
            {
                db.Open();

                SqlCommand checkCmd = new SqlCommand(
                    "SELECT COUNT(*) FROM Users WHERE Username = @Username", db);

                checkCmd.Parameters.AddWithValue("@Username", username);

                int count = Convert.ToInt32(checkCmd.ExecuteScalar());

                if (count > 0)
                {
                    lblMessage.Text = "Username already exists.";
                    return;
                }

                string accountNo = DateTime.Now.ToString("yyyyMMddHHmmss");

                SqlCommand userCmd = new SqlCommand(
                    @"INSERT INTO Users (AccountNo, FirstName, LastName, Username, Password)
                      VALUES (@AccountNo, @FirstName, @LastName, @Username, @Password);
                      SELECT CAST(SCOPE_IDENTITY() AS INT);", db);

                userCmd.Parameters.AddWithValue("@AccountNo", accountNo);
                userCmd.Parameters.AddWithValue("@FirstName", firstName);
                userCmd.Parameters.AddWithValue("@LastName", lastName);
                userCmd.Parameters.AddWithValue("@Username", username);
                userCmd.Parameters.AddWithValue("@Password", password);

                int userId = Convert.ToInt32(userCmd.ExecuteScalar());

                SqlCommand accountCmd = new SqlCommand(
                    "INSERT INTO Accounts (UserId, Balance) VALUES (@UserId, 0)", db);

                accountCmd.Parameters.AddWithValue("@UserId", userId);
                accountCmd.ExecuteNonQuery();

                Response.Redirect("Default.aspx");
            }
        }
    }

    internal static class DBHelper
    {
        public static SqlConnection GetConnection()
        {
            string connStr = ConfigurationManager.ConnectionStrings["CloudMoneyDBss"]?.ConnectionString;

            if (string.IsNullOrWhiteSpace(connStr))
            {
                throw new InvalidOperationException("Connection string 'CloudMoneyDBss' is not configured.");
            }

            return new SqlConnection(connStr);
        }
    }
}