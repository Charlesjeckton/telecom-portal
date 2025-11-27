<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    String usernameSession = (String) session.getAttribute("username");
    if (usernameSession == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="includes/customerTheme.jspf" %>
    <title>Register Customer</title>

    <style>
        .error-text {
            color: #d9534f;
            font-size: 0.85rem;
            margin-top: 3px;
        }
        .invalid-input {
            border: 1px solid #d9534f !important;
        }
        .password-wrapper {
            position: relative;
        }
        .toggle-password {
            position: absolute;
            top: 50%;
            right: 12px;
            transform: translateY(-50%);
            cursor: pointer;
            font-size: 1.2rem;
            color: gray;
        }
    </style>

</head>
<body>

<%@ include file="includes/customerNavbar.jspf" %>

<div class="page-container">

    <div class="card shadow-sm mx-auto" style="max-width: 520px; padding: 30px; border-radius: 12px;">
        <h2 class="text-center mb-4">Register New Customer</h2>

        <!-- GLOBAL SUCCESS / ERROR (Bootstrap Alerts) -->
        <c:if test="${not empty param.success}">
            <div class="alert alert-success text-center">${param.success}</div>
        </c:if>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger text-center">${param.error}</div>
        </c:if>

        <!-- IMPORTANT → Fixed action and path -->
        <form action="${pageContext.request.contextPath}/customer/registerCustomer" method="post">

            <!-- NAME -->
            <div class="mb-3">
                <label class="form-label">Full Name</label>
                <input 
                    type="text" 
                    class="form-control ${not empty errors.name ? 'invalid-input' : ''}" 
                    name="name"
                    value="${form_name}"
                    placeholder="Enter full name"
                    required>
                <c:if test="${not empty errors.name}">
                    <div class="error-text">${errors.name}</div>
                </c:if>
            </div>

            <!-- PHONE -->
            <div class="mb-3">
                <label class="form-label">Phone Number</label>
                <input 
                    type="text" 
                    class="form-control ${not empty errors.phone ? 'invalid-input' : ''}" 
                    name="phone"
                    value="${form_phone}"
                    placeholder="Enter phone number"
                    required>
                <c:if test="${not empty errors.phone}">
                    <div class="error-text">${errors.phone}</div>
                </c:if>
            </div>

            <!-- EMAIL -->
            <div class="mb-3">
                <label class="form-label">Email Address</label>
                <input 
                    type="email"
                    class="form-control ${not empty errors.email ? 'invalid-input' : ''}" 
                    name="email"
                    value="${form_email}"
                    placeholder="Enter email address"
                    required>
                <c:if test="${not empty errors.email}">
                    <div class="error-text">${errors.email}</div>
                </c:if>
            </div>

            <!-- USERNAME -->
            <div class="mb-3">
                <label class="form-label">Username</label>
                <input 
                    type="text" 
                    class="form-control ${not empty errors.username ? 'invalid-input' : ''}" 
                    name="username"
                    value="${form_username}"
                    placeholder="Choose a username"
                    required>
                <c:if test="${not empty errors.username}">
                    <div class="error-text">${errors.username}</div>
                </c:if>
            </div>

            <!-- PASSWORD -->
            <div class="mb-4 password-wrapper">
                <label class="form-label">Password</label>
                <input 
                    type="password" 
                    class="form-control ${not empty errors.password ? 'invalid-input' : ''}" 
                    name="password"
                    id="password"
                    placeholder="Enter password"
                    required>

                <i class="pi pi-eye toggle-password" onclick="togglePassword()"></i>

                <c:if test="${not empty errors.password}">
                    <div class="error-text">${errors.password}</div>
                </c:if>
            </div>

            <button type="submit" class="btn btn-primary w-100 btn-lg">Register</button>

        </form>
    </div>

</div>

<script>
function togglePassword() {
    const field = document.getElementById("password");
    field.type = (field.type === "password") ? "text" : "password";
}
</script>

</body>
</html>
