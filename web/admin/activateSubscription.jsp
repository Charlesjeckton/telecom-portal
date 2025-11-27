<%@ include file="includes/adminTheme.jspf" %>
<%@ include file="includes/adminSidebar.jspf" %>
<%@ page import="dao.SubscriptionDAO" %>
<%@ page import="model.Subscription" %>

<%
    String idParam = request.getParameter("id");
    if (idParam == null) {
%>
        <h3 style="color:red;">Invalid subscription ID</h3>
        <a href="subscriptions.jsp">Back</a>
<%
        return;
    }

    int id = Integer.parseInt(idParam);
    Subscription sub = new SubscriptionDAO().getSubscriptionById(id);

    if (sub == null) {
%>
        <h3 style="color:red;">Subscription not found</h3>
        <a href="subscriptions.jsp">Back</a>
<%
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Activate Subscription</title>
</head>
<body>

<h2>Activate Subscription</h2>

<p><strong>Service:</strong> <%= sub.getServiceName() %></p>
<p><strong>Current Status:</strong> <%= sub.getStatus() %></p>

<form method="post" action="subscription">

    <input type="hidden" name="action" value="activate">
    <input type="hidden" name="id" value="<%= sub.getId() %>">

    <label>Start Date:</label><br>
    <input type="date" name="start_date" required><br><br>

    <button type="submit">Activate</button>
</form>

<br>
<a href="subscriptions.jsp">Back</a>

</body>
</html>
