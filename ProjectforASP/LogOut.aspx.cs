using System;
using System.Data.SqlClient;

namespace CloudMoney
{
    public partial class Logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["SessionId"] != null)
            {
                int sessionId = Convert.ToInt32(Session["SessionId"]);

                using (SqlConnection db = DBHelper.GetConnection())
                {
                    db.Open();

                    SqlCommand cmd = new SqlCommand(
                        "UPDATE UserSessions SET LogoutTime = GETDATE() WHERE SessionId=@SessionId", db);

                    cmd.Parameters.AddWithValue("@SessionId", sessionId);
                    cmd.ExecuteNonQuery();
                }
            }

            Session.Clear();
            Session.Abandon();

            Response.Redirect("~/Default.aspx");
        }
    }
}