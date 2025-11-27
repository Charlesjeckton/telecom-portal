package servlet.admin;

import dao.ServiceDAO;
import model.Service;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/toggleService")
public class AdminServiceToggleServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json; charset=UTF-8");

        try {
            int id = Integer.parseInt(request.getParameter("id"));

            ServiceDAO dao = new ServiceDAO();

            // Toggle the status
            boolean updateOk = dao.toggleStatus(id);

            // Fetch updated service so we know the new status
            Service updatedService = dao.getServiceById(id);

            boolean newStatus = updatedService != null && updatedService.isActive();

            // Return JSON
            String json = "{"
                    + "\"success\": " + updateOk + ","
                    + "\"active\": " + newStatus
                    + "}";

            response.getWriter().write(json);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false}");
        }
    }
}
