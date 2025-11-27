package bean;

import dao.ServiceDAO;
import dao.SubscriptionDAO;
import dao.BillingDAO;
import model.Service;
import model.Subscription;
import model.Billing;

import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;
import java.io.Serializable;
import java.util.List;

@ManagedBean(name = "adminBean")
@ViewScoped
public class AdminBean implements Serializable {

    private static final long serialVersionUID = 1L;

    private Service service = new Service();
    private List<Subscription> allSubscriptions;
    private List<Billing> unpaidBills;

    private final ServiceDAO serviceDAO = new ServiceDAO();
    private final SubscriptionDAO subscriptionDAO = new SubscriptionDAO();
    private final BillingDAO billingDAO = new BillingDAO();

    /**
     * Add a new service to the database.
     * Resets the form on success and refreshes subscription table.
     */
    public void addService() {
        boolean ok = serviceDAO.addService(service);
        if (ok) {
            service = new Service(); // Reset form
            loadAllSubscriptions();  // Refresh subscription table
        }
    }

    /**
     * Load all subscriptions with customer and service names
     * for the admin dashboard.
     */
    public void loadAllSubscriptions() {
        allSubscriptions = subscriptionDAO.getAllSubscriptions(); 
        // Make sure SubscriptionDAO.getAllSubscriptions() returns 
        // customerName and serviceName fields populated
    }

    /**
     * Load unpaid bills for the admin dashboard.
     */
    public void loadUnpaidBills() {
        unpaidBills = billingDAO.getUnpaidBills();
    }

    // ===== Getters & Setters =====

    public Service getService() {
        return service;
    }

    public void setService(Service service) {
        this.service = service;
    }

    public List<Subscription> getAllSubscriptions() {
        // Lazy load if not already loaded
        if (allSubscriptions == null) {
            loadAllSubscriptions();
        }
        return allSubscriptions;
    }

    public List<Billing> getUnpaidBills() {
        // Lazy load if not already loaded
        if (unpaidBills == null) {
            loadUnpaidBills();
        }
        return unpaidBills;
    }
}
