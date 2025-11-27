<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/primeicons@5.0.0/primeicons.css" />

    <style>
        body {
            margin: 0;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background: linear-gradient(135deg, #4e2fbf, #1a94e8);
            font-family: "Poppins", sans-serif;
        }

        /* Fade-in animation */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(25px); }
            to   { opacity: 1; transform: translateY(0);   }
        }

        /* LOGIN CARD */
        .login-wrapper {
            width: 380px;
            padding: 45px 40px;
            border-radius: 20px;
            background: #ffffff;
            box-shadow: 0 18px 40px rgba(0,0,0,0.25);
            animation: fadeIn 0.7s ease-out;
            text-align: center;
        }

        .login-title {
            font-size: 30px;
            font-weight: 700;
            margin-bottom: 28px;
            color: #2c2c2c;
        }

        /* INPUT FIELD GROUP */
        .input-group {
            position: relative;
            width: 100%;
            margin-bottom: 28px;
        }

        /* Left icon (user / lock) */
        .input-group i.input-icon {
            position: absolute;
            top: 50%;
            left: 14px;
            transform: translateY(-50%);
            color: #555;
            font-size: 18px;
        }

        /* Input field */
        .input-group input {
            width: 100%;
            padding: 15px 55px 15px 45px; /* 45px left icon, 55px right icon */
            border-radius: 12px;
            border: 1px solid #ccc;
            background: #f3f3f3;
            font-size: 16px;
            box-sizing: border-box;
            transition: all 0.25s ease;
        }

        .input-group input:focus {
            border-color: #1a94e8;
            background: #fff;
            box-shadow: 0 0 4px rgba(26,148,232,0.4);
            outline: none;
        }

        /* Eye icon (Password toggle) */
        .toggle-password {
            position: absolute;
            right: 15px;   /* far end */
            top: 50%;
            transform: translateY(-50%);
            font-size: 18px;
            cursor: pointer;
            color: #555;
        }

        /* BUTTON */
        button {
            width: 100%;
            padding: 14px;
            border: none;
            border-radius: 12px;
            background: linear-gradient(135deg, #1a94e8, #6b1fc7);
            font-size: 17px;
            font-weight: 600;
            color: #fff;
            cursor: pointer;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        button:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.25);
        }

        /* ERROR ALERT */
        .alert {
            margin-bottom: 20px;
            padding: 13px;
            border-radius: 10px;
            font-weight: 600;
            text-align: left;
        }

        .alert-danger {
            background: #ffe0e0;
            color: #b10000;
            border-left: 5px solid #d00000;
        }

        /* FOOTER SMALL TEXT */
        .footer-note {
            margin-top: 22px;
            color: #666;
            font-size: 14px;
        }
    </style>
</head>

<body>

<div class="login-wrapper">

    <div class="login-title">Telecom System Login</div>

    <!-- Display login error -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger">
            <i class="pi pi-exclamation-triangle"></i> ${error}
        </div>
    </c:if>

    <form action="login" method="post">

        <!-- Username -->
        <div class="input-group">
            <i class="pi pi-user input-icon"></i>
            <input type="text" name="username" placeholder="Enter username" required minlength="3">
        </div>

        <!-- Password -->
        <div class="input-group">
            <i class="pi pi-lock input-icon"></i>
            <input type="password" id="password" name="password" placeholder="Enter password" required minlength="4">
            <i class="pi pi-eye toggle-password" onclick="togglePassword()"></i>
        </div>

        <button type="submit">
            <i class="pi pi-sign-in"></i> Login
        </button>
    </form>

    <div class="footer-note">
        © 2025 Telecom Management System
    </div>
</div>

<script>
    function togglePassword() {
        const pw = document.getElementById("password");
        pw.type = pw.type === "password" ? "text" : "password";
    }
</script>

</body>
</html>
