package bean;

import dao.UserDAO;
import model.User;

import javax.faces.bean.ManagedBean;
import javax.faces.bean.SessionScoped;
import javax.faces.context.FacesContext;
import java.io.IOException;
import java.io.Serializable;

@ManagedBean
@SessionScoped
public class LoginBean implements Serializable {

    private String username;
    private String password;
    private User user;
    private UserDAO userDAO = new UserDAO();

    // Perform login
    public String login() {
        user = userDAO.login(username, password);
        if(user != null) {
            if("ADMIN".equalsIgnoreCase(user.getRole())) {
                return "adminView.xhtml?faces-redirect=true";
            } else {
                return "customerView.xhtml?faces-redirect=true";
            }
        } else {
            FacesContext.getCurrentInstance().addMessage(null,
                    new javax.faces.application.FacesMessage("Invalid username or password"));
            return null;
        }
    }

    // Logout
    public void logout() throws IOException {
        FacesContext.getCurrentInstance().getExternalContext().invalidateSession();
        FacesContext.getCurrentInstance().getExternalContext().redirect("login.xhtml");
    }

    // ✅ Redirect if not customer
    public void redirectIfNotCustomer() throws IOException {
        if(user == null || !"CUSTOMER".equalsIgnoreCase(user.getRole())) {
            FacesContext.getCurrentInstance().getExternalContext().redirect("login.xhtml");
        }
    }

    // ✅ Redirect if not admin
    public void redirectIfNotAdmin() throws IOException {
        if(user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
            FacesContext.getCurrentInstance().getExternalContext().redirect("login.xhtml");
        }
    }

    // Getters & Setters
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
}
