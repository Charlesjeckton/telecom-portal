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
            /* No need for margin-left; .content handles it */
            .table-actions {
                display: flex;
                gap: 6px;
            }
            @media (max-width: 768px) {

                h2 {
                    font-weight: 700;
                    margin-top: 40px;
                    margin-bottom: 6px;
                }
                /* Table styling for all screen sizes */
                .subscription-table {
                    font-size: 0.95rem; /* slightly smaller default */
                }

                .subscription-table th,
                .subscription-table td {
                    padding: 10px;
                }

                /* Smaller screens */
                @media (max-width: 768px) {
                    .subscription-table {
                        font-size: 0.80rem !important; /* smaller text */
                    }

                    .subscription-table th,
                    .subscription-table td {
                        padding: 6px !important; /* smaller padding */
                    }

                    .card {
                        margin: 0 5px; /* reduce card width for sidebar */
                    }
                }

                /* Extra small devices */
                @media (max-width: 576px) {
                    .subscription-table {
                        font-size: 0.75rem !important;
                    }

                    .subscription-table th,
                    .subscription-table td {
                        padding: 4px !important;
                    }
                }
            </style>
        </head>

        <body>

            <div class="content">

                <!-- Page Header (Responsive & Centered on Large Screens) -->
                <div class="d-flex flex-column flex-md-row 
                     justify-content-between align-items-md-center 
                     mb-4 px-2 mx-auto" 
                     style="max-width: 1200px;
                    width: 100%;">

                    <h2 class="fw-bold text-center text-md-start mb-3 mb-md-0">
                        All Subscription
                    </h2>

                    <a href="addSubscription.jsp" 
                       class="btn btn-primary w-100 w-md-auto"
                       style="max-width: 200px;">
                        + Add New
                    </a>
                </div>


                <%@ include file="includes/alerts.jspf" %>

                <%        SubscriptionDAO subDao = new SubscriptionDAO();
                    CustomerDAO custDao = new CustomerDAO();
                    ServiceDAO servDao = new ServiceDAO();

                    List<Subscription> subs = subDao.getAllSubscriptions();

                    Map<Integer, Customer> customerCache = new HashMap<>();
                    Map<Integer, Service> serviceCache = new HashMap<>();
                %>

                <div class="card shadow-sm">
                    <div class="card-body">

                        <!-- Responsive Table Wrapper -->
                        <div class="table-responsive">
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
                                        <td><%= c != null ? c.getName() : "Unknown Customer"%></td>
                                        <td><%= sv != null ? sv.getName() : "Unknown Service"%></td>
                                        <td><%= s.getPurchaseDate() != null ? s.getPurchaseDate() : "-"%></td>
                                        <td><%= s.getExpiryDate() != null ? s.getExpiryDate() : "-"%></td>

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
                                        <td colspan="6" class="text-center text-muted">
                                            No subscriptions found.
                                        </td>
                                    </tr>

                                    <% }%>
                                </tbody>

                            </table>
                        </div>

                    </div>
                </div>

            </div>

        </body>
    </html>
