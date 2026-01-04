<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - SpendWise</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        body {
            background-color: #f8f9fa;
        }
        .sidebar {
            height: 100vh;
            width: 250px;
            position: fixed;
            top: 0;
            left: 0;
            background-color: #343a40;
            padding-top: 20px;
            color: white;
        }
        .sidebar a {
            color: white;
            text-decoration: none;
            display: block;
            padding: 10px;
            margin: 5px 15px;
            border-radius: 5px;
            transition: background 0.3s;
        }
        .sidebar a:hover, .sidebar a.active {
            background-color: #495057;
        }
        .content {
            margin-left: 260px;
            padding: 20px;
        }
        .card {
            border: none;
            border-radius: 10px;
            box-shadow: 0px 5px 15px rgba(0, 0, 0, 0.1);
        }
        .header {
            background: #343a40;
            color: white;
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .header a {
            color: white;
            text-decoration: none;
            padding: 8px 15px;
            background: #dc3545;
            border-radius: 5px;
            transition: background 0.3s;
        }
        .header a:hover {
            background: #c82333;
        }
        footer {
            text-align: center;
            padding: 10px;
            background: #343a40;
            color: white;
            margin-top: 20px;
        }
        @media (max-width: 768px) {
            .sidebar {
                width: 100%;
                height: auto;
                position: relative;
            }
            .content {
                margin-left: 0;
            }
        }
    </style>
</head>
<body>

<!-- Sidebar Navigation -->
<div class="sidebar">
    <h3 class="text-center">SpendWise</h3>
    <a href="#overview" class="active">Overview</a>
    <a href="listusers">User Management</a>
    <a href="#expenses">Expense Management</a>
    <a href="#categories">Category and Vendor Management</a>
    <a href="adminreports">Reports and Analytics</a>
    <a href="#otp">OTP and Email Notifications</a>
    <a href="#settings">Settings and Configuration</a>
    <a href="#security">Security and Logs</a>
</div>

<!-- Main Content -->
<div class="content">
    <!-- Header -->
    <div class="header">
        <h4>Admin Dashboard</h4>
        <a href="logout">Logout</a>
    </div>

    <!-- Dashboard Overview -->
    <div class="container mt-3">
        <div class="row g-4">
            <div class="col-md-4">
                <div class="card p-3 text-center">
                    <h5>Total Users</h5>
                    <!-- FIXED: Now shows actual data from controller -->
                    <h3 class="text-primary"><span id="totalUsers">${totalUsers}</span></h3>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card p-3 text-center">
                    <h5>Total Expenses</h5>
                    <!-- FIXED: Now shows actual data from controller -->
                    <h3 class="text-danger">$<span id="totalExpenses">${totalExpenses}</span></h3>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card p-3 text-center">
                    <h5>Total Accounts</h5>
                    <!-- FIXED: Now shows actual data from controller -->
                    <h3 class="text-success"><span id="totalAccounts">${totalAccounts}</span></h3>
                </div>
            </div>
        </div>
    </div>

    <!-- Sections -->
    <div class="container mt-4">
        <div class="row">
            <div class="col-lg-12">
                <section id="users" class="card p-3 mb-3">
                    <h2>User Management</h2>
                    <p>Manage users: View, Edit, Delete, Block/Unblock.</p>
                    <a href="listusers" class="btn btn-primary">Manage Users</a>
                </section>
                <section id="expenses" class="card p-3 mb-3">
                    <h2>Expense Management</h2>
                    <p>View, filter, and manage all user expenses.</p>
                </section>
                <section id="categories" class="card p-3 mb-3">
                    <h2>Category and Vendor Management</h2>
                    <p>Add, edit, or remove categories and vendors.</p>
                </section>
                <section id="reports" class="card p-3 mb-3">
                    <h2>Reports and Analytics</h2>
                    <p>View expense trends, insights, and generate reports.</p>
                    <a href="adminreports" class="btn btn-primary">View Reports</a>
                </section>
                <section id="otp" class="card p-3 mb-3">
                    <h2>OTP and Email Notifications</h2>
                    <p>Manage OTP requests and email notifications.</p>
                </section>
                <section id="settings" class="card p-3 mb-3">
                    <h2>Settings and Configuration</h2>
                    <p>Modify application settings and user roles.</p>
                </section>
                <section id="security" class="card p-3 mb-3">
                    <h2>Security and Logs</h2>
                    <p>Monitor login attempts and security logs.</p>
                </section>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer>
        <p>&copy; 2025 SpendWise. All rights reserved.</p>
    </footer>
</div>

</body>
</html>