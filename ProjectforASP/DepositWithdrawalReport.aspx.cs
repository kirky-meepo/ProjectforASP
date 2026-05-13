using System;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;

namespace CloudMoney
{
    public partial class DepositWithdrawalReport : System.Web.UI.Page
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
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "Invalid date format. Use MM/DD/YYYY.";
                return;
            }

            if (fromDate > DateTime.Today || toDate > DateTime.Today)
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "Dates cannot be future dates.";
                return;
            }

            if (fromDate > toDate)
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "From date must be earlier than To date.";
                return;
            }

            int userId = Convert.ToInt32(Session["UserId"]);
            string type = ddlType.SelectedValue;

            using (SqlConnection db = DBHelper.GetConnection())
            {
                db.Open();

                string query = @"
                    SELECT 
                        ROW_NUMBER() OVER (ORDER BY TransactionDate ASC) AS Seq,

                        CASE 
                            WHEN TransactionType = 'Deposit' THEN 'D'
                            WHEN TransactionType = 'Withdrawal' THEN 'W'
                        END AS Type,

                        CONVERT(varchar, TransactionDate, 101) + ' ' +
                        CONVERT(varchar, TransactionDate, 108) AS [Date],

                        Amount

                    FROM Transactions

                    WHERE UserId = @UserId
                    AND TransactionType IN ('Deposit','Withdrawal')

                    AND TransactionDate >= @FromDate
                    AND TransactionDate < DATEADD(DAY,1,@ToDate)
                ";

                if (type != "All")
                {
                    query += " AND TransactionType = @Type";
                }

                query += " ORDER BY TransactionDate ASC";

                SqlCommand cmd = new SqlCommand(query, db);

                cmd.Parameters.AddWithValue("@UserId", userId);
                cmd.Parameters.AddWithValue("@FromDate", fromDate);
                cmd.Parameters.AddWithValue("@ToDate", toDate);

                if (type != "All")
                {
                    cmd.Parameters.AddWithValue("@Type", type);
                }

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();

                da.Fill(dt);

                foreach (DataRow row in dt.Rows)
                {
                    row["Amount"] = Convert.ToDecimal(row["Amount"]).ToString("N2");
                }

                gvReport.DataSource = dt;
                gvReport.DataBind();

                lblMessage.Text = dt.Rows.Count == 0
                    ? "No records found."
                    : "";
            }
        }
    }
}