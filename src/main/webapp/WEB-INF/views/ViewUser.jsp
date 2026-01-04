<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View User - SpendWise</title>
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
            max-width: 450px;
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
        .user-info {
            text-align: left;
            margin-bottom: 20px;
        }
        .btn-group {
            display: flex;
            justify-content: space-between;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>User Details</h2>
        <div class="user-info">
            <p><strong>ID:</strong> <c:out value="${user.id}" /></p>
            <p><strong>Name:</strong> <c:out value="${user.firstName}" /> <c:out value="${user.lastName}" /></p>
            <p><strong>Email:</strong> <c:out value="${user.email}" /></p>
            <p><strong>Role:</strong> <c:out value="${user.role}" /></p>
        </div>
        <div class="btn-group">
            <a href="edituser?userId=${user.id}" class="btn btn-primary">Edit</a>
            <a href="deleteuser?userId=${user.id}" class="btn btn-danger"
               onclick="return confirm('Are you sure you want to delete this user?');">Delete</a>
        </div>
        <br>
        <a href="listusers" class="btn btn-secondary">Back to Users</a>
    </div>
</body>
</html>
