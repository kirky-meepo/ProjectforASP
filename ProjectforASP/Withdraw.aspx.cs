using System;
using System.Data.SqlClient;

namespace CloudMoney
{
    public partial class Withdraw : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("Login.aspx");
            }

            if (!IsPostBack)
            {
                LoadBalance();
            }
        }

        private void LoadBalance()
        {
            int userId = Convert.ToInt32(Session["UserId"]);

            using (SqlConnection db = DBHelper.GetConnection())
            {
                db.Open();

                SqlCommand cmd = new SqlCommand(
                    "SELECT Balance FROM Accounts WHERE UserId=@UserId", db);

                cmd.Parameters.AddWithValue("@UserId", userId);

                decimal balance = Convert.ToDecimal(cmd.ExecuteScalar());
                lblBalance.Text = balance.ToString("N2");
            }
        }

        protected void btnWithdraw_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            decimal amount;

            if (!decimal.TryParse(txtAmount.Text, out amount))
            {
                lblMessage.Text = "Invalid amount.";
                return;
            }

            if (amount < 100 || amount > 50000 || amount % 100 != 0)
            {
                lblMessage.Text = "Amount must be 100 to 50,000 and divisible by 100.";
                return;
            }

            using (SqlConnection db = DBHelper.GetConnection())
            {
                db.Open();

                SqlCommand balCmd = new SqlCommand(
                    "SELECT Balance FROM Accounts WHERE UserId=@UserId", db);

                balCmd.Parameters.AddWithValue("@UserId", userId);

                decimal balance = Convert.ToDecimal(balCmd.ExecuteScalar());

                if (amount > balance)
                {
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    lblMessage.Text = "Invalid amount.";
                    return;
                }

                decimal newBalance = balance - amount;

                SqlCommand update = new SqlCommand(
                    "UPDATE Accounts SET Balance=@Balance WHERE UserId=@UserId", db);

                update.Parameters.AddWithValue("@Balance", newBalance);
                update.Parameters.AddWithValue("@UserId", userId);
                update.ExecuteNonQuery();

                SqlCommand trans = new SqlCommand(
                    @"INSERT INTO Transactions(UserId, TransactionType, Amount, Debit, BalanceAfter)
                      VALUES(@UserId, 'Withdrawal', @Amount, @Amount, @BalanceAfter)", db);

                trans.Parameters.AddWithValue("@UserId", userId);
                trans.Parameters.AddWithValue("@Amount", amount);
                trans.Parameters.AddWithValue("@BalanceAfter", newBalance);
                trans.ExecuteNonQuery();

                lblMessage.Text = "Withdrawal successful.";
                lblBalance.Text = newBalance.ToString("N2");

                SqlCommand notif = new SqlCommand(
                @"INSERT INTO Notifications(UserId, Message, ReferenceNo, Amount)
                  VALUES(@UserId, @Message, @ReferenceNo, @Amount)", db);

                notif.Parameters.AddWithValue("@UserId", userId);
                notif.Parameters.AddWithValue("@Message", "Withdrawal successful");
                notif.Parameters.AddWithValue("@ReferenceNo", "WDR" + DateTime.Now.ToString("yyyyMMddHHmmss"));
                notif.Parameters.AddWithValue("@Amount", amount);

                notif.ExecuteNonQuery();
            }
        }
    }
}