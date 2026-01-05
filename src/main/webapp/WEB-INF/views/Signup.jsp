<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Signup - SpendWise</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 40px 20px;
        }
        .container-box {
            max-width: 900px;
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0px 10px 40px rgba(0, 0, 0, 0.3);
        }
        .logo {
            text-align: center;
            margin-bottom: 20px;
        }
        .logo i {
            font-size: 3rem;
            color: #667eea;
        }
        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 10px;
            font-weight: 600;
        }
        .subtitle {
            text-align: center;
            color: #666;
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
        .btn-secondary {
            padding: 12px;
            font-weight: 600;
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
        <i class="bi bi-person-plus-fill"></i>
    </div>
    <h2>Create Your Account</h2>
    <p class="subtitle">Join SpendWise and start managing your expenses</p>

    <form action="saveuser" method="post" id="signupForm">
        <div class="row">
            <div class="col-md-6">
                <div class="form-group">
                    <label for="firstName" class="form-label"><i class="bi bi-person"></i> First Name</label>
                    <input type="text" class="form-control" id="firstName" name="firstName" placeholder="John" required>
                </div>
            </div>
            <div class="col-md-6">
                <div class="form-group">
                    <label for="lastName" class="form-label"><i class="bi bi-person"></i> Last Name</label>
                    <input type="text" class="form-control" id="lastName" name="lastName" placeholder="Doe" required>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-6">
                <div class="form-group">
                    <label for="email" class="form-label"><i class="bi bi-envelope"></i> Email</label>
                    <input type="email" class="form-control" id="email" name="email" placeholder="john.doe@example.com" required>
                </div>
            </div>
            <div class="col-md-6">
                <div class="form-group password-container">
                    <label for="password" class="form-label"><i class="bi bi-lock"></i> Password</label>
                    <input type="password" class="form-control" id="password" name="password" placeholder="••••••••" required>
                    <i class="bi bi-eye password-toggle" id="togglePassword" onclick="togglePassword()"></i>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-6">
                <div class="form-group">
                    <label for="contactNum" class="form-label"><i class="bi bi-telephone"></i> Contact Number</label>
                    <input type="tel" class="form-control" id="contactNum" name="contactNum" pattern="[0-9]{10}" placeholder="1234567890" required>
                </div>
            </div>
            <div class="col-md-6">
                <div class="form-group">
                    <label for="dob" class="form-label"><i class="bi bi-calendar"></i> Date of Birth</label>
                    <input type="date" class="form-control" id="dob" name="dob" required>
                </div>
            </div>
        </div>

        <div class="form-group">
            <label class="form-label"><i class="bi bi-gender-ambiguous"></i> Gender</label>
            <div class="d-flex gap-3">
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="gender" value="male" id="male" required>
                    <label class="form-check-label" for="male">Male</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="gender" value="female" id="female">
                    <label class="form-check-label" for="female">Female</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="gender" value="other" id="other">
                    <label class="form-check-label" for="other">Other</label>
                </div>
            </div>
        </div>

        <!-- REMOVED: Role Selection - Users are automatically assigned USER role -->

        <div class="d-flex justify-content-center gap-3 mt-4">
            <button type="submit" class="btn btn-primary px-5">
                <i class="bi bi-check-circle"></i> Sign Up
            </button>
            <button type="reset" class="btn btn-secondary px-5">
                <i class="bi bi-x-circle"></i> Reset
            </button>
        </div>

        <div class="text-center mt-3">
            <p>Already have an account? <a href="login" style="color: #667eea; text-decoration: none; font-weight: 600;">Login here</a></p>
        </div>
    </form>
</div>

<!-- Loading Overlay -->
<div class="loading-overlay" id="loadingOverlay">
    <div class="spinner-border-custom"></div>
</div>

<!-- SweetAlert2 -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
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
    document.getElementById('signupForm').addEventListener('submit', function() {
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