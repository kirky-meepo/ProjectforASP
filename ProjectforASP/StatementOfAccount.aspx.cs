using System;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;

namespace CloudMoney
{
    public partial class StatementOfAccount : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("Login.aspx");
            }
        }

        protected void btnList_Click(object sender, EventArgs e)
        {
            DateTime fromDate, toDate;

            bool validFrom = DateTime.TryParseExact(
                txtFrom.Text.Trim(),
                "MM/dd/yyyy",
                CultureInfo.InvariantCulture,
                DateTimeStyles.None,
                out fromDate);

            bool validTo = DateTime.TryParseExact(
                txtTo.Text.Trim(),
                "MM/dd/yyyy",
                CultureInfo.InvariantCulture,
                DateTimeStyles.None,
                out toDate);

            if (!validFrom || !validTo)
            {
                lblMessage.Text = "Invalid date format. Use MM/DD/YYYY.";
                return;
            }

            if (fromDate > DateTime.Today || toDate > DateTime.Today)
            {
                lblMessage.Text = "Dates cannot be in the future.";
                return;
            }

            if (fromDate > toDate)
            {
                lblMessage.Text = "'From' date must be earlier than 'To' date.";
                return;
            }

            int userId = Convert.ToInt32(Session["UserId"]);

            using (SqlConnection db = DBHelper.GetConnection())
            {
                db.Open();

                SqlCommand cmd = new SqlCommand(@"
                    SELECT 
                        ROW_NUMBER() OVER (ORDER BY TransactionDate ASC) AS Seq,
                        CASE 
                            WHEN TransactionType = 'Deposit' THEN 'D'
                            WHEN TransactionType = 'Withdrawal' THEN 'W'
                            WHEN TransactionType = 'Sent' THEN 'S'
                            WHEN TransactionType = 'Received' THEN 'R'
                        END AS Type,
                        CONVERT(varchar, TransactionDate, 101) + ' ' + 
                        CONVERT(varchar, TransactionDate, 108) AS [Date],
                        Debit,
                        Credit,
                        BalanceAfter,
                        SentTo,
                        ReceivedFrom
                    FROM Transactions
                    WHERE UserId = @UserId
                    AND TransactionDate >= @FromDate
                    AND TransactionDate < DATEADD(DAY, 1, @ToDate)
                    ORDER BY TransactionDate ASC
                ", db);

                cmd.Parameters.AddWithValue("@UserId", userId);
                cmd.Parameters.AddWithValue("@FromDate", fromDate);
                cmd.Parameters.AddWithValue("@ToDate", toDate);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvStatement.DataSource = dt;
                gvStatement.DataBind();

                lblMessage.Text = dt.Rows.Count == 0 ? "No records found." : "";
            }
        }
    }
}