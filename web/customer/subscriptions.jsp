<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ include file="includes/customerTheme.jspf" %>
<%@ include file="includes/customerNavbar.jspf" %>


<%@ page import="java.util.*" %>
<%@ page import="dao.SubscriptionDAO" %>
<%@ page import="model.Subscription" %>


<!DOCTYPE html>
<html>
<head>
    <title>My Subscriptions</title>
    <style>
            /* ============================================
               PAGE LAYOUT (No sidebar – aligned with navbar)
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

            /* Center Status */
            td, th {
                vertical-align: middle !important;
            }

            .actions-col, .table-actions {
                text-align: center;
            }

            /* Status badge */
             .main-content { 
                 padding: 25px;
             }
        .badge-active {
            background-color: #28a745;
        }
        .badge-expired {
            background-color: #6c757d;
        }
        </style>

</head>

<body>

<div class="main-content">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold">My Subscriptions</h2>
        <a href="addSubscription.jsp" class="btn btn-primary">+ Add New</a>
    </div>

    <%@ include file="includes/alerts.jspf" %>

    <%
    Integer customerId = (Integer) session.getAttribute("customerId");

    if (customerId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    SubscriptionDAO subDao = new SubscriptionDAO();
    List<Subscription> subs = subDao.getSubscriptionsByCustomerId(customerId);
%>

    <div class="card shadow-sm">
        <div class="card-body">

            <table class="table table-hover table-bordered align-middle">
                <thead class="table-dark">
                <tr>
                    <th>Service Name</th>
                    <th>Purchase Date</th>
                    <th>Expiry Date</th>
                    <th>Status</th>
                </tr>
                </thead>

                <tbody>
                <%
                    if (subs != null && !subs.isEmpty()) {
                        for (Subscription s : subs) {
                %>

                <tr>
                    <!-- SERVICE -->
                    <td><%= s.getServiceName() != null ? s.getServiceName() : "Unknown" %></td>

                    <!-- PURCHASE DATE -->
                    <td><%= s.getPurchaseDate() != null ? s.getPurchaseDate() : "-" %></td>

                    <!-- EXPIRY DATE -->
                    <td><%= s.getExpiryDate() != null ? s.getExpiryDate() : "-" %></td>

                    <!-- STATUS -->
                    <td>
                        <span class="badge 
                            <%= "ACTIVE".equalsIgnoreCase(s.getStatus()) ? "badge-active" : "badge-expired" %>">
                            <%= s.getStatus() %>
                        </span>
                    </td>
                </tr>

                <%
                        }
                    } else {
                %>

                <tr>
                    <td colspan="4" class="text-center text-muted">
                        No subscriptions found.
                    </td>
                </tr>

                <% } %>

                </tbody>
            </table>

        </div>
    </div>

</div>

</body>
</html>
