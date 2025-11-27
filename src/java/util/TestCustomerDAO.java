package util;

import dao.CustomerDAO;
import model.Customer;
import model.User;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class TestCustomerDAO {
    public static void main(String[] args) {

        CustomerDAO dao = new CustomerDAO();

        // Create Customer
        Customer c = new Customer();
        c.setName("John Doe");
        c.setPhoneNumber("0712345678");
        c.setEmail("john@example.com");

        // Parse registration date
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        try {
            Date regDate = sdf.parse("2025-11-22");
            c.setRegistrationDate(regDate);
        } catch (ParseException e) {
            System.err.println("Invalid date format!");
            return;
        }

        // Create User
        User u = new User();
        u.setUsername("johndoe");
        u.setPassword("password123");
        u.setRole("CUSTOMER");

        // Call updated DAO (now returning a String)
        String result = dao.registerCustomer(c, u);

        if (result.equals("SUCCESS")) {
            System.out.println("Customer registered successfully!");
        } else {
            System.out.println("Failed: " + result);
        }
    }
}
