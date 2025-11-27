<%@ include file="includes/adminTheme.jspf" %>
<%@ include file="includes/adminSidebar.jspf" %>
<%@ page import="java.util.List" %>
<%@ page import="dao.SubscriptionDAO" %>
<%@ page import="dao.CustomerDAO" %>
<%@ page import="dao.ServiceDAO" %>
<%@ page import="model.Subscription" %>
<%@ page import="model.Customer" %>
<%@ page import="model.Service" %>

<%
    int id = Integer.parseInt(request.getParameter("id"));

    SubscriptionDAO subDao = new SubscriptionDAO();
    CustomerDAO custDao = new CustomerDAO();
    ServiceDAO servDao = new ServiceDAO();

    Subscription sub = subDao.getSubscriptionById(id);

    if (sub == null) {
%>
<h3 style="color:red;">Subscription not found.</h3>
<a href="subscriptions.jsp">Back</a>
<%
        return;
    }

    List<Customer> customers = custDao.getAllCustomers();
    List<Service> services = servDao.getAllServices();
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Edit Subscription</title>

        <style>
            body {
                font-family: Arial, sans-serif;
                background: #f0f2f5;
                margin: 0;
                padding: 0;
            }

            .container {
                width: 400px;
                background: #fff;
                margin: 40px auto;
                padding: 25px;
                border-radius: 12px;
                box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            }

            h2 {
                text-align: center;
                margin-bottom: 25px;
                color: #333;
            }

            label {
                font-weight: bold;
                display: block;
                margin-bottom: 6px;
                color: #444;
            }

            input, select, textarea {
                width: 100%;
                padding: 10px;
                border-radius: 6px;
                border: 1px solid #ccc;
                margin-bottom: 15px;
                font-size: 14px;
            }

            button {
                width: 100%;
                background: #0066ff;
                color: #fff;
                padding: 12px;
                border: none;
                font-size: 15px;
                font-weight: bold;
                border-radius: 6px;
                cursor: pointer;
            }

            button:hover {
                background: #0052cc;
            }

            .back-link {
                text-align: center;
                display: block;
                margin-top: 15px;
                color: #0066ff;
                text-decoration: none;
            }

            .back-link:hover {
                text-decoration: underline;
            }
        </style>

    </head>
    <body>

        <div class="container">
            <h2>Edit Subscription</h2>

            <form action="subscription" method="post">

                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="<%= sub.getId()%>">

                <label>Customer Name:</label>
                <select name="customer_id" required>
                    <% for (Customer c : customers) {%>
                    <option value="<%= c.getId()%>" <%= (c.getId() == sub.getCustomerId()) ? "selected" : ""%>>
                        <%= c.getName()%>
                    </option>
                    <% } %>
                </select>

                <label>Service Name:</label>
                <select name="service_id" required>
                    <% for (Service s : services) {%>
                    <option value="<%= s.getId()%>" <%= (s.getId() == sub.getServiceId()) ? "selected" : ""%>>
                        <%= s.getName()%>
                    </option>
                    <% }%>
                </select>
                
                <label>Status:</label>
                <select name="status">
                    <option value="ACTIVE" <%= "ACTIVE".equalsIgnoreCase(sub.getStatus()) ? "selected" : ""%>>ACTIVE</option>
                    <option value="INACTIVE" <%= "INACTIVE".equalsIgnoreCase(sub.getStatus()) ? "selected" : ""%>>INACTIVE</option>
                </select>

                <button type="submit">Update</button>
            </form>

            <a href="subscriptions.jsp" class="back-link">Back</a>
        </div>

    </body>
</html>
