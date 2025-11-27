<%@ page import="dao.SubscriptionDAO" %>
<%@ page import="model.Subscription" %>
<%@ page import="dao.ServiceDAO" %>
<%@ page import="model.Service" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String id = request.getParameter("id");
    if (id == null) {
        response.sendRedirect("subscriptions.jsp?error=Invalid+subscription");
        return;
    }

    int subId = Integer.parseInt(id);

    SubscriptionDAO dao = new SubscriptionDAO();
    Subscription sub = dao.getSubscriptionById(subId);

    if (sub == null) {
        response.sendRedirect("subscriptions.jsp?error=Subscription+not+found");
        return;
    }

    // Load service details
    ServiceDAO serviceDao = new ServiceDAO();
    Service service = serviceDao.getServiceById(sub.getServiceId());
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="includes/customerTheme.jspf" %>
    <title>Activate Subscription</title>
</head>
<body>

<%@ include file="includes/customerNavbar.jspf" %>

<div class="page-container">

    <div class="card shadow-sm mx-auto" style="max-width: 500px; padding: 30px; border-radius: 12px;">
        <h3 class="text-center mb-4">Activate Subscription</h3>

        <form action="activateSubscription" method="post">

            <!-- Hidden inputs -->
            <input type="hidden" name="id" value="<%= sub.getId() %>">
            <input type="hidden" name="service_id" value="<%= sub.getServiceId() %>">

            <!-- Service Name (readonly) -->
            <div class="mb-3">
                <label class="form-label">Service</label>
                <input type="text" class="form-control" value="<%= service != null ? service.getName() : "Unknown Service" %>" readonly>
            </div>

            <!-- Start Date -->
            <div class="mb-3">
                <label class="form-label">Start Date</label>
                <input type="date" name="start_date" class="form-control" required>
            </div>

            <!-- End Date -->
            <div class="mb-3">
                <label class="form-label">End Date</label>
                <input type="date" name="end_date" class="form-control" required>
            </div>

            <!-- Submit Button -->
            <button type="submit" class="btn btn-primary w-100">Activate</button>

        </form>
    </div>

</div>

</body>
</html>
