import java.sql.*;
import java.io.*;

String url = "jdbc:filemaker://localhost/database_name";
String driver = "com.filemaker.jdbc.Driver";
String user = "admin";
String password = "";

System.setProperty("jdbc.drivers", driver);
try {
  Connection connection = DriverManager.getConnection (url, user, password);
  Statement statement = connection.createStatement ();
  String q = "SELECT * FROM table";
  ResultSet srs = statement.executeQuery (q);

  for (int i = 0; srs.next(); i++)
  {
    String row = srs.getString("COLUMN_NAME");
    println (row);
  }
    
  srs.close();
  connection.close();
} catch (Exception e) {
  print (e);
}
