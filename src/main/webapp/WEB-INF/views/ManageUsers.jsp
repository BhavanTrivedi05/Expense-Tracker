<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Users - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        .admin-badge {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
            padding: 5px 15px;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: bold;
        }
        .user-badge {
            background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
            color: white;
            padding: 5px 15px;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: bold;
        }
        .table {
            box-shadow: 0px 0px 15px rgba(0, 0, 0, 0.1);
        }
        .btn-group-custom {
            display: flex;
            gap: 5px;
        }
    </style>
</head>
<body class="container mt-4">

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2><i class="bi bi-people-fill"></i> Manage Users</h2>
    <a href="admindashboard" class="btn btn-secondary">
        <i class="bi bi-arrow-left"></i> Back to Dashboard
    </a>
</div>

<!-- Success/Error Messages -->
<c:if test="${not empty success}">
    <div class="alert alert-success alert-dismissible fade show">
        <i class="bi bi-check-circle"></i> ${success}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>
<c:if test="${not empty error}">
    <div class="alert alert-danger alert-dismissible fade show">
        <i class="bi bi-exclamation-triangle"></i> ${error}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<table class="table table-hover table-striped">
    <thead class="table-dark">
    <tr>
        <th><i class="bi bi-hash"></i> ID</th>
        <th><i class="bi bi-person"></i> Name</th>
        <th><i class="bi bi-envelope"></i> Email</th>
        <th><i class="bi bi-telephone"></i> Contact</th>
        <th><i class="bi bi-shield"></i> Role</th>
        <th><i class="bi bi-gear"></i> Actions</th>
    </tr>
    </thead>
    <tbody>
    <c:choose>
        <c:when test="${not empty userList}">
            <c:forEach var="user" items="${userList}">
                <tr>
                    <td>${user.userId}</td>
                    <td>
                        <strong>${user.firstName} ${user.lastName}</strong>
                        <c:if test="${user.userId == currentAdmin.userId}">
                            <span class="badge bg-info">You</span>
                        </c:if>
                    </td>
                    <td>${user.email}</td>
                    <td>${user.contactNum}</td>
                    <td>
                        <c:choose>
                            <c:when test="${user.role == 'ADMIN'}">
                                        <span class="admin-badge">
                                            <i class="bi bi-shield-fill-check"></i> ADMIN
                                        </span>
                            </c:when>
                            <c:otherwise>
                                        <span class="user-badge">
                                            <i class="bi bi-person-fill"></i> USER
                                        </span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <div class="btn-group-custom">
                            <c:choose>
                                <c:when test="${user.role == 'ADMIN'}">
                                    <c:if test="${user.userId != currentAdmin.userId}">
                                        <a href="${pageContext.request.contextPath}/admin/demoteuser?userId=${user.userId}"
                                           class="btn btn-warning btn-sm"
                                           onclick="return confirm('Demote ${user.firstName} to regular user?');">
                                            <i class="bi bi-arrow-down-circle"></i> Demote
                                        </a>
                                    </c:if>
                                    <c:if test="${user.userId == currentAdmin.userId}">
                                        <span class="text-muted small">Cannot modify yourself</span>
                                    </c:if>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/admin/promoteuser?userId=${user.userId}"
                                       class="btn btn-success btn-sm"
                                       onclick="return confirm('Promote ${user.firstName} to admin? They will have full access.');">
                                        <i class="bi bi-arrow-up-circle"></i> Promote to Admin
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/deleteuser?userId=${user.userId}"
                                       class="btn btn-danger btn-sm"
                                       onclick="return confirm('Delete ${user.firstName}? This cannot be undone!');">
                                        <i class="bi bi-trash"></i> Delete
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </td>
                </tr>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <tr>
                <td colspan="6" class="text-center text-muted">
                    <i class="bi bi-inbox"></i> No users found
                </td>
            </tr>
        </c:otherwise>
    </c:choose>
    </tbody>
</table>

<div class="alert alert-info mt-4">
    <i class="bi bi-info-circle-fill"></i>
    <strong>Admin Management:</strong>
    Promote users to grant admin privileges. Admins can manage categories, vendors, and view all system data.
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
    <c:if test="${not empty success}">
    Swal.fire({
        icon: 'success',
        title: 'Success!',
        text: '${success}',
        toast: true,
        position: 'top-end',
        showConfirmButton: false,
        timer: 3000,
        timerProgressBar: true
    });
    </c:if>

    <c:if test="${not empty error}">
    Swal.fire({
        icon: 'error',
        title: 'Error!',
        text: '${error}',
        toast: true,
        position: 'top-end',
        showConfirmButton: false,
        timer: 3000,
        timerProgressBar: true
    });
    </c:if>
</script>
</body>
</html>