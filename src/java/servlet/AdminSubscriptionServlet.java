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
import java.util.Date;

@WebServlet("/subscription")
public class AdminSubscriptionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect("subscriptions.jsp?error=Invalid+action");
            return;
        }

        if (action.equals("add")) {
            addSubscription(request, response);
        } else {
            response.sendRedirect("subscriptions.jsp?error=Unknown+action");
        }
    }

    private void addSubscription(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            int customerId = Integer.parseInt(request.getParameter("customer_id"));
            int serviceId = Integer.parseInt(request.getParameter("service_id"));

            SubscriptionDAO subDAO = new SubscriptionDAO();
            ServiceDAO serviceDAO = new ServiceDAO();
            BillingDAO billingDAO = new BillingDAO();

            // 1️⃣ Fetch service (to get charge + duration)
            Service service = serviceDAO.getServiceById(serviceId);

            if (service == null) {
                response.sendRedirect("addSubscription.jsp?error=Service+not+found");
                return;
            }

            // 2️⃣ Use current datetime as purchase date
            LocalDateTime purchaseDateTime = LocalDateTime.now();
            Date purchaseDate = Date.from(purchaseDateTime.atZone(ZoneId.systemDefault()).toInstant());

            // 3️⃣ Auto-calc expiry
            LocalDateTime expiryDateTime = calculateExpiry(purchaseDateTime, service);
            Date expiryDate = Date.from(expiryDateTime.atZone(ZoneId.systemDefault()).toInstant());

            // 4️⃣ Add subscription into DB
            Subscription sub = new Subscription(customerId, serviceId, purchaseDate, expiryDate, "ACTIVE");
            boolean added = subDAO.addSubscription(sub);

            if (!added) {
                response.sendRedirect("addSubscription.jsp?error=Failed+to+add+subscription");
                return;
            }

            // 5️⃣ Create billing record
            Billing bill = new Billing();
            bill.setCustomerId(customerId);
            bill.setServiceId(serviceId);
            bill.setAmount(service.getCharge());
            bill.setBillingDate(purchaseDate);
            bill.setPaid(false);

            billingDAO.generateBill(bill);

            response.sendRedirect("subscriptions.jsp?success=Subscription+added+successfully");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("addSubscription.jsp?error=Invalid+input");
        }
    }

    /** Calculate expiry based on service duration */
    private LocalDateTime calculateExpiry(LocalDateTime start, Service service) {

        int duration = service.getDurationValue();
        String unit = service.getDurationUnit();  // HOUR, DAY, WEEK, MONTH

        switch (unit) {
            case "HOUR":
                return start.plusHours(duration);
            case "DAY":
                return start.plusDays(duration);
            case "WEEK":
                return start.plusWeeks(duration);
            case "MONTH":
                return start.plusMonths(duration);
            default:
                return start.plusDays(1);
        }
    }
}
