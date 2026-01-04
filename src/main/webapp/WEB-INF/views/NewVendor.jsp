<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>New Vendor</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container mt-4">

<h2 class="mb-3">Add New Vendor</h2>

<form action="savevendor" method="post" class="border p-4 rounded shadow-sm">
    <div class="mb-3">
        <label for="title" class="form-label">Vendor Name</label>
        <input type="text" id="title" name="title" class="form-control" required>
    </div>

    <!-- FIXED: Removed category dropdown (vendor doesn't have categoryId) -->

    <button type="submit" class="btn btn-success">Save Vendor</button>
    <a href="listvendor" class="btn btn-secondary">Cancel</a>
</form>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>