<%@ include file="includes/adminTheme.jspf" %>
<%@ include file="includes/adminSidebar.jspf" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>


<!DOCTYPE html>
<html>
<head>
    <title>Dashboard - Admin Panel</title>
</head>
<body>

<div class="content">
    <h2>Welcome Admin 👋</h2>

    <div class="row">
        <div class="col-md-4 mb-4">
            <div class="card dashboard-card shadow-sm">
                <div class="card-body">
                    <h5><i class="bi bi-people"></i> Customers</h5>
                    <p>Manage customers</p>
                    <a href="customers.jsp" class="btn btn-primary">View Customers</a>
                </div>
            </div>
        </div>

        <div class="col-md-4 mb-4">
            <div class="card dashboard-card shadow-sm">
                <div class="card-body">
                    <h5><i class="bi bi-list-check"></i> Services</h5>
                    <p>Manage Telecom services</p>
                    <a href="services.jsp" class="btn btn-primary">Manage Services</a>
                </div>
            </div>
        </div>

        <div class="col-md-4 mb-4">
            <div class="card dashboard-card shadow-sm">
                <div class="card-body">
                    <h5><i class="bi bi-card-list"></i> Subscriptions</h5>
                    <p>Manage customer subscriptions</p>
                    <a href="subscriptions.jsp" class="btn btn-primary">View Subscriptions</a>
                </div>
            </div>
        </div>

        <div class="col-md-4 mb-4">
            <div class="card dashboard-card shadow-sm">
                <div class="card-body">
                    <h5><i class="bi bi-cash-stack"></i> Billing History</h5>
                    <p>Review billing history</p>
                    <a href="billing.jsp" class="btn btn-primary">View Billing</a>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-4">
            <div class="card dashboard-card shadow-sm">
                <div class="card-body">
                    <h5><i class="bi bi-graph-up"></i> Report</h5>
                    <p>Review report</p>
                    <a href="reports.jsp" class="btn btn-primary">View Report</a>
                </div>
            </div>
        </div>

    </div>
</div>

</body>
</html>
