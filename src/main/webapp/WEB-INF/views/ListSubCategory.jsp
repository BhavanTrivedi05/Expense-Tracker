<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Subcategory List</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .container {
            max-width: 900px;
        }
        .table {
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
        }
        .btn {
            margin-right: 5px;
        }
    </style>
</head>
<body class="container mt-4">

    <h2 class="mb-3 text-center">Subcategory List</h2>

    <table class="table table-borderless table-striped">
        <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th>Title</th>
                <th>Category</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${not empty subcategoryList}">
                    <c:forEach var="subcategory" items="${subcategoryList}">
                        <tr>
                            <td>${subcategory.subCategoryId}</td>
                            <td>${subcategory.title}</td>
                            <td>${subcategory.categoryId}</td> 
                            <td>
                                <a href="viewsubcategory?subCategoryId=${subcategory.subCategoryId}" class="btn btn-info btn-sm">View</a>
                                <a href="editsubcategory?subCategoryId=${subcategory.subCategoryId}" class="btn btn-primary btn-sm">Edit</a>
                                <a href="deletesubcategory?subCategoryId=${subcategory.subCategoryId}" class="btn btn-danger btn-sm"
                                   onclick="return confirm('Are you sure you want to delete this subcategory?');">Delete</a>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="4" class="text-center">No subcategories found</td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>

    <div class="text-center">
        <a href="newsubcategory" class="btn btn-success">Add New Subcategory</a>
        <a href="listcategory" class="btn btn-secondary">Back to Categories</a>
        <a href="home" class="btn btn-dark">Back to Dashboard</a>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- SweetAlert2 for Toast Notifications -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

    <!-- Custom Loading Spinner -->
    <style>
        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.7);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 9999;
        }

        .spinner-border-custom {
            width: 5rem;
            height: 5rem;
            border: 0.5rem solid #f3f3f3;
            border-top: 0.5rem solid #3498db;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .btn {
            transition: all 0.3s ease;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }

        .card {
            transition: all 0.3s ease;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0,0,0,0.2);
        }
    </style>

    <!-- Loading Overlay -->
    <div class="loading-overlay" id="loadingOverlay">
        <div class="spinner-border-custom"></div>
    </div>

    <!-- Toast Notification Helper Functions -->
    <script>
        // Show loading spinner
        function showLoading() {
            document.getElementById('loadingOverlay').style.display = 'flex';
        }

        // Hide loading spinner
        function hideLoading() {
            document.getElementById('loadingOverlay').style.display = 'none';
        }

        // Success toast
        function showSuccess(message) {
            Swal.fire({
                icon: 'success',
                title: 'Success!',
                text: message,
                toast: true,
                position: 'top-end',
                showConfirmButton: false,
                timer: 3000,
                timerProgressBar: true
            });
        }

        // Error toast
        function showError(message) {
            Swal.fire({
                icon: 'error',
                title: 'Oops...',
                text: message,
                toast: true,
                position: 'top-end',
                showConfirmButton: false,
                timer: 3000,
                timerProgressBar: true
            });
        }

        // Warning toast
        function showWarning(message) {
            Swal.fire({
                icon: 'warning',
                title: 'Warning',
                text: message,
                toast: true,
                position: 'top-end',
                showConfirmButton: false,
                timer: 3000,
                timerProgressBar: true
            });
        }

        // Show loading on form submit
        document.addEventListener('DOMContentLoaded', function() {
            const forms = document.querySelectorAll('form');
            forms.forEach(form => {
                form.addEventListener('submit', function() {
                    showLoading();
                });
            });
        });
    </script>
</body>
</html>
