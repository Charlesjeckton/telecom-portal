<%@ page import="java.util.List" %>
<%@ page import="dao.SubscriptionDAO" %>
<%@ page import="model.Subscription" %>

<%
    // Ensure user logged in
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    SubscriptionDAO dao = new SubscriptionDAO();

    int customerId = dao.getCustomerIdByUserId(userId);
    if (customerId == 0) {
        response.sendRedirect("../error.jsp");
        return;
    }

    List<Subscription> subs = dao.getSubscriptionsByCustomerId(customerId);

    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="includes/customerTheme.jspf" %>
    <title>My Subscriptions</title>

    <style>
        .fade-in {
            animation: fadeIn 0.6s ease-in-out;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(8px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        .table td, .table th {
            vertical-align: middle;
        }
    </style>
</head>
<body>

<%@ include file="includes/customerNavbar.jspf" %>

<div class="page-container fade-in">

    <h2 class="mb-4 text-center fw-bold">My Subscriptions</h2>

    <!-- Alerts -->
    <% if (success != null) { %>
        <div class="alert alert-success alert-dismissible fade show text-center" role="alert">
            <i class="pi pi-check-circle"></i> <%= success %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>

    <% if (error != null) { %>
        <div class="alert alert-danger alert-dismissible fade show text-center" role="alert">
            <i class="pi pi-exclamation-triangle"></i> <%= error %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>

    <!-- Subscription Table -->
    <div class="card shadow-sm mb-4">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-striped table-hover align-middle mb-0">
                    <thead class="table-dark">
                        <tr>
                            <th>Service</th>
                            <th>Start Date</th>
                            <th>End Date</th>
                            <th>Status</th>
                            <th style="width:160px;">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (subs == null || subs.isEmpty()) { %>
                            <tr>
                                <td colspan="5" class="text-center text-muted py-4">
                                    <i class="pi pi-info-circle"></i> No subscriptions found.
                                </td>
                            </tr>
                        <% } else { 
                            for (Subscription s : subs) { %>
                                <tr>
                                    <td><%= s.getServiceName() %></td>
                                    <td><%= s.getStartDate() %></td>

                                    <td>
                                        <% if (s.getEndDate() == null || s.getEndDate().trim().isEmpty()) { %>
                                            <span class="text-muted">Ongoing</span>
                                        <% } else { %>
                                            <%= s.getEndDate() %>
                                        <% } %>
                                    </td>

                                    <td>
                                        <% if ("active".equalsIgnoreCase(s.getStatus())) { %>
                                            <span class="badge bg-success">Active</span>
                                        <% } else { %>
                                            <span class="badge bg-secondary">Inactive</span>
                                        <% } %>
                                    </td>

                                    <td>
                                        <% if ("active".equalsIgnoreCase(s.getStatus())) { %>
                                            <form action="deactivateSubscription" method="post" style="display:inline;">
                                                <input type="hidden" name="id" value="<%= s.getId() %>" />
                                                <button type="submit" class="btn btn-danger btn-sm">
                                                    <i class="pi pi-times"></i> Deactivate
                                                </button>
                                            </form>
                                        <% } else { %>
                                            <a href="activateSubscriptionForm.jsp?id=<%= s.getId() %>" 
                                               class="btn btn-success btn-sm">
                                                <i class="pi pi-check"></i> Activate
                                            </a>
                                        <% } %>
                                    </td>
                                </tr>
                        <%  } } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Add Subscription -->
    <div class="text-end">
        <a href="addSubscription.jsp" class="btn btn-primary btn-lg">
            <i class="pi pi-plus"></i> Add Subscription
        </a>
    </div>

</div>

</body>
</html>
