package servlet.customer;

import dao.CustomerDAO;
import model.Customer;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.Date;

@WebServlet("/customer/registerCustomer")
public class RegisterCustomerServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Read form fields
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Build Customer object
        Customer c = new Customer();
        c.setName(name);
        c.setEmail(email);
        c.setPhoneNumber(phone);
        c.setRegistrationDate(new Date()); // auto-set

        // Build User object
        User u = new User();
        u.setUsername(username);
        u.setPassword(password);
        u.setRole("CUSTOMER");

        // Register using DAO
        CustomerDAO dao = new CustomerDAO();
        String result = dao.registerCustomer(c, u);  // Now returns string!

        if (result.equals("SUCCESS")) {
            String msg = URLEncoder.encode("Customer Registered Successfully", "UTF-8");
            response.sendRedirect("registerCustomer.jsp?success=" + msg);
        } else {
            // return exact failure reason
            String err = URLEncoder.encode(result, "UTF-8");
            response.sendRedirect("registerCustomer.jsp?error=" + err);
        }
    }
}
