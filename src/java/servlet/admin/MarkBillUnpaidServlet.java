package servlet.admin;

import dao.BillingDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/markBillUnpaid")
public class MarkBillUnpaidServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        String idParam = request.getParameter("billId");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect("paidBills.jsp?error=Invalid+Bill+ID");
            return;
        }

        int billId = Integer.parseInt(idParam);

        BillingDAO dao = new BillingDAO();

        boolean ok = dao.markBillAsUnpaid(billId); // You will add this method below

        if (ok) {
            response.sendRedirect("paidBills.jsp?success=Bill+Marked+as+Unpaid");
        } else {
            response.sendRedirect("paidBills.jsp?error=Failed+to+update+bill");
        }
    }
}
