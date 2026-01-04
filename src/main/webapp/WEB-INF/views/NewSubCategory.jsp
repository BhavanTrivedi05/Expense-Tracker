<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>New Subcategory</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container mt-4">

<h2 class="mb-3">Add New Subcategory</h2>

<form action="savesubcategory" method="post" class="border p-4 rounded shadow-sm">
    <div class="mb-3">
        <label for="title" class="form-label">Subcategory Title</label>
        <input type="text" id="title" name="title" class="form-control" required></div>

    <div class="mb-3">
        <label for="categoryId" class="form-label">Category</label>
        <select id="categoryId" name="categoryId" class="form-select" required>
            <option value="">Select Category</option>
            <!-- FIXED: Now populated from controller -->
            <c:forEach items="${allCategories}" var="c">
                <option value="${c.categoryId}">${c.title}</option>
            </c:forEach>
        </select>
    </div>

    <button type="submit" class="btn btn-success">Save Subcategory</button>
    <a href="listsubcategory" class="btn btn-secondary">Cancel</a>
</form>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>