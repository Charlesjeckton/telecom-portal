package servlet.customer;

import dao.BillingDAO;
import model.Billing;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.List;

@WebServlet("/customer/paidBills")
public class CustomerPaidBillsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Validate session
        Integer userId = (Integer) request.getSession().getAttribute("userId");
        Integer customerId = (Integer) request.getSession().getAttribute("customerId");

        if (userId == null || customerId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Load paid bills for this customer
        BillingDAO billingDAO = new BillingDAO();
        List<Billing> paidList = billingDAO.getPaidBillsByCustomer(customerId);

        // Attach to request
        request.setAttribute("paidList", paidList);

        // Forward to JSP
        RequestDispatcher rd = request.getRequestDispatcher("/customer/paidBills.jsp");
        rd.forward(request, response);
    }
}
