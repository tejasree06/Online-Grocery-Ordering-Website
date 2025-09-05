<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*, Model.OrderDisplayItem, java.text.SimpleDateFormat" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>My Orders</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/nav_bar.css"> 
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; padding: 0; background-color: #eef2f7; color: #333; line-height: 1.6; }
        .page-container { max-width: 900px; margin: 20px auto; padding: 20px; background-color: #ffffff; border-radius: 10px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); margin-top: 80px; /* Adjust if navbar is fixed */ }
        h2.page-title { text-align: center; color: #2c3e50; margin-bottom: 25px; font-size: 2.2em; font-weight: 500; }
        .order-group { margin-bottom: 30px; border: 1px solid #d1d9e6; border-radius: 8px; background-color: #f8f9fa; box-shadow: 0 2px 5px rgba(0,0,0,0.05); }
        .order-header { background-image: linear-gradient(to right, #4e54c8, #8f94fb); color: white; padding: 12px 18px; border-top-left-radius: 7px; border-top-right-radius: 7px; display: flex; justify-content: space-between; align-items: center; }
        .order-header h3 { margin: 0; font-size: 1.3em; font-weight: 500; }
        .order-header .order-date { font-size: 0.95em; opacity: 0.9; }
        .order-details-content { padding: 15px; }
        .shipping-address { font-size: 0.9em; color: #555; margin-bottom: 15px; padding-bottom:10px; border-bottom: 1px dashed #ccc; }
        .order-item { display: flex; align-items: flex-start; padding: 12px 0; border-bottom: 1px solid #e0e0e0; }
        .order-item:last-child { border-bottom: none; }
        .order-item img { width: 70px; height: 70px; object-fit: cover; border-radius: 6px; margin-right: 15px; border: 1px solid #eee; }
        .item-info { flex-grow: 1; }
        .item-info .product-name { font-size: 1.05em; font-weight: 600; color: #34568B; margin: 0 0 5px 0; }
        .item-details p { font-size: 0.9em; margin: 3px 0; color: #454545; }
        .item-details .label { font-weight: 500; }
        .no-orders-message { text-align: center; padding: 40px 20px; background-color: #fff3cd; border: 1px solid #ffeeba; color: #856404; border-radius: 8px; font-size: 1.1em; }
        .no-orders-message i {font-size: 2em; margin-bottom: 10px; display:block;}
        .no-orders-message a {display:inline-block; margin-top:15px; padding:8px 15px; background-color:#007bff; color:white; text-decoration:none; border-radius:5px;}
        .order-total-summary { text-align: right; padding-top: 10px; margin-top:10px; border-top: 1px solid #ccc; font-weight: bold; font-size: 1.1em; color: #28a745;}
    </style>
</head>
<body>
    <%
        HttpSession sessionObj = request.getSession(false);
        if (sessionObj == null || sessionObj.getAttribute("customerID") == null) {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
            return;
        }
        
        String role = (String) sessionObj.getAttribute("role");
        if (!"customer".equalsIgnoreCase(role)) {
             response.sendRedirect(request.getContextPath() + "/Login.jsp?error=unauthorized_access");
            return;
        }

        Map<String, List<OrderDisplayItem>> customerOrdersMap = (Map<String, List<OrderDisplayItem>>) request.getAttribute("customerOrdersMap");
        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM, yyyy");
    %>

    <jsp:include page="navbar_customer.jsp" />

    <div class="page-container">
        <h2 class="page-title">Your Order History</h2>

        <% if (customerOrdersMap == null || customerOrdersMap.isEmpty()) { %>
            <div class="no-orders-message">
                <i class="fa fa-dropbox"></i>
                <p>You haven't placed any orders yet. Start shopping to see your orders here!</p>
                <a href="<%= request.getContextPath() %>/Home.jsp">Shop Now</a>
            </div>
        <% } else { %>
            <% for (Map.Entry<String, List<OrderDisplayItem>> entry : customerOrdersMap.entrySet()) {
                String orderId = entry.getKey();
                List<OrderDisplayItem> itemsInOrder = entry.getValue();
                OrderDisplayItem firstItem = itemsInOrder.get(0); 
                double orderGrandTotal = 0;
            %>
                <div class="order-group">
                    <div class="order-header">
                        <h3>Order ID: <%= orderId %></h3>
                        <span class="order-date">Placed on: <%= sdf.format(firstItem.getOrderDate()) %></span>
                    </div>
                    <div class="order-details-content">
                        <p class="shipping-address"><span class="label">Shipped to:</span> <%= firstItem.getShippingAddress() %></p>
                        <% for (OrderDisplayItem item : itemsInOrder) { 
                             orderGrandTotal += item.getItemTotalAmount();
                        %>
                            <div class="order-item">
                                <img src="<%= request.getContextPath() %>/assets/images/<%= item.getProductUrl() %>" alt="<%= item.getProductName() %>">
                                <div class="item-info">
                                    <p class="product-name"><%= item.getProductName() %></p>
                                    <div class="item-details">
                                        <p><span class="label">Unit Price:</span> Rs. <%= String.format("%.2f", item.getUnitPrice()) %></p>
                                        <p><span class="label">Quantity:</span> <%= item.getQuantityOrdered() %></p>
                                        <p><span class="label">Item Total:</span> Rs. <%= String.format("%.2f", item.getItemTotalAmount()) %></p>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                        <div class="order-total-summary">
                           Order Total: Rs. <%= String.format("%.2f", orderGrandTotal) %>
                        </div>
                    </div>
                </div>
            <% } %>
        <% } %>
    </div>
</body>
</html>