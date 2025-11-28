<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.BillingDAO" %>
<%@ page import="model.Billing" %>
<%@ page import="java.util.*" %>

<%@ include file="includes/customerTheme.jspf" %>
<%@ include file="includes/customerNavbar.jspf" %>

<!DOCTYPE html>
<html>
<head>
    <title>Reports & Charts - Admin Panel</title>

    <!-- Chart.js CDN -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        .chart-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        .chart-title {
            font-weight: bold;
            margin-bottom: 15px;
        }
    </style>
</head>

<body>

<div class="content">

    <h2 class="fw-bold mb-4">Reports & Billing Analytics</h2>

    <%
        BillingDAO dao = new BillingDAO();

        int paidCount = dao.countPaidBills();
        int unpaidCount = dao.countUnpaidBills();

        Map<String, Integer> monthlyTotals = dao.getMonthlyTotals();

        // Convert month labels to JS array
        StringBuilder labelsBuilder = new StringBuilder("[");
        StringBuilder valuesBuilder = new StringBuilder("[");

        for (Map.Entry<String, Integer> entry : monthlyTotals.entrySet()) {
            labelsBuilder.append("'").append(entry.getKey()).append("',");
            valuesBuilder.append(entry.getValue()).append(",");
        }

        if (!monthlyTotals.isEmpty()) {
            labelsBuilder.setLength(labelsBuilder.length() - 1); // remove last comma
            valuesBuilder.setLength(valuesBuilder.length() - 1);
        }

        labelsBuilder.append("]");
        valuesBuilder.append("]");
    %>

    <!-- ======================= SUMMARY CARDS ======================= -->
    <div class="row mb-4">
        <div class="col-md-4">
            <div class="chart-card text-center">
                <h5>Total Bills</h5>
                <h2 class="text-primary"><%= paidCount + unpaidCount %></h2>
            </div>
        </div>

        <div class="col-md-4">
            <div class="chart-card text-center">
                <h5>Paid Bills</h5>
                <h2 class="text-success"><%= paidCount %></h2>
            </div>
        </div>

        <div class="col-md-4">
            <div class="chart-card text-center">
                <h5>Unpaid Bills</h5>
                <h2 class="text-danger"><%= unpaidCount %></h2>
            </div>
        </div>
    </div>


    <!-- ======================= PIE CHART ======================= -->
    <div class="chart-card">
        <h4 class="chart-title">Paid vs Unpaid Bills</h4>
        <canvas id="pieChart"></canvas>
    </div>


    <!-- ======================= LINE CHART ======================= -->
    <div class="chart-card">
        <h4 class="chart-title">Monthly Billing Trend</h4>
        <canvas id="lineChart"></canvas>
    </div>

</div>

<script>
    // ================= PIE CHART =================
    new Chart(document.getElementById('pieChart'), {
        type: 'pie',
        data: {
            labels: ['Paid', 'Unpaid'],
            datasets: [{
                data: [<%= paidCount %>, <%= unpaidCount %>],
                backgroundColor: ['#28a745', '#dc3545']
            }]
        }
    });

    // ================= LINE CHART =================
    new Chart(document.getElementById('lineChart'), {
        type: 'line',
        data: {
            labels: <%= labelsBuilder.toString() %>,
            datasets: [{
                label: 'Total Billing (KES)',
                data: <%= valuesBuilder.toString() %>,
                borderWidth: 3,
                borderColor: '#007bff',
                tension: 0.3
            }]
        }
    });
</script>

</body>
</html>
