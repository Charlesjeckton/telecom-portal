<%@ include file="includes/adminTheme.jspf" %>
<%@ include file="includes/adminSidebar.jspf" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>Dashboard - Admin Panel</title>

    <style>

        /* PAGE CONTENT WRAPPER */
        .content {
            padding: 30px;
        }

        h2 {
            font-weight: 700;
            margin-bottom: 30px;
        }

        /* DASHBOARD CARDS (same layout, just modernized) */
        .dashboard-card {
            border-radius: 16px;
            padding: 25px;
            background: #ffffff;
            border: 1px solid #e5e5e5;
            transition: 0.25s ease-in-out;
            height: 100%; /* ensures even height */
        }

        .dashboard-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.12);
        }

        .dashboard-card h5 {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 12px;
            display: flex;
            align-items: center;
        }

        .dashboard-card i {
            font-size: 24px;
            margin-right: 8px;
            color: #0d6efd;
        }

        .dashboard-card p {
            color: #666;
            margin-bottom: 18px;
        }

        .btn-primary {
            width: 100%;
            padding: 10px;
            border-radius: 10px;
        }

        /* RESPONSIVE FIX — keep same grid, better padding */
        @media (max-width: 768px) {
            .content {
                padding: 20px;
            }
            h2 {
            font-weight: 700;
            margin-top: 40px;
            margin-bottom: 6px;
        }

            .dashboard-card {
                padding: 20px;
            }

            .dashboard-card h5 {
                font-size: 18px;
            }
        }

        @media (max-width: 576px) {
            h2 {
                font-size: 22px;
            }
        }

    </style>
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
