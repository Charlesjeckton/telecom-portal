package bean;

import dao.UserDAO;
import model.User;

import javax.faces.bean.ManagedBean;
import javax.faces.bean.SessionScoped;
import java.io.Serializable;
import javax.faces.context.FacesContext;

@ManagedBean
@SessionScoped
public class UserBean implements Serializable {

    private String username;
    private String password;
    private User user; // logged-in user

    private UserDAO userDAO = new UserDAO();

    // Login method
    public String login() {
        user = userDAO.login(username, password);

        if (user != null) {
            if ("ADMIN".equalsIgnoreCase(user.getRole())) {
                return "adminView.xhtml?faces-redirect=true";
            } else if ("CUSTOMER".equalsIgnoreCase(user.getRole())) {
                return "customerView.xhtml?faces-redirect=true";
            } else {
                FacesContext.getCurrentInstance().getExternalContext().invalidateSession();
                return "login.xhtml?faces-redirect=true";
            }
        } else {
            FacesContext.getCurrentInstance().getExternalContext().getRequestMap()
                    .put("loginError", "Invalid username or password");
            return null;
        }
    }

    // Logout method
    public String logout() {
        FacesContext.getCurrentInstance().getExternalContext().invalidateSession();
        return "login.xhtml?faces-redirect=true";
    }

    // Getters & setters
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public User getUser() { return user; }
}
