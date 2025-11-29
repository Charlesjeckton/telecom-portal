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
            .main-content {
                margin-left: 260px;
                padding: 25px;
                transition: 0.3s ease;
            }
            .page-wrapper {
                max-width: 1200px;
                width: 100%;
                margin: 0 auto;
            }
            @media (max-width: 768px) {

                h2 {
                    font-weight: 700;
                    margin-top: 40px;
                    margin-bottom: 6px;
                }
                @media (max-width: 992px) {
                    .main-content {
                        margin-left: 0 !important;
                        padding: 15px;
                    }
                }

                .table-responsive {
                    width: 100%;
                    overflow-x: auto;
                }

                td.table-actions, th.actions-col {
                    text-align: center !important;
                    vertical-align: middle !important;
                }

                .table-actions {
                    display: flex;
                    gap: 6px;
                    justify-content: center;
                    flex-wrap: wrap;
                }

                .action-btn {
                    min-width: 70px;
                    height: 35px;
                    font-size: 13px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                }

                .toggle-btn {
                    min-width: 95px;
                }

                @media (max-width: 576px) {
                    .action-btn {
                        min-width: 60px;
                        height: 30px;
                        font-size: 12px;
                    }
                    .toggle-btn {
                        min-width: 80px;
                    }
                }
            </style>

        </head>

        <body>

            <div class="main-content">
                <div class="page-wrapper">

                    <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 px-2">
                        <h2 class="fw-bold text-center text-md-start mb-3 mb-md-0">Services Management</h2>

                        <a href="addServices.jsp" 
                           class="btn btn-primary w-100 w-md-auto" 
                           style="max-width: 200px;">
                            + Add New
                        </a>
                    </div>

                    <%@ include file="includes/alerts.jspf" %>
                    <div id="ajax-msg"></div>

                    <%        ServiceDAO dao = new ServiceDAO();
                        List<Service> services = dao.getAllServices();
                    %>

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

                                        <% if (services != null && !services.isEmpty()) {
                                                for (Service s : services) {

                                                    // ---- SAFE ID GENERATOR ----
                                                    String safeId = String.valueOf(s.getId());

                                                    if (safeId == null) {
                                                        safeId = "";
                                                    }
                                                    safeId = safeId.trim();

                                                    safeId = safeId.replaceAll("[^A-Za-z0-9]", "");

                                                    // If ID is empty, fallback to unique ID
                                                    if (safeId.isEmpty()) {
                                                        safeId = "svc" + Math.abs(s.hashCode());
                                                    }
                                        %>

                                        <tr id="row-<%= safeId%>">

                                            <td><%= s.getName()%></td>
                                            <td><%= s.getDescription()%></td>
                                            <td>KES <%= s.getCharge()%></td>
                                            <td><%= s.getDurationValue()%> <%= s.getDurationUnit()%></td>

                                            <td>
                                                <span id="status-<%= safeId%>"
                                                      class="badge bg-<%= s.isActive() ? "success" : "secondary"%>">
                                                    <%= s.isActive() ? "Active" : "Inactive"%>
                                                </span>
                                            </td>

                                            <td class="table-actions">

                                                <button
                                                    class="btn btn-sm action-btn toggle-btn <%= s.isActive() ? "btn-secondary" : "btn-success"%>"
                                                    data-id="<%= safeId%>">
                                                    <%= s.isActive() ? "Deactivate" : "Activate"%>
                                                </button>

                                                <a href="editService.jsp?id=<%= safeId%>"
                                                   class="btn btn-warning btn-sm action-btn">
                                                    Edit
                                                </a>

                                                <form action="../admin/service" method="post" style="display:inline;">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="id" value="<%= safeId%>">

                                                    <button class="btn btn-danger btn-sm action-btn"
                                                            onclick="return confirm('Delete this service?');">
                                                        Delete
                                                    </button>
                                                </form>
                                            </td>

                                        </tr>

                                        <% } // end for
                    } else { %>

                                        <tr>
                                            <td colspan="6" class="text-center text-muted">
                                                No services found.
                                            </td>
                                        </tr>

                                        <% }%>

                                    </tbody>
                                </table>
                            </div>

                        </div>
                    </div>

                </div>
            </div>

            <script>
                function showAlert(msg, type = "success") {
                    const alertBox = document.getElementById("ajax-msg");
                    alertBox.innerHTML =
                            '<div class="alert alert-' + type + ' alert-dismissible fade show mt-2">' +
                            '<strong>' + (type === "success" ? "Success" : "Error") + ':</strong> ' + msg +
                            '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>' +
                            '</div>';
                }
            </script>


            <script>
                document.querySelectorAll(".toggle-btn").forEach(button => {
                    button.addEventListener("click", async function () {

                        const id = this.dataset.id;

                        const response = await fetch("<%= request.getContextPath()%>/admin/toggleService", {
                            method: "POST",
                            headers: {"Content-Type": "application/x-www-form-urlencoded"},
                            body: "id=" + id
                        });

                        const data = await response.json();

                        if (!data.success) {
                            showAlert("Failed to update service.", "danger");
                            return;
                        }

                        const badge = document.getElementById("status-" + id);

                        badge.innerText = data.active ? "Active" : "Inactive";
                        badge.className = "badge bg-" + (data.active ? "success" : "secondary");

                        this.innerText = data.active ? "Deactivate" : "Activate";
                        this.classList.toggle("btn-secondary", data.active);
                        this.classList.toggle("btn-success", !data.active);

                        showAlert("Service status updated successfully!");
                    });
                });
            </script>

        </body>
    </html>
