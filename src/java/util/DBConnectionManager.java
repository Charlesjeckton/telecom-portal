package util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DBConnectionManager {
    private static final String PROPS = "/db.properties";
    private static String url;
    private static String user;
    private static String password;

    static {
        try (InputStream in = DBConnectionManager.class.getResourceAsStream(PROPS)) {
            if (in == null) throw new RuntimeException("db.properties NOT FOUND in classpath!");
            Properties p = new Properties();
            p.load(in);
            url = p.getProperty("db.url");
            user = p.getProperty("db.user");
            password = p.getProperty("db.password");
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (Exception e) {
            throw new RuntimeException("Failed to load database credentials: " + e.getMessage(), e);
        }
    }

    // ✅ Updated to throw only SQLException
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, user, password);
    }
}
