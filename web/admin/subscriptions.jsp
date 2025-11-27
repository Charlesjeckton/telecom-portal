<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ include file="includes/adminTheme.jspf" %>
<%@ include file="includes/adminSidebar.jspf" %>


<%@ page import="java.util.*" %>
<%@ page import="dao.SubscriptionDAO" %>
<%@ page import="dao.CustomerDAO" %>
<%@ page import="dao.ServiceDAO" %>
<%@ page import="model.Subscription" %>
<%@ page import="model.Customer" %>
<%@ page import="model.Service" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Subscription Management - Admin Panel</title>

        <style>
            .main-content {
                margin-left: 260px;
                padding: 25px;
            }
            .table-actions {
                display: flex;
                gap: 6px;
            }
        </style>
    </head>

    <body>

        <div class="main-content">

            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="fw-bold">All Subscription</h2>
                <a href="addSubscription.jsp" class="btn btn-primary">+ Add New</a>
            </div>

            <%@ include file="includes/alerts.jspf" %>
            <%
                SubscriptionDAO subDao = new SubscriptionDAO();
                CustomerDAO custDao = new CustomerDAO();
                ServiceDAO servDao = new ServiceDAO();

                List<Subscription> subs = subDao.getAllSubscriptions();

                Map<Integer, Customer> customerCache = new HashMap<>();
                Map<Integer, Service> serviceCache = new HashMap<>();
            %>

            <div class="card shadow-sm">
                <div class="card-body">

                    <table class="table table-hover table-bordered align-middle">
                        <thead class="table-dark">
                            <tr>
                                <th>Customer</th>
                                <th>Service</th>
                                <th>Purchase Date</th>
                                <th>Expiry Date</th>
                                <th>Status</th>
                            </tr>
                        </thead>

                        <tbody>
                            <%
                                if (subs != null && !subs.isEmpty()) {

                                    for (Subscription s : subs) {

                                        Customer c = customerCache.computeIfAbsent(
                                                s.getCustomerId(),
                                                id -> custDao.getCustomerById(id)
                                        );

                                        Service sv = serviceCache.computeIfAbsent(
                                                s.getServiceId(),
                                                id -> servDao.getServiceById(id)
                                        );
                            %>

                            <tr>
                                <!-- CUSTOMER NAME -->
                                <td><%= (c != null) ? c.getName() : "Unknown Customer"%></td>

                                <!-- SERVICE NAME -->
                                <td><%= (sv != null) ? sv.getName() : "Unknown Service"%></td>

                                <!-- PURCHASE DATE -->
                                <td><%= s.getPurchaseDate() != null ? s.getPurchaseDate() : "-"%></td>

                                <!-- EXPIRY DATE -->
                                <td><%= s.getExpiryDate() != null ? s.getExpiryDate() : "-"%></td>

                                <!-- STATUS -->
                                <td>
                                    <span class="badge bg-<%= "Active".equalsIgnoreCase(s.getStatus()) ? "success" : "secondary"%>">
                                        <%= s.getStatus()%>
                                    </span>
                                </td>

                            </tr>

                            <%
                                }
                            } else {
                            %>
                            <tr>
                                <td colspan="6" class="text-center text-muted">No subscriptions found.</td>
                            </tr>
                            <% }%>
                        </tbody>

                    </table>

                </div>
            </div>

        </div>

    </body>
</html>
