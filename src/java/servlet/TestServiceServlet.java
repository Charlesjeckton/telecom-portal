package servlet;

import dao.ServiceDAO;
import model.Service;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/testService")
public class TestServiceServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        res.setContentType("text/html");
        PrintWriter out = res.getWriter();

        ServiceDAO dao = new ServiceDAO();
        List<Service> services = dao.getAllServices();

        out.println("<h2>Services List</h2>");
        for (Service s : services) {
            out.println("<p>" + s.getId() + " - " + s.getName() + " - " + s.getCharge() + "</p>");
        }
    }
}
