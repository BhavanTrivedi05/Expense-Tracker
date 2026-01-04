<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- Profile.jsp -->
<!DOCTYPE html>
<html>
<head>
    <title>User Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container mt-4">

    <div class="card shadow-lg p-4">
        <h2 class="mb-3 text-center">User Profile</h2>

        <ul class="list-group list-group-flush">
            <li class="list-group-item"><strong>First Name:</strong> ${user.firstName}</li>
            <li class="list-group-item"><strong>Last Name:</strong> ${user.lastName}</li>
            <li class="list-group-item"><strong>Email:</strong> ${user.email}</li>
        </ul>

        <div class="mt-3 text-center">
            <a href="editprofile" class="btn btn-primary">Edit Profile</a>
            <a href="dashboard" class="btn btn-secondary">Back to Dashboard</a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
