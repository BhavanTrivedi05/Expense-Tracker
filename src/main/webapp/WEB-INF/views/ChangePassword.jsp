<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change Password - SpendWise</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            padding: 20px;
        }
        .container-box {
            max-width: 500px;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.2);
        }
        h2 {
            text-align: center;
            color: #003366;
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .password-container {
            position: relative;
        }
        .password-container input {
            width: 100%;
            padding-right: 40px;
        }
        .password-toggle {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
        }
    </style>
</head>
<body>
    <div class="container-box">
        <h2>Change Password</h2>
        <form action="updatepassword" method="post">
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" class="form-control" id="email" name="email" required>
            </div>
            <div class="form-group">
                <label for="otp">OTP</label>
                <input type="text" class="form-control" id="otp" name="otp" required>
            </div>
            <div class="form-group password-container">
                <label for="password">New Password</label>
                <input type="password" class="form-control" id="password" name="password" required>
                <span class="password-toggle" onclick="togglePassword('password')">👁️</span>
            </div>
            <div class="form-group password-container">
                <label for="confirmPassword">Confirm Password</label>
                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                <span class="password-toggle" onclick="togglePassword('confirmPassword')">👁️</span>
            </div>
            <div class="d-flex justify-content-center gap-3 mt-3">
                <button type="submit" class="btn btn-primary">Update Password</button>
                <button type="reset" class="btn btn-secondary">Reset</button>
            </div>
        </form>
    </div>
    <script>
        function togglePassword(fieldId) {
            var passwordField = document.getElementById(fieldId);
            if (passwordField.type === "password") {
                passwordField.type = "text";
            } else {
                passwordField.type = "password";
            }
        }
    </script>
</body>
</html>