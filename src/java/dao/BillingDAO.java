package dao;

import model.Billing;
import util.DBConnectionManager;

import java.sql.*;
import java.util.*;

public class BillingDAO {

    // ============================================================
    // 1️⃣ Generate a Bill
    // ============================================================
    public boolean generateBill(Billing bill) {
        String sql = "INSERT INTO billing (customer_id, service_id, amount, billing_date, paid) "
                + "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, bill.getCustomerId());
            stmt.setInt(2, bill.getServiceId());
            stmt.setDouble(3, bill.getAmount());

            java.util.Date utilDate = bill.getBillingDate();
            if (utilDate != null) {
                stmt.setTimestamp(4, new Timestamp(utilDate.getTime()));
            } else {
                stmt.setNull(4, Types.TIMESTAMP);
            }

            stmt.setBoolean(5, bill.isPaid());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("❌ Error generating bill: " + e.getMessage());
            return false;
        }
    }

    // ============================================================
    // 2️⃣ Extract Billing Object
    // ============================================================
    private Billing extractBilling(ResultSet rs) throws SQLException {
        Billing bill = new Billing();

        bill.setId(rs.getInt("id"));
        bill.setCustomerId(rs.getInt("customer_id"));
        bill.setServiceId(rs.getInt("service_id"));
        bill.setAmount(rs.getDouble("amount"));

        Timestamp ts = rs.getTimestamp("billing_date");
        if (ts != null) bill.setBillingDate(new java.util.Date(ts.getTime()));

        bill.setPaid(rs.getBoolean("paid"));

        try { bill.setServiceName(rs.getString("service_name")); } catch (Exception ignored) {}
        try { bill.setCustomerName(rs.getString("customer_name")); } catch (Exception ignored) {}
        try { bill.setCustomerEmail(rs.getString("customer_email")); } catch (Exception ignored) {}

        return bill;
    }

    // ============================================================
    // 3️⃣ Get All Bills
    // ============================================================
    public List<Billing> getAllBills() {
        List<Billing> list = new ArrayList<>();

        String sql = "SELECT b.*, s.name AS service_name "
                + "FROM billing b "
                + "LEFT JOIN services s ON b.service_id = s.id "
                + "ORDER BY b.id DESC";

        try (Connection conn = DBConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) list.add(extractBilling(rs));

        } catch (SQLException e) {
            System.err.println("❌ Error fetching all bills: " + e.getMessage());
        }

        return list;
    }

    // ============================================================
    // 4️⃣ Unpaid Bills
    // ============================================================
    public List<Billing> getUnpaidBills() {
        List<Billing> list = new ArrayList<>();

        String sql = "SELECT * FROM billing WHERE paid = 0 ORDER BY billing_date DESC";

        try (Connection conn = DBConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) list.add(extractBilling(rs));

        } catch (SQLException e) {
            System.err.println("❌ Error fetching unpaid bills: " + e.getMessage());
        }

        return list;
    }

    // ============================================================
    // 5️⃣ Customer Bills
    // ============================================================
    public List<Billing> getBillsByCustomer(int customerId) {
        List<Billing> list = new ArrayList<>();

        String sql = "SELECT b.*, s.name AS service_name "
                + "FROM billing b "
                + "LEFT JOIN services s ON b.service_id = s.id "
                + "WHERE b.customer_id = ? "
                + "ORDER BY b.id DESC";

        try (Connection conn = DBConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, customerId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) list.add(extractBilling(rs));
            }

        } catch (SQLException e) {
            System.err.println("❌ Error fetching customer bills: " + e.getMessage());
        }

        return list;
    }

    // ============================================================
    // 6️⃣ Mark bill paid
    // ============================================================
    public boolean markBillAsPaid(int billId) {
        String sql = "UPDATE billing SET paid = 1 WHERE id = ?";

        try (Connection conn = DBConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, billId);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("❌ Error marking bill paid: " + e.getMessage());
            return false;
        }
    }

    // ============================================================
    // 7️⃣ Mark bill unpaid
    // ============================================================
    public boolean markBillAsUnpaid(int billId) {
        String sql = "UPDATE billing SET paid = 0 WHERE id = ?";

        try (Connection conn = DBConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, billId);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("❌ Error marking bill unpaid: " + e.getMessage());
            return false;
        }
    }

    // ============================================================
    // 8️⃣ Paid Bills by Customer
    // ============================================================
    public List<Billing> getPaidBillsByCustomer(int customerId) {
        List<Billing> list = new ArrayList<>();

        String sql = "SELECT b.*, s.name AS service_name "
                + "FROM billing b "
                + "LEFT JOIN services s ON b.service_id = s.id "
                + "WHERE b.customer_id = ? AND b.paid = 1 "
                + "ORDER BY b.billing_date DESC";

        try (Connection conn = DBConnectionManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractBilling(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ============================================================
    // 9️⃣ Unpaid Bills WITH customer info
    // ============================================================
    public List<Billing> getUnpaidBillsWithCustomer() {
        List<Billing> list = new ArrayList<>();

        String sql = "SELECT b.*, c.name AS customer_name, c.email AS customer_email, "
                + "s.name AS service_name "
                + "FROM billing b "
                + "LEFT JOIN customers c ON b.customer_id = c.id "
                + "LEFT JOIN services s ON b.service_id = s.id "
                + "WHERE b.paid = 0 ORDER BY b.id DESC";

        try (Connection conn = DBConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) list.add(extractBilling(rs));

        } catch (SQLException e) {
            System.err.println("❌ Error fetching unpaid bills: " + e.getMessage());
        }

        return list;
    }

    // ============================================================
    // 🔟 Paid Bills with customer info
    // ============================================================
    public List<Billing> getPaidBillsWithCustomer() {
        List<Billing> list = new ArrayList<>();

        String sql = "SELECT b.*, c.name AS customer_name, c.email AS customer_email, "
                + "s.name AS service_name "
                + "FROM billing b "
                + "JOIN customers c ON b.customer_id = c.id "
                + "JOIN services s ON b.service_id = s.id "
                + "WHERE b.paid = 1 ORDER BY b.billing_date DESC";

        try (Connection conn = DBConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) list.add(extractBilling(rs));

        } catch (SQLException e) {
            System.err.println("❌ Error fetching paid bills: " + e.getMessage());
        }

        return list;
    }

    // ============================================================
    // 1️⃣1️⃣ Count paid bills by customer
    // ============================================================
    public int countPaidBillsByCustomer(int customerId) {
        String sql = "SELECT COUNT(*) FROM billing WHERE customer_id = ? AND paid = 1";

        try (Connection conn = DBConnectionManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) { e.printStackTrace(); }

        return 0;
    }

    // ============================================================
    // 1️⃣2️⃣ Count unpaid bills by customer
    // ============================================================
    public int countUnpaidBillsByCustomer(int customerId) {
        String sql = "SELECT COUNT(*) FROM billing WHERE customer_id = ? AND paid = 0";

        try (Connection conn = DBConnectionManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) { e.printStackTrace(); }

        return 0;
    }

    // ============================================================
    // 1️⃣3️⃣ Monthly totals for one customer
    // ============================================================
    public Map<String, Integer> getMonthlyTotalsByCustomer(int customerId) {
        Map<String, Integer> map = new LinkedHashMap<>();

        String sql = "SELECT DATE_FORMAT(billing_date, '%Y-%m') AS month, SUM(amount) "
                + "FROM billing "
                + "WHERE customer_id = ? "
                + "GROUP BY month "
                + "ORDER BY month ASC";

        try (Connection conn = DBConnectionManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                map.put(rs.getString("month"), rs.getInt(2));
            }

        } catch (Exception e) { e.printStackTrace(); }

        return map;
    }

    // ============================================================
    // 1️⃣4️⃣ Count all paid bills
    // ============================================================
    public int countPaidBills() {
        String sql = "SELECT COUNT(*) FROM billing WHERE paid = 1";

        try (Connection conn = DBConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) return rs.getInt(1);

        } catch (SQLException e) {
            System.err.println("❌ Error counting paid bills: " + e.getMessage());
        }

        return 0;
    }

    // ============================================================
    // 1️⃣5️⃣ Count all unpaid bills
    // ============================================================
    public int countUnpaidBills() {
        String sql = "SELECT COUNT(*) FROM billing WHERE paid = 0";

        try (Connection conn = DBConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) return rs.getInt(1);

        } catch (SQLException e) {
            System.err.println("❌ Error counting unpaid bills: " + e.getMessage());
        }

        return 0;
    }

    // ============================================================
    // 1️⃣6️⃣ Monthly totals for all customers
    // ============================================================
    public Map<String, Integer> getMonthlyTotals() {
        Map<String, Integer> map = new LinkedHashMap<>();

        String sql = "SELECT DATE_FORMAT(billing_date, '%Y-%m') AS month, "
                + "SUM(amount) AS total "
                + "FROM billing "
                + "GROUP BY month "
                + "ORDER BY month ASC";

        try (Connection conn = DBConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                map.put(rs.getString("month"), rs.getInt("total"));
            }

        } catch (SQLException e) {
            System.err.println("❌ Error fetching monthly totals: " + e.getMessage());
        }

        return map;
    }

}
