using System;
using System.Data.SqlClient;

namespace CloudMoney
{
    public partial class SendCloudMoney : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("Login.aspx");
            }
        }

        protected void btnCheck_Click(object sender, EventArgs e)
        {
            string accountNo = txtRecipientAccount.Text.Trim();

            using (SqlConnection db = DBHelper.GetConnection())
            {
                db.Open();

                SqlCommand cmd = new SqlCommand(
                    @"SELECT UserId, AccountNo, FirstName, LastName 
                      FROM Users 
                      WHERE AccountNo=@AccountNo AND IsActive=1", db);

                cmd.Parameters.AddWithValue("@AccountNo", accountNo);

                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    if (Convert.ToInt32(dr["UserId"]) == Convert.ToInt32(Session["UserId"]))
                    {
                        lblMessage.Text = "You cannot send CloudMoney to your own account.";
                        lblAccountNo.Text = "";
                        lblRecipientName.Text = "";
                        return;
                    }

                    lblAccountNo.Text = dr["AccountNo"].ToString();
                    lblRecipientName.Text = dr["FirstName"].ToString() + " " + dr["LastName"].ToString();
                    lblMessage.Text = "Recipient account found.";
                }
                else
                {
                    lblAccountNo.Text = "";
                    lblRecipientName.Text = "";
                    lblMessage.Text = "Recipient account does not exist.";
                }
            }
        }

        protected void btnSend_Click(object sender, EventArgs e)
        {
            int senderUserId = Convert.ToInt32(Session["UserId"]);
            string recipientAccountNo = txtRecipientAccount.Text.Trim();
            string password = txtPassword.Text.Trim();
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

                SqlCommand passCmd = new SqlCommand(
                    "SELECT COUNT(*) FROM Users WHERE UserId=@UserId AND Password=@Password", db);

                passCmd.Parameters.AddWithValue("@UserId", senderUserId);
                passCmd.Parameters.AddWithValue("@Password", password);

                int passwordValid = Convert.ToInt32(passCmd.ExecuteScalar());

                if (passwordValid == 0)
                {
                    lblMessage.Text = "Incorrect password.";
                    return;
                }

                SqlCommand recCmd = new SqlCommand(
                    "SELECT UserId FROM Users WHERE AccountNo=@AccountNo AND IsActive=1", db);

                recCmd.Parameters.AddWithValue("@AccountNo", recipientAccountNo);

                object recResult = recCmd.ExecuteScalar();

                if (recResult == null)
                {
                    lblMessage.Text = "Recipient account does not exist.";
                    return;
                }

                int receiverUserId = Convert.ToInt32(recResult);

                if (receiverUserId == senderUserId)
                {
                    lblMessage.Text = "You cannot send CloudMoney to your own account.";
                    return;
                }

                SqlCommand senderBalCmd = new SqlCommand(
                    "SELECT Balance FROM Accounts WHERE UserId=@UserId", db);

                senderBalCmd.Parameters.AddWithValue("@UserId", senderUserId);

                decimal senderBalance = Convert.ToDecimal(senderBalCmd.ExecuteScalar());

                if (amount > senderBalance)
                {
                    lblMessage.Text = "Insufficient funds.";
                    return;
                }

                SqlCommand receiverBalCmd = new SqlCommand(
                    "SELECT Balance FROM Accounts WHERE UserId=@UserId", db);

                receiverBalCmd.Parameters.AddWithValue("@UserId", receiverUserId);

                decimal receiverBalance = Convert.ToDecimal(receiverBalCmd.ExecuteScalar());

                decimal senderNewBalance = senderBalance - amount;
                decimal receiverNewBalance = receiverBalance + amount;

                SqlCommand updateSender = new SqlCommand(
                    "UPDATE Accounts SET Balance=@Balance WHERE UserId=@UserId", db);

                updateSender.Parameters.AddWithValue("@Balance", senderNewBalance);
                updateSender.Parameters.AddWithValue("@UserId", senderUserId);
                updateSender.ExecuteNonQuery();

                SqlCommand updateReceiver = new SqlCommand(
                    "UPDATE Accounts SET Balance=@Balance WHERE UserId=@UserId", db);

                updateReceiver.Parameters.AddWithValue("@Balance", receiverNewBalance);
                updateReceiver.Parameters.AddWithValue("@UserId", receiverUserId);
                updateReceiver.ExecuteNonQuery();

                SqlCommand senderAccCmd = new SqlCommand(
                    "SELECT AccountNo FROM Users WHERE UserId=@UserId", db);

                senderAccCmd.Parameters.AddWithValue("@UserId", senderUserId);

                string senderAccountNo = senderAccCmd.ExecuteScalar().ToString();

                SqlCommand sentTrans = new SqlCommand(
                    @"INSERT INTO Transactions(UserId, TransactionType, Amount, Debit, BalanceAfter, SentTo)
                      VALUES(@UserId, 'Sent', @Amount, @Amount, @BalanceAfter, @SentTo)", db);

                sentTrans.Parameters.AddWithValue("@UserId", senderUserId);
                sentTrans.Parameters.AddWithValue("@Amount", amount);
                sentTrans.Parameters.AddWithValue("@BalanceAfter", senderNewBalance);
                sentTrans.Parameters.AddWithValue("@SentTo", recipientAccountNo);
                sentTrans.ExecuteNonQuery();

                SqlCommand receivedTrans = new SqlCommand(
                    @"INSERT INTO Transactions(UserId, TransactionType, Amount, Credit, BalanceAfter, ReceivedFrom)
                      VALUES(@UserId, 'Received', @Amount, @Amount, @BalanceAfter, @ReceivedFrom)", db);

                receivedTrans.Parameters.AddWithValue("@UserId", receiverUserId);
                receivedTrans.Parameters.AddWithValue("@Amount", amount);
                receivedTrans.Parameters.AddWithValue("@BalanceAfter", receiverNewBalance);
                receivedTrans.Parameters.AddWithValue("@ReceivedFrom", senderAccountNo);
                receivedTrans.ExecuteNonQuery();

                SqlCommand notif = new SqlCommand(
                    @"INSERT INTO Notifications(UserId, Message)
                      VALUES(@UserId, @Message)", db);

                notif.Parameters.AddWithValue("@UserId", receiverUserId);
                notif.Parameters.AddWithValue("@Message", "You received " + amount.ToString("N2") + " CloudMoney from account " + senderAccountNo);
                notif.ExecuteNonQuery();

                lblMessage.Text = "CloudMoney sent successfully.";
            }
        }
    }
}