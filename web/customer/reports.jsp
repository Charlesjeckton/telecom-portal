<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.BillingDAO" %>
<%@ page import="model.Billing" %>
<%@ page import="java.util.*" %>

<%@ include file="includes/customerTheme.jspf" %>
<%@ include file="includes/customerNavbar.jspf" %>

<!-- ⭐ Fix: Highlight the 'Reports' menu in navbar -->
<c:set var="activePage" value="reports" />


<%
    // ==================== SESSION CHECK ====================
    Integer customerId = (Integer) session.getAttribute("customerId");

    if (customerId == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    BillingDAO dao = new BillingDAO();

    // ==================== CUSTOMER-SPECIFIC COUNTS ====================
    int paidCount = dao.countPaidBillsByCustomer(customerId);
    int unpaidCount = dao.countUnpaidBillsByCustomer(customerId);

    // ==================== MONTHLY TOTALS ====================
    Map<String, Integer> monthlyTotals = dao.getMonthlyTotalsByCustomer(customerId);

    StringBuilder labelsBuilder = new StringBuilder("[");
    StringBuilder valuesBuilder = new StringBuilder("[");

    for (Map.Entry<String, Integer> entry : monthlyTotals.entrySet()) {
        labelsBuilder.append("'").append(entry.getKey()).append("',");
        valuesBuilder.append(entry.getValue()).append(",");
    }

    if (!monthlyTotals.isEmpty()) {
        labelsBuilder.setLength(labelsBuilder.length() - 1);
        valuesBuilder.setLength(valuesBuilder.length() - 1);
    }

    labelsBuilder.append("]");
    valuesBuilder.append("]");
%>

<!DOCTYPE html>
<html>
    <head>
        <title>My Billing Reports</title>

        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

        <style>

            /* Main Page Container */
            .main-content {
                padding: 30px 20px;
                max-width: 1100px;
                margin: 0 auto;
            }

            @media (max-width: 576px) {
                .main-content {
                    padding: 15px 10px;
                }
            }

            /* ===== Summary Cards ===== */
            .summary-card {
                text-align: center;
                background: #fff;
                padding: 20px;
                border-radius: 16px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.08);
                transition: 0.2s ease;
            }
            .summary-card:hover {
                transform: translateY(-3px);
                box-shadow: 0 6px 16px rgba(0,0,0,0.12);
            }

            .summary-title {
                font-size: 16px;
                color: #555;
                font-weight: 500;
            }

            .summary-value {
                font-size: 30px;
                font-weight: bold;
                margin-top: 5px;
            }

            /* ===== Charts Layout (Improved Responsive Grid) ===== */
            .chart-section {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
                gap: 25px;
                margin-bottom: 50px;
            }

            .chart-card {
                background: #ffffff;
                border-radius: 16px;
                padding: 25px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.08);
                transition: 0.2s ease;
                min-height: 420px;
                display: flex;
                flex-direction: column;
                justify-content: center;
            }

            .chart-card:hover {
                transform: translateY(-4px);
                box-shadow: 0 6px 16px rgba(0,0,0,0.12);
            }

            .chart-title {
                font-weight: 600;
                text-align: center;
                margin-bottom: 15px;
                font-size: 18px;
            }

            .chart-card canvas {
                width: 100% !important;
                height: 340px !important;
            }

            @media (max-width: 768px) {
                .chart-card canvas {
                    height: 260px !important;
                }
            }

            @media (max-width: 576px) {
                .chart-card {
                    min-height: 360px;
                }
                .chart-card canvas {
                    height: 220px !important;
                }
            }

        </style>

    </head>
    <body>

        <div class="main-content">

            <h2 class="pt-4 fw-bold mb-4 text-center">My Billing Reports & Analytics</h2>

            <!-- ======================= SUMMARY CARDS ======================= -->
            <div class="row mb-4">

                <div class="col-md-4 mb-3">
                    <div class="summary-card">
                        <div class="summary-title">Total Bills</div>
                        <div class="summary-value text-primary"><%= paidCount + unpaidCount%></div>
                    </div>
                </div>

                <div class="col-md-4 mb-3">
                    <div class="summary-card">
                        <div class="summary-title">Paid Bills</div>
                        <div class="summary-value text-success"><%= paidCount%></div>
                    </div>
                </div>

                <div class="col-md-4 mb-3">
                    <div class="summary-card">
                        <div class="summary-title">Unpaid Bills</div>
                        <div class="summary-value text-danger"><%= unpaidCount%></div>
                    </div>
                </div>

            </div>

            <!-- ======================= CHARTS ======================= -->
            <div class="chart-section">

                <!-- PIE CHART -->
                <div class="chart-card">
                    <h4 class="chart-title">Paid vs Unpaid Bills</h4>
                    <canvas id="pieChart"></canvas>
                </div>

                <!-- LINE CHART -->
                <div class="chart-card">
                    <h4 class="chart-title">Monthly Billing Trend</h4>
                    <canvas id="lineChart"></canvas>
                </div>

            </div>

        </div>

        <script>

            // PIE CHART
            new Chart(document.getElementById('pieChart'), {
                type: 'pie',
                data: {
                    labels: ['Paid', 'Unpaid'],
                    datasets: [{
                            data: [<%= paidCount%>, <%= unpaidCount%>],
                            backgroundColor: ['#28a745', '#dc3545']
                        }]
                }
            });

            // LINE CHART
            new Chart(document.getElementById('lineChart'), {
                type: 'line',
                data: {
                    labels: <%= labelsBuilder.toString()%>,
                    datasets: [{
                            label: 'Total Billing (KES)',
                            data: <%= valuesBuilder.toString()%>,
                            borderWidth: 3,
                            borderColor: '#007bff',
                            tension: 0.3
                        }]
                }
            });

        </script>

    </body>
</html>
