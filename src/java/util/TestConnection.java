package util;

import java.sql.Connection;

public class TestConnection {
    public static void main(String[] args) {
        try (Connection conn = DBConnectionManager.getConnection()) {
            if (conn != null) {
                System.out.println("Database connection successful!");
            }
        } catch (Exception e) {
            e.printStackTrace(); // <-- show actual error
        }
    }
}
