<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SpendWise Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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
            overflow-y: auto;
        }
        .sidebar h2 {
            font-size: 1.5rem;
            margin-bottom: 10px;
        }
        .sidebar a {
            color: white;
            text-decoration: none;
            display: block;
            padding: 12px;
            margin: 5px 0;
            border-radius: 8px;
            transition: all 0.3s ease;
        }
        .sidebar a:hover, .sidebar a.active {
            background: rgba(255, 255, 255, 0.1);
            transform: translateX(5px);
        }
        .sidebar a i {
            margin-right: 10px;
            width: 20px;
        }
        .dashboard-content {
            margin-left: 250px;
            flex: 1;
            padding: 20px;
            width: 100%;
        }
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0px 5px 15px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
        }
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0px 10px 25px rgba(0, 0, 0, 0.15);
        }
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px;
            border-radius: 15px;
            margin-bottom: 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .header a {
            color: white;
            text-decoration: none;
            padding: 10px 20px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 8px;
            transition: all 0.3s;
            backdrop-filter: blur(10px);
        }
        .header a:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: scale(1.05);
        }
        .stat-card {
            padding: 25px;
            border-radius: 15px;
            color: white;
            height: 100%;
            position: relative;
            overflow: hidden;
        }
        .stat-card::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            animation: rotate 20s linear infinite;
        }
        @keyframes rotate {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        .stat-card h3 {
            font-size: 2.5rem;
            font-weight: bold;
            margin: 10px 0;
        }
        .stat-card small {
            opacity: 0.9;
        }
        .stat-card i {
            font-size: 3rem;
            opacity: 0.2;
            position: absolute;
            right: 20px;
            top: 20px;
        }
        .bg-gradient-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .bg-gradient-success {
            background: linear-gradient(135deg, #56ab2f 0%, #a8e063 100%);
        }
        .bg-gradient-danger {
            background: linear-gradient(135deg, #ee0979 0%, #ff6a00 100%);
        }
        .bg-gradient-warning {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }
        .chart-card {
            padding: 20px;
            height: 300px;
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
    <h2><i class="bi bi-wallet2"></i> SpendWise</h2>
    <hr style="border-color: rgba(255,255,255,0.3);">

    <a href="home" class="active"><i class="bi bi-house-door-fill"></i>Dashboard</a>
    <a href="listaccount"><i class="bi bi-bank"></i>My Accounts</a>
    <a href="listexpense"><i class="bi bi-receipt"></i>My Expenses</a>
    <a href="reports"><i class="bi bi-graph-up"></i>Reports</a>

    <!-- ADMIN ONLY SECTION -->
    <c:if test="${user.role == 'ADMIN'}">
        <hr style="border-color: rgba(255,255,255,0.3); margin-top: 20px;">
        <small style="color: #aaa; padding-left: 10px; font-weight: 600;">
            <i class="bi bi-shield-fill-check"></i> ADMIN ZONE
        </small>
        <a href="listcategory"><i class="bi bi-tags-fill"></i>Categories</a>
        <a href="listsubcategory"><i class="bi bi-tag-fill"></i>Subcategories</a>
        <a href="listvendor"><i class="bi bi-shop"></i>Vendors</a>
        <a href="${pageContext.request.contextPath}/admin/listusers"><i class="bi bi-people-fill"></i>Manage Users</a>
        <a href="admindashboard"><i class="bi bi-speedometer2"></i>Admin Dashboard</a>
    </c:if>

    <hr style="border-color: rgba(255,255,255,0.3); margin-top: 20px;">
    <a href="settings"><i class="bi bi-gear-fill"></i>Settings</a>
</div>

<!-- Main Content -->
<div class="dashboard-content">
    <!-- Header -->
    <div class="header">
        <div>
            <h4>
                <i class="bi bi-person-circle"></i> Welcome back, <span>${user.firstName}</span>
                <c:if test="${user.role == 'ADMIN'}">
                    <span class="badge bg-danger ms-2">ADMIN</span>
                </c:if>
            </h4>
            <small>Track and manage your expenses efficiently</small>
        </div>
        <a href="logout"><i class="bi bi-box-arrow-right"></i> Logout</a>
    </div>

    <!-- Dashboard Stats -->
    <div class="container-fluid">
        <div class="row g-4">
            <c:choose>
                <c:when test="${not empty dashboardStats}">
                    <c:forEach var="stat" items="${dashboardStats}">
                        <div class="col-md-4">
                            <div class="card stat-card ${stat.color}">
                                <i class="bi bi-wallet2"></i>
                                <h6>${stat.title}</h6>
                                <h3>$${stat.value}</h3>
                                <small><i class="bi bi-graph-up"></i> ${stat.status}</small>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="col-md-4">
                        <div class="card stat-card bg-gradient-primary">
                            <i class="bi bi-wallet-fill"></i>
                            <h6>Total Balance</h6>
                            <h3>$0.00</h3>
                            <small><i class="bi bi-bank"></i> Across all accounts</small>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="card stat-card bg-gradient-danger">
                            <i class="bi bi-receipt-cutoff"></i>
                            <h6>Total Expenses</h6>
                            <h3>$0.00</h3>
                            <small><i class="bi bi-calendar"></i> 0 transactions</small>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="card stat-card bg-gradient-success">
                            <i class="bi bi-graph-up-arrow"></i>
                            <h6>Remaining</h6>
                            <h3>$0.00</h3>
                            <small><i class="bi bi-check-circle"></i> On track</small>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Charts Row -->
        <div class="row mt-4 g-4">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-body chart-card">
                        <h5><i class="bi bi-pie-chart-fill"></i> Spending by Category</h5>
                        <canvas id="categoryChart"></canvas>
                    </div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="card">
                    <div class="card-body chart-card">
                        <h5><i class="bi bi-graph-up"></i> Last 7 Days Trend</h5>
                        <canvas id="trendChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="row mt-4">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-body">
                        <h5><i class="bi bi-lightning-fill"></i> Quick Actions</h5>
                        <div class="d-flex gap-2 mt-3 flex-wrap">
                            <a href="newexpense" class="btn btn-primary">
                                <i class="bi bi-plus-circle"></i> Add Expense
                            </a>
                            <a href="newaccount" class="btn btn-success">
                                <i class="bi bi-wallet-fill"></i> Add Account
                            </a>
                            <c:if test="${user.role == 'ADMIN'}">
                                <a href="newcategory" class="btn btn-info">
                                    <i class="bi bi-tags-fill"></i> Add Category
                                </a>
                                <a href="newvendor" class="btn btn-warning">
                                    <i class="bi bi-shop"></i> Add Vendor
                                </a>
                            </c:if>
                            <a href="reports" class="btn btn-secondary">
                                <i class="bi bi-file-earmark-bar-graph"></i> View Reports
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Getting Started Guide (Only for users with no expenses) -->
        <div class="row mt-4">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-body">
                        <h5><i class="bi bi-info-circle-fill"></i> Getting Started</h5>
                        <div class="row mt-3">
                            <div class="col-md-3 text-center">
                                <i class="bi bi-1-circle-fill" style="font-size: 2rem; color: #667eea;"></i>
                                <p class="mt-2"><strong>Create Account</strong><br>
                                    <small>Add your bank or credit card</small></p>
                            </div>
                            <div class="col-md-3 text-center">
                                <i class="bi bi-2-circle-fill" style="font-size: 2rem; color: #667eea;"></i>
                                <p class="mt-2"><strong>Browse Categories</strong><br>
                                    <small>Explore expense categories</small></p>
                            </div>
                            <div class="col-md-3 text-center">
                                <i class="bi bi-3-circle-fill" style="font-size: 2rem; color: #667eea;"></i>
                                <p class="mt-2"><strong>Track Expenses</strong><br>
                                    <small>Add your daily expenses</small></p>
                            </div>
                            <div class="col-md-3 text-center">
                                <i class="bi bi-4-circle-fill" style="font-size: 2rem; color: #667eea;"></i>
                                <p class="mt-2"><strong>View Insights</strong><br>
                                    <small>Analyze your spending</small></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Loading Overlay -->
<div class="loading-overlay" id="loadingOverlay">
    <div class="spinner-border-custom"></div>
</div>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
    // Show access denied message
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get('error') === 'access_denied') {
        Swal.fire({
            icon: 'error',
            title: 'Access Denied',
            text: 'You do not have permission to access that page.',
            confirmButtonColor: '#dc3545'
        });
    } else if (urlParams.get('error') === 'admin_only') {
        Swal.fire({
            icon: 'warning',
            title: 'Admin Only',
            text: 'This feature is only available to administrators.',
            confirmButtonColor: '#ffc107'
        });
    }

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

    // ========== DYNAMIC CHART DATA FROM CONTROLLER ==========

    // Pie Chart - Category Breakdown (REAL DATA)
    const categoryCtx = document.getElementById('categoryChart');
    if (categoryCtx) {
        const categoryLabels = [
            <c:forEach var="label" items="${categoryLabels}" varStatus="status">
            '${label}'<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];

        const categoryData = [
            <c:forEach var="data" items="${categoryData}" varStatus="status">
            ${data}<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];

        new Chart(categoryCtx, {
            type: 'doughnut',
            data: {
                labels: categoryLabels,
                datasets: [{
                    data: categoryData,
                    backgroundColor: [
                        '#FF6384',
                        '#36A2EB',
                        '#FFCE56',
                        '#4BC0C0',
                        '#9966FF',
                        '#FF9F40',
                        '#FF6384',
                        '#C9CBCF'
                    ],
                    borderWidth: 0,
                    hoverOffset: 10
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            padding: 15,
                            font: {
                                size: 11
                            }
                        }
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                let label = context.label || '';
                                let value = context.parsed || 0;
                                let total = context.dataset.data.reduce((a, b) => a + b, 0);
                                let percentage = ((value / total) * 100).toFixed(1);
                                return label + ': $' + value.toFixed(2) + ' (' + percentage + '%)';
                            }
                        }
                    }
                }
            }
        });
    }

    // Line Chart - 7-Day Trend (REAL DATA)
    const trendCtx = document.getElementById('trendChart');
    if (trendCtx) {
        const trendLabels = [
            <c:forEach var="label" items="${trendLabels}" varStatus="status">
            '${label}'<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];

        const trendData = [
            <c:forEach var="data" items="${trendData}" varStatus="status">
            ${data}<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];

        new Chart(trendCtx, {
            type: 'line',
            data: {
                labels: trendLabels,
                datasets: [{
                    label: 'Daily Spending ($)',
                    data: trendData,
                    borderColor: '#667eea',
                    backgroundColor: 'rgba(102, 126, 234, 0.1)',
                    tension: 0.4,
                    fill: true,
                    pointRadius: 6,
                    pointHoverRadius: 8,
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
                        display: false
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

    // Loading overlay
    window.addEventListener('load', function() {
        document.getElementById('loadingOverlay').style.display = 'none';
    });
</script>

</body>
</html>