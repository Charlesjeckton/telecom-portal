<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ include file="includes/adminTheme.jspf" %>
<%@ include file="includes/adminSidebar.jspf" %>

<%@ page import="java.util.List" %>
<%@ page import="dao.ServiceDAO" %>
<%@ page import="model.Service" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Admin • Service Management</title>

    <style>
        .main-content {
            margin-left: 260px;
            padding: 25px;
        }
        .table-actions {
            display: flex;
            gap: 6px;
        }
        .toggle-btn {
            min-width: 65px;
        }
    </style>
</head>

<body>

<div class="main-content">

    <!-- PAGE HEADER -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold mb-0">Service Management</h2>
        <a href="addService.jsp" class="btn btn-primary">+ Add New Service</a>
    </div>

    <!-- GLOBAL ALERTS -->
    <c:if test="${not empty message}">
        <div class="alert alert-${messageType eq 'success' ? 'success' : 'danger'} alert-dismissible fade show">
            <strong>${messageType eq 'success' ? 'Success' : 'Error'}:</strong> ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- FETCH SERVICES FROM DAO -->
    <%
        ServiceDAO dao = new ServiceDAO();
        List<Service> services = dao.getAllServices();
    %>

    <!-- SERVICES TABLE -->
    <div class="card shadow-sm">
        <div class="card-body">

            <table class="table table-hover table-bordered align-middle">
                <thead class="table-dark">
                <tr>
                    <th>Name</th>
                    <th>Description</th>
                    <th>Charges (KES)</th>
                    <th>Duration</th>
                    <th>Status</th>
                    <th style="width: 180px;">Actions</th>
                </tr>
                </thead>

                <tbody>
                <% if (services != null && !services.isEmpty()) { %>

                    <% for (Service s : services) { %>
                    <tr>
                        <td><%= s.getName() %></td>
                        <td><%= s.getDescription() %></td>

                        <!-- CHARGE -->
                        <td>KES <%= s.getCharge() %></td>

                        <!-- DURATION -->
                        <td>
                            <%= s.getDurationValue() %> 
                            <%= s.getDurationUnit() %>
                        </td>

                        <!-- STATUS BADGE -->
                        <td>
                            <span id="status-<%= s.getId() %>" 
                                  class="badge bg-<%= s.isActive() ? "success" : "secondary" %>">
                                <%= s.isActive() ? "Active" : "Inactive" %>
                            </span>
                        </td>

                        <!-- ACTION BUTTONS -->
                        <td class="table-actions">

                            <!-- TOGGLE ACTIVE/INACTIVE -->
                            <button class="btn btn-info btn-sm toggle-btn"
                                    data-id="<%= s.getId() %>">
                                Update
                            </button>

                            <!-- EDIT -->
                            <a href="editService.jsp?id=<%= s.getId() %>" 
                               class="btn btn-warning btn-sm">Edit</a>

                            <!-- DELETE -->
                            <form action="../admin/service" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="<%= s.getId() %>">
                                <button class="btn btn-danger btn-sm"
                                        onclick="return confirm('Are you sure you want to delete this service?');">
                                    Delete
                                </button>
                            </form>

                        </td>
                    </tr>
                    <% } %>

                <% } else { %>

                <tr>
                    <td colspan="6" class="text-center text-muted">No services found.</td>
                </tr>

                <% } %>
                </tbody>
            </table>

        </div>
    </div>

</div>


<!-- BOOTSTRAP TOAST -->
<div class="toast-container position-fixed top-0 end-0 p-3" style="z-index: 2000;">
    <div id="liveToast" class="toast text-white bg-primary border-0" role="alert">
        <div class="d-flex">
            <div class="toast-body" id="toast-msg">Message...</div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
        </div>
    </div>
</div>


<script>
function showToast(msg, type="primary") {
    let toast = document.getElementById("liveToast");
    let body  = document.getElementById("toast-msg");

    toast.className = "toast text-white bg-" + type + " border-0";
    body.innerText = msg;

    let t = new bootstrap.Toast(toast);
    t.show();
}
</script>

<!-- AJAX: TOGGLE SERVICE ACTIVE STATUS -->
<script>
document.querySelectorAll(".toggle-btn").forEach(btn => {
    btn.addEventListener("click", function () {

        const id = this.getAttribute("data-id");

        fetch('${pageContext.request.contextPath}/admin/toggleService', {
            method: "POST",
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: "id=" + id
        })

        .then(res => res.json())
        .then(data => {
            if (data.success) {
                let badge = document.getElementById("status-" + id);
                badge.innerText = data.active ? "Active" : "Inactive";
                badge.className = "badge bg-" + (data.active ? "success" : "secondary");

                showToast("Service status updated!", "success");
            } 
            else {
                showToast("Failed to update service!", "danger");
            }
        })
        .catch(err => showToast("Request error!", "danger"));
    });
});
</script>

</body>
</html>
