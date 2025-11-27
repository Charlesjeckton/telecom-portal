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

@WebServlet("/registerCustomer")
public class RegisterCustomerServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Read form inputs
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Build Customer object
        Customer customer = new Customer();
        customer.setName(name);
        customer.setEmail(email);
        customer.setPhoneNumber(phone);
        customer.setRegistrationDate(new Date());

        // Build User object
        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setRole("CUSTOMER");

        // Save in DB
        CustomerDAO dao = new CustomerDAO();
        String result = dao.registerCustomer(customer, user);  // Returns SUCCESS or error message

        if ("SUCCESS".equals(result)) {

            String msg = URLEncoder.encode("Customer Registered Successfully", "UTF-8");
            response.sendRedirect(request.getContextPath() + "/registerCustomer.jsp?success=" + msg);

        } else {

            String msg = URLEncoder.encode(result, "UTF-8");
            response.sendRedirect(request.getContextPath() + "/registerCustomer.jsp?error=" + msg);
        }
    }
}
