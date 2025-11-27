<%@ include file="includes/adminTheme.jspf" %>
<%@ include file="includes/adminSidebar.jspf" %>
<%@ page import="dao.CustomerDAO" %>
<%@ page import="dao.ServiceDAO" %>
<%@ page import="model.Customer" %>
<%@ page import="model.Service" %>
<%@ page import="java.util.List" %>

<%
    CustomerDAO cdao = new CustomerDAO();
    ServiceDAO sdao = new ServiceDAO();

    List<Customer> customers = cdao.getAllCustomers();
    List<Service> services = sdao.getAllServices();
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Add Subscription - Admin Panel</title>

        <style>
            .main-content {
                margin-left: 260px;
                padding: 30px;
            }
        </style>
    </head>

    <body>

        <div class="main-content">

            <!-- Messages -->
            <% if (request.getParameter("error") != null) {%>
            <div class="alert alert-danger">
                <%= request.getParameter("error")%>
            </div>
            <% } %>

            <% if (request.getParameter("success") != null) {%>
            <div class="alert alert-success">
                <%= request.getParameter("success")%>
            </div>
            <% } %>

            <!-- Header -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="fw-bold">Add Subscription</h2>

                <a href="subscriptions.jsp" class="btn btn-secondary">
                    ? Back to Subscriptions
                </a>
            </div>

            <!-- Form Card -->
            <div class="card shadow-sm">
                <div class="card-body">

                    <form method="post" action="subscription" class="row g-3">

                        <input type="hidden" name="action" value="add">

                        <!-- Customer -->
                        <div class="col-md-12">
                            <label class="form-label">Customer:</label>
                            <select name="customer_id" class="form-select" required>
                                <option value="">Select Customer</option>
                                <% for (Customer c : customers) {%>
                                <option value="<%= c.getId()%>"><%= c.getName()%></option>
                                <% } %>
                            </select>
                        </div>

                        <!-- Service -->
                        <div class="col-md-12">
                            <label class="form-label">Service:</label>
                            <select name="service_id" class="form-select" required>
                                <option value="">Select Service</option>
                                <% for (Service s : services) {%>
                                <option value="<%= s.getId()%>"><%= s.getName()%></option>
                                <% }%>
                            </select>
                        </div>



                        <!-- Submit -->
                        <div class="col-12">
                            <button type="submit" class="btn btn-primary w-100">
                                Add Subscription
                            </button>
                        </div>

                    </form>

                </div>
            </div>

        </div>

    </body>
</html>
