package servlet.customer;

import dao.BillingDAO;
import model.Billing;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.List;

@WebServlet("/customer/billing")
public class CustomerBillingServlet extends HttpServlet {

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

        BillingDAO billingDAO = new BillingDAO();

        // Detect which tab the user is viewing
        String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "unpaid"; // default tab
        }

        List<Billing> bills = billingDAO.getBillsByCustomer(customerId);

        if ("paid".equals(tab)) {
            // Only load PAID bills
            List<Billing> paidList = bills.stream()
                    .filter(Billing::isPaid)
                    .toList();
            request.setAttribute("paidList", paidList);
        } else {
            // Only load UNPAID bills
            List<Billing> unpaidList = bills.stream()
                    .filter(b -> !b.isPaid())
                    .toList();
            request.setAttribute("unpaidList", unpaidList);
        }

        // send active tab to JSP
        request.setAttribute("activeTab", tab);

        request.getRequestDispatcher("/customer/billing.jsp").forward(request, response);
    }
}
