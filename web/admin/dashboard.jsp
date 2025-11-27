<%@ include file="includes/adminTheme.jspf" %>
<%@ include file="includes/adminSidebar.jspf" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>


<!DOCTYPE html>
<html>
<head>
</head>
<body>

<div class="content">
    <h2>Welcome Admin 👋</h2>

    <div class="row">

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
                    <a href="unpaidBills.jsp" class="btn btn-primary">Paid Bills</a>
                    <a href="paidBills.jsp" class="btn btn-primary">Unpaid Bills</a>
                </div>
            </div>
        </div>

    </div>
</div>

</body>
</html>
