<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Expense Reports - SpendWise</title>
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
        <a href="reports" class="active">Reports</a>
        <a href="settings">Settings</a>
    </div>

    <div class="dashboard-content">
        <div class="container">
            <h2 class="mb-4">Expense Reports</h2>

            <!-- Monthly Summary -->
            <div class="row">
                <div class="col-md-4">
                    <div class="card p-3">
                        <h5>Total Expenses (This Month)</h5>
                        <h3>$${totalExpenses}</h3>
                        <p class="text-danger">${expenseChange}% increase</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card p-3">
                        <h5>Top Spending Category</h5>
                        <h3>${topCategory}</h3>
                        <p class="text-warning">${categoryPercentage}% of total expenses</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card p-3">
                        <h5>Remaining Budget</h5>
                        <h3>$${remainingBudget}</h3>
                        <p class="text-success">On Track</p>
                    </div>
                </div>
            </div>

            <!-- Expense Table -->
            <div class="mt-4">
                <h4>Recent Transactions</h4>
                <table class="table table-striped">
                    <thead class="table-dark">
                        <tr>
                            <th>Date</th>
                            <th>Category</th>
                            <th>Vendor</th>
                            <th>Amount</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="expense" items="${expenseList}">
                            <tr>
                                <td>${expense.transactionDate}</td>
                                <td>${expense.category.title}</td>
                                <td>${expense.vendor.title}</td>
                                <td>$${expense.amount}</td>
                                <td class="${expense.status == 'Pending' ? 'text-warning' : 'text-success'}">
                                    ${expense.status}
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- Expense Graph (Future Implementation) -->
            <div class="mt-4">
                <h4>Expense Trends (Coming Soon)</h4>
                <p>Visual representation of your spending trends will be added here.</p>
            </div>
        </div>
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
