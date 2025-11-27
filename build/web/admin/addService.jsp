<%@ include file="includes/adminTheme.jspf" %>
<%@ include file="includes/adminSidebar.jspf" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <title>Add New Service</title>

    <style>
        .main-content {
            margin-left: 260px; /* Same as sidebar width */
            padding: 20px;
        }
    </style>
</head>

<body>

<div class="main-content">

    <h2 class="mb-4">Add New Service</h2>

    <% if (request.getParameter("error") != null) { %>
        <div class="alert alert-danger">
            <%= request.getParameter("error") %>
        </div>
    <% } %>

    <div class="card shadow-sm">
        <div class="card-body">

            <!-- IMPORTANT: Ensure your servlet mapping /admin/service -->
            <form action="service" method="post">

                <!-- Action -->
                <input type="hidden" name="action" value="add">

                <!-- Service Name -->
                <div class="mb-3">
                    <label class="form-label">Service Name</label>
                    <input type="text" name="name" class="form-control" required>
                </div>

                <!-- Description -->
                <div class="mb-3">
                    <label class="form-label">Description</label>
                    <textarea name="description" class="form-control" rows="3" required></textarea>
                </div>

                <!-- Charge -->
                <div class="mb-3">
                    <label class="form-label">Charges</label>
                    <input type="number" step="0.01" name="charge" class="form-control" required>
                </div>

                <!-- Duration Value -->
                <div class="mb-3">
                    <label class="form-label">Duration Value</label>
                    <input type="number" name="duration_value" class="form-control" required>
                </div>

                <!-- Duration Unit -->
                <div class="mb-3">
                    <label class="form-label">Duration Unit</label>
                    <select name="duration_unit" class="form-control" required>
                        <option value="">-- Select Duration Unit --</option>
                        <option value="HOUR">Hours</option>
                        <option value="DAY">Days</option>
                        <option value="WEEK">Weeks</option>
                        <option value="MONTH">Months</option>
                        <option value="YEAR">Years</option>
                    </select>
                </div>

                <!-- Submit Buttons -->
                <button type="submit" class="btn btn-primary">Add Service</button>
                <a href="services.jsp" class="btn btn-secondary">Cancel</a>

            </form>

        </div>
    </div>

</div>

</body>
</html>
