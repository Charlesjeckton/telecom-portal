<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ include file="includes/adminTheme.jspf" %>
<%@ include file="includes/adminSidebar.jspf" %>

<%@ page import="java.util.List" %>
<%@ page import="model.Billing" %>
<%@ page import="dao.BillingDAO" %>

<%
    BillingDAO dao = new BillingDAO();
    List<Billing> unpaidBills = dao.getUnpaidBillsWithCustomer();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Unpaid Bills - Admin Panel</title>

    <style>
        .main-content {
            margin-left: 260px; /* match sidebar width */
            padding: 25px;
        }
        .table-actions {
            display: flex;
            gap: 8px;
        }
        .btn-pay {
            background: #198754;
            color: #fff;
        }
        .btn-pay:hover {
            background: #157347;
        }
    </style>
</head>

<body>

<div class="main-content">

    <!-- PAGE TITLE -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold">Unpaid Bills</h2>
    </div>

    <!-- SERVLET MESSAGES (request scope) -->
    <c:if test="${not empty message}">
        <div class="alert alert-${messageType == 'success' ? 'success' : 'danger'} alert-dismissible fade show">
            <strong>${messageType == 'success' ? 'Success:' : 'Error:'}</strong> ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- REDIRECT MESSAGES (?success=... / ?error=...) -->
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


    <!-- TABLE CARD -->
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
                    if (unpaidBills != null && !unpaidBills.isEmpty()) {
                        for (Billing bill : unpaidBills) {
                %>

                    <tr>
                        <td><%= bill.getCustomerName() %></td>
                        <td><%= bill.getServiceName() %></td>
                        <td><%= bill.getAmount() %></td>
                        <td><%= bill.getBillingDate() %></td>

                        <td>
                            <form action="<%= request.getContextPath() %>/admin/markBillPaid" method="post" style="display:inline;">
                                <input type="hidden" name="id" value="<%= bill.getId() %>">

                                <button type="submit"
                                        onclick="return confirm('Mark this bill as paid?');"
                                        class="btn btn-sm btn-pay">
                                    Mark as Paid
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
                            No unpaid bills found.
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
