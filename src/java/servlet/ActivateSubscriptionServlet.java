package servlet;

import dao.SubscriptionDAO;
import dao.ServiceDAO;
import dao.BillingDAO;
import model.Billing;
import model.Service;
import model.Subscription;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;
import java.util.Date;

@WebServlet("/customer/activateSubscription")
public class ActivateSubscriptionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // 1️⃣ Must be logged in
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("../login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        SubscriptionDAO subDAO = new SubscriptionDAO();
        ServiceDAO serviceDAO = new ServiceDAO();
        BillingDAO billingDAO = new BillingDAO();

        // 2️⃣ Fetch customer ID mapped to user
        int customerId = subDAO.getCustomerIdByUserId(userId);
        if (customerId == 0) {
            response.sendRedirect("../error.jsp");
            return;
        }

        try {
            // 3️⃣ Subscription ID
            int subId = Integer.parseInt(request.getParameter("id"));

            // 4️⃣ Ensure subscription belongs to logged-in customer
            if (!subDAO.customerOwnsSubscription(customerId, subId)) {
                response.sendRedirect("subscriptions.jsp?error=Unauthorized+action");
                return;
            }

            // 5️⃣ Fetch subscription and service
            Subscription sub = subDAO.getSubscriptionById(subId);
            if (sub == null) {
                response.sendRedirect("subscriptions.jsp?error=Subscription+not+found");
                return;
            }

            Service service = serviceDAO.getServiceById(sub.getServiceId());
            if (service == null) {
                response.sendRedirect("subscriptions.jsp?error=Service+not+found");
                return;
            }

            // 6️⃣ Calculate purchaseDate and expiryDate
            LocalDateTime purchaseDateTime = LocalDateTime.now();
            LocalDateTime expiryDateTime = calculateExpiry(purchaseDateTime, service);

            Date purchaseDate = Date.from(purchaseDateTime.atZone(ZoneId.systemDefault()).toInstant());
            Date expiryDate = Date.from(expiryDateTime.atZone(ZoneId.systemDefault()).toInstant());

            // 7️⃣ Activate subscription
            boolean activated = subDAO.activateSubscription(subId, purchaseDate, expiryDate);
            if (!activated) {
                response.sendRedirect("subscriptions.jsp?error=Activation+failed");
                return;
            }

            // 8️⃣ Create billing
            Billing bill = new Billing();
            bill.setCustomerId(customerId);
            bill.setServiceId(service.getId());
            bill.setAmount(service.getCharge());
            bill.setBillingDate(purchaseDate);
            bill.setPaid(false);

            billingDAO.generateBill(bill);

            // 9️⃣ Redirect success
            response.sendRedirect("subscriptions.jsp?success=Subscription+Activated");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("subscriptions.jsp?error=Invalid+input");
        }
    }

    /** Calculate expiry based on service duration */
    private LocalDateTime calculateExpiry(LocalDateTime start, Service service) {
        int duration = service.getDurationValue();
        String unit = service.getDurationUnit();  // HOUR, DAY, WEEK, MONTH

        switch (unit) {
            case "HOUR":
                return start.plus(duration, ChronoUnit.HOURS);
            case "DAY":
                return start.plus(duration, ChronoUnit.DAYS);
            case "WEEK":
                return start.plus(duration, ChronoUnit.WEEKS);
            case "MONTH":
                return start.plus(duration, ChronoUnit.MONTHS);
            default:
                return start.plusDays(1);
        }
    }
}
