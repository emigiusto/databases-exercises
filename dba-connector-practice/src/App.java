import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class App {
    public static void main(String[] args) throws Exception {
            Connection conn = null;
            try {
                String url = "jdbc:postgresql://localhost/imdb?user=postgres&password=1234";
                conn = DriverManager.getConnection(url);
                System.out.println("Connected to the PostgreSQL server successfully.");
                /*  ----------------  */
                Statement stmt = null;
                String query = "select * from movie where id = 261";
                try {
                    stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery(query);
                    while (rs.next()) {
                        String name = rs.getString("title");
                        System.out.println(name);
                    }
                } catch (SQLException e ) {
                    throw new Error("Problem", e);
                } finally {
                    if (stmt != null) { stmt.close(); }
                }
            } catch (SQLException e) {
                System.out.println(e.getMessage());
            } finally {
                try {
                    if (conn != null) {
                        conn.close();
                    }
                } catch (SQLException ex) {
                    System.out.println(ex.getMessage());
                }
            }
    }
}
