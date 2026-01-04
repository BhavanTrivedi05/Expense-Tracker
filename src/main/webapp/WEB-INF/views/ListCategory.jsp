<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Category List</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .container {
            max-width: 800px;
        }
        .table {
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
        }
        .btn {
            margin: 5px 3px;
        }
    </style>
</head>
<body class="container mt-4">

<h2 class="mb-3 text-center">Category List</h2>

<!-- FIXED: Success/Error messages -->
<c:if test="${not empty success}">
    <div class="alert alert-success">${success}</div>
</c:if>
<c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
</c:if>

<table class="table table-bordered table-hover">
    <thead class="table-dark text-center">
    <tr>
        <th>ID</th>
        <th>Title</th>
        <th>Actions</th>
    </tr>
    </thead>
    <tbody>
    <!-- FIXED: Correct attribute name (was categorylist) -->
    <c:choose>
        <c:when test="${not empty categoryList}">
            <c:forEach var="cat" items="${categoryList}">
                <tr class="text-center">
                    <td>${cat.categoryId}</td>
                    <td>${cat.title}</td>
                    <td>
                        <a href="viewcategory?categoryId=${cat.categoryId}" class="btn btn-info btn-sm">View</a>
                        <a href="editcategory?categoryId=${cat.categoryId}" class="btn btn-primary btn-sm">Edit</a>
                        <a href="deletecategory?categoryId=${cat.categoryId}" class="btn btn-danger btn-sm"
                           onclick="return confirm('Are you sure you want to delete this category?');">Delete</a>
                    </td>
                </tr>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <tr>
                <td colspan="3" class="text-center text-muted">No categories found</td>
            </tr>
        </c:otherwise>
    </c:choose>
    </tbody>
</table>

<div class="text-center mt-3">
    <a href="newcategory" class="btn btn-success">Add New Category</a>
    <a href="home" class="btn btn-secondary">Back to Dashboard</a>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>