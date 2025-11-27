<%@ page import="dao.ServiceDAO" %>
<%@ page import="model.Service" %>
<%@ page import="java.util.List" %>

<%
    // Authentication check
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
}


    ServiceDAO serviceDAO = new ServiceDAO();
    List<Service> services = serviceDAO.getAllServices();

    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="includes/customerTheme.jspf" %>
    <title>Add Subscription</title>
</head>
<body>

<%@ include file="includes/customerNavbar.jspf" %>

<div class="page-container">

    <div class="card shadow-sm mx-auto" style="max-width: 500px; padding: 30px; border-radius: 12px;">
        <h2 class="text-center mb-4">Add New Subscription</h2>

        <% if (error != null && !error.isEmpty()) { %>
            <div class="alert alert-danger text-center"><%= error %></div>
        <% } %>

        <form action="addSubscription" method="post">

            <!-- SERVICE SELECT -->
            <div class="mb-3">
                <label class="form-label">Select Service:</label>
                <select name="service_id" class="form-select" required>
                    <option value="">-- Select Service --</option>
                    <% if (services != null) {
                           for (Service s : services) { %>
                        <option value="<%= s.getId() %>"><%= s.getName() %></option>
                    <%   } 
                       } %>
                </select>
            </div>

            <!-- START DATE -->
            <div class="mb-3">
                <label class="form-label">Start Date:</label>
                <input type="date" name="start_date" class="form-control" required>
            </div>

            <!-- END DATE -->
            <div class="mb-3">
                <label class="form-label">End Date:</label>
                <input type="date" name="end_date" class="form-control" required>
            </div>

            <!-- Buttons -->
            <div class="d-flex justify-content-between mt-4">
                <button type="submit" class="btn btn-success w-50 me-2">Add Subscription</button>
                <a href="subscriptions.jsp" class="btn btn-secondary w-50 ms-2">Cancel</a>
            </div>

        </form>
    </div>

</div>

</body>
</html>
