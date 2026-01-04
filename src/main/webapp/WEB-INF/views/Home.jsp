<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SpendWise Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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
            position: fixed;
            top: 0;
            left: 0;
            overflow-y: auto;
        }
        .sidebar a {
            color: white;
            text-decoration: none;
            display: block;
            padding: 10px;
            margin: 5px 0;
            border-radius: 5px;
            transition: background 0.3s ease;
        }
        .sidebar a:hover, .sidebar a.active {
            background-color: #495057;
        }
        .dashboard-content {
            margin-left: 250px;
            flex: 1;
            padding: 20px;
            width: 100%;
        }
        .card {
            border: none;
            border-radius: 10px;
            box-shadow: 0px 5px 15px rgba(0, 0, 0, 0.1);
            transition: transform 0.2s ease-in-out;
        }
        .card:hover {
            transform: scale(1.05);
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
        @media (max-width: 768px) {
            .sidebar {
                width: 100%;
                height: auto;
                position: relative;
            }
            .dashboard-content {
                margin-left: 0;
            }
        }
    </style>
</head>
<body>

    <!-- Sidebar -->
    <div class="sidebar">
        <h2>SpendWise</h2>
        <a href="listaccount">Accounts</a>
        <a href="listvendor">Vendors</a>
        <a href="listcategory">Categories</a>
        <a href="listsubcategory">Subcategories</a>
        <a href="listExpense">Expenses</a>
        <a href="reports">Reports</a>
        <a href="settings">Settings</a>
    </div>

    <!-- Main Content -->
    <div class="dashboard-content">
        <!-- Header -->
        <div class="header">
            <h4>Welcome, <span>${user.firstName}</span></h4>
            <a href="logout">Logout</a>
        </div>

        <!-- Dashboard Stats (Dynamic Data) -->
        <div class="container mt-3">
            <div class="row g-4">
                <c:forEach var="stat" items="${dashboardStats}">
                    <div class="col-md-4">
                        <div class="card p-3 text-center">
                            <h5>${stat.title}</h5>
                            <h3 class="${stat.color}">$<span>${stat.value}</span></h3>
                            <p class="${stat.color}">${stat.status}</p>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

</body>
</html>
