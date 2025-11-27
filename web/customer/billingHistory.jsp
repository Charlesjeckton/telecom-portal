<%@ page import="dao.BillingDAO, model.Billing, java.util.*" %>

<%
    Integer customerId = (Integer) session.getAttribute("customerId");

    // If user is not logged in, redirect
    if (customerId == null) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
}


    BillingDAO billingDAO = new BillingDAO();
    List<Billing> bills = billingDAO.getBillsByCustomer(customerId);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="includes/customerTheme.jspf" %>
    <title>Billing History</title>
</head>
<body>

<%@ include file="includes/customerNavbar.jspf" %>

<div class="page-container">

    <h2 class="mb-4 text-center">Billing History</h2>

    <div class="card shadow-sm">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-striped table-hover mb-0 align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th>Date</th>
                            <th>Service</th>
                            <th>Amount</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (bills == null || bills.isEmpty()) { %>
                            <tr>
                                <td colspan="4" class="text-center text-muted">No billing records found.</td>
                            </tr>
                        <% } else { %>
                            <% for (Billing b : bills) { %>
                                <tr>
                                    <td><%= b.getBillingDate() %></td>
                                    <td><%= b.getServiceName() != null ? b.getServiceName() : "N/A" %></td>
                                    <td>KES <%= b.getAmount() %></td>
                                    <td>
                                        <% if (b.isPaid()) { %>
                                            <span class="badge bg-success">Paid</span>
                                        <% } else { %>
                                            <span class="badge bg-warning text-dark">Unpaid</span>
                                        <% } %>
                                    </td>
                                </tr>
                            <% } %>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</div>

</body>
</html>
