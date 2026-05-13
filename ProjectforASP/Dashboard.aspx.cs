using System;
using System.Data;
using System.Data.SqlClient;

namespace CloudMoney
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Default.aspx");
            }

            if (!IsPostBack)
            {
                LoadDashboard();
                LoadNotifications();
            }
        }

        private void LoadDashboard()
        {
            int userId = Convert.ToInt32(Session["UserId"]);

            using (SqlConnection db = DBHelper.GetConnection())
            {
                db.Open();

                SqlCommand cmd = new SqlCommand(
                    @"SELECT U.AccountNo, U.FirstName, U.LastName, U.DateRegistered, A.Balance
                      FROM Users U
                      INNER JOIN Accounts A ON U.UserId = A.UserId
                      WHERE U.UserId=@UserId", db);

                cmd.Parameters.AddWithValue("@UserId", userId);

                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    lblAccountNo.Text = dr["AccountNo"].ToString();
                    lblName.Text = dr["FirstName"].ToString() + " " + dr["LastName"].ToString();
                    lblDateRegistered.Text = Convert.ToDateTime(dr["DateRegistered"]).ToString("MM/dd/yyyy");
                    lblBalance.Text = Convert.ToDecimal(dr["Balance"]).ToString("N2");
                }

                dr.Close();

                SqlCommand sentCmd = new SqlCommand(
                    @"SELECT ISNULL(SUM(Amount), 0)
                      FROM Transactions
                      WHERE UserId=@UserId AND TransactionType='Sent'", db);

                sentCmd.Parameters.AddWithValue("@UserId", userId);

                decimal totalSent = Convert.ToDecimal(sentCmd.ExecuteScalar());
                lblTotalSent.Text = totalSent.ToString("N2");
            }
        }

        private void LoadNotifications()
        {
            int userId = Convert.ToInt32(Session["UserId"]);

            using (SqlConnection db = DBHelper.GetConnection())
            {
                db.Open();

                SqlDataAdapter da = new SqlDataAdapter(
                    @"SELECT TOP 5 Message, 
                      DateCreated,
                      ReferenceNo,
                      Message,
                      Amount
                      FROM Notifications
                      WHERE UserId=@UserId
                      ORDER BY DateCreated DESC", db);

                da.SelectCommand.Parameters.AddWithValue("@UserId", userId);

                DataTable dt = new DataTable();
                da.Fill(dt);

                gvNotifications.DataSource = dt;
                gvNotifications.DataBind();
            }
        }
    }
}