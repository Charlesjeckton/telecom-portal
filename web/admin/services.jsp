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
    <title>Service Management - Admin Panel</title>

    <style>
        /* ------------------------------ */
        /* MAIN LAYOUT RESPONSIVENESS     */
        /* ------------------------------ */

        .main-content {
            margin-left: 260px;
            padding: 25px;
            transition: 0.3s ease;
        }

        /* On tablets and mobile, remove sidebar spacing */
        @media (max-width: 992px) {
            .main-content {
                margin-left: 0 !important;
                padding: 15px;
            }
        }

        /* ------------------------------ */
        /* TABLE RESPONSIVENESS           */
        /* ------------------------------ */

        .table-responsive {
            width: 100%;
            overflow-x: auto;
        }

        /* Center the Actions column */
        th.actions-col,
        td.table-actions {
            text-align: center !important;
            vertical-align: middle !important;
        }

        /* ------------------------------ */
        /* ACTION BUTTONS                 */
        /* ------------------------------ */

        .table-actions {
            display: flex;
            gap: 6px;
            justify-content: center;
            flex-wrap: wrap;  /* Buttons wrap on mobile */
        }

        .action-btn {
            min-width: 70px;
            max-width: 70px;
            height: 35px;
            font-size: 13px;
            padding: 4px 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 500;
        }

        .toggle-btn {
            min-width: 95px;
        }

        /* Even smaller UI on small phones */
        @media (max-width: 576px) {
            .action-btn {
                min-width: 60px;
                max-width: 60px;
                height: 30px;
                font-size: 12px;
                padding: 3px 4px;
            }

            .toggle-btn {
                min-width: 80px;
            }
        }

    </style>
</head>

<body>

<div class="main-content">

    <!-- PAGE HEADER -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold mb-0">Service Management</h2>

        <!-- Add new service button (responsive) -->
        <a href="addService.jsp" class="btn btn-primary action-btn">
            + New
        </a>
    </div>

    <%@ include file="includes/alerts.jspf" %>

    <!-- AJAX ALERT AREA -->
    <div id="ajax-msg"></div>

    <!-- FETCH SERVICES -->
    <%
        ServiceDAO dao = new ServiceDAO();
        List<Service> services = dao.getAllServices();
    %>

    <!-- TABLE AREA -->
    <div class="card shadow-sm">
        <div class="card-body">

            <div class="table-responsive">
                <table class="table table-hover table-bordered align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th>Name</th>
                            <th>Description</th>
                            <th>Charges (KES)</th>
                            <th>Duration</th>
                            <th>Status</th>
                            <th class="actions-col">Actions</th>
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

                            <td>
                                <span id="status-<%= s.getId() %>"
                                      class="badge bg-<%= s.isActive() ? "success" : "secondary" %>">
                                    <%= s.isActive() ? "Active" : "Inactive" %>
                                </span>
                            </td>

                            <td class="table-actions">

                                <!-- TOGGLE BUTTON -->
                                <button
                                    class="btn btn-sm action-btn toggle-btn <%= s.isActive() ? "btn-secondary" : "btn-success" %>"
                                    data-id="<%= s.getId() %>">
                                    <%= s.isActive() ? "Deactivate" : "Activate" %>
                                </button>

                                <!-- EDIT BUTTON -->
                                <a href="editService.jsp?id=<%= s.getId() %>"
                                   class="btn btn-warning btn-sm action-btn">
                                    Edit
                                </a>

                                <!-- DELETE BUTTON -->
                                <form action="../admin/service" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="<%= s.getId() %>">

                                    <button class="btn btn-danger btn-sm action-btn"
                                            onclick="return confirm('Delete this service?');">
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

</div>

<!-- ALERT FUNCTION -->
<script>
    function showAlert(msg, type = "success") {
        const alertBox = document.getElementById("ajax-msg");
        let prefix = (type === "success") ? "Success" : "Error";

        alertBox.innerHTML =
            '<div class="alert alert-' + type + ' alert-dismissible fade show mt-2">' +
                '<strong>' + prefix + ':</strong> ' + msg +
                '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>' +
            '</div>';
    }
</script>

<!-- AJAX TOGGLE SCRIPT -->
<script>
    document.querySelectorAll(".toggle-btn").forEach(button => {
        button.addEventListener("click", async function () {

            const id = this.dataset.id;

            const response = await fetch("<%= request.getContextPath() %>/admin/toggleService", {
                method: "POST",
                headers: {"Content-Type": "application/x-www-form-urlencoded"},
                body: "id=" + id
            });

            const data = await response.json();

            if (!data.success) {
                showAlert("Failed to update service.", "danger");
                return;
            }

            // Update badge
            const badge = document.getElementById("status-" + id);
            badge.innerText = data.active ? "Active" : "Inactive";
            badge.className = "badge bg-" + (data.active ? "success" : "secondary");

            // Update button
            this.innerText = data.active ? "Deactivate" : "Activate";
            this.classList.toggle("btn-secondary", data.active);
            this.classList.toggle("btn-success", !data.active);

            showAlert("Service status updated successfully!");
        });
    });
</script>

</body>
</html>
