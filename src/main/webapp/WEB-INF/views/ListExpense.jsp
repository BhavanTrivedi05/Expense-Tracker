<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Expense List</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .container {
            max-width: 900px;
        }
        .table {
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
        }
        .btn {
            margin-right: 5px;
        }
    </style>
</head>
<body class="container mt-4">

    <h2 class="mb-3 text-center">Expense List</h2>

    <table class="table table-borderless table-striped">
        <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th>Title</th>
                <th>Amount</th>
                <th>Category</th>
                <th>Subcategory</th>
                <th>Transaction Date</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${not empty expenseList}">
                    <c:forEach var="ex" items="${expenseList}">
                        <tr>
                            <td>${ex.expenseId}</td>
                            <td>${ex.title}</td>
                            <td>$${ex.amount}</td>
                            <td>${ex.categoryId}</td>
                            <td>${ex.subcategoryId}</td>
                            <td>${ex.transactionDate}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${ex.status}">Active</c:when>
                                    <c:otherwise>Inactive</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <a href="viewexpense?expenseId=${ex.expenseId}" class="btn btn-info btn-sm">View</a>
                                <a href="editexpense?expenseId=${ex.expenseId}" class="btn btn-primary btn-sm">Edit</a>
                                <a href="deleteexpense?expenseId=${ex.expenseId}" class="btn btn-danger btn-sm"
                                   onclick="return confirm('Are you sure you want to delete this expense?');">Delete</a>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="8" class="text-center">No expenses found</td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>

    <div class="text-center">
        <a href="newexpense" class="btn btn-success">Add New Expense</a>
        <a href="home" class="btn btn-secondary">Back to Dashboard</a>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
