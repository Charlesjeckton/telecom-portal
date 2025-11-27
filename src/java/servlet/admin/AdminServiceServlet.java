package servlet.admin;

import dao.ServiceDAO;
import model.Service;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/service")
public class AdminServiceServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        ServiceDAO dao = new ServiceDAO();

        if (action == null || action.trim().isEmpty()) {
            response.sendRedirect("services.jsp?error=No+action+provided");
            return;
        }

        switch (action) {

            // =====================================================
            //  ADD SERVICE
            // =====================================================
            case "add":
                try {
                    String name = request.getParameter("name");
                    String description = request.getParameter("description");
                    double charge = Double.parseDouble(request.getParameter("charge"));
                    int durationValue = Integer.parseInt(request.getParameter("duration_value"));
                    String durationUnit = request.getParameter("duration_unit");

                    Service service = new Service();
                    service.setName(name);
                    service.setDescription(description);
                    service.setCharge(charge);
                    service.setDurationValue(durationValue);
                    service.setDurationUnit(durationUnit);
                    service.setActive(true);

                    boolean added = dao.addService(service);

                    if (added) {
                        response.sendRedirect("services.jsp?success=Service+added");
                    } else {
                        response.sendRedirect("addService.jsp?error=Failed+to+add+service");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    response.sendRedirect("addService.jsp?error=Invalid+input");
                }
                break;


            // =====================================================
            //  UPDATE SERVICE
            // =====================================================
            case "update":
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    String name = request.getParameter("name");
                    String description = request.getParameter("description");
                    double charge = Double.parseDouble(request.getParameter("charge"));
                    int durationValue = Integer.parseInt(request.getParameter("duration_value"));
                    String durationUnit = request.getParameter("duration_unit");
                    boolean active = request.getParameter("active") != null;

                    Service service = new Service();
                    service.setId(id);
                    service.setName(name);
                    service.setDescription(description);
                    service.setCharge(charge);
                    service.setDurationValue(durationValue);
                    service.setDurationUnit(durationUnit);
                    service.setActive(active);

                    boolean updated = dao.updateService(service);

                    if (updated) {
                        response.sendRedirect("services.jsp?success=Service+updated");
                    } else {
                        response.sendRedirect("editService.jsp?id=" + id + "&error=Update+failed");
                    }

                } catch (Exception e) {
                    e.printStackTrace();
                    response.sendRedirect("services.jsp?error=Invalid+update+input");
                }
                break;


            // =====================================================
            //  DELETE SERVICE
            // =====================================================
            case "delete":
                try {
                    int id = Integer.parseInt(request.getParameter("id"));

                    boolean deleted = dao.deleteService(id);

                    if (deleted) {
                        response.sendRedirect("services.jsp?success=Service+deleted");
                    } else {
                        response.sendRedirect("services.jsp?error=Failed+to+delete");
                    }

                } catch (Exception e) {
                    response.sendRedirect("services.jsp?error=Invalid+delete+input");
                }
                break;


            // =====================================================
            //  UNKNOWN ACTION
            // =====================================================
            default:
                response.sendRedirect("services.jsp?error=Unknown+action");
        }
    }
}
