<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Settings - SpendWise</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            display: flex;
            min-height: 100vh;
            background-color: #f8f9fa;
        }
        .sidebar {
            width: 250px;
            background-color: #343a40;
            color: white;
            padding: 20px;
            height: 100vh;
        }
        .sidebar a {
            color: white;
            text-decoration: none;
            display: block;
            padding: 10px;
            margin: 5px 0;
            border-radius: 5px;
        }
        .sidebar a.active, .sidebar a:hover {
            background-color: #495057;
        }
        .dashboard-content {
            flex: 1;
            padding: 20px;
        }
        .card {
            border: none;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body>
    <div class="sidebar">
        <h2>SpendWise</h2>
        <a href="home">Dashboard</a>
        <a href="listaccount">Accounts</a>
        <a href="listvendor">Vendors</a>
        <a href="listcategory">Categories</a>
        <a href="listsubcategory">Subcategories</a>
        <a href="listexpense">Expenses</a>
        <a href="reports">Reports</a>
        <a href="settings" class="active">Settings</a>
    </div>

    <div class="dashboard-content">
        <div class="container">
            <h2 class="mb-4">Settings</h2>

            <!-- Profile Settings -->
            <div class="card p-4 mb-4">
                <h4>Profile Settings</h4>
                <form action="updateProfile" method="post">
                    <div class="mb-3">
                        <label class="form-label">Full Name</label>
                        <input type="text" class="form-control" name="fullName" value="${user.fullName}" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" class="form-control" name="email" value="${user.email}" required>
                    </div>
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                </form>
            </div>

            <!-- Security Settings -->
            <div class="card p-4 mb-4">
                <h4>Security Settings</h4>
                <form action="updatePassword" method="post">
                    <div class="mb-3">
                        <label class="form-label">Current Password</label>
                        <input type="password" class="form-control" name="currentPassword" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">New Password</label>
                        <input type="password" class="form-control" name="newPassword" required>
                    </div>
                    <button type="submit" class="btn btn-danger">Update Password</button>
                </form>
            </div>

            <!-- Notification Preferences -->
            <div class="card p-4">
                <h4>Notification Preferences</h4>
                <form action="updateNotifications" method="post">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" name="emailNotifications" id="emailNotifications" 
                            ${user.emailNotifications ? 'checked' : ''}>
                        <label class="form-check-label" for="emailNotifications">
                            Email Notifications
                        </label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" name="smsNotifications" id="smsNotifications"
                            ${user.smsNotifications ? 'checked' : ''}>
                        <label class="form-check-label" for="smsNotifications">
                            SMS Notifications
                        </label>
                    </div>
                    <button type="submit" class="btn btn-success mt-3">Save Preferences</button>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
