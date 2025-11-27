package util;

import dao.BillingDAO;
import model.Billing;

import java.text.SimpleDateFormat;
import java.util.Date;

public class TestBillingDAO {
    public static void main(String[] args) {

        try {
            BillingDAO dao = new BillingDAO();
            Billing bill = new Billing();

            bill.setCustomerId(1);
            bill.setAmount(1200);

            // Convert String to Date
            String dateStr = "2025-11-22";
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date billingDate = sdf.parse(dateStr);
            bill.setBillingDate(billingDate);

            bill.setPaid(false);

            if (dao.generateBill(bill)) {
                System.out.println("Bill generated successfully!");
            } else {
                System.out.println("Failed to generate bill.");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
