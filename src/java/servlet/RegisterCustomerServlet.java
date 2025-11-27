package servlet;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/registerCustomer")
public class RegisterCustomerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Allow opening URL directly in browser
        request.getRequestDispatcher("registerCustomer.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // ✅ MATCH DBConnectionManager EXACTLY
        String url = "jdbc:mysql://localhost:3307/telecom?useSSL=false&serverTimezone=UTC";
        String user = "root";
        String pass = "";

        Connection conn = null;

        try {
            // Required for Payara even if standalone works
            Class.forName("com.mysql.cj.jdbc.Driver");

            conn = DriverManager.getConnection(url, user, pass);
            conn.setAutoCommit(false); // transaction start

            // Insert into users
            String userSql = "INSERT INTO users (username, password, role) VALUES (?, ?, 'CUSTOMER')";
            PreparedStatement userStmt = conn.prepareStatement(userSql, Statement.RETURN_GENERATED_KEYS);
            userStmt.setString(1, username);
            userStmt.setString(2, password);
            userStmt.executeUpdate();

            ResultSet rs = userStmt.getGeneratedKeys();
            int userId = 0;

            if (rs.next()) {
                userId = rs.getInt(1);
            }

            // Insert into customers
            String customerSql = "INSERT INTO customers (name, phone_number, email, registration_date, user_id) VALUES (?, ?, ?, CURDATE(), ?)";
            PreparedStatement custStmt = conn.prepareStatement(customerSql);
            custStmt.setString(1, name);
            custStmt.setString(2, phone);
            custStmt.setString(3, email);
            custStmt.setInt(4, userId);

            custStmt.executeUpdate();

            conn.commit();

            request.setAttribute("message", "Customer registered successfully!");
            request.setAttribute("messageType", "success");

        } catch (Exception e) {

            e.printStackTrace(); // show real error

            try { if (conn != null) conn.rollback(); } catch (Exception ex) {}

            request.setAttribute("message", "Error: " + e.getMessage());
            request.setAttribute("messageType", "error");
        }

        request.getRequestDispatcher("registerCustomer.jsp").forward(request, response);
    }
}
