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

        <div class="col-md-4 mb-4">
            <a href="registerCustomer.jsp" class="text-decoration-none text-dark">
                <div class="card menu-card p-4 text-center">
                    <h5>➕ New Customer</h5>
                </div>
            </a>
        </div>

        <div class="col-md-4 mb-4">
            <a href="subscriptions.jsp" class="text-decoration-none text-dark">
                <div class="card menu-card p-4 text-center">
                    <h5>📄 My Subscriptions</h5>
                </div>
            </a>
        </div>

        <div class="col-md-4 mb-4">
            <a href="billingHistory.jsp" class="text-decoration-none text-dark">
                <div class="card menu-card p-4 text-center">
                    <h5>💳 Billing History</h5>
                </div>
            </a>
        </div>

    </div>
</div>

</body>
</html>
