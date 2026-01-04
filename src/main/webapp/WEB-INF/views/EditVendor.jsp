<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Vendor - SpendWise</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
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
    <h2 class="text-center">Edit Vendor</h2>
    <form action="editvendor" method="post">
        <input type="hidden" name="vendorId" value="${vendor.vendorId}">

        <div class="mb-3">
            <label class="form-label">Vendor ID</label>
            <input type="text" class="form-control" value="${vendor.vendorId}" readonly>
        </div>
        <div class="mb-3">
            <label class="form-label">Title</label>
            <input type="text" name="title" class="form-control" value="${vendor.title}" required>
        </div>

        <!-- FIXED: Removed duplicate vendor dropdown -->

        <button type="submit" class="btn btn-primary w-100">Update Vendor</button>
        <a href="listvendor" class="btn btn-secondary w-100 mt-2">Cancel</a>
    </form>
</div>

</body>
</html>