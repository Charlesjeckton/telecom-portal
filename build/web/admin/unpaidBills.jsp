<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="card shadow-sm">
    <div class="card-body">
        <table class="table table-hover table-bordered align-middle">
            <thead class="table-dark">
                <tr>
                    <th>Customer</th>
                    <th>Service</th>
                    <th>Amount (KES)</th>
                    <th>Billing Date</th>
                    <th style="width: 150px;">Action</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty unpaidList}">
                        <c:forEach var="bill" items="${unpaidList}">
                            <tr>
                                <td>${bill.customerName}</td>
                                <td>${bill.serviceName}</td>
                                <td>${bill.amount}</td>
                                <td>${bill.billingDate}</td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/admin/markBillPaid"
                                          method="post" style="display:inline;">
                                        <input type="hidden" name="id" value="${bill.id}" />
                                        <input type="hidden" name="tab" value="unpaid" />
                                        <button type="submit"
                                                onclick="return confirm('Mark this bill as PAID?');"
                                                class="btn btn-sm btn-success">
                                            Mark as Paid
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>

                    <c:otherwise>
                        <tr>
                            <td colspan="5" class="text-center text-muted py-3">
                                No unpaid bills found.
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>
