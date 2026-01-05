<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>New Expense</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container mt-4">

<h2 class="mb-3">Add New Expense</h2>

<form action="saveexpense" method="post" class="border p-4 rounded shadow-sm">
    <div class="mb-3">
        <label for="title" class="form-label">Expense Title</label>
        <input type="text" id="title" name="title" class="form-control" required>
    </div>

    <div class="mb-3">
        <label for="amount" class="form-label">Amount ($)</label>
        <input type="number" id="amount" name="amount" step="0.01" class="form-control" required>
    </div>

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

    <div class="mb-3">
        <label for="subcategoryId" class="form-label">Subcategory</label>
        <select id="subcategoryId" name="subcategoryId" class="form-select">
            <option value="">Select Subcategory (Optional)</option>
            <!-- FIXED: Now populated from controller -->
            <c:forEach items="${allSubCategories}" var="sc">
                <option value="${sc.subCategoryId}">${sc.title}</option>
            </c:forEach>
        </select>
    </div>

    <div class="mb-3">
        <label for="vendorId" class="form-label">Vendor</label>
        <select id="vendorId" name="vendorId" class="form-select">
            <option value="">Select Vendor (Optional)</option>
            <!-- FIXED: Now populated from controller -->
            <c:forEach items="${allVendors}" var="v">
                <option value="${v.vendorId}">${v.title}</option>
            </c:forEach>
        </select>
    </div>

    <div class="mb-3">
        <label for="accountId" class="form-label">Account</label>
        <select id="accountId" name="accountId" class="form-select" required>
            <option value="">Select Account</option>
            <!-- FIXED: Now populated from controller -->
            <c:forEach items="${allAccounts}" var="a">
                <option value="${a.accountId}">${a.title}</option>
            </c:forEach>
        </select>
    </div>

    <div class="mb-3">
        <label for="transcationDate" class="form-label">Transaction Date</label>
        <input type="datetime-local" id="transcationDate" name="transcationDate" class="form-control">
    </div>

    <div class="mb-3">
        <label for="description" class="form-label">Description</label>
        <textarea id="description" name="description" class="form-control" rows="3"></textarea>
    </div>

    <button type="submit" class="btn btn-success">Save Expense</button>
    <a href="listexpense" class="btn btn-secondary">Cancel</a>
</form>

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