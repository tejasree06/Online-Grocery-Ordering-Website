<%@ page session="true"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="Dao.ProductDAO, Model.Product, java.util.List"%>
<%@ include file="../assets/alerts.jsp"%> <%-- This include remains --%>
<%
    HttpSession sessionObj = request.getSession(false);
    if((sessionObj == null || sessionObj.getAttribute("customerID") == null)){
        response.sendRedirect(request.getContextPath() + "/Login.jsp");
        return;
    }
    else if(!(sessionObj.getAttribute("role").equals("admin"))){
        response.sendRedirect(request.getContextPath() + "/Login.jsp");
        return;
    }

    ProductDAO productDAO = new ProductDAO();
    List<Product> productList = null;
    String pageErrorMessage = null;

    try {
        productList = productDAO.getAllProducts();
        if (productList == null) { // Ensure list is not null for the loop
            productList = new java.util.ArrayList<>(); // Use fully qualified name if import is just java.util.List
        }
    } catch (Exception e) {
        e.printStackTrace();
        pageErrorMessage = "Error retrieving product list: " + e.getMessage();
        productList = new java.util.ArrayList<>(); // Initialize to empty on error
    }
%>
<!DOCTYPE html>
<html lang="en" style="height: 100%; margin: 0; padding: 0;">
<head>
<title>View Products - Admin</title>
<link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"> <%-- For Font Awesome icons, if used in My Profile link --%>
<%-- <link rel="stylesheet"
    href="<%=request.getContextPath() %>/assets/css/view_product.css"> --%>
<%-- <link rel="stylesheet"
    href="<%=request.getContextPath() %>/assets/css/nav_bar.css"> --%>
<style>
    /* Basic body, table, and utility resets */
    body {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: 'Segoe UI', Arial, sans-serif;
        color: #34495e; /* Consistent admin text color */
    }
    table {
        border-collapse: collapse;
        width: 98%; /* Make table nearly full width */
        margin: 25px auto;
        box-shadow: 0 3px 12px rgba(0,0,0,0.12);
    }
    th, td {
        border: 1px solid #dfe6e9; /* Softer borders */
        padding: 10px 12px;
        text-align: left;
        vertical-align: middle;
    }
    th {
        font-weight: 600; /* Bold headers */
    }
    /* Icon basic style, if any appear in links */
    .fa {
        margin-left: 5px;
    }
    /* Container for action buttons to manage spacing */
    .action-buttons-container {
        display: flex; /* Align buttons in a row */
        gap: 8px; /* Space between buttons */
        justify-content: center; /* Center buttons in the cell if desired */
    }
