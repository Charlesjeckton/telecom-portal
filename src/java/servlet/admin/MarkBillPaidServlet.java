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

        String idParam = request.getParameter("id");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect("unpaidBills.jsp?error=Invalid+Bill+ID");
            return;
        }

        int billId = Integer.parseInt(idParam);

        BillingDAO dao = new BillingDAO();
        boolean ok = dao.markBillAsPaid(billId);

        if (ok) {
            response.sendRedirect("unpaidBills.jsp?success=Bill+Marked+as+Paid");
        } else {
            response.sendRedirect("unpaidBills.jsp?error=Failed+to+update+bill");
        }
    }
}
