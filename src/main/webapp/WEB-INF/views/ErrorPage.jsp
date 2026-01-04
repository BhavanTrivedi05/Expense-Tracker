<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - SpendWise</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #f8d7da;
        }
        .card {
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            width: 400px;
            background: white;
            text-align: center;
        }
        .error-icon {
            font-size: 50px;
            color: #dc3545;
        }
    </style>
</head>
<body>

    <div class="card">
        <div class="error-icon">❌</div>
        <h2 class="text-danger">Oops! Something went wrong.</h2>
        <p class="text-muted">An unexpected error occurred. Please try again later.</p>
        <a href="home" class="btn btn-danger w-100">Go to Home</a>
    </div>

</body>
</html>