package bean;

import dao.ServiceDAO;
import model.Service;

import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;
import java.io.Serializable;

@ManagedBean(name="serviceBean")
@ViewScoped
public class ServiceBean implements Serializable {

    private Service service = new Service();
    private ServiceDAO serviceDAO = new ServiceDAO();

    public Service getService() {
        return service;
    }

    public void setService(Service service) {
        this.service = service;
    }

    public void addService() {
        boolean success = serviceDAO.addService(service);
        if(success) {
            service = new Service(); // reset form
        }
    }
}
