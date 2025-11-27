package dao;

import model.Subscription;
import util.DBConnectionManager;

import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class SubscriptionDAO {

    // =====================================================
    // GET CUSTOMER ID BY USER ID
    // =====================================================
    public int getCustomerIdByUserId(int userId) {
        String sql = "SELECT id FROM customers WHERE user_id = ?";

        try (Connection conn = DBConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) return rs.getInt("id");

        } catch (SQLException e) {
            System.err.println("ERROR getCustomerIdByUserId: " + e.getMessage());
        }
        return 0;
    }
public List<Subscription> getActiveSubscriptionsByCustomer(int customerId) {
    List<Subscription> list = new ArrayList<>();

    String sql = "SELECT s.*, c.name AS customerName, sv.name AS serviceName " +
                 "FROM subscriptions s " +
                 "JOIN customers c ON s.customer_id = c.id " +
                 "JOIN services sv ON s.service_id = sv.id " +
                 "WHERE s.customer_id = ? AND s.status = 'ACTIVE'";

    try (Connection conn = DBConnectionManager.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setInt(1, customerId);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            Subscription sub = new Subscription();
            sub.setId(rs.getInt("id"));
            sub.setCustomerId(rs.getInt("customer_id"));
            sub.setServiceId(rs.getInt("service_id"));

            sub.setCustomerName(rs.getString("customerName"));
            sub.setServiceName(rs.getString("serviceName"));

            // Convert SQL Date → util.Date
            java.sql.Date pDate = rs.getDate("purchase_date");
            java.sql.Date eDate = rs.getDate("expiry_date");

            if (pDate != null) sub.setPurchaseDate(new java.util.Date(pDate.getTime()));
            if (eDate != null) sub.setExpiryDate(new java.util.Date(eDate.getTime()));

            sub.setStatus(rs.getString("status"));

            list.add(sub);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}

    // =====================================================
    // GET SUBSCRIPTIONS BY CUSTOMER ID
    // =====================================================
    public List<Subscription> getSubscriptionsByCustomerId(int customerId) {
        List<Subscription> list = new ArrayList<>();

        String sql = "SELECT s.*, srv.name AS service_name, srv.price AS service_price " +
                "FROM subscriptions s " +
                "JOIN services srv ON s.service_id = srv.id " +
                "WHERE s.customer_id = ? " +
                "ORDER BY s.id DESC";

        try (Connection conn = DBConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, customerId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Subscription s = new Subscription();

                s.setId(rs.getInt("id"));
                s.setCustomerId(rs.getInt("customer_id"));
                s.setServiceId(rs.getInt("service_id"));
                s.setServiceName(rs.getString("service_name"));
                s.setMonthlyPrice(rs.getDouble("service_price"));

                s.setPurchaseDate(rs.getTimestamp("purchase_date"));
                s.setExpiryDate(rs.getTimestamp("expiry_date"));
                s.setStatus(rs.getString("status"));

                list.add(s);
            }

        } catch (SQLException e) {
            System.err.println("ERROR getSubscriptionsByCustomerId: " + e.getMessage());
        }
        return list;
    }

    // =====================================================
    // ADD SUBSCRIPTION
    // =====================================================
    public boolean addSubscription(Subscription s) {
        String sql =
                "INSERT INTO subscriptions (customer_id, service_id, purchase_date, expiry_date, status) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, s.getCustomerId());
            stmt.setInt(2, s.getServiceId());
            stmt.setTimestamp(3, new Timestamp(s.getPurchaseDate().getTime()));

            if (s.getExpiryDate() != null)
                stmt.setTimestamp(4, new Timestamp(s.getExpiryDate().getTime()));
            else
                stmt.setNull(4, Types.TIMESTAMP);

            stmt.setString(5, s.getStatus());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("ERROR addSubscription: " + e.getMessage());
        }

        return false;
    }

    // =====================================================
    // UPDATE SUBSCRIPTION
    // =====================================================
    public boolean updateSubscription(Subscription s) {
        String sql =
                "UPDATE subscriptions SET customer_id = ?, service_id = ?, " +
                "purchase_date = ?, expiry_date = ?, status = ? WHERE id = ?";

        try (Connection conn = DBConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, s.getCustomerId());
            stmt.setInt(2, s.getServiceId());
            stmt.setTimestamp(3, new Timestamp(s.getPurchaseDate().getTime()));

            if (s.getExpiryDate() != null)
                stmt.setTimestamp(4, new Timestamp(s.getExpiryDate().getTime()));
            else
                stmt.setNull(4, Types.TIMESTAMP);

            stmt.setString(5, s.getStatus());
            stmt.setInt(6, s.getId());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("ERROR updateSubscription: " + e.getMessage());
        }

        return false;
    }

    // =====================================================
    // ACTIVATE SUBSCRIPTION
    // =====================================================
    public boolean activateSubscription(int id, Date purchaseDate, Date expiryDate) {

        String sql = "UPDATE subscriptions SET purchase_date = ?, expiry_date = ?, status = 'ACTIVE' WHERE id = ?";

        try (Connection conn = DBConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setTimestamp(1, new Timestamp(purchaseDate.getTime()));

            if (expiryDate != null)
                stmt.setTimestamp(2, new Timestamp(expiryDate.getTime()));
            else
                stmt.setNull(2, Types.TIMESTAMP);

            stmt.setInt(3, id);

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("ERROR activateSubscription: " + e.getMessage());
        }

        return false;
    }

    // =====================================================
    // DEACTIVATE SUBSCRIPTION
    // =====================================================
    public boolean deactivateSubscription(int id) {
        String sql = "UPDATE subscriptions SET status = 'EXPIRED', expiry_date = NOW() WHERE id = ?";

        try (Connection conn = DBConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("ERROR deactivateSubscription: " + e.getMessage());
        }

        return false;
    }

    // =====================================================
    // GET ALL SUBSCRIPTIONS (ADMIN)
    // =====================================================
    public List<Subscription> getAllSubscriptions() {
    List<Subscription> list = new ArrayList<>();

    String sql =
        "SELECT s.id, s.customer_id, s.service_id, s.purchase_date, s.expiry_date, s.status, " +
        "c.name AS customer_name, srv.name AS service_name " +
        "FROM subscriptions s " +
        "JOIN customers c ON s.customer_id = c.id " +
        "JOIN services srv ON s.service_id = srv.id " +
        "ORDER BY s.id DESC";

    try (Connection conn = DBConnectionManager.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql);
         ResultSet rs = stmt.executeQuery()) {

        while (rs.next()) {
            Subscription s = new Subscription();
            s.setId(rs.getInt("id"));
            s.setCustomerId(rs.getInt("customer_id"));
            s.setServiceId(rs.getInt("service_id"));
            s.setCustomerName(rs.getString("customer_name"));
            s.setServiceName(rs.getString("service_name"));

            s.setPurchaseDate(rs.getTimestamp("purchase_date"));
            s.setExpiryDate(rs.getTimestamp("expiry_date"));
            s.setStatus(rs.getString("status"));

            list.add(s);
        }

    } catch (SQLException e) {
        System.err.println("❌ ERROR getAllSubscriptions: " + e.getMessage());
    }

    System.out.println("DEBUG: DAO returned " + list.size() + " subscriptions");

    return list;
}


    // =====================================================
    // GET SUBSCRIPTION BY ID
    // =====================================================
    public Subscription getSubscriptionById(int id) {
        String sql =
                "SELECT s.*, srv.name AS service_name, srv.price AS service_price " +
                "FROM subscriptions s " +
                "JOIN services srv ON s.service_id = srv.id " +
                "WHERE s.id = ?";

        try (Connection conn = DBConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Subscription s = new Subscription();

                s.setId(rs.getInt("id"));
                s.setCustomerId(rs.getInt("customer_id"));
                s.setServiceId(rs.getInt("service_id"));
                s.setServiceName(rs.getString("service_name"));
                s.setMonthlyPrice(rs.getDouble("service_price"));

                s.setPurchaseDate(rs.getTimestamp("purchase_date"));
                s.setExpiryDate(rs.getTimestamp("expiry_date"));
                s.setStatus(rs.getString("status"));

                return s;
            }

        } catch (SQLException e) {
            System.err.println("ERROR getSubscriptionById: " + e.getMessage());
        }

        return null;
    }

    // =====================================================
    // GET ACTIVE SUBSCRIPTIONS (FOR BILLING SCHEDULER)
    // =====================================================
    public List<Subscription> getActiveSubscriptions() {
        List<Subscription> list = new ArrayList<>();

        String sql =
                "SELECT s.*, srv.price AS service_price " +
                "FROM subscriptions s " +
                "JOIN services srv ON s.service_id = srv.id " +
                "WHERE s.status = 'ACTIVE'";

        try (Connection conn = DBConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Subscription s = new Subscription();

                s.setId(rs.getInt("id"));
                s.setCustomerId(rs.getInt("customer_id"));
                s.setServiceId(rs.getInt("service_id"));
                s.setMonthlyPrice(rs.getDouble("service_price"));

                s.setPurchaseDate(rs.getTimestamp("purchase_date"));
                s.setExpiryDate(rs.getTimestamp("expiry_date"));
                s.setStatus(rs.getString("status"));

                list.add(s);
            }

        } catch (SQLException e) {
            System.err.println("ERROR getActiveSubscriptions: " + e.getMessage());
        }

        return list;
    }

    // =====================================================
    // OWN SUBSCRIPTION CHECK
    // =====================================================
    public boolean customerOwnsSubscription(int customerId, int subscriptionId) {
        String sql = "SELECT id FROM subscriptions WHERE id = ? AND customer_id = ?";

        try (Connection conn = DBConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, subscriptionId);
            stmt.setInt(2, customerId);

            ResultSet rs = stmt.executeQuery();
            return rs.next();

        } catch (SQLException e) {
            System.err.println("ERROR customerOwnsSubscription: " + e.getMessage());
        }
        return false;
    }

    // =====================================================
    // ADD SUBSCRIPTION (SHORT FORM)
    // =====================================================
    public boolean addSubscription(int customerId, int serviceId, Date purchaseDate, Date expiryDate) {
        Subscription s = new Subscription();
        s.setCustomerId(customerId);
        s.setServiceId(serviceId);
        s.setPurchaseDate(purchaseDate);
        s.setExpiryDate(expiryDate);
        s.setStatus("ACTIVE");
        return addSubscription(s);
    }

}
