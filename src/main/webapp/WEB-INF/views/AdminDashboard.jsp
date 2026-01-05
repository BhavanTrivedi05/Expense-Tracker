<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - SpendWise</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
            background: linear-gradient(180deg, #1e3c72 0%, #2a5298 100%);
            padding-top: 20px;
            color: white;
        }
        .sidebar h3 {
            padding: 0 15px;
            font-size: 1.3rem;
            margin-bottom: 10px;
        }
        .sidebar .admin-badge {
            background: rgba(220, 53, 69, 0.2);
            color: #ffcccb;
            padding: 5px 10px;
            border-radius: 5px;
            font-size: 0.75rem;
            margin: 0 15px 15px 15px;
            display: inline-block;
        }
        .sidebar a {
            color: white;
            text-decoration: none;
            display: block;
            padding: 12px 15px;
            margin: 3px 10px;
            border-radius: 8px;
            transition: all 0.3s;
        }
        .sidebar a:hover, .sidebar a.active {
            background: rgba(255, 255, 255, 0.15);
            transform: translateX(5px);
        }
        .sidebar a i {
            margin-right: 10px;
            width: 20px;
        }
        .content {
            margin-left: 260px;
            padding: 20px;
        }
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0px 5px 15px rgba(0, 0, 0, 0.1);
            transition: all 0.3s;
            background: white; /* ADDED */
        }
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0px 8px 25px rgba(0, 0, 0, 0.15);
        }
        .header {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
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
        }
        .header a:hover {
            background: rgba(255, 255, 255, 0.3);
        }
        .stat-box {
            padding: 25px;
            border-radius: 15px;
            color: white;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        .stat-box h6 {
            font-size: 0.9rem;
            font-weight: 600;
            margin-bottom: 10px;
            opacity: 0.95;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .stat-box h2 {
            font-size: 2.8rem;
            font-weight: bold;
            margin: 15px 0;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.2);
        }
        .stat-box small {
            font-size: 0.85rem;
            opacity: 0.9;
        }
        .stat-box i {
            font-size: 3.5rem;
            opacity: 0.15;
            position: absolute;
            right: 15px;
            top: 15px;
        }

        /* Gradient backgrounds for stat boxes */
        .bg-gradient-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .bg-gradient-danger {
            background: linear-gradient(135deg, #ee0979 0%, #ff6a00 100%);
        }
        .bg-gradient-success {
            background: linear-gradient(135deg, #56ab2f 0%, #8fd3f4 100%);
        }
        .bg-gradient-warning {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }

        footer {
            text-align: center;
            padding: 15px;
            background: #343a40;
            color: white;
            margin-top: 30px;
            border-radius: 10px;
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
    <h3><i class="bi bi-shield-fill-check"></i> Admin Panel</h3>
    <span class="admin-badge"><i class="bi bi-lock-fill"></i> ADMIN MODE</span>
    <hr style="border-color: rgba(255,255,255,0.3);">

    <a href="admindashboard" class="active"><i class="bi bi-speedometer2"></i>Dashboard</a>
    <a href="${pageContext.request.contextPath}/admin/listusers"><i class="bi bi-people-fill"></i>Manage Users</a>
    <a href="listcategory"><i class="bi bi-tags-fill"></i>Categories</a>
    <a href="listsubcategory"><i class="bi bi-tag-fill"></i>Subcategories</a>
    <a href="listvendor"><i class="bi bi-shop"></i>Vendors</a>
    <a href="adminreports"><i class="bi bi-file-earmark-bar-graph"></i>System Reports</a>

    <hr style="border-color: rgba(255,255,255,0.3);">
    <a href="home"><i class="bi bi-house-door"></i>User Dashboard</a>
    <a href="${pageContext.request.contextPath}/admin/logout"><i class="bi bi-box-arrow-right"></i>Logout</a>
</div>

<!-- Main Content -->
<div class="content">
    <!-- Header -->
    <div class="header">
        <div>
            <h4><i class="bi bi-shield-lock-fill"></i> Administrator Dashboard</h4>
            <small>System-wide statistics and management</small>
        </div>
        <div>
                <span class="me-3">
                    <i class="bi bi-person-circle"></i> ${admin.firstName} ${admin.lastName}
                </span>
            <a href="${pageContext.request.contextPath}/admin/logout">
                <i class="bi bi-box-arrow-right"></i> Logout
            </a>
        </div>
    </div>

    <!-- System Statistics -->
    <div class="container-fluid">
        <div class="row g-4">
            <div class="col-md-3">
                <div class="card stat-box bg-gradient-primary">
                    <i class="bi bi-people"></i>
                    <h6>Total Users</h6>
                    <h2>${totalUsers}</h2>
                    <small>
                        <i class="bi bi-shield"></i> ${totalAdmins} Admins |
                        <i class="bi bi-person"></i> ${totalRegularUsers} Users
                    </small>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-box bg-gradient-danger">
                    <i class="bi bi-cash-stack"></i>
                    <h6>Total Expenses</h6>
                    <h2>$${totalExpenses}</h2>
                    <small><i class="bi bi-receipt"></i> ${expenseCount} transactions</small>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-box bg-gradient-success">
                    <i class="bi bi-bank"></i>
                    <h6>Total Accounts</h6>
                    <h2>${totalAccounts}</h2>
                    <small><i class="bi bi-credit-card"></i> Active accounts</small>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-box bg-gradient-warning">
                    <i class="bi bi-tags"></i>
                    <h6>Categories</h6>
                    <h2>${totalCategories}</h2>
                    <small>
                        <i class="bi bi-tag"></i> ${totalSubCategories} subcategories |
                        <i class="bi bi-shop"></i> ${totalVendors} vendors
                    </small>
                </div>
            </div>
        </div>

        <!-- Charts -->
        <div class="row mt-4 g-4">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-body" style="height: 300px;">
                        <h5><i class="bi bi-graph-up"></i> User Growth</h5>
                        <canvas id="userGrowthChart"></canvas>
                    </div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="card">
                    <div class="card-body" style="height: 300px;">
                        <h5><i class="bi bi-pie-chart"></i> Platform Activity</h5>
                        <canvas id="activityChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Management Sections -->
        <div class="row mt-4">
            <div class="col-lg-12">
                <div class="card">
                    <div class="card-body">
                        <h5><i class="bi bi-lightning-fill"></i> Quick Admin Actions</h5>
                        <div class="d-flex gap-2 mt-3 flex-wrap">
                            <a href="${pageContext.request.contextPath}/admin/listusers" class="btn btn-primary">
                                <i class="bi bi-people"></i> Manage Users
                            </a>
                            <a href="newcategory" class="btn btn-success">
                                <i class="bi bi-tags"></i> Add Category
                            </a>
                            <a href="newvendor" class="btn btn-info">
                                <i class="bi bi-shop"></i> Add Vendor
                            </a>
                            <a href="adminreports" class="btn btn-warning">
                                <i class="bi bi-file-earmark-bar-graph"></i> View Reports
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer>
        <p>&copy; 2026 SpendWise Admin Panel. All rights reserved.</p>
    </footer>
</div>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
    // User Growth Chart (DYNAMIC DATA)
    const userGrowthCtx = document.getElementById('userGrowthChart');
    if (userGrowthCtx) {
        const userGrowthLabels = [
            <c:forEach var="label" items="${userGrowthLabels}" varStatus="status">
            '${label}'<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];

        const userGrowthData = [
            <c:forEach var="data" items="${userGrowthData}" varStatus="status">
            ${data}<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];

        new Chart(userGrowthCtx, {
            type: 'line',
            data: {
                labels: userGrowthLabels,
                datasets: [{
                    label: 'New Users',
                    data: userGrowthData,
                    borderColor: '#667eea',
                    backgroundColor: 'rgba(102, 126, 234, 0.2)',
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
                        display: true,
                        position: 'top'
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            stepSize: 1
                        }
                    }
                }
            }
        });
    }

    // Activity Chart (DYNAMIC DATA)
    const activityCtx = document.getElementById('activityChart');
    if (activityCtx) {
        const activityLabels = [
            <c:forEach var="label" items="${activityLabels}" varStatus="status">
            '${label}'<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];

        const activityData = [
            <c:forEach var="data" items="${activityData}" varStatus="status">
            ${data}<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];

        new Chart(activityCtx, {
            type: 'doughnut',
            data: {
                labels: activityLabels,
                datasets: [{
                    data: activityData,
                    backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0'],
                    borderWidth: 0,
                    hoverOffset: 10
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom'
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return context.label + ': ' + context.parsed + ' items';
                            }
                        }
                    }
                }
            }
        });
    }
</script>

</body>
</html>