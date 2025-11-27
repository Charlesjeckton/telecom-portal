package servlet;

import util.DBConnectionManager;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        String sql = "SELECT id, role FROM users WHERE username=? AND password=?";

        try (Connection conn = DBConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, username);
            stmt.setString(2, password);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {

                int userId = rs.getInt("id");
                String role = rs.getString("role");

                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                session.setAttribute("role", role);
                session.setAttribute("userId", userId);

                // ---------- FETCH CUSTOMER ID ----------
                int customerId = 0;
                try (PreparedStatement custStmt =
                             conn.prepareStatement("SELECT id FROM customers WHERE user_id=?")) {

                    custStmt.setInt(1, userId);
                    ResultSet custRs = custStmt.executeQuery();

                    if (custRs.next()) {
                        customerId = custRs.getInt("id");
                        session.setAttribute("customerId", customerId);
                    }
                }

                // ---------- REDIRECT BY ROLE ----------
                if ("ADMIN".equalsIgnoreCase(role)) {
                    response.sendRedirect("admin/dashboard.jsp");

                } else if ("CUSTOMER".equalsIgnoreCase(role)) {
                    response.sendRedirect("customer/home.jsp");

                } else {
                    response.sendRedirect("login.jsp?error=Unknown role");
                }

            } else {
                request.setAttribute("error", "Invalid username or password");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Login error: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
