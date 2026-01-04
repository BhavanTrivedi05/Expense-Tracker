<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!-- NewVendor.jsp -->
<!DOCTYPE html>
<html>
<head>
    <title>New Vendor</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container mt-4">

    <h2 class="mb-3">Add New Vendor</h2>

    <form action="savevendor" method="post" class="border p-4 rounded shadow-sm mb-4">
        <div class="mb-3">
            <label for="vendorName" class="form-label">Vendor Name</label>
            <input type="text" id="vendorName" name="vendorName" class="form-control" required>
        </div>

        <button type="submit" class="btn btn-success">Save Vendor</button>
        <a href="listvendors" class="btn btn-secondary">Cancel</a>
    </form>

    <h2 class="mb-3">Vendor List</h2>

    <table class="table table-bordered table-striped">
        <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th>Vendor Name</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${allVendors}" var="v">
                <tr>
                    <td>${v.vendorId}</td>
                    <td>${v.vendorName}</td>
                    <td>
                        <a href="editvendor?vendorId=${v.vendorId}" class="btn btn-warning btn-sm">Edit</a>
                        <a href="deletevendor?vendorId=${v.vendorId}" class="btn btn-danger btn-sm"
                           onclick="return confirm('Are you sure you want to delete this vendor?');">Delete</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