</style>
</head>
<body style="min-height: 100%; background-image: linear-gradient(to bottom, #f4f6f9, #e9ecef); padding-top: 70px; /* Consistent with other admin pages */ box-sizing: border-box;">

    <nav class="navbar" style="background-image: linear-gradient(to right, #2c3e50, #34495e); color: #ecf0f1; padding: 10px 30px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.18); position: fixed; top: 0; left: 0; width: 100%; z-index: 1000; box-sizing: border-box;">
        <ul class="nav_list" style="list-style: none; margin: 0; padding: 0; display: flex; align-items: center; gap: 18px;">
            <li><a href="admin_dashboard.jsp" style="color: #bdc3c7; text-decoration: none; font-size: 0.9em; padding: 7px 10px;">Home</a></li>
            <li><a href="<%= request.getContextPath() %>/AdminProfileServlet" style="color: #bdc3c7; text-decoration: none; font-size: 0.9em; padding: 7px 10px;">My Profile <i class="fa fa-user"></i></a></li>
            <!--  <li><a href="add_admin.jsp" style="color: #bdc3c7; text-decoration: none; font-size: 0.9em; padding: 7px 10px;">Add Admin</a></li>-->
            <li><a href="add_product.jsp" style="color: #bdc3c7; text-decoration: none; font-size: 0.9em; padding: 7px 10px;">Add Product</a></li>
            <li><a href="view_product.jsp" style="color: #ffffff; background-image: linear-gradient(to right, #27ae60, #2ecc71); padding: 7px 14px; border-radius: 5px; text-decoration: none; font-size: 0.95em; font-weight:500;">View Products</a></li>
            <li><a href="view_customer.jsp" style="color: #bdc3c7; text-decoration: none; font-size: 0.9em; padding: 7px 10px;">View Customers</a></li>
        </ul>
        <ul style="list-style: none; margin: 0; padding: 0;">
             <li><a href="<%= request.getContextPath() %>/logout" class="btn_logout" style="background-image: linear-gradient(to right, #e74c3c, #c0392b); color: white; padding: 8px 18px; text-decoration: none; border-radius: 5px; font-size: 0.9em; font-weight: 500; border: none; cursor: pointer; box-shadow: 0 1px 4px rgba(0,0,0,0.2);">Logout</a></li>
        </ul>
    </nav>

    <div style="padding: 20px; max-width: 1300px; margin: 0 auto; box-sizing: border-box;">
        <h2 class="page_heading" style="text-align: center; color: #2c3e50; margin-top: 20px; margin-bottom: 30px; font-size: 2.1em; font-weight: 500; border-bottom: 2px solid #95a5a6; padding-bottom: 10px; background-image: linear-gradient(to right, #16a085, #f1c40f); -webkit-background-clip: text; color: transparent;">Product Inventory</h2>

        <% if (pageErrorMessage != null) { %>
            <p style="text-align:center; font-size: 1.1em; color: #c0392b; background-color: #f9e0e0; border: 1px solid #eebbbb; padding: 15px; border-radius: 6px; margin-bottom: 20px;">
                <i class="fa fa-exclamation-triangle" style="margin-right:8px;"></i> <%= pageErrorMessage %>
            </p>
        <% } %>

        <% if (productList.isEmpty() && pageErrorMessage == null) { %>
            <p style="text-align:center; font-size: 1.1em; color: #2980b9; background-color: #d6eaf8; border: 1px solid #a9cce3; padding: 15px; border-radius: 6px;">
                 <i class="fa fa-info-circle" style="margin-right:8px;"></i> No products found in the inventory. You can <a href="add_product.jsp" style="color: #1f618d; text-decoration:underline; font-weight:500;">add a new product</a>.
            </p>
        <% } else if (!productList.isEmpty()) { %>
            <table border="1" style="border: 1px solid #bdc3c7; background-color: #ffffff;">
                <thead style="background-image: linear-gradient(to bottom, #34495e, #2c3e50); color: #ecf0f1;">
                    <tr>
                        <th style="padding: 12px 15px; border-right: 1px solid #4a6276; text-align:center;">ID</th>
                        <th style="padding: 12px 15px; border-right: 1px solid #4a6276;">Name</th>
                        <th style="padding: 12px 15px; border-right: 1px solid #4a6276; text-align:right;">Price (Rs.)</th>
                        <th style="padding: 12px 15px; border-right: 1px solid #4a6276; text-align:center;">Quantity</th>
                        <th style="padding: 12px 15px; border-right: 1px solid #4a6276;">Category</th>
                        <th style="padding: 12px 15px; border-right: 1px solid #4a6276; max-width:300px; word-wrap:break-word;">Description</th>
                        <th style="padding: 12px 15px; text-align:center;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                <% for (Product product : productList) { 
                    // Basic null safety for display
                    String prodId = (product!=null && product.getId()!=null)? product.getId() : "0"; // Assuming IDs are non-null int
                    String prodName = (product.getName() != null) ? product.getName() : "N/A";
                    double prodPrice = product.getPrice(); // Assuming primitive double
                    int prodQuantity = product.getQuantity(); // Assuming primitive int
                    String prodCategory = (product.getCategory() != null) ? product.getCategory() : "Uncategorized";
                    String prodDescription = (product.getDescription() != null && !product.getDescription().trim().isEmpty()) ? product.getDescription() : "No description.";
                %>
                    <tr style="background-color: #fcfdff;"> 
                        <td style="text-align:center; padding: 10px 12px; border-bottom: 1px solid #e4e9ed; color: #34495e;"><%= prodId %></td>
                        <td style="padding: 10px 12px; border-bottom: 1px solid #e4e9ed; font-weight:500; color: #2980b9;"><%= prodName %></td>
                        <td style="text-align:right; padding: 10px 12px; border-bottom: 1px solid #e4e9ed; color: #27ae60; font-weight:500;"><%= String.format("%.2f", prodPrice) %></td>
                        <td style="text-align:center; padding: 10px 12px; border-bottom: 1px solid #e4e9ed; color: <%= prodQuantity <= 5 ? "#e74c3c" : "#2c3e50" %>; font-weight: <%= prodQuantity <= 5 ? "bold" : "normal" %>;"><%= prodQuantity %></td>
                        <td style="padding: 10px 12px; border-bottom: 1px solid #e4e9ed; color: #7f8c8d;"><%= prodCategory %></td>
                        <td style="padding: 10px 12px; border-bottom: 1px solid #e4e9ed; font-size:0.88em; color:#34495e; max-width:300px; word-wrap:break-word; line-height:1.4;"><%= prodDescription %></td>
                        <td class="btn_update_delete" style="text-align:center; padding: 8px 10px; border-bottom: 1px solid #e4e9ed;">
                            <div class="action-buttons-container">
                                <a class="btn_update" href="<%= request.getContextPath() %>/Views/update_product.jsp?id=<%= prodId %>"
                                   style="text-decoration:none; background-image: linear-gradient(to right, #56ab2f, #a8e063); color:white; padding: 7px 14px; border-radius: 4px; font-size:0.85em; display:inline-block; box-shadow: 0 1px 3px rgba(0,0,0,0.1);">Update</a>
                                <a class="btn_delete" href="<%= request.getContextPath() %>/ProductServlet?action=delete&id=<%= prodId %>" onclick="return confirm('Are you sure you want to delete this product: <%= prodName.replace("'", "\\'") %>?');"
                                   style="text-decoration:none; background-image: linear-gradient(to right, #cb2d3e, #ef473a); color:white; padding: 7px 14px; border-radius: 4px; font-size:0.85em; display:inline-block; box-shadow: 0 1px 3px rgba(0,0,0,0.1);">Delete</a>
                            </div>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
    <footer style="background-image: linear-gradient(to right, #3E5151, #313D47); color: #bdc3c7; padding: 30px 20px; text-align: center; margin-top: auto; /* Pushes footer to bottom if content is short / font-size: 0.9em; line-height: 1.6; border-top: 3px solid #56ab2f; / Accent color - adjust to your primary green/theme color */">
    <div style="max-width: 1100px; margin: 0 auto; display: flex; flex-direction: column; align-items: center; gap: 15px;">

        <div class="footer-links" style="margin-bottom: 15px;">
            <a href="<%= request.getContextPath() %>/about_us.jsp" style="color: #ecf0f1; text-decoration: none; margin: 0 12px; font-weight: 500;">About Us</a>
            <span style="color: #7f8c8d;">|</span>
            <a href="<%= request.getContextPath() %>/contact.jsp" style="color: #ecf0f1; text-decoration: none; margin: 0 12px; font-weight: 500;">Contact</a>
            <span style="color: #7f8c8d;">|</span>
            <a href="<%= request.getContextPath() %>/privacy_policy.jsp" style="color: #ecf0f1; text-decoration: none; margin: 0 12px; font-weight: 500;">Privacy Policy</a>
            <span style="color: #7f8c8d;">|</span>
            <a href="<%= request.getContextPath() %>/terms_conditions.jsp" style="color: #ecf0f1; text-decoration: none; margin: 0 12px; font-weight: 500;">Terms & Conditions</a>
        </div>

        <div class="footer-social" style="margin-bottom: 15px;">
            <!-- Replace # with your actual social media links -->
            <a href="#" title="Facebook" style="color: #ecf0f1; text-decoration: none; margin: 0 10px; font-size: 1.3em;"><i class="fa fa-facebook-square"></i></a>
            <a href="#" title="Instagram" style="color: #ecf0f1; text-decoration: none; margin: 0 10px; font-size: 1.3em;"><i class="fa fa-instagram"></i></a>
            <a href="#" title="Twitter" style="color: #ecf0f1; text-decoration: none; margin: 0 10px; font-size: 1.3em;"><i class="fa fa-twitter-square"></i></a>
        </div>

        <div class="footer-copyright" style="font-size: 0.85em; color: #95a5a6;">
            © <%= new java.text.SimpleDateFormat("yyyy").format(new java.util.Date()) %> Online Grocery Inc. All Rights Reserved.
            <br>
            Designed with <i class="fa fa-heart" style="color: #e74c3c;"></i> for great shopping experiences.
        </div>

    </div>
</footer>
</body>
</html>