package servlet.admin;

import dao.BillingDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/markBillPaid")
public class MarkBillPaidServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        // Accept either "id" or "billId"
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            idParam = request.getParameter("billId");
        }

        String tab = request.getParameter("tab");
        if (tab == null || tab.trim().isEmpty()) tab = "unpaid"; // default

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/billing.jsp?tab=" + tab + "&error=Invalid+Bill+ID");
            return;
        }

        int billId;
        try {
            billId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/billing.jsp?tab=" + tab + "&error=Invalid+Bill+ID");
            return;
        }

        BillingDAO dao = new BillingDAO();
        boolean ok = dao.markBillAsPaid(billId);

        if (ok) {
            response.sendRedirect(request.getContextPath() + "/admin/billing.jsp?tab=" + tab + "&success=Bill+Marked+as+Paid");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/billing.jsp?tab=" + tab + "&error=Failed+to+update+bill");
        }
    }
}
