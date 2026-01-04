<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Expense</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container mt-4">

<h2 class="mb-3">Edit Expense</h2>

<form action="editexpense" method="post" class="border p-4 rounded shadow-sm">
    <input type="hidden" name="expenseId" value="${expense.expenseId}">

    <div class="mb-3">
        <label for="title" class="form-label">Expense Title</label>
        <input type="text" id="title" name="title" class="form-control" value="${expense.title}" required>
    </div>

    <div class="mb-3">
        <label for="amount" class="form-label">Amount ($)</label>
        <input type="number" id="amount" name="amount" step="0.01" class="form-control" value="${expense.amount}" required>
    </div>

    <div class="mb-3">
        <label for="categoryId" class="form-label">Category</label>
        <select id="categoryId" name="categoryId" class="form-select" required>
            <option value="">Select Category</option>
            <c:forEach items="${allCategories}" var="c">
                <option value="${c.categoryId}" ${c.categoryId == expense.categoryId ? 'selected' : ''}>
                        ${c.title}
                </option>
            </c:forEach>
        </select>
    </div>

    <div class="mb-3">
        <label for="subcategoryId" class="form-label">Subcategory</label>
        <select id="subcategoryId" name="subcategoryId" class="form-select">
            <option value="">Select Subcategory (Optional)</option>
            <c:forEach items="${allSubCategories}" var="sc">
                <option value="${sc.subCategoryId}" ${sc.subCategoryId == expense.subcategoryId ? 'selected' : ''}>
                        ${sc.title}
                </option>
            </c:forEach>
        </select>
    </div>

    <div class="mb-3">
        <label for="vendorId" class="form-label">Vendor</label>
        <select id="vendorId" name="vendorId" class="form-select">
            <option value="">Select Vendor (Optional)</option>
            <c:forEach items="${allVendors}" var="v">
                <option value="${v.vendorId}" ${v.vendorId == expense.vendorId ? 'selected' : ''}>
                        ${v.title}
                </option>
            </c:forEach>
        </select>
    </div>

    <div class="mb-3">
        <label for="accountId" class="form-label">Account</label>
        <select id="accountId" name="accountId" class="form-select" required>
            <option value="">Select Account</option>
            <c:forEach items="${allAccounts}" var="a">
                <option value="${a.accountId}" ${a.accountId == expense.accountId ? 'selected' : ''}>
                        ${a.title}
                </option>
            </c:forEach>
        </select>
    </div>

    <div class="mb-3">
        <label for="transcationDate" class="form-label">Transaction Date</label>
        <input type="datetime-local" id="transcationDate" name="transcationDate" class="form-control" value="${expense.transcationDate}">
    </div>

    <div class="mb-3">
        <label for="description" class="form-label">Description</label>
        <textarea id="description" name="description" class="form-control" rows="3">${expense.description}</textarea>
    </div>

    <button type="submit" class="btn btn-primary">Update Expense</button>
    <a href="listexpense" class="btn btn-secondary">Cancel</a>
</form>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>