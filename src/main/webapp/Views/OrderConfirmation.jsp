<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Order Confirmation</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/nav_bar.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; padding: 0; background-color: #f0f8ff; color: #333; }
        .page-container { max-width: 700px; margin: 20px auto; padding: 30px 40px; background-color: #ffffff; border-radius: 12px; box-shadow: 0 6px 20px rgba(0,0,0,0.1); text-align: center; margin-top: 80px; }
        .confirmation-icon { font-size: 4.5em; margin-bottom: 20px; }
        .success .confirmation-icon { color: #28a745; } 
        .failure .confirmation-icon { color: #dc3545; } 
        .confirmation-title { font-size: 2.2em; margin-top: 0; margin-bottom: 15px; font-weight: 600; }
        .success .confirmation-title { color: #155724; }
        .failure .confirmation-title { color: #721c24; }
        .confirmation-message { font-size: 1.1em; line-height: 1.7; margin-bottom: 25px; color: #555; }
        .btn-action {
            display: inline-block; margin-top: 20px; padding: 12px 30px; background-image: linear-gradient(to right, #007bff, #0056b3);
            color: white; text-decoration: none; border-radius: 25px; font-size: 1.05em; font-weight: 500;
            transition: background-color 0.3s ease; box-shadow: 0 2px 5px rgba(0,0,0,0.15);
        }
        .btn-action:hover { background-image: linear-gradient(to right, #0056b3, #004085); }
    </style>
</head>
<body>
    <%
        HttpSession sessionObj = request.getSession(false);
        if (sessionObj == null || sessionObj.getAttribute("customerID") == null) {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
            return;
        }
        String status = request.getParameter("status");
        String message = request.getParameter("message"); 
    %>

    <jsp:include page="navbar_customer.jsp" />

    <div class="page-container <% if ("success".equals(status)) { out.print("success"); } else { out.print("failure"); } %>">
        <% if ("success".equals(status)) { %>
            <i class="fa fa-check-circle confirmation-icon"></i>
            <h2 class="confirmation-title">Order Placed Successfully!</h2>
            <p class="confirmation-message">Thank you for your purchase. Your order is being processed. You will receive a confirmation and updates via email shortly.</p>
            <a href="<%= request.getContextPath() %>/Home.jsp" class="btn-action">Continue Shopping</a>
        <% } else { %>
            <i class="fa fa-times-circle confirmation-icon"></i>
            <h2 class="confirmation-title">Order Placement Failed</h2>
            <p class="confirmation-message">We're sorry, but we encountered an issue while processing your order.
            <% if (message != null && !message.isEmpty()) { %>
                <br>Details: <%= message.replace("_", " ") %>
            <% } %>
            Please try placing your order again. If the problem persists, kindly contact our customer support.</p>
            <a href="<%= request.getContextPath() %>/Views/Cart.jsp" class="btn-action">Return to Cart</a>
        <% } %>
    </div>
</body>
</html>