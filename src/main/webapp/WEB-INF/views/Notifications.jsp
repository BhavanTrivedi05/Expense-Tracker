<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- Notifications.jsp -->
<!DOCTYPE html>
<html>
<head>
    <title>Notifications</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container mt-4">

    <h2 class="mb-3">Notifications</h2>

    <c:choose>
        <c:when test="${not empty notifications}">
            <div class="list-group">
                <c:forEach var="notification" items="${notifications}">
                    <div class="list-group-item list-group-item-info">
                        <span class="fw-bold">📢 ${notification}</span>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <p class="alert alert-warning">No new notifications.</p>
        </c:otherwise>
    </c:choose>

    <a href="dashboard" class="btn btn-primary mt-3">Back to Dashboard</a>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
