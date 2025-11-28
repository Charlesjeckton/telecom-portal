<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<style>
    /* PAGE LAYOUT ? SAME STYLE AS SUBSCRIPTIONS PAGE */
    .main-content {
        max-width: 1100px;
        margin: 0 auto;
    }

    @media (max-width: 576px) {
        .main-content {
            padding: 15px 10px;
        }
    }

    /* RESPONSIVE TABLE */
    .table-responsive {
        width: 100%;
        overflow-x: auto;
        -webkit-overflow-scrolling: touch;
    }

    th, td {
        white-space: nowrap;
        vertical-align: middle !important;
    }
</style>

<!-- Main Responsive Container -->
<div class="main-content">

    <div class="card shadow-sm">
        <div class="card-body">

            <!-- Responsive Wrapper -->
            <div class="table-responsive">
                <table class="table table-hover table-bordered align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th>Service Name</th>
                            <th>Amount (KES)</th>
                            <th>Billing Date</th>
                        </tr>
                    </thead>

                    <tbody>
                        <c:choose>
                            <c:when test="${paidList ne null && fn:length(paidList) > 0}">
                                <c:forEach var="bill" items="${paidList}">
                                    <tr>
                                        <td>${bill.serviceName}</td>
                                        <td>${bill.amount}</td>
                                        <td>
                                            <fmt:formatDate 
                                                value="${bill.billingDate}" 
                                                pattern="yyyy-MM-dd HH:mm" 
                                                />
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>

                            <c:otherwise>
                                <tr>
                                    <td colspan="3" class="text-center text-muted py-3">
                                        No paid bills found.
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

        </div>
    </div>

</div>


