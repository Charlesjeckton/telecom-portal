<%@ include file="includes/adminTheme.jspf" %>
<%@ include file="includes/adminSidebar.jspf" %>
<%@ page import="dao.ServiceDAO" %>
<%@ page import="model.Service" %>

<%
    String idParam = request.getParameter("id");

    if (idParam == null) {
%>
<div class="main-content">
    <div class="alert alert-danger mt-4">Invalid service ID.</div>
    <a href="services.jsp" class="btn btn-secondary mt-3">Back to Services</a>
</div>
<%
        return;
    }

    int id = Integer.parseInt(idParam);
    Service service = new ServiceDAO().getServiceById(id);

    if (service == null) {
%>
<div class="main-content">
    <div class="alert alert-danger mt-4">Service not found.</div>
    <a href="services.jsp" class="btn btn-secondary mt-3">Back to Services</a>
</div>
<%
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Service - Admin Panel</title>

    <style>
        .main-content {
            margin-left: 260px;
            padding: 20px;
        }
    </style>
</head>

<body>

<div class="main-content">

    <h2 class="mb-4">Edit Service</h2>

    <div class="card shadow-sm">
        <div class="card-body">

            <form action="../admin/service" method="post">

                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="<%= service.getId() %>">

                <!-- Service Name -->
                <div class="mb-3">
                    <label class="form-label">Service Name</label>
                    <input type="text" name="name"
                           class="form-control"
                           value="<%= service.getName() %>" required>
                </div>

                <!-- Description -->
                <div class="mb-3">
                    <label class="form-label">Description</label>
                    <textarea name="description"
                              class="form-control"
                              rows="4"
                              required><%= service.getDescription().trim() %></textarea>
                </div>

                <!-- Charge -->
                <div class="mb-3">
                    <label class="form-label">Charges</label>
                    <input type="number" step="0.01" name="charge"
                           class="form-control"
                           value="<%= service.getCharge() %>" required>
                </div>

                <!-- Duration Value -->
                <div class="mb-3">
                    <label class="form-label">Duration Value</label>
                    <input type="number" name="duration_value"
                           class="form-control"
                           value="<%= service.getDurationValue() %>" required>
                </div>

                <!-- Duration Unit -->
                <div class="mb-3">
                    <label class="form-label">Duration Unit</label>
                    <select name="duration_unit" class="form-control" required>
                        <option value="">-- Select Duration Unit --</option>
                        <option value="HOUR"  <%= "HOUR".equals(service.getDurationUnit())  ? "selected" : "" %>>Hours</option>
                        <option value="DAY"   <%= "DAY".equals(service.getDurationUnit())   ? "selected" : "" %>>Days</option>
                        <option value="WEEK"  <%= "WEEK".equals(service.getDurationUnit())  ? "selected" : "" %>>Weeks</option>
                        <option value="MONTH" <%= "MONTH".equals(service.getDurationUnit()) ? "selected" : "" %>>Months</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-primary">Update Service</button>
                <a href="services.jsp" class="btn btn-secondary">Cancel</a>

            </form>

        </div>
    </div>

</div>

</body>
</html>
