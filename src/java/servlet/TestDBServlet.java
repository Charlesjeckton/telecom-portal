package servlet;

import util.DBConnectionManager;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/testdb")
public class TestDBServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        try {
            Connection conn = DBConnectionManager.getConnection();
            if (conn != null) {
                out.println("<h1>Database connection successful!</h1>");
                conn.close();
            } else {
                out.println("<h1>Failed to connect to the database.</h1>");
            }
        } catch (Exception e) {
            out.println("<h1>Error: " + e.getMessage() + "</h1>");
            e.printStackTrace(out);
        }
    }
}
