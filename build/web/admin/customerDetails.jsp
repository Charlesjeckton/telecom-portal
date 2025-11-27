<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dao.CustomerDAO"%>
<%@page import="model.Customer"%>

<%@ include file="includes/adminTheme.jspf" %>
<%@ include file="includes/adminSidebar.jspf" %>

<!DOCTYPE html>
<html>
<head>
    <title>Customer Details - Admin Panel</title>

    <style>
        .main-content {
            margin-left: 260px;
            padding: 25px;
        }
        .detail-title {
            font-weight: bold;
            width: 180px;
        }
    </style>
</head>

<body>

<div class="main-content">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold">Customer Details</h2>
        <a href="customers.jsp" class="btn btn-secondary">
            ← Back to Customers
        </a>
    </div>

    <%
        String idParam = request.getParameter("id");

        if (idParam != null) {
            int id = Integer.parseInt(idParam);
            CustomerDAO dao = new CustomerDAO();
            Customer c = dao.getCustomerById(id);

            if (c != null) {
    %>

    <!-- CARD WRAPPER -->
    <div class="card shadow-sm">
        <div class="card-body">

            <table class="table table-bordered table-striped">
                <tr>
                    <td class="detail-title">Customer ID</td>
                    <td><%= c.getId() %></td>
                </tr>
                <tr>
                    <td class="detail-title">Name</td>
                    <td><%= c.getName() %></td>
                </tr>
                <tr>
                    <td class="detail-title">Phone</td>
                    <td><%= c.getPhoneNumber() %></td>
                </tr>
                <tr>
                    <td class="detail-title">Email</td>
                    <td><%= c.getEmail() %></td>
                </tr>
                <tr>
                    <td class="detail-title">Registration Date</td>
                    <td><%= c.getRegistrationDate() %></td>
                </tr>
            </table>

        </div>
    </div>

    <%
            } else {
    %>

    <div class="alert alert-danger">Customer not found!</div>

    <%
            }
        } else {
    %>

    <div class="alert alert-warning">Invalid customer ID!</div>

    <% } %>

</div>

</body>
</html>
