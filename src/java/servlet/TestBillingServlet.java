package servlet;

import dao.BillingDAO;
import model.Billing;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/testBilling")
public class TestBillingServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        res.setContentType("text/html");
        PrintWriter out = res.getWriter();

        BillingDAO dao = new BillingDAO();
        List<Billing> bills = dao.getAllBills();

        out.println("<h2>Billing List:</h2>");
        for (Billing b : bills) {
            out.println("<p>Bill ID: " + b.getId() +
                        " | Customer ID: " + b.getCustomerId() +
                        " | Amount: " + b.getAmount() +
                        " | Date: " + b.getBillingDate() +
                        " | Paid: " + (b.isPaid() ? "Yes" : "No") + "</p>");
        }
    }
}
