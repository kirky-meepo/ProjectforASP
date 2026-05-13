using System;
using System.Data.SqlClient;

namespace CloudMoney
{
    public partial class ChangePassword : System.Web.UI.Page
    {
        protected void btnChange_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(Session["UserId"]);

            using (SqlConnection db = DBHelper.GetConnection())
            {
                db.Open();

                SqlCommand check = new SqlCommand(
                    "SELECT COUNT(*) FROM Users WHERE UserId=@UserId AND Password=@Pass", db);

                check.Parameters.AddWithValue("@UserId", userId);
                check.Parameters.AddWithValue("@Pass", txtCurrent.Text);

                int valid = Convert.ToInt32(check.ExecuteScalar());

                if (valid == 0)
                {
                    lblMessage.Text = "Incorrect current password.";
                    return;
                }

                if (txtNew.Text != txtConfirm.Text)
                {
                    lblMessage.Text = "Passwords do not match.";
                    return;
                }

                SqlCommand update = new SqlCommand(
                    "UPDATE Users SET Password=@NewPass WHERE UserId=@UserId", db);

                update.Parameters.AddWithValue("@NewPass", txtNew.Text);
                update.Parameters.AddWithValue("@UserId", userId);

                update.ExecuteNonQuery();

                lblMessage.Text = "Password successfully changed.";
            }
        }
    }
}