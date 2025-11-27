package servlet;

import dao.SubscriptionDAO;
import model.Subscription;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/customer/subscriptions")
public class CustomerSubscriptionsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        // Check login
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        SubscriptionDAO dao = new SubscriptionDAO();

        // Convert user → customer ID
        int customerId = dao.getCustomerIdByUserId(userId);
        if (customerId == 0) {
            req.setAttribute("error", "Customer profile not found.");
            req.getRequestDispatcher("/customer/subscriptions.jsp")
                    .forward(req, resp);
            return;
        }

        // Fetch subscriptions (now includes start_date, end_date, service_name, status)
        List<Subscription> subs = dao.getSubscriptionsByCustomerId(customerId);

        req.setAttribute("subscriptions", subs);

        // Forward to JSP
        req.getRequestDispatcher("/customer/subscriptions.jsp")
                .forward(req, resp);
    }
}
