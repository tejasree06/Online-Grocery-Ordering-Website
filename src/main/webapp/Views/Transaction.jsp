<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Complete Your Payment</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/nav_bar.css"> 
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; padding: 0; background-color: #f0f2f5; color: #333; line-height: 1.6; }
        .page-container { max-width: 650px; margin: 20px auto; padding: 20px; background-color: #ffffff; border-radius: 10px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); margin-top: 80px; /* Adjust if navbar is fixed */ }
        h2.page-title { text-align: center; color: #1e3c72; margin-bottom: 25px; font-size: 2em; font-weight: 600; }
        .section-title { font-size: 1.4em; color: #2a5298; margin-bottom: 15px; border-bottom: 2px solid #e0e0e0; padding-bottom: 8px; }
        .order-summary p, .payment-form .form-group label { font-size: 1em; margin-bottom: 8px; }
        .order-summary .detail-label { font-weight: 500; color: #555; }
        .order-summary .detail-value { color: #333; }
        .order-summary .total-amount { font-weight: bold; color: #28a745; font-size: 1.5em; margin-top: 10px; }
        .payment-form .form-group { margin-bottom: 18px; }
        .payment-form .form-group input[type="text"], .payment-form .form-group input[type="password"] {
            width: calc(100% - 22px); padding: 10px; border: 1px solid #ced4da; border-radius: 5px; font-size: 1em;
            transition: border-color 0.3s ease;
        }
        .payment-form .form-group input[type="text"]:focus, .payment-form .form-group input[type="password"]:focus {
            border-color: #80bdff; outline: 0; box-shadow: 0 0 0 0.2rem rgba(0,123,255,.25);
        }
        .payment-form .expiry-cvv-group { display: flex; gap: 15px; }
        .payment-form .expiry-cvv-group .form-group { flex: 1; }
        .btn-pay {
            display: block; width: 100%; padding: 12px; background-image: linear-gradient(to right, #1fa2ff, #12d8fa, #a6ffcb);
            color: #004085; border: none; border-radius: 6px; font-size: 1.1em; font-weight: 600; cursor: pointer;
            text-transform: uppercase; letter-spacing: 0.5px; box-shadow: 0 4px 10px rgba(0, 123, 255, 0.2);
            transition: opacity 0.3s ease;
        }
        .btn-pay:hover { opacity: 0.9; }
        .error-message-payment { color: #dc3545; background-color: #f8d7da; border: 1px solid #f5c6cb; padding: 10px; border-radius: 5px; margin-bottom: 15px; text-align: center; font-size: 0.95em;}
    </style>
</head>
<body>
    <%
        HttpSession sessionObj = request.getSession(false);
        if (sessionObj == null || sessionObj.getAttribute("customerID") == null) {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
            return;
        }

        Double totalAmount = (Double) sessionObj.getAttribute("checkoutTotalAmount");
        Integer totalItems = (Integer) sessionObj.getAttribute("checkoutTotalItems");
        String shippingAddress = (String) sessionObj.getAttribute("checkoutShippingAddress");

        if (totalAmount == null || totalItems == null || shippingAddress == null) {
            response.sendRedirect(request.getContextPath() + "/Views/Cart.jsp?error=Transaction_data_unavailable_please_retry_checkout");
            return;
        }
        
        String paymentErrorMessage = request.getParameter("message"); 
    %>

    <%-- Include a customer-specific navbar. Create this file or adapt an existing navbar. --%>
    <%-- For simplicity, ensure OnlineOrdering/src/main/webapp/Views/navbar_customer.jsp exists and is appropriate --%>
    <jsp:include page="navbar_customer.jsp" />

    <div class="page-container">
        <h2 class="page-title">Final Step: Secure Payment</h2>

        <div class="order-summary" style="margin-bottom: 30px;">
            <h3 class="section-title">Confirm Your Order</h3>
            <p><span class="detail-label">Total Items:</span> <span class="detail-value"><%= totalItems %></span></p>
            <p><span class="detail-label">Shipping To:</span> <span class="detail-value"><%= shippingAddress %></span></p>
            <p class="total-amount">Amount to Pay: Rs. <%= String.format("%.2f", totalAmount) %></p>
        </div>

        <div class="payment-form">
            <h3 class="section-title">Enter Payment Details (Dummy)</h3>
            
            <% if (paymentErrorMessage != null && !paymentErrorMessage.isEmpty()) { %>
                <p class="error-message-payment"><%= paymentErrorMessage.replace("_", " ") %></p>
            <% } %>

            <form action="<%= request.getContextPath() %>/ProcessPaymentServlet" method="post">
                <div class="form-group">
                    <label for="cardNumber">Card Number</label>
                    <input type="text" id="cardNumber" name="cardNumber" placeholder="XXXX-XXXX-XXXX-XXXX" required 
                           pattern="\d{4}-\d{4}-\d{4}-\d{4}" title="Enter 16 digits in XXXX-XXXX-XXXX-XXXX format. (e.g., 1111-1111-1111-1111 for testing)">
                </div>
                <div class="form-group">
                    <label for="cardName">Name on Card</label>
                    <input type="text" id="cardName" name="cardName" placeholder="e.g., John M. Doe" required>
                </div>
                <div class="expiry-cvv-group">
                    <div class="form-group">
                        <label for="expiryDate">Expiry Date</label>
                        <input type="text" id="expiryDate" name="expiryDate" placeholder="MM/YY" required 
                               pattern="(0[1-9]|1[0-2])\/\d{2}" title="Enter in MM/YY format (e.g., 12/25)">
                    </div>
                    <div class="form-group">
                        <label for="cvv">CVV</label>
                        <input type="text" id="cvv" name="cvv" placeholder="XXX" required 
                               pattern="\d{3}" title="Enter 3-digit CVV (e.g., 123)">
                    </div>
                </div>
                <button type="submit" class="btn-pay">Pay Rs. <%= String.format("%.2f", totalAmount) %></button>
            </form>
        </div>
    </div>
</body>
</html>