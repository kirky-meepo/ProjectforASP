using System.Configuration;
using System.Data.SqlClient;

public class DBHelper
{
    public static SqlConnection GetConnection()
    {
        string conn = ConfigurationManager.ConnectionStrings["CloudMoneyDBss"].ConnectionString;
        return new SqlConnection(conn);
    }
}