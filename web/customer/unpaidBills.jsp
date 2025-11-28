<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>


<style>
    /* PAGE LAYOUT ? SAME STYLE AS SUBSCRIPTIONS PAGE */
    .main-content {
        max-width: 1100px;
        margin: 0 auto;
    }

    /* Reduce spacing directly under billing tabs */
    .tab-content {
        padding-top: 5px !important;   /* was 15?25px from bootstrap */
        margin-top: 5px !important;    /* tighten table position */
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

<div class="main-content">

    <!-- Reduced top margin here -->
    <div class="card shadow-sm mt-2">
        <div class="card-body">

            <div class="table-responsive">
                <table class="table table-hover table-bordered align-middle">

                    <thead class="table-dark">
                        <tr>
                            <th>Service Name</th>
                            <th>Amount (KES)</th>
                            <th>Billing Date</th>
                            <th style="width: 150px;">Action</th>
                        </tr>
                    </thead>

                    <tbody>
                        <c:choose>

                            <c:when test="${unpaidList ne null and fn:length(unpaidList) > 0}">
                                <c:forEach var="bill" items="${unpaidList}">
                                    <tr>
                                        <td>${bill.serviceName}</td>
                                        <td>${bill.amount}</td>
                                        <td>
                                            <fmt:formatDate value="${bill.billingDate}" pattern="yyyy-MM-dd HH:mm" />
                                        </td>
                                        <td>
                                            <form action="${pageContext.request.contextPath}/admin/markBillPaid"
                                                  method="post" style="display:inline;">
                                                <input type="hidden" name="id" value="${bill.id}" />
                                                <input type="hidden" name="tab" value="unpaid" />

                                                <button type="submit"
                                                        onclick="return confirm('Mark this bill as PAID?');"
                                                        class="btn btn-sm btn-success">
                                                    Pay Bill
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>

                            <c:otherwise>
                                <tr>
                                    <td colspan="4" class="text-center text-muted py-3">
                                        No unpaid bills found.
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
