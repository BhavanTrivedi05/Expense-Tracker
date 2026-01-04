<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Subcategory List</title>
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

    <h2 class="mb-3 text-center">Subcategory List</h2>

    <table class="table table-borderless table-striped">
        <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th>Title</th>
                <th>Category</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${not empty subcategoryList}">
                    <c:forEach var="subcategory" items="${subcategoryList}">
                        <tr>
                            <td>${subcategory.subCategoryId}</td>
                            <td>${subcategory.title}</td>
                            <td>${subcategory.categoryId}</td> 
                            <td>
                                <a href="viewsubcategory?subCategoryId=${subcategory.subCategoryId}" class="btn btn-info btn-sm">View</a>
                                <a href="editsubcategory?subCategoryId=${subcategory.subCategoryId}" class="btn btn-primary btn-sm">Edit</a>
                                <a href="deletesubcategory?subCategoryId=${subcategory.subCategoryId}" class="btn btn-danger btn-sm"
                                   onclick="return confirm('Are you sure you want to delete this subcategory?');">Delete</a>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="4" class="text-center">No subcategories found</td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>

    <div class="text-center">
        <a href="newsubcategory" class="btn btn-success">Add New Subcategory</a>
        <a href="listcategory" class="btn btn-secondary">Back to Categories</a>
        <a href="home" class="btn btn-dark">Back to Dashboard</a>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
