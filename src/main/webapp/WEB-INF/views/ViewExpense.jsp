<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Expense - SpendWise</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .container {
            max-width: 450px;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.2);
            text-align: center;
        }
        h2 {
            color: #003366;
            margin-bottom: 20px;
        }
        .expense-info {
            text-align: left;
            margin-bottom: 20px;
        }
        .btn-group {
            display: flex;
            justify-content: space-between;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Expense Details</h2>
        <div class="expense-info">
            <p><strong>Title:</strong> <c:out value="${expense.title}" /></p>
            <p><strong>Amount:</strong> $<c:out value="${expense.amount}" /></p>
            <p><strong>Category:</strong> <c:out value="${expense.category.title}" /></p>
            <p><strong>Subcategory:</strong> <c:out value="${expense.subCategory.title}" /></p>
            <p><strong>Date:</strong> <c:out value="${expense.date}" /></p>
            <p><strong>Description:</strong> <c:out value="${expense.description}" /></p>
        </div>
        <div class="btn-group">
            <a href="editexpense?expenseId=${expense.id}" class="btn btn-primary">Edit</a>
            <a href="deleteexpense?expenseId=${expense.id}" class="btn btn-danger"
               onclick="return confirm('Are you sure you want to delete this expense?');">Delete</a>
        </div>
        <br>
        <a href="listexpenses" class="btn btn-secondary">Back to Expenses</a>
    </div>
</body>
</html>
