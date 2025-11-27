package servlet;

import dao.CustomerDAO;
import model.Customer;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/testCustomer")
public class TestCustomerServlet extends HttpServlet {

@Override
protected void doGet(HttpServletRequest req, HttpServletResponse res)
        throws ServletException, IOException {

    res.setContentType("text/html");
    PrintWriter out = res.getWriter();

    try {
        CustomerDAO dao = new CustomerDAO();

        List<Customer> customers = dao.getAllCustomers();

        out.println("<h2>Customer List:</h2>");

        if (customers == null || customers.isEmpty()) {
            out.println("<p>No customers found.</p>");
        } else {
            out.println("<ul>");
            for (Customer c : customers) {
                out.println("<li>ID: " + c.getId() +
                            " | Name: " + c.getName() +
                            " | Phone: " + c.getPhoneNumber() +
                            " | Email: " + c.getEmail() +
                            " | Registered: " + c.getRegistrationDate() +
                            "</li>");
            }
            out.println("</ul>");
        }

    } catch (Exception e) {
        out.println("<p>Error retrieving customers: " + e.getMessage() + "</p>");
        e.printStackTrace();
    } finally {
        out.close();
    }
}

}
