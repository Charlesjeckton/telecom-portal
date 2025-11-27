<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <title>Register Customer</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 400px;
            margin: 50px auto;
            padding: 30px;
            background-color: #ffffff;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        h2 {
            text-align: center;
            color: #333333;
        }
        form {
            display: flex;
            flex-direction: column;
        }
        label {
            margin-bottom: 5px;
            font-weight: bold;
        }
        input[type="text"], 
        input[type="email"], 
        input[type="password"] {
            padding: 8px;
            margin-bottom: 15px;
            border: 1px solid #cccccc;
            border-radius: 5px;
            font-size: 14px;
        }
        button {
            padding: 10px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        button:hover {
            background-color: #45a049;
        }
        .message {
            text-align: center;
            margin-bottom: 15px;
            font-weight: bold;
        }
        .message.success { color: green; }
        .message.error { color: red; }
        a {
            display: block;
            text-align: center;
            margin-top: 15px;
            color: #3333cc;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Register New Customer</h2>

    <!-- Display success/error message -->
    <c:if test="${not empty message}">
        <div class="message ${messageType}">${message}</div>
    </c:if>

    <form action="registerCustomer" method="post">
        <label for="name">Full Name:</label>
        <input type="text" id="name" name="name" placeholder="Enter full name" required>

        <label for="phone">Phone Number:</label>
        <input type="text" id="phone" name="phone" placeholder="Enter phone number" required>

        <label for="email">Email Address:</label>
        <input type="email" id="email" name="email" placeholder="Enter email address" required>

        <label for="username">Username:</label>
        <input type="text" id="username" name="username" placeholder="Choose a username" required>

        <label for="password">Password:</label>
        <input type="password" id="password" name="password" placeholder="Enter password" required>

        <button type="submit">Register</button>
    </form>

    <a href="listCustomers.jsp">View All Customers</a>
</div>

</body>
</html>
