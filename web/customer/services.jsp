<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    // Set active page for navbar highlight
%>
<c:set var="activePage" value="services" />


<%@ include file="includes/customerTheme.jspf" %>
<%@ include file="includes/customerNavbar.jspf" %>

<%@ page import="java.util.List" %>
<%@ page import="dao.ServiceDAO" %>
<%@ page import="model.Service" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Services</title>

    <style>
        /* ============================================
           PAGE LAYOUT
        ============================================ */
        .main-content {
            padding: 30px 20px;
            max-width: 1100px;
            margin: 0 auto;
        }

        @media (max-width: 576px) {
            .main-content {
                padding: 15px 10px;
            }
        }

        /* ============================================
           RESPONSIVE TABLE
        ============================================ */
        .table-responsive {
            width: 100%;
            overflow-x: auto;
        }

        td, th {
            vertical-align: middle !important;
        }

        .actions-col, .table-actions {
            text-align: center;
        }

        .badge {
            font-size: 0.85rem;
            padding: 8px 12px;
        }
    </style>
</head>

<body>

<div class="main-content">

    <!-- PAGE TITLE -->
    <div class="text-center mb-4">
        <h2 class="fw-bold mb-0">Services Available</h2>
    </div>

    <!-- FETCH SERVICES -->
    <%
        ServiceDAO dao = new ServiceDAO();
        List<Service> services = dao.getAllActiveServices();
    %>

    <!-- TABLE CARD -->
    <div class="card shadow-sm">
        <div class="card-body">

            <div class="table-responsive">
                <table class="table table-hover table-bordered">
                    <thead class="table-dark">
                        <tr>
                            <th>Service Name</th>
                            <th>Description</th>
                            <th>Charges (KES)</th>
                            <th>Duration</th>
                            <th>Status</th>
                        </tr>
                    </thead>

                    <tbody>
                        <% if (services != null && !services.isEmpty()) { %>

                            <% for (Service s : services) { %>
                            <tr id="row-<%= s.getId() %>">

                                <td><%= s.getName() %></td>
                                <td><%= s.getDescription() %></td>
                                <td>KES <%= s.getCharge() %></td>
                                <td><%= s.getDurationValue() %> <%= s.getDurationUnit() %></td>

                                <td class="text-center">
                                    <span id="status-<%= s.getId() %>"
                                          class="badge bg-<%= s.isActive() ? "success" : "secondary" %>">
                                        <%= s.isActive() ? "Active" : "Inactive" %>
                                    </span>
                                </td>

                            </tr>
                            <% } %>

                        <% } else { %>

                        <tr>
                            <td colspan="5" class="text-center text-muted">No services found.</td>
                        </tr>

                        <% } %>
                    </tbody>

                </table>
            </div>

        </div>
    </div>

</div>

</body>
</html>
