import dao.SubscriptionDAO;

import java.text.SimpleDateFormat;
import java.util.Date;

public class TestSubscriptionDAO {
    public static void main(String[] args) throws Exception {

        SubscriptionDAO dao = new SubscriptionDAO();

        int subId = 1; 
        String purchaseDateStr = "2025-01-01";

        // Convert String to Date
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date purchaseDate = sdf.parse(purchaseDateStr);

        // Auto-calculate expiryDate (example: +30 days)
        Date expiryDate = new Date(purchaseDate.getTime() + 30L * 24 * 60 * 60 * 1000);

        if (dao.activateSubscription(subId, purchaseDate, expiryDate)) {
            System.out.println("Subscription activated!");
        } else {
            System.out.println("Failed to activate subscription.");
        }
    }
}
