package bean;

import dao.CustomerDAO;
import model.Customer;
import model.User;

import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;
import java.io.Serializable;
import java.util.Date;

@ManagedBean
@ViewScoped
public class CustomerBean implements Serializable {

    private Customer customer = new Customer();
    private String username;
    private String password;

    private CustomerDAO dao = new CustomerDAO();

    public void register() {
        FacesContext context = FacesContext.getCurrentInstance();
        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setRole("CUSTOMER");
        customer.setRegistrationDate(new Date());

        try {
            dao.registerCustomer(customer, user);
            context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_INFO, "Success", "Customer registered successfully"));
            // Clear fields
            customer = new Customer();
            username = "";
            password = "";
        } catch (Exception e) {
            context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_ERROR, "Registration Failed", e.getMessage()));
        }
    }

    // Getters and setters
    public Customer getCustomer() { return customer; }
    public void setCustomer(Customer customer) { this.customer = customer; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
}
