<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ include file="includes/customerTheme.jspf" %>
<%@ include file="includes/customerNavbar.jspf" %>

<c:set var="activePage" value="billing" />



<style>

    /* Active tab styling */
    .nav-tabs .nav-link.active {
        background-color: #198754 !important;
        color: #fff !important;
        border-color: #198754 !important;
        font-weight: bold;
    }

    /* Hover effect */
    .nav-tabs .nav-link:hover {
        background-color: #e7f1ff;
        color: #198754;
    }

</style>

<div class="content">

    <!-- CENTERED TITLE WITH REDUCED TOP PADDING -->
    <h2 class="pt-4 mb-3 fw-bold text-center">Billing History</h2>


    <!-- =================== ALERT MESSAGES =================== -->
    <c:if test="${not empty message}">
        <div class="alert alert-${messageType} alert-dismissible fade show">
            <strong>
                <c:choose>
                    <c:when test="${messageType eq 'success'}">Success:</c:when>
                    <c:otherwise>Error:</c:otherwise>
                </c:choose>
            </strong>
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <c:if test="${not empty param.success}">
        <div class="alert alert-success alert-dismissible fade show">
            <strong>Success:</strong> ${param.success}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <c:if test="${not empty param.error}">
        <div class="alert alert-danger alert-dismissible fade show">
            <strong>Error:</strong> ${param.error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>


    <!-- ======================= CENTERED TABS ======================= -->
    <ul class="nav nav-tabs justify-content-center mb-2" id="billingTabs">
        <li class="nav-item">
            <a class="nav-link" id="tab-paid"
               href="${pageContext.request.contextPath}/customer/billing?tab=paid">
                Paid Bills
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" id="tab-unpaid"
               href="${pageContext.request.contextPath}/customer/billing?tab=unpaid">
                Unpaid Bills
            </a>
        </li>
    </ul>


    <!-- ======================= TAB CONTENT (NO EXTRA SPACE) ======================= -->
    <div class="tab-content" style="padding-top: 0 !important; margin-top: 0 !important;">

        <div class="tab-pane fade" id="unpaid">
            <jsp:include page="unpaidBills.jsp" />
        </div>

        <div class="tab-pane fade" id="paid">
            <jsp:include page="paidBills.jsp" />
        </div>

    </div>

</div>

<!-- ======================= TAB LOGIC ======================= -->
<script>
    const params = new URLSearchParams(window.location.search);
    const tab = params.get("tab");

    const unpaidTab = document.getElementById("tab-unpaid");
    const paidTab = document.getElementById("tab-paid");

    const unpaidContent = document.getElementById("unpaid");
    const paidContent = document.getElementById("paid");

    // Reset
    unpaidTab.classList.remove("active");
    paidTab.classList.remove("active");
    unpaidContent.classList.remove("show", "active");
    paidContent.classList.remove("show", "active");

    // Determine active tab
    if (tab === "paid") {
        paidTab.classList.add("active");
        paidContent.classList.add("show", "active");
    } else {
        unpaidTab.classList.add("active");
        unpaidContent.classList.add("show", "active");
    }
</script>
