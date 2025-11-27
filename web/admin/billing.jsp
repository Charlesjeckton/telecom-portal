<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- THEME + SIDEBAR -->
<%@ include file="includes/adminTheme.jspf" %>
<%@ include file="includes/adminSidebar.jspf" %>

<%@ page import="dao.BillingDAO" %>

<%
    BillingDAO dao = new BillingDAO();
    request.setAttribute("paidList", dao.getPaidBillsWithCustomer());
    request.setAttribute("unpaidList", dao.getUnpaidBillsWithCustomer());
%>

<style>
    /* Style for active tab */
    .nav-tabs .nav-link.active {
        background-color: #198754 !important;
        color: #fff !important;
        border-color: #0d6efd !important;
        font-weight: bold;
    }

    .nav-tabs .nav-link:hover {
        background-color: #e7f1ff;
        color: #0d6efd;
    }
</style>

<div class="content">
    <h2 class="mb-4 fw-bold">Billing History</h2>

    <!-- ===================== ALERT MESSAGES ===================== -->
    <c:if test="${not empty message}">
        <c:choose>
            <c:when test="${messageType eq 'success'}">
                <c:set var="alertType" value="success" />
                <c:set var="alertTitle" value="Success:" />
            </c:when>
            <c:otherwise>
                <c:set var="alertType" value="danger" />
                <c:set var="alertTitle" value="Error:" />
            </c:otherwise>
        </c:choose>

        <div class="alert alert-${alertType} alert-dismissible fade show">
            <strong>${alertTitle}</strong> ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- REDIRECT SUCCESS -->
    <c:if test="${not empty param.success}">
        <div class="alert alert-success alert-dismissible fade show">
            <strong>Success:</strong> ${param.success}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- REDIRECT ERROR -->
    <c:if test="${not empty param.error}">
        <div class="alert alert-danger alert-dismissible fade show">
            <strong>Error:</strong> ${param.error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <!-- =========================================================== -->

    <!-- Tabs -->
    <ul class="nav nav-tabs" id="billingTabs">
        <li class="nav-item">
            <a class="nav-link" id="tab-unpaid" href="billing.jsp?tab=unpaid">Unpaid Bills</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" id="tab-paid" href="billing.jsp?tab=paid">Paid Bills</a>
        </li>
    </ul>

    <div class="tab-content pt-3">

        <!-- UNPAID TAB -->
        <div class="tab-pane fade" id="unpaid">
            <jsp:include page="unpaidBills.jsp" />
        </div>

        <!-- PAID TAB -->
        <div class="tab-pane fade" id="paid">
            <jsp:include page="paidBills.jsp" />
        </div>

    </div>
</div>

<!-- Correct Tab Switching -->
<script>
    const urlParams = new URLSearchParams(window.location.search);
    const tab = urlParams.get("tab");

    const unpaidTab = document.getElementById("tab-unpaid");
    const paidTab = document.getElementById("tab-paid");

    const unpaidContent = document.getElementById("unpaid");
    const paidContent = document.getElementById("paid");

    // Clean existing active classes
    unpaidTab.classList.remove("active");
    paidTab.classList.remove("active");
    unpaidContent.classList.remove("show", "active");
    paidContent.classList.remove("show", "active");

    // Activate correct tab
    if (tab === "paid") {
        paidTab.classList.add("active");
        paidContent.classList.add("show", "active");
    } else {
        unpaidTab.classList.add("active");
        unpaidContent.classList.add("show", "active");
    }
</script>
