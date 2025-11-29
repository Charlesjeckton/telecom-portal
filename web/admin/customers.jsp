<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dao.CustomerDAO"%>
<%@page import="model.Customer"%>
<%@page import="java.util.List"%>

<%@ include file="includes/adminTheme.jspf" %>
<%@ include file="includes/adminSidebar.jspf" %>

<!DOCTYPE html>
<html>
<head>
    <title>Customer - Admin Panel</title>

    <style>
        .table-actions {
            display: flex;
            gap: 6px;
        }
        @media (max-width: 768px) {
            h2 {
            font-weight: 700;
            margin-top: 40px;
            margin-bottom: 6px;
        }
    </style>
</head>

<body>

<div class="content">

    <div class="text-center mb-4">
        <h2 class="fw-bold">Customer List</h2>
    </div>

    <div class="card shadow-sm">
        <div class="card-body">

            <!-- TRUE RESPONSIVE TABLE WRAPPER -->
            <div class="table-responsive">
                <table class="table table-hover table-bordered align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th>Name</th>
                            <th>Phone</th>
                            <th>Email</th>
                            <th style="width: 120px;">Action</th>
                        </tr>
                    </thead>

                    <tbody>
                        <%
                            CustomerDAO dao = new CustomerDAO();
                            List<Customer> customers = dao.getAllCustomers();

                            if (customers != null && !customers.isEmpty()) {
                                for (Customer c : customers) {
                        %>

                        <tr>
                            <td><%= c.getName() %></td>
                            <td><%= c.getPhoneNumber() %></td>
                            <td><%= c.getEmail() %></td>

                            <td>
                                <a class="btn btn-primary btn-sm"
                                   href="customerDetails.jsp?id=<%= c.getId() %>">
                                   <i class="bi bi-eye"></i> View
                                </a>
                            </td>
                        </tr>

                        <%
                                }
                            } else {
                        %>

                        <tr>
                            <td colspan="4" class="text-center text-muted">
                                No customers found.
                            </td>
                        </tr>

                        <% } %>
                    </tbody>
                </table>
            </div>
            <!-- END TABLE RESPONSIVE -->

        </div>
    </div>

</div>

</body>
</html>
