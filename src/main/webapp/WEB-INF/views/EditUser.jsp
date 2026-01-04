<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit User - SpendWise</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #f8f9fa;
        }
        .card {
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            width: 400px;
            background: white;
        }
    </style>
</head>
<body>

    <div class="card">
        <h2 class="text-center">Edit User</h2>
        <form action="edituser" method="post">
            <!-- Hidden User ID -->
            <input type="hidden" name="userId" value="${user.userId}">
            <input type="hidden" name="email" value="${user.email}"> <!-- Ensure email is submitted -->
            
            <div class="mb-3">
                <label class="form-label">First Name</label>
                <input type="text" name="firstName" class="form-control" value="${user.firstName}" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Last Name</label>
                <input type="text" name="lastName" class="form-control" value="${user.lastName}" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Email</label>
                <input type="email" class="form-control" value="${user.email}" readonly>
            </div>
            <div class="mb-3">
                <label class="form-label">Role</label>
                <select name="roleId" class="form-select">
                    <option value="">Select Role</option>
                    <c:forEach var="role" items="${roles}">
                        <option value="${role.roleId}" ${role.roleId == user.roleId ? 'selected' : ''}>
                            ${role.roleName}
                        </option>
                    </c:forEach>
                </select>
            </div>
            <button type="submit" class="btn btn-primary w-100">Update User</button>
        </form>
    </div>

</body>
</html>
