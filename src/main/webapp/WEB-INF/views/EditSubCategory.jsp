<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Subcategory - SpendWise</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #f8f9fa;
        }
        .card {
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            width: 400px;
            background: white;
        }
    </style>
</head>
<body>

    <div class="card">
        <h2 class="text-center">Edit Subcategory</h2>
        <form action="editsubcategory" method="post">
            <input type="hidden" name="subCategoryId" value="${subcategory.subCategoryId}">
            
            <div class="mb-3">
                <label class="form-label">New Title</label>
                <input type="text" name="title" class="form-control" value="${subcategory.title}" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Category</label>
                <select name="categoryId" class="form-select" required>
                    <option value="">Select Category</option>
                    <c:forEach var="category" items="${categories}">
                        <option value="${category.categoryId}" ${category.categoryId == subcategory.categoryId ? 'selected' : ''}>
                            ${category.title}
                        </option>
                    </c:forEach>
                </select>
            </div>
            <button type="submit" class="btn btn-primary w-100">Update Subcategory</button>
        </form>
    </div>

</body>
</html>
