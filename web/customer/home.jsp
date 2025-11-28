<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>


<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
}

%>

<!DOCTYPE html>
<html lang="en">

<!-- Include Theme -->
<%@ include file="includes/customerTheme.jspf" %>

<body>

<!-- Include Navbar -->
<%@ include file="includes/customerNavbar.jspf" %>

<!-- MAIN CONTENT -->
<div class="page-container">

    <h2 class="mb-4">Welcome, <%= username %> 👋</h2>
    <p>Select an option below:</p>
    
    
    <div class="row mt-4">

    <!-- SERVICES -->
    <div class="col-md-4 mb-4">
        <a href="services.jsp" class="text-decoration-none text-dark">
            <div class="card menu-card p-4 text-center">
                <h5>🛠️ Services</h5>
            </div>
        </a>
    </div>

    <!-- SUBSCRIPTIONS -->
    <div class="col-md-4 mb-4">
        <a href="subscriptions.jsp" class="text-decoration-none text-dark">
            <div class="card menu-card p-4 text-center">
                <h5>📄 My Subscriptions</h5>
            </div>
        </a>
    </div>
    
      <!-- BILLING HISTORY -->
    <div class="col-md-4 mb-4">
            <a href="billing.jsp" class="text-decoration-none text-dark">
                <div class="card menu-card p-4 text-center">
                    <h5>💳 Billing History</h5>
                </div>
            </a>
        </div>

    <!-- REPORTS -->
    <div class="col-md-4 mb-4">
        <a href="reports.jsp" class="text-decoration-none text-dark">
            <div class="card menu-card p-4 text-center">
                <h5>📊 Reports</h5>
            </div>
        </a>
    </div>

</div>
</div>

</body>
</html>
