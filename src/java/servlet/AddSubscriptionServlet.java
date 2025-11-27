package servlet;

import dao.SubscriptionDAO;
import dao.ServiceDAO;
import dao.BillingDAO;
import model.Billing;
import model.Service;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.Date;

@WebServlet("/customer/addSubscription")
public class AddSubscriptionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Ensure user login
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("../login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        SubscriptionDAO subDAO = new SubscriptionDAO();
        ServiceDAO serviceDAO = new ServiceDAO();
        BillingDAO billingDAO = new BillingDAO();

        // Fetch customer ID
        int customerId = subDAO.getCustomerIdByUserId(userId);
        if (customerId == 0) {
            response.sendRedirect("../error.jsp");
            return;
        }

        try {
            int serviceId = Integer.parseInt(request.getParameter("service_id"));

            // Fetch service to get duration and charge
            Service service = serviceDAO.getServiceById(serviceId);
            if (service == null) {
                response.sendRedirect("subscriptions.jsp?error=Service+not+found");
                return;
            }

            // 1️⃣ Purchase date = now
            LocalDateTime purchaseDate = LocalDateTime.now();

            // 2️⃣ Calculate expiry based on service duration
            LocalDateTime expiryDate = calculateExpiry(purchaseDate, service);

            // 3️⃣ Add subscription to DB
            boolean added = subDAO.addSubscription(customerId, serviceId,
                    java.util.Date.from(purchaseDate.atZone(java.time.ZoneId.systemDefault()).toInstant()),
                    java.util.Date.from(expiryDate.atZone(java.time.ZoneId.systemDefault()).toInstant()));

            if (!added) {
                response.sendRedirect("subscriptions.jsp?error=Failed+to+add+subscription");
                return;
            }

            // 4️⃣ Generate billing
            Billing bill = new Billing();
            bill.setCustomerId(customerId);
            bill.setServiceId(serviceId);
            bill.setAmount(service.getCharge());
            bill.setBillingDate(java.util.Date.from(purchaseDate.atZone(java.time.ZoneId.systemDefault()).toInstant()));
            bill.setPaid(false);

            billingDAO.generateBill(bill);

            response.sendRedirect("subscriptions.jsp?success=Subscription+added+successfully");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("subscriptions.jsp?error=Invalid+input");
        }
    }

    /** Calculate expiry date based on service duration */
    private LocalDateTime calculateExpiry(LocalDateTime start, Service service) {
        int duration = service.getDurationValue();
        String unit = service.getDurationUnit(); // "HOUR", "DAY", "WEEK", "MONTH"

        switch (unit.toUpperCase()) {
            case "HOUR":
                return start.plus(duration, ChronoUnit.HOURS);
            case "DAY":
                return start.plus(duration, ChronoUnit.DAYS);
            case "WEEK":
                return start.plus(duration, ChronoUnit.WEEKS);
            case "MONTH":
                return start.plus(duration, ChronoUnit.MONTHS);
            default:
                return start.plusDays(1); // fallback
        }
    }
}
