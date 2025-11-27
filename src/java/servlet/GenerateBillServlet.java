package servlet;

import dao.BillingDAO;
import dao.SubscriptionDAO;
import dao.ServiceDAO;
import model.Billing;
import model.Service;
import model.Subscription;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;

@WebServlet("/GenerateBillServlet")
public class GenerateBillServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int customerId = Integer.parseInt(request.getParameter("customerId"));

            // DAOs
            SubscriptionDAO subDao = new SubscriptionDAO();
            ServiceDAO serviceDao = new ServiceDAO();
            BillingDAO billingDao = new BillingDAO();

            // Fetch active subscriptions
            List<Subscription> activeSubscriptions = subDao.getActiveSubscriptionsByCustomer(customerId);

            if (activeSubscriptions.isEmpty()) {
                response.sendRedirect("billingHistory.jsp?customerId=" + customerId + "&error=No+active+subscriptions");
                return;
            }

            double totalAmount = 0.0;

            // Sum charges from all active subscriptions
            for (Subscription sub : activeSubscriptions) {
                Service service = serviceDao.getServiceById(sub.getServiceId());
                if (service != null) {
                    totalAmount += service.getCharge();
                }
            }

            // Create billing entry
            Billing bill = new Billing();
            bill.setCustomerId(customerId);
            bill.setAmount(totalAmount);

            // Set billing date to today
            Date billingDate = Date.from(LocalDate.now().atStartOfDay(ZoneId.systemDefault()).toInstant());
            bill.setBillingDate(billingDate);

            bill.setPaid(false);

            // Save billing to DB
            boolean created = billingDao.generateBill(bill);

            if (created) {
                response.sendRedirect("billingHistory.jsp?customerId=" + customerId + "&success=Bill+generated+successfully");
            } else {
                response.sendRedirect("billingHistory.jsp?customerId=" + customerId + "&error=Failed+to+generate+bill");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp?msg=" + e.getMessage());
        }
    }
}
