<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Expense Tracker - Expenses</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .container {
            margin-top: 50px;
        }
        table {
            background: white;
        }
        .btn-actions {
            display: flex;
            gap: 5px;
            justify-content: center;
        }
    </style>
</head>
<body>

    <div class="container">
        <h2 class="text-center">Your Expenses</h2>
        
        <div class="table-responsive">
            <table class="table table-bordered table-hover">
                <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>Title</th>
                        <th>Amount</th>
                        <th>Category</th>
                        <th>Subcategory</th>
                        <th>Vendor</th>
                        <th>Account</th>
                        <th>Date</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty expenses}">
                            <c:forEach var="expense" items="${expenses}">
                                <tr>
                                    <td>${expense.id}</td>
                                    <td>${expense.title}</td>
                                    <td>$${expense.amount}</td>
                                    <td>${expense.category.name}</td>
                                    <td>${expense.subCategory.name}</td>
                                    <td>${expense.vendor.name}</td>
                                    <td>${expense.account.accountName}</td>
                                    <td>${expense.transactionDate}</td>
                                    <td class="btn-actions">
                                        <a href="editExpense?id=${expense.id}" class="btn btn-warning btn-sm">Edit</a>
                                        <a href="deleteExpense?id=${expense.id}" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this expense?')">Delete</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="9" class="text-center text-muted">No expenses found</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

        <div class="text-center mt-3">
            <a href="addExpense" class="btn btn-primary">Add New Expense</a>
            <a href="home" class="btn btn-secondary">Back to Home</a>
        </div>
    </div>

</body>
</html>
