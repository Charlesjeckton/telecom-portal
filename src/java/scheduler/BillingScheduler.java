package scheduler;

import dao.BillingDAO;
import dao.SubscriptionDAO;
import model.Billing;
import model.Subscription;

import javax.ejb.Schedule;
import javax.ejb.Singleton;
import javax.ejb.Startup;
import java.util.Date;
import java.util.List;

/**
 * BillingScheduler
 *
 * Runs on the 1st day of every month at 01:00 (server time) and generates bills
 * for active subscriptions.
 *
 * NOTE: This is an EJB singleton + timer. Payara 5 (Java EE 8) supports this.
 */
@Singleton
@Startup
public class BillingScheduler {

    private final BillingDAO billingDAO = new BillingDAO();
    private final SubscriptionDAO subscriptionDAO = new SubscriptionDAO();

    /**
     * Production schedule: runs on day 1 of each month at 01:00.
     * Adjust hour/minute as needed.
     */
    @Schedule(dayOfMonth = "1", hour = "01", minute = "00", persistent = false)
    public void generateMonthlyBills() {
        System.out.println("[BillingScheduler] Auto-billing started: " + new Date());
        try {
            List<Subscription> activeSubs = subscriptionDAO.getActiveSubscriptions();
            if (activeSubs == null || activeSubs.isEmpty()) {
                System.out.println("[BillingScheduler] No active subscriptions found.");
                return;
            }

            int created = 0;
            for (Subscription sub : activeSubs) {
                try {
                    Billing bill = new Billing();
                    bill.setCustomerId(sub.getCustomerId());
                    bill.setServiceId(sub.getServiceId());

                    // use subscription price — ensure Subscription has getMonthlyPrice()
                    bill.setAmount(sub.getMonthlyPrice());
                    bill.setBillingDate(new Date());
                    bill.setPaid(false);

                    boolean ok = billingDAO.generateBill(bill);
                    if (ok) created++;
                } catch (Exception inner) {
                    System.err.println("[BillingScheduler] Failed to create bill for sub id="
                                       + sub.getId() + " : " + inner.getMessage());
                }
            }

            System.out.println("[BillingScheduler] Auto-billing finished. Bills created: " + created);
        } catch (Exception e) {
            System.err.println("[BillingScheduler] ERROR: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
