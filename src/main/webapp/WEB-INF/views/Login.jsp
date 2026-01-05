<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - SpendWise</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
            box-shadow: 0px 10px 40px rgba(0, 0, 0, 0.3);
        }
        .logo {
            text-align: center;
            margin-bottom: 30px;
        }
        .logo i {
            font-size: 4rem;
            color: #667eea;
        }
        h3 {
            text-align: center;
            color: #333;
            margin-bottom: 10px;
            font-weight: 600;
        }
        .text-muted {
            text-align: center;
            margin-bottom: 30px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-label {
            font-weight: 500;
            color: #555;
        }
        .form-control {
            padding: 12px;
            border-radius: 8px;
            border: 1px solid #ddd;
            transition: all 0.3s;
        }
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
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
            color: #667eea;
            font-size: 1.2rem;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 12px;
            font-weight: 600;
            transition: all 0.3s;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        .links {
            text-align: center;
            margin-top: 20px;
        }
        .links a {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
        }
        .links a:hover {
            text-decoration: underline;
        }

        /* Loading Overlay */
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
            border-top: 0.5rem solid #667eea;
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
    <div class="logo">
        <i class="bi bi-wallet2"></i>
    </div>
    <h3>Welcome to SpendWise</h3>
    <p class="text-muted">Track your expenses efficiently</p>

    <form action="authenticate" method="post" id="loginForm">
        <div class="form-group">
            <label for="email" class="form-label"><i class="bi bi-envelope"></i> Email</label>
            <input type="email" class="form-control" id="email" name="email" placeholder="Enter your email" required>
        </div>
        <div class="form-group password-container">
            <label for="password" class="form-label"><i class="bi bi-lock"></i> Password</label>
            <input type="password" class="form-control" id="password" name="password" placeholder="Enter your password" required>
            <i class="bi bi-eye password-toggle" id="togglePassword" onclick="togglePassword()"></i>
        </div>
        <div class="mb-3 form-check">
            <input type="checkbox" id="remember" name="remember" class="form-check-input">
            <label for="remember" class="form-check-label">Remember Me</label>
        </div>
        <button type="submit" class="btn btn-primary w-100">
            <i class="bi bi-box-arrow-in-right"></i> Login
        </button>
    </form>

    <div class="links">
        <a href="forgetpassword"><i class="bi bi-question-circle"></i> Forgot Password?</a> |
        <a href="signup"><i class="bi bi-person-plus"></i> Sign Up</a>
    </div>
</div>

<!-- Loading Overlay -->
<div class="loading-overlay" id="loadingOverlay">
    <div class="spinner-border-custom"></div>
</div>

<!-- SweetAlert2 -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
    // Show error if present
    <c:if test="${not empty error}">
    Swal.fire({
        icon: 'error',
        title: 'Login Failed',
        text: '${error}',
        confirmButtonColor: '#667eea'
    });
    </c:if>

    // Show success if present
    <c:if test="${not empty success}">
    Swal.fire({
        icon: 'success',
        title: 'Success!',
        text: '${success}',
        confirmButtonColor: '#667eea'
    });
    </c:if>

    // Toggle password visibility
    function togglePassword() {
        const passwordField = document.getElementById('password');
        const toggleIcon = document.getElementById('togglePassword');

        if (passwordField.type === 'password') {
            passwordField.type = 'text';
            toggleIcon.classList.remove('bi-eye');
            toggleIcon.classList.add('bi-eye-slash');
        } else {
            passwordField.type = 'password';
            toggleIcon.classList.remove('bi-eye-slash');
            toggleIcon.classList.add('bi-eye');
        }
    }

    // Show loading on form submit
    document.getElementById('loginForm').addEventListener('submit', function() {
        document.getElementById('loadingOverlay').style.display = 'flex';
    });

    // Hide loading on page load
    window.addEventListener('load', function() {
        document.getElementById('loadingOverlay').style.display = 'none';
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>