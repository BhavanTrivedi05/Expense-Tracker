<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Account - SpendWise</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .container {
            max-width: 400px;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.2);
            text-align: center;
        }
        h2 {
            color: #003366;
            margin-bottom: 20px;
        }
        .account-info {
            text-align: left;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Account Details</h2>
        <div class="account-info">
            <p><strong>ID:</strong> <c:out value="${account.id}" /></p>
            <p><strong>Title:</strong> <c:out value="${account.title}" /></p>
            <p><strong>Balance:</strong> $<c:out value="${account.balance}" /></p>
        </div>
        <a href="editaccount?accountId=${account.id}" class="btn btn-primary">Edit</a>
        <a href="deleteaccount?accountId=${account.id}" class="btn btn-danger"
           onclick="return confirm('Are you sure you want to delete this account?');">Delete</a>
        <a href="listaccounts" class="btn btn-secondary">Back to Accounts</a>
    </div>
</body>
</html>
