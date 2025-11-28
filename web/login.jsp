<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Login</title>

        <!-- Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- PrimeIcons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/primeicons@5.0.0/primeicons.css" />

        <style>
            body {
                margin: 0;
                min-height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
                background: linear-gradient(135deg, #4e2fbf, #1a94e8);
                font-family: "Poppins", sans-serif;
                padding: 20px; /* Better mobile spacing */
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(25px);
                }
                to   {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* Bigger card */
            .login-wrapper {
                width: 100%;
                max-width: 460px; /* Increased from 400px */
                padding: 40px 32px; /* Slightly bigger inside spacing */
                border-radius: 22px;
                background: #ffffff;
                box-shadow: 0 20px 45px rgba(0,0,0,0.28);
                animation: fadeIn 0.7s ease-out;
            }

            .input-group-text {
                background: #f3f3f3;
                border-right: none;
                font-size: 1.1rem;
            }

            .form-control {
                border-left: none;
                background: #f3f3f3;
                padding: 12px 14px;
                font-size: 1.05rem;
            }

            .form-control:focus {
                background: #fff;
                border-color: #1a94e8;
                box-shadow: 0 0 5px rgba(26,148,232,0.4);
            }

            button {
                background: linear-gradient(135deg, #1a94e8, #6b1fc7);
                border: none;
                padding: 14px;
                font-size: 1.1rem;
                border-radius: 12px;
            }

            button:hover {
                opacity: 0.92;
            }

            .toggle-password {
                cursor: pointer;
            }

            /* Redesigned Register link */
            .register-box {
                margin-top: 18px;
                background: #f5f9ff;
                padding: 12px;
                border-radius: 12px;
                font-size: 0.95rem;
                border: 1px solid #e0e7ff;
            }

            .register-box a {
                font-weight: 600;
                color: #1a94e8;
                text-decoration: none;
            }

            .register-box a:hover {
                text-decoration: underline;
            }
        </style>

    </head>

    <body>

        <div class="login-wrapper">

            <h3 class="text-center fw-bold mb-4">Telecom System Login</h3>

            <!-- Login error -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger d-flex align-items-center">
                    <i class="pi pi-exclamation-triangle me-2"></i> ${error}
                </div>
            </c:if>

            <form action="login" method="post">

                <!-- Username -->
                <div class="input-group mb-3">
                    <span class="input-group-text"><i class="pi pi-user"></i></span>
                    <input type="text" name="username" class="form-control" placeholder="Enter username" required minlength="3">
                </div>

                <!-- Password -->
                <div class="input-group mb-3">
                    <span class="input-group-text"><i class="pi pi-lock"></i></span>
                    <input type="password" id="password" name="password" class="form-control" placeholder="Enter password" required minlength="4">
                    <span class="input-group-text toggle-password" onclick="togglePassword()">
                        <i class="pi pi-eye"></i>
                    </span>
                </div>

                <button type="submit" class="btn btn-primary w-100">
                    <i class="pi pi-sign-in"></i> Login
                </button>
            </form>

            <div class="register-box text-center">
                Don't have an account?
                <a href="registerCustomer.jsp">Create an account</a>
            </div>


            <p class="text-center text-muted mt-2 mb-0" style="font-size: 13px;">
                © 2025 Telecom Management System
            </p>

        </div>

        <script>
            function togglePassword() {
                const pw = document.getElementById("password");
                pw.type = pw.type === "password" ? "text" : "password";
            }
        </script>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    </body>
</html>
