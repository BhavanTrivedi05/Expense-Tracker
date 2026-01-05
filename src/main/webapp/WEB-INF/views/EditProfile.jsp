<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile - SpendWise</title>
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
    <script>
        function validatePasswords() {
            let password = document.getElementById("password").value;
            let confirmPassword = document.getElementById("confirmPassword").value;
            
            if (password !== "" && password !== confirmPassword) {
                alert("Passwords do not match!");
                return false;
            }
            return true;
        }
    </script>
</head>
<body>

    <div class="card">
        <h2 class="text-center">Edit Profile</h2>
        <form action="editprofile" method="post" onsubmit="return validatePasswords()">
            <input type="hidden" name="userId" value="${user.userId}">
            
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
                <input type="email" name="email" class="form-control" value="${user.email}" readonly>
            </div>

            <div class="mb-3">
                <label class="form-label">Role</label>
                <select name="roleId" class="form-select" required>
                    <option value="">Select Role</option>
                    <c:forEach var="role" items="${roles}">
                        <option value="${role.roleId}" ${role.roleId == user.roleId ? 'selected' : ''}>
                            ${role.roleName}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="mb-3">
                <label class="form-label">New Password (optional)</label>
                <input type="password" id="password" name="password" class="form-control" placeholder="New Password">
            </div>
            <div class="mb-3">
                <label class="form-label">Confirm Password</label>
                <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" placeholder="Confirm Password">
            </div>

            <button type="submit" class="btn btn-primary w-100">Update Profile</button>
        </form>
    </div>
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
