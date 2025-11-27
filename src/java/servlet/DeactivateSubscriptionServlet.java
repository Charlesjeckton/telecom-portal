package servlet;

import dao.SubscriptionDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(urlPatterns = {
        "/customer/deactivateSubscription",
        "/admin/deactivateSubscription"
})
public class DeactivateSubscriptionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);

        // Check login
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("../login.jsp");
            return;
        }

        String path = request.getServletPath(); // detects /customer/... or /admin/...

        boolean isCustomer = path.contains("/customer/");
        boolean isAdmin = path.contains("/admin/");

        SubscriptionDAO dao = new SubscriptionDAO();

        int userId = (int) session.getAttribute("userId");

        int customerId = 0;

        // Only customers need customerId
        if (isCustomer) {
            customerId = dao.getCustomerIdByUserId(userId);

            if (customerId == 0) {
                response.sendRedirect("../error.jsp");
                return;
            }
        }

        // Validate subscription ID
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            redirectError(response, path, "Invalid subscription ID");
            return;
        }

        int subscriptionId;

        try {
            subscriptionId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            redirectError(response, path, "Invalid subscription ID");
            return;
        }

        // Customer must own subscription
        if (isCustomer && !dao.customerOwnsSubscription(customerId, subscriptionId)) {
            redirectError(response, path, "Access denied");
            return;
        }

        // Deactivate
        boolean ok = dao.deactivateSubscription(subscriptionId);

        if (ok) {
            redirectSuccess(response, path, "Subscription deactivated");
        } else {
            redirectError(response, path, "Failed to deactivate");
        }
    }

    // POST -> redirect to GET
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        doGet(request, response);
    }

    private void redirectError(HttpServletResponse response, String path, String msg) throws IOException {
        if (path.contains("/customer/")) {
            response.sendRedirect("subscriptions.jsp?error=" + msg.replace(" ", "+"));
        } else {
            response.sendRedirect("../admin/subscriptions.jsp?error=" + msg.replace(" ", "+"));
        }
    }

    private void redirectSuccess(HttpServletResponse response, String path, String msg) throws IOException {
        if (path.contains("/customer/")) {
            response.sendRedirect("subscriptions.jsp?success=" + msg.replace(" ", "+"));
        } else {
            response.sendRedirect("../admin/subscriptions.jsp?success=" + msg.replace(" ", "+"));
        }
    }
}
