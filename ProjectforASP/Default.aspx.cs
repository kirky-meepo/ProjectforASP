using System;
using System.Data.SqlClient;

namespace CloudMoney
{
    public partial class Login : System.Web.UI.Page
    {
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            using (SqlConnection db = DBHelper.GetConnection())
            {
                db.Open();

                SqlCommand cmd = new SqlCommand(
                    "SELECT UserId FROM Users WHERE Username=@Username AND Password=@Password AND IsActive=1", db);

                cmd.Parameters.AddWithValue("@Username", username);
                cmd.Parameters.AddWithValue("@Password", password);

                object result = cmd.ExecuteScalar();

                if (result != null)
                {
                    int userId = Convert.ToInt32(result);

                    Session["UserId"] = userId;
                    Session["Username"] = username;

                    SqlCommand sessionCmd = new SqlCommand(
                        "INSERT INTO UserSessions(UserId) VALUES(@UserId); SELECT SCOPE_IDENTITY();", db);

                    sessionCmd.Parameters.AddWithValue("@UserId", userId);

                    int sessionId = Convert.ToInt32(sessionCmd.ExecuteScalar());
                    Session["SessionId"] = sessionId;

                    Response.Redirect("Dashboard.aspx");
                }
                else
                {
                    lblMessage.Text = "Invalid username or password.";
                }
            }
        }
    }
}