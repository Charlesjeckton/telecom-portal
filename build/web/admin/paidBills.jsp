<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ include file="includes/adminTheme.jspf" %>
<%@ include file="includes/adminSidebar.jspf" %>

<%@ page import="java.util.List" %>
<%@ page import="model.Billing" %>
<%@ page import="dao.BillingDAO" %>

<%
    BillingDAO dao = new BillingDAO();
    List<Billing> paidBills = dao.getPaidBillsWithCustomer();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Paid Bills - Admin Panel</title>

    <style>
        .main-content {
            margin-left: 260px;
            padding: 25px;
        }
        .btn-unpay {
            background: #dc3545;
            color: #fff;
        }
        .btn-unpay:hover {
            background: #bb2d3b;
        }
    </style>
</head>

<body>

<div class="main-content">

    <!-- PAGE TITLE -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold">Paid Bills</h2>
    </div>

    <!-- SERVLET MESSAGES -->
    <c:if test="${not empty message}">
        <div class="alert alert-${messageType == 'success' ? 'success' : 'danger'} alert-dismissible fade show">
            <strong>${messageType == 'success' ? 'Success:' : 'Error:'}</strong> ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- URL REDIRECT MESSAGES -->
    <c:if test="${not empty param.success}">
        <div class="alert alert-success alert-dismissible fade show">
            <strong>Success:</strong> ${param.success}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <c:if test="${not empty param.error}">
        <div class="alert alert-danger alert-dismissible fade show">
            <strong>Error:</strong> ${param.error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>


    <!-- TABLE WRAPPER -->
    <div class="card shadow-sm">
        <div class="card-body">

            <table class="table table-hover table-bordered align-middle">
                <thead class="table-dark">
                    <tr>
                        <th>Customer</th>
                        <th>Service</th>
                        <th>Amount (KES)</th>
                        <th>Billing Date</th>
                        <th style="width: 150px;">Action</th>
                    </tr>
                </thead>

                <tbody>
                <%
                    if (paidBills != null && !paidBills.isEmpty()) {
                        for (Billing bill : paidBills) {
                %>

                    <tr>
                        <td><%= bill.getCustomerName() %></td>
                        <td><%= bill.getServiceName() %></td>
                        <td><%= bill.getAmount() %></td>
                        <td><%= bill.getBillingDate() %></td>

                        <td>
                            <form action="<%= request.getContextPath() %>/admin/markBillUnpaid" method="post" style="display:inline;">
                                <input type="hidden" name="billId" value="<%= bill.getId() %>">

                                <button type="submit"
                                        onclick="return confirm('Mark this bill as UNPAID?');"
                                        class="btn btn-sm btn-unpay">
                                    Mark Unpaid
                                </button>
                            </form>
                        </td>
                    </tr>

                <%
                        }
                    } else {
                %>

                    <tr>
                        <td colspan="5" class="text-center text-muted py-3">
                            No paid bills found.
                        </td>
                    </tr>

                <%
                    }
                %>
                </tbody>

            </table>

        </div>
    </div>

</div>

</body>
</html>
