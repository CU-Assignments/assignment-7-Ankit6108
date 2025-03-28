import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class FetchEmployeeData {
    // JDBC URL, username and password of MySQL server
    private static final String URL = "jdbc:mysql://localhost:3306/your_database_name";
    private static final String USER = "your_username";
    private static final String PASSWORD = "your_password";

    public static void main(String[] args) {
        // Establishing a connection
        try (Connection connection = DriverManager.getConnection(URL, USER, PASSWORD)) {
            System.out.println("Connected to the database successfully.");

            // Creating a statement
            Statement statement = connection.createStatement();

            // Executing a query to fetch data from Employee table
            String query = "SELECT EmpID, Name, Salary FROM Employee";
            ResultSet resultSet = statement.executeQuery(query);

            // Processing the result set
            System.out.println("EmpID\tName\tSalary");
            System.out.println("-------------------------");
            while (resultSet.next()) {
                int empId = resultSet.getInt("EmpID");
                String name = resultSet.getString("Name");
                double salary = resultSet.getDouble("Salary");

                // Displaying the data
                System.out.printf("%d\t%s\t%.2f%n", empId, name, salary);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
