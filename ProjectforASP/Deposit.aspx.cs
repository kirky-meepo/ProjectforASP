using System;
using System.Data.SqlClient;

namespace CloudMoney
{
    public partial class Deposit : System.Web.UI.Page
    {
        protected void btnDeposit_Click(object sender, EventArgs e)
        {
            // ✅ Check if user is logged in
            if (Session["UserId"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            int userId = Convert.ToInt32(Session["UserId"]);
            decimal amount;

            // ✅ Validate input
            if (!decimal.TryParse(txtAmount.Text, out amount))
            {
                lblMessage.Text = "Invalid amount.";
                return;
            }

            // ✅ Deposit rules
            if (amount < 100 || amount > 50000 || amount % 100 != 0)
            {
                lblMessage.Text = "Deposit must be between 100 and 50,000, multiples of 100 only.";
                return;
            }

            using (SqlConnection db = DBHelper.GetConnection())
            {
                db.Open();

                // ✅ Get current balance
                SqlCommand balCmd = new SqlCommand(
                    "SELECT Balance FROM Accounts WHERE UserId=@UserId", db);

                balCmd.Parameters.AddWithValue("@UserId", userId);

                object result = balCmd.ExecuteScalar();

                if (result == null)
                {
                    lblMessage.Text = "Account not found.";
                    return;
                }

                decimal balance = Convert.ToDecimal(result);

                decimal newBalance = balance + amount;

                // ✅ Update balance
                SqlCommand update = new SqlCommand(
                    "UPDATE Accounts SET Balance=@Bal WHERE UserId=@UserId", db);

                update.Parameters.AddWithValue("@Bal", newBalance);
                update.Parameters.AddWithValue("@UserId", userId);
                update.ExecuteNonQuery();

                // ✅ Insert transaction record
                SqlCommand trans = new SqlCommand(
                    @"INSERT INTO Transactions(UserId, TransactionType, Amount, Credit, BalanceAfter)
                      VALUES(@UserId, 'Deposit', @Amt, @Amt, @Bal)", db);

                trans.Parameters.AddWithValue("@UserId", userId);
                trans.Parameters.AddWithValue("@Amt", amount);
                trans.Parameters.AddWithValue("@Bal", newBalance);
                trans.ExecuteNonQuery();

                lblMessage.ForeColor = System.Drawing.Color.Green;
                lblMessage.Text = "Deposit successful!";

                SqlCommand notif = new SqlCommand(
                @"INSERT INTO Notifications(UserId, Message, ReferenceNo, Amount)
                  VALUES(@UserId, @Message, @ReferenceNo, @Amount)", db);

                notif.Parameters.AddWithValue("@UserId", userId);
                notif.Parameters.AddWithValue("@Message", "Deposit successful");
                notif.Parameters.AddWithValue("@ReferenceNo", "DEP" + DateTime.Now.ToString("yyyyMMddHHmmss"));
                notif.Parameters.AddWithValue("@Amount", amount);

                notif.ExecuteNonQuery();
            }
        }

        // ✅ BACK BUTTON FUNCTION
        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("Dashboard.aspx");
        }
    }
}