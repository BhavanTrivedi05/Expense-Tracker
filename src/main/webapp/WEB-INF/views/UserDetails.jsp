<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>User Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container mt-4">

    <h2 class="mb-3">User Details</h2>

    <div class="border p-4 rounded shadow-sm bg-light">
        <p><strong>First Name:</strong> <c:out value="${user.firstName}" /></p>
        <p><strong>Last Name:</strong> <c:out value="${user.lastName}" /></p>
        <p><strong>Email:</strong> <c:out value="${user.email}" /></p>
        <p><strong>Role:</strong> <c:out value="${user.role}" /></p>
    </div>

    <br>

    <a href="edituser?userId=${user.userId}" class="btn btn-warning">Edit User</a>
    <a href="deleteuser?userId=${user.userId}" class="btn btn-danger"
       onclick="return confirm('Are you sure you want to delete this user?');">Delete User</a>

    <a href="listusers" class="btn btn-secondary">Back to Users</a>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
