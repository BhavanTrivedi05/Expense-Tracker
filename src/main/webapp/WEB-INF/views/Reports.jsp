<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Expense Reports - SpendWise</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            display: flex;
            min-height: 100vh;
            background-color: #f8f9fa;
        }
        .sidebar {
            width: 250px;
            background: linear-gradient(180deg, #343a40 0%, #212529 100%);
            color: white;
            padding: 20px;
            height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
        }
        .sidebar a {
            color: white;
            text-decoration: none;
            display: block;
            padding: 10px;
            margin: 5px 0;
            border-radius: 5px;
            transition: all 0.3s;
        }
        .sidebar a.active, .sidebar a:hover {
            background: rgba(255, 255, 255, 0.1);
            transform: translateX(5px);
        }
        .sidebar a i {
            margin-right: 10px;
        }
        .dashboard-content {
            margin-left: 250px;
            flex: 1;
            padding: 20px;
        }
        .card {
            border: none;
            box-shadow: 0px 0px 15px rgba(0, 0, 0, 0.1);
            border-radius: 15px;
            margin-bottom: 20px;
            transition: all 0.3s;
        }
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0px 5px 25px rgba(0, 0, 0, 0.15);
        }
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px;
            border-radius: 15px;
            margin-bottom: 25px;
        }
        .stat-card {
            padding: 20px;
            border-radius: 15px;
            color: white;
            position: relative;
            overflow: hidden;
        }
        .stat-card h3 {
            font-size: 2rem;
            font-weight: bold;
        }
        .stat-card i {
            position: absolute;
            right: 20px;
            top: 20px;
            font-size: 3rem;
            opacity: 0.2;
        }
        .chart-container {
            position: relative;
            height: 350px;
            padding: 20px;
        }
        .bg-gradient-danger {
            background: linear-gradient(135deg, #ee0979 0%, #ff6a00 100%);
        }
        .bg-gradient-warning {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }
        .bg-gradient-success {
            background: linear-gradient(135deg, #56ab2f 0%, #a8e063 100%);
        }
        .bg-gradient-info {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }

        /* Export Button Styles */
        .btn-group .btn {
            padding: 12px 24px;
            font-weight: 600;
            transition: all 0.3s;
            border: none;
            color: white;
        }

        .btn-group .btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.3);
        }

        .btn-group .btn-success {
            background: linear-gradient(135deg, #56ab2f 0%, #a8e063 100%);
        }

        .btn-group .btn-danger {
            background: linear-gradient(135deg, #ee0979 0%, #ff6a00 100%);
        }

        .btn-group .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        .btn-group .btn-dark {
            background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
        }
    </style>
</head>
<body>
<!-- Sidebar -->
<div class="sidebar">
    <h2><i class="bi bi-wallet2"></i> SpendWise</h2>
    <hr style="border-color: rgba(255,255,255,0.2);">
    <a href="home"><i class="bi bi-house-door"></i>Dashboard</a>
    <a href="listaccount"><i class="bi bi-bank"></i>Accounts</a>
    <a href="listexpense"><i class="bi bi-receipt"></i>Expenses</a>
    <a href="reports" class="active"><i class="bi bi-graph-up"></i>Reports</a>

    <c:if test="${sessionScope.user.role == 'ADMIN'}">
        <hr style="border-color: rgba(255,255,255,0.2);">
        <small style="color: #aaa; padding-left: 10px;">ADMIN</small>
        <a href="listcategory"><i class="bi bi-tags"></i>Categories</a>
        <a href="listvendor"><i class="bi bi-shop"></i>Vendors</a>
        <a href="admindashboard"><i class="bi bi-speedometer2"></i>Admin Dashboard</a>
    </c:if>
</div>

<!-- Main Content -->
<div class="dashboard-content">
    <div class="container-fluid">

        <!-- Header -->
        <div class="header">
            <h2><i class="bi bi-graph-up-arrow"></i> Expense Reports & Analytics</h2>
            <p class="mb-0">Visualize and analyze your spending patterns</p>
        </div>

        <!-- Export Buttons - UPDATED WITH 4 OPTIONS -->
        <div class="text-end mb-3">
            <div class="btn-group" role="group" aria-label="Export options">
                <a href="exportexpenses" class="btn btn-success" title="Export to Excel">
                    <i class="bi bi-file-earmark-excel-fill"></i> Excel
                </a>
                <a href="exportpdf" class="btn btn-danger" title="Export to PDF">
                    <i class="bi bi-file-earmark-pdf-fill"></i> PDF
                </a>
                <a href="exportcsv" class="btn btn-primary" title="Export to CSV">
                    <i class="bi bi-filetype-csv"></i> CSV
                </a>
                <a href="exportjson" class="btn btn-dark" title="Export to JSON">
                    <i class="bi bi-filetype-json"></i> JSON
                </a>
            </div>
        </div>

        <!-- Summary Cards -->
        <div class="row g-4 mb-4">
            <div class="col-md-3">
                <div class="card stat-card bg-gradient-danger">
                    <i class="bi bi-cash-stack"></i>
                    <h6>Total Expenses</h6>
                    <h3>$<c:out value="${totalExpenses}" default="0.00"/></h3>
                    <p class="mb-0">
                        <small>
                            <c:choose>
                                <c:when test="${fn:contains(expenseChange, '-')}">
                                    <i class="bi bi-arrow-down"></i>
                                </c:when>
                                <c:otherwise>
                                    <i class="bi bi-arrow-up"></i>
                                </c:otherwise>
                            </c:choose>
                            <c:out value="${expenseChange}" default="0"/>% vs last month
                        </small>
                    </p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card bg-gradient-warning">
                    <i class="bi bi-tag"></i>
                    <h6>Top Category</h6>
                    <h3><c:out value="${topCategory}" default="N/A"/></h3>
                    <p class="mb-0"><small><c:out value="${categoryPercentage}" default="0"/>% of total</small></p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card bg-gradient-success">
                    <i class="bi bi-wallet"></i>
                    <h6>Remaining Budget</h6>
                    <h3>$<c:out value="${remainingBudget}" default="0.00"/></h3>
                    <p class="mb-0"><small>Budget tracking coming soon</small></p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card bg-gradient-info">
                    <i class="bi bi-receipt"></i>
                    <h6>Total Transactions</h6>
                    <h3><c:out value="${not empty expenseList ? expenseList.size() : 0}"/></h3>
                    <p class="mb-0"><small>Recorded expenses</small></p>
                </div>
            </div>
        </div>

        <!-- Message -->
        <c:if test="${not empty message}">
            <div class="alert alert-success alert-dismissible fade show">
                <i class="bi bi-check-circle"></i> ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- No Data Message -->
        <c:if test="${empty expenseList}">
            <div class="alert alert-warning">
                <i class="bi bi-exclamation-triangle"></i>
                <strong>No expense data found.</strong> Start tracking your expenses to see analytics here.
                <a href="newexpense" class="btn btn-sm btn-primary ms-3">
                    <i class="bi bi-plus"></i> Add Expense
                </a>
            </div>
        </c:if>

        <!-- Charts Grid -->
        <c:if test="${not empty expenseList}">
            <div class="row g-4">
                <!-- Chart 1: Category Breakdown -->
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-body">
                            <h5><i class="bi bi-pie-chart-fill"></i> Spending by Category</h5>
                            <div class="chart-container">
                                <canvas id="categoryChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Chart 2: Monthly Trend -->
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-body">
                            <h5><i class="bi bi-graph-up"></i> 6-Month Spending Trend</h5>
                            <div class="chart-container">
                                <canvas id="monthlyTrendChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Chart 3: Top 5 Expenses -->
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-body">
                            <h5><i class="bi bi-bar-chart-fill"></i> Top 5 Highest Expenses</h5>
                            <div class="chart-container">
                                <canvas id="topExpensesChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Chart 4: Weekly Comparison -->
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-body">
                            <h5><i class="bi bi-calendar-week"></i> Last 4 Weeks Comparison</h5>
                            <div class="chart-container">
                                <canvas id="weeklyChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Expense Table -->
            <div class="card mt-4">
                <div class="card-body">
                    <h5><i class="bi bi-table"></i> Detailed Expense List</h5>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="table-light">
                            <tr>
                                <th>Date</th>
                                <th>Title</th>
                                <th>Category</th>
                                <th>Amount</th>
                                <th>Status</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${not empty expenseList}">
                                    <c:forEach var="expense" items="${expenseList}" end="9" varStatus="loop">
                                        <tr>
                                            <td><c:out value="${expense.transcationDate}"/></td>
                                            <td><c:out value="${expense.title}"/></td>
                                            <td><span class="badge bg-info">Category ${expense.categoryId}</span></td>
                                            <td class="fw-bold text-danger">$${expense.amount}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${expense.status}">
                                                        <span class="badge bg-success">Active</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">Inactive</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="5" class="text-center text-muted">
                                            <i class="bi bi-inbox"></i> No expenses to display
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <!-- Show View All button if more than 10 -->
                    <c:set var="listSize" value="${not empty expenseList ? expenseList.size() : 0}"/>
                    <c:if test="${listSize > 10}">
                        <div class="text-center mt-3">
                            <a href="listexpense" class="btn btn-outline-primary">
                                <i class="bi bi-list-ul"></i> View All ${listSize} Expenses
                            </a>
                        </div>
                    </c:if>
                </div>
            </div>
        </c:if>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
    // Chart 1: Category Pie Chart
    const categoryCtx = document.getElementById('categoryChart');
    if (categoryCtx) {
        const categoryLabels = [
            <c:forEach var="label" items="${categoryLabels}" varStatus="status">
            '${fn:escapeXml(label)}'<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];

        const categoryData = [
            <c:forEach var="data" items="${categoryData}" varStatus="status">
            ${data}<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];

        if (categoryData.length > 0) {
            new Chart(categoryCtx, {
                type: 'pie',
                data: {
                    labels: categoryLabels,
                    datasets: [{
                        data: categoryData,
                        backgroundColor: [
                            '#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0',
                            '#9966FF', '#FF9F40', '#FF6384', '#C9CBCF'
                        ],
                        borderWidth: 2,
                        borderColor: '#fff'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'right',
                            labels: {
                                padding: 15,
                                font: {
                                    size: 12
                                }
                            }
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    let value = context.parsed;
                                    let total = context.dataset.data.reduce((a, b) => a + b, 0);
                                    let percentage = total > 0 ? ((value / total) * 100).toFixed(1) : 0;
                                    return context.label + ': $' + value.toFixed(2) + ' (' + percentage + '%)';
                                }
                            }
                        }
                    }
                }
            });
        }
    }

    // Chart 2: Monthly Trend Line
    const monthlyCtx = document.getElementById('monthlyTrendChart');
    if (monthlyCtx) {
        const monthlyLabels = [
            <c:forEach var="label" items="${monthlyLabels}" varStatus="status">
            '${fn:escapeXml(label)}'<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];

        const monthlyData = [
            <c:forEach var="data" items="${monthlyData}" varStatus="status">
            ${data}<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];

        new Chart(monthlyCtx, {
            type: 'line',
            data: {
                labels: monthlyLabels,
                datasets: [{
                    label: 'Monthly Spending',
                    data: monthlyData,
                    borderColor: '#667eea',
                    backgroundColor: 'rgba(102, 126, 234, 0.1)',
                    tension: 0.4,
                    fill: true,
                    pointRadius: 5,
                    pointHoverRadius: 7,
                    pointBackgroundColor: '#667eea',
                    pointBorderColor: '#fff',
                    pointBorderWidth: 2
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: true,
                        position: 'top'
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return 'Spent: $' + context.parsed.y.toFixed(2);
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return '$' + value;
                            }
                        }
                    }
                }
            }
        });
    }

    // Chart 3: Top 5 Expenses Bar Chart
    const topExpensesCtx = document.getElementById('topExpensesChart');
    if (topExpensesCtx) {
        const topExpenseLabels = [
            <c:forEach var="label" items="${topExpenseLabels}" varStatus="status">
            '${fn:escapeXml(label)}'<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];

        const topExpenseData = [
            <c:forEach var="data" items="${topExpenseData}" varStatus="status">
            ${data}<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];

        new Chart(topExpensesCtx, {
            type: 'bar',
            data: {
                labels: topExpenseLabels,
                datasets: [{
                    label: 'Amount ($)',
                    data: topExpenseData,
                    backgroundColor: [
                        'rgba(255, 99, 132, 0.7)',
                        'rgba(54, 162, 235, 0.7)',
                        'rgba(255, 206, 86, 0.7)',
                        'rgba(75, 192, 192, 0.7)',
                        'rgba(153, 102, 255, 0.7)'
                    ],
                    borderColor: [
                        'rgba(255, 99, 132, 1)',
                        'rgba(54, 162, 235, 1)',
                        'rgba(255, 206, 86, 1)',
                        'rgba(75, 192, 192, 1)',
                        'rgba(153, 102, 255, 1)'
                    ],
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                indexAxis: 'y',
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return 'Amount: $' + context.parsed.x.toFixed(2);
                            }
                        }
                    }
                },
                scales: {
                    x: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return '$' + value;
                            }
                        }
                    }
                }
            }
        });
    }

    // Chart 4: Weekly Spending Bar Chart
    const weeklyCtx = document.getElementById('weeklyChart');
    if (weeklyCtx) {
        const weeklyLabels = [
            <c:forEach var="label" items="${weeklyLabels}" varStatus="status">
            '${fn:escapeXml(label)}'<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];

        const weeklyData = [
            <c:forEach var="data" items="${weeklyData}" varStatus="status">
            ${data}<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];

        new Chart(weeklyCtx, {
            type: 'bar',
            data: {
                labels: weeklyLabels,
                datasets: [{
                    label: 'Weekly Spending ($)',
                    data: weeklyData,
                    backgroundColor: 'rgba(102, 126, 234, 0.7)',
                    borderColor: 'rgba(102, 126, 234, 1)',
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: true,
                        position: 'top'
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return 'Spent: $' + context.parsed.y.toFixed(2);
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return '$' + value;
                            }
                        }
                    }
                }
            }
        });
    }

    // Success/Error Messages
    <c:if test="${not empty success}">
    Swal.fire({
        icon: 'success',
        title: 'Success!',
        text: '${success}',
        toast: true,
        position: 'top-end',
        showConfirmButton: false,
        timer: 3000,
        timerProgressBar: true
    });
    </c:if>

    <c:if test="${not empty error}">
    Swal.fire({
        icon: 'error',
        title: 'Error!',
        text: '${error}',
        toast: true,
        position: 'top-end',
        showConfirmButton: false,
        timer: 3000,
        timerProgressBar: true
    });
    </c:if>
</script>

</body>
</html>