<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>List Accounts</title>
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

    <h2 class="mb-3 text-center">Account List</h2>
    
    <table class="table table-borderless table-striped">
        <thead class="table-dark">
            <tr>
                <th>Title</th>
                <th>Description</th>
                <th>Balance</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="acc" items="${accountList}">
                <tr>
                    <td>${acc.title}</td>
                    <td>${acc.description}</td>
                    <td>$${acc.amount}</td>
                    <td>
                        <a href="editaccount?accountId=${acc.accountId}" class="btn btn-primary btn-sm">Edit</a>
                        <a href="deleteaccount?accountId=${acc.accountId}" class="btn btn-danger btn-sm"
                           onclick="return confirm('Are you sure you want to delete this account?');">Delete</a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty accountList}">
                <tr>
                    <td colspan="4" class="text-center">No accounts found</td>
                </tr>
            </c:if>
        </tbody>
    </table>

    <div class="text-center">
        <a href="newaccount" class="btn btn-success">Add New Account</a>
        <a href="home" class="btn btn-secondary">Back to Dashboard</a>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
