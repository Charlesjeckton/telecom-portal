package dao;

import model.Billing;
import util.DBConnectionManager;

import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

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

            if (bill.getBillingDate() != null) {
                stmt.setTimestamp(4, new Timestamp(bill.getBillingDate().getTime()));
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
    // 2️⃣ Extract Billing from ResultSet
    // ============================================================
    private Billing extractBillingFromResultSet(ResultSet rs) throws SQLException {
        Billing bill = new Billing();

        bill.setId(rs.getInt("id"));
        bill.setCustomerId(rs.getInt("customer_id"));
        bill.setServiceId(rs.getInt("service_id"));
        bill.setAmount(rs.getDouble("amount"));

        Timestamp ts = rs.getTimestamp("billing_date");
        if (ts != null) {
            bill.setBillingDate(new Date(ts.getTime()));
        }

        bill.setPaid(rs.getBoolean("paid"));

        try { bill.setServiceName(rs.getString("service_name")); } catch (SQLException ignore) {}
        try { bill.setCustomerName(rs.getString("customer_name")); } catch (SQLException ignore) {}
        try { bill.setCustomerEmail(rs.getString("customer_email")); } catch (SQLException ignore) {}

        return bill;
    }

    // ============================================================
    // 3️⃣ Get All Bills
    // ============================================================
    public List<Billing> getAllBills() {
        List<Billing> list = new ArrayList<>();
        String sql = "SELECT b.*, s.name AS service_name FROM billing b "
                   + "LEFT JOIN services s ON b.service_id = s.id ORDER BY b.id DESC";

        try (Connection conn = DBConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                list.add(extractBillingFromResultSet(rs));
            }

        } catch (SQLException e) {
            System.err.println("❌ Error fetching all bills: " + e.getMessage());
        }

        return list;
    }

    // ============================================================
    // 4️⃣ Get Unpaid Bills
    // ============================================================
    public List<Billing> getUnpaidBills() {
        List<Billing> list = new ArrayList<>();
        String sql = "SELECT * FROM billing WHERE paid = 0 ORDER BY billing_date DESC";

        try (Connection conn = DBConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                list.add(extractBillingFromResultSet(rs));
            }

        } catch (SQLException e) {
            System.err.println("❌ Error fetching unpaid bills: " + e.getMessage());
        }

        return list;
    }

    // ============================================================
    // 5️⃣ Get Bills By Customer
    // ============================================================
    public List<Billing> getBillsByCustomer(int customerId) {
        List<Billing> list = new ArrayList<>();
        String sql = "SELECT b.*, s.name AS service_name FROM billing b "
                   + "LEFT JOIN services s ON b.service_id = s.id "
                   + "WHERE b.customer_id = ? ORDER BY b.id DESC";

        try (Connection conn = DBConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, customerId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(extractBillingFromResultSet(rs));
                }
            }

        } catch (SQLException e) {
            System.err.println("❌ Error fetching customer bills: " + e.getMessage());
        }

        return list;
    }

    // ============================================================
    // 6️⃣ Mark Bill As Paid
    // ============================================================
    public boolean markBillAsPaid(int billId) {
        String sql = "UPDATE billing SET paid = 1 WHERE id = ?";

        try (Connection conn = DBConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, billId);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("❌ Error marking bill as paid: " + e.getMessage());
            return false;
        }
    }

    // ============================================================
    // 7️⃣ Mark Bill As Unpaid
    // ============================================================
    public boolean markBillAsUnpaid(int billId) {
        String sql = "UPDATE billing SET paid = 0 WHERE id = ?";

        try (Connection conn = DBConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, billId);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("❌ Error marking bill as unpaid: " + e.getMessage());
            return false;
        }
    }

    // ============================================================
    // 8️⃣ Get Unpaid Bills With Customer Info
    // ============================================================
    public List<Billing> getUnpaidBillsWithCustomer() {
        List<Billing> list = new ArrayList<>();
        String sql = "SELECT b.*, c.name AS customer_name, c.email AS customer_email, s.name AS service_name "
                   + "FROM billing b "
                   + "LEFT JOIN customers c ON b.customer_id = c.id "
                   + "LEFT JOIN services s ON b.service_id = s.id "
                   + "WHERE b.paid = 0 ORDER BY b.id DESC";

        try (Connection conn = DBConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                list.add(extractBillingFromResultSet(rs));
            }

        } catch (SQLException e) {
            System.err.println("❌ Error fetching unpaid bills with customer info: " + e.getMessage());
        }

        return list;
    }

    // ============================================================
    // 9️⃣ Get Paid Bills With Customer Info
    // ============================================================
    public List<Billing> getPaidBillsWithCustomer() {
        List<Billing> list = new ArrayList<>();
        String sql = "SELECT b.*, c.name AS customer_name, c.email AS customer_email, s.name AS service_name "
                   + "FROM billing b "
                   + "JOIN customers c ON b.customer_id = c.id "
                   + "JOIN services s ON b.service_id = s.id "
                   + "WHERE b.paid = 1 ORDER BY b.billing_date DESC";

        try (Connection conn = DBConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                list.add(extractBillingFromResultSet(rs));
            }

        } catch (SQLException e) {
            System.err.println("❌ Error fetching paid bills with customer info: " + e.getMessage());
        }

        return list;
    }
}
