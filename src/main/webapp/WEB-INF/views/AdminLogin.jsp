<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Portal - SpendWise</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 50%, #7e22ce 100%);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            padding: 20px;
        }
        .container-box {
            max-width: 450px;
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0px 10px 50px rgba(0, 0, 0, 0.5);
            border: 3px solid #dc3545;
        }
        .admin-badge {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
            padding: 8px 20px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: bold;
            display: inline-block;
            margin-bottom: 20px;
            animation: glow 2s infinite;
        }
        @keyframes glow {
            0%, 100% { box-shadow: 0 0 10px rgba(220, 53, 69, 0.5); }
            50% { box-shadow: 0 0 20px rgba(220, 53, 69, 0.8); }
        }
        .logo {
            text-align: center;
            margin-bottom: 20px;
        }
        .logo i {
            font-size: 4rem;
            color: #dc3545;
            animation: pulse 2s infinite;
        }
        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.1); }
        }
        h3 {
            text-align: center;
            color: #333;
            margin-bottom: 10px;
            font-weight: 700;
        }
        .subtitle {
            text-align: center;
            color: #dc3545;
            margin-bottom: 30px;
            font-weight: 600;
        }
        .alert-warning {
            background: #fff3cd;
            border-color: #ffc107;
            color: #856404;
            font-size: 0.9rem;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #ffc107;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-label {
            font-weight: 600;
            color: #555;
        }
        .form-control {
            padding: 12px;
            border-radius: 8px;
            border: 2px solid #ddd;
            transition: all 0.3s;
        }
        .form-control:focus {
            border-color: #dc3545;
            box-shadow: 0 0 0 0.2rem rgba(220, 53, 69, 0.25);
        }
        .password-container {
            position: relative;
        }
        .password-container input {
            width: 100%;
            padding-right: 45px;
        }
        .password-toggle {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #dc3545;
            font-size: 1.2rem;
        }
        .btn-danger {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            border: none;
            padding: 14px;
            font-weight: 700;
            transition: all 0.3s;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .btn-danger:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(220, 53, 69, 0.5);
        }
        .links {
            text-align: center;
            margin-top: 20px;
        }
        .links a {
            color: #dc3545;
            text-decoration: none;
            font-weight: 600;
        }
        .links a:hover {
            text-decoration: underline;
        }
        .info-box {
            background: #e7f3ff;
            border-left: 4px solid #0d6efd;
            padding: 10px 15px;
            margin-top: 20px;
            border-radius: 5px;
            font-size: 0.85rem;
        }

        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.8);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 9999;
        }

        .spinner-border-custom {
            width: 5rem;
            height: 5rem;
            border: 0.5rem solid #f3f3f3;
            border-top: 0.5rem solid #dc3545;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
<div class="container-box">
    <div class="text-center">
            <span class="admin-badge">
                <i class="bi bi-shield-lock-fill"></i> ADMIN ACCESS ONLY
            </span>
    </div>

    <div class="logo">
        <i class="bi bi-shield-fill-check"></i>
    </div>

    <h3>Admin Portal</h3>
    <p class="subtitle">Authorized Personnel Only</p>

    <div class="alert-warning">
        <i class="bi bi-exclamation-triangle-fill"></i>
        <strong>Security Notice:</strong> This area is restricted to administrators only. All access attempts are monitored and logged.
    </div>

    <form action="${pageContext.request.contextPath}/admin/authenticate" method="post" id="adminLoginForm">
        <div class="form-group">
            <label for="email" class="form-label">
                <i class="bi bi-person-badge-fill"></i> Admin Email
            </label>
            <input type="email" class="form-control" id="email" name="email"
                   placeholder="admin@spendwise.com" required>
        </div>

        <div class="form-group password-container">
            <label for="password" class="form-label">
                <i class="bi bi-key-fill"></i> Password
            </label>
            <input type="password" class="form-control" id="password" name="password"
                   placeholder="Enter admin password" required>
            <i class="bi bi-eye password-toggle" id="togglePassword" onclick="togglePassword()"></i>
        </div>

        <div class="form-group password-container">
            <label for="adminKey" class="form-label">
                <i class="bi bi-shield-lock-fill"></i> Admin Secret Key
            </label>
            <input type="password" class="form-control" id="adminKey" name="adminKey"
                   placeholder="Enter secret access key" required>
            <i class="bi bi-eye password-toggle" id="toggleAdminKey" onclick="toggleAdminKey()" style="top: 65%;"></i>
        </div>

        <button type="submit" class="btn btn-danger w-100">
            <i class="bi bi-shield-check"></i> Secure Admin Login
        </button>
    </form>

    <div class="info-box">
        <i class="bi bi-info-circle-fill"></i>
        <strong>First time?</strong> The first registered user automatically becomes admin. Check server console for credentials.
    </div>

    <div class="links">
        <a href="${pageContext.request.contextPath}/login">
            <i class="bi bi-arrow-left-circle"></i> Back to User Login
        </a>
    </div>
</div>

<div class="loading-overlay" id="loadingOverlay">
    <div class="spinner-border-custom"></div>
</div>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
    <c:if test="${not empty error}">
    Swal.fire({
        icon: 'error',
        title: 'Access Denied',
        text: '${error}',
        confirmButtonColor: '#dc3545'
    });
    </c:if>

    function togglePassword() {
        const field = document.getElementById('password');
        const icon = document.getElementById('togglePassword');
        if (field.type === 'password') {
            field.type = 'text';
            icon.classList.replace('bi-eye', 'bi-eye-slash');
        } else {
            field.type = 'password';
            icon.classList.replace('bi-eye-slash', 'bi-eye');
        }
    }

    function toggleAdminKey() {
        const field = document.getElementById('adminKey');
        const icon = document.getElementById('toggleAdminKey');
        if (field.type === 'password') {
            field.type = 'text';
            icon.classList.replace('bi-eye', 'bi-eye-slash');
        } else {
            field.type = 'password';
            icon.classList.replace('bi-eye-slash', 'bi-eye');
        }
    }

    document.getElementById('adminLoginForm').addEventListener('submit', function() {
        document.getElementById('loadingOverlay').style.display = 'flex';
    });

    window.addEventListener('load', function() {
        document.getElementById('loadingOverlay').style.display = 'none';
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>