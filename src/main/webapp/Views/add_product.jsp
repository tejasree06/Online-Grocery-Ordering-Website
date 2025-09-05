<%@ page session="true"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
%>
<!DOCTYPE html>
<html lang="en" style="height: 100%; margin: 0; padding: 0;">
<head>
<title>Add Product - Admin</title>
<%-- <link rel="stylesheet" href="<%=request.getContextPath() %>/assets/css/add_product.css"> --%>
<%-- <link rel="stylesheet" href="<%=request.getContextPath() %>/assets/css/nav_bar.css"> --%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"> <%-- For icons in navbar --%>
<style>
    /* Basic body and form element resets */
    body {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: 'Segoe UI', Arial, sans-serif;
        color: #34495e; /* Consistent admin text color */
    }
    /* General styles for form inputs and textareas, will be applied inline but good for reference */
    .form_input_general { /* A general class to reduce repetition if we weren't doing pure inline */
        width: 100%;
        padding: 10px 12px;
        margin-bottom: 15px; /* Space below each input */
        border: 1px solid #ced4da;
        border-radius: 6px;
        font-size: 0.95em;
        box-sizing: border-box;
        background-color: #f8f9fa;
        color: #495057;
    }
    .form_label_general { /* General label style */
        display: block;
        margin-bottom: 6px;
        font-weight: 500;
        font-size: 0.9em;
        color: #495057;
    }
    /* Icon basic style */
    .fa {
        margin-left: 5px;
    }
</style>
</head>
<body style="min-height: 100%; background-image: linear-gradient(to bottom, #e0eafc, #cfdef3); padding-top: 70px; /* Admin theme background */ box-sizing: border-box;">

    <nav class="navbar" style="background-image: linear-gradient(to right, #2c3e50, #34495e); color: #ecf0f1; padding: 10px 30px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.18); position: fixed; top: 0; left: 0; width: 100%; z-index: 1000; box-sizing: border-box;">
        <ul class="nav_list" style="list-style: none; margin: 0; padding: 0; display: flex; align-items: center; gap: 18px;">
            <li><a href="admin_dashboard.jsp" style="color: #bdc3c7; text-decoration: none; font-size: 0.9em; padding: 7px 10px;">Home</a></li>
            <li><a href="<%= request.getContextPath() %>/AdminProfileServlet" style="color: #bdc3c7; text-decoration: none; font-size: 0.9em; padding: 7px 10px;">My Profile <i class="fa fa-user"></i></a></li>
            <!-- <li><a href="add_admin.jsp" style="color: #bdc3c7; text-decoration: none; font-size: 0.9em; padding: 7px 10px;">Add Admin</a></li>-->
            <li><a href="add_product.jsp" style="color: #ffffff; background-image: linear-gradient(to right, #f39c12, #e67e22); padding: 7px 14px; border-radius: 5px; text-decoration: none; font-size: 0.95em; font-weight:500;">Add Product</a></li>
            <li><a href="view_product.jsp" style="color: #bdc3c7; text-decoration: none; font-size: 0.9em; padding: 7px 10px;">View Products</a></li>
            <li><a href="view_customer.jsp" style="color: #bdc3c7; text-decoration: none; font-size: 0.9em; padding: 7px 10px;">View Customers</a></li>
        </ul>
        <ul style="list-style: none; margin: 0; padding: 0;">
             <li><a href="<%= request.getContextPath() %>/logout" class="btn_logout" style="background-image: linear-gradient(to right, #e74c3c, #c0392b); color: white; padding: 8px 18px; text-decoration: none; border-radius: 5px; font-size: 0.9em; font-weight: 500; border: none; cursor: pointer; box-shadow: 0 1px 4px rgba(0,0,0,0.2);">Logout</a></li>
        </ul>
    </nav>

    <div style="display: flex; flex-direction: column; align-items: center; padding: 20px; gap: 30px; box-sizing: border-box;">

        <!-- Add Single Product Form -->
        <div style="width: 100%; max-width: 650px; box-sizing: border-box;">
            <h2 class="page_heading" style="text-align: center; margin-top: 0; margin-bottom: 25px; font-size: 1.9em; font-weight: 500; background-image: linear-gradient(to right, #56ab2f, #a8e063); -webkit-background-clip: text; color: transparent; border-bottom: 2px solid #8bc34a; padding-bottom:10px;">Add New Product Manually</h2>
            <form action="<%= request.getContextPath() %>/ProductServlet" method="post" class="add_product_form" style="background-image: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%); padding: 25px 30px; border-radius: 12px; box-shadow: 0 6px 20px rgba(0,0,0,0.1); border:1px solid #d8e0ea;">
                <input type="hidden" name="action" value="add">
                
                <label for="name" class="form_label" style="display: block; margin-bottom: 6px; font-weight: 500; font-size: 0.9em; color: #495057;">Product Name</label>
                <input type="text" id="name" name="name" class="form_input" placeholder="e.g., Fresh Apples" required style="width: 100%; padding: 10px 12px; margin-bottom: 15px; border: 1px solid #ced4da; border-radius: 6px; font-size: 0.95em; box-sizing: border-box; background-color: #f8f9fa; color: #495057;">
                
                <label for="description" class="form_label" style="display: block; margin-bottom: 6px; font-weight: 500; font-size: 0.9em; color: #495057;">Description</label>
                <textarea id="description" name="description" class="form_input" placeholder="Briefly describe the product" maxlength="255" required style="width: 100%; padding: 10px 12px; margin-bottom: 15px; border: 1px solid #ced4da; border-radius: 6px; font-size: 0.95em; box-sizing: border-box; background-color: #f8f9fa; color: #495057; min-height: 80px; resize: vertical;"></textarea>

                <label for="price" class="form_label" style="display: block; margin-bottom: 6px; font-weight: 500; font-size: 0.9em; color: #495057;">Price (Rs.)</label>
                <input type="number" id="price" name="price" class="form_input" placeholder="e.g., 49.99" min="0.01" step="0.01" required title="Price should be greater than zero." style="width: 100%; padding: 10px 12px; margin-bottom: 15px; border: 1px solid #ced4da; border-radius: 6px; font-size: 0.95em; box-sizing: border-box; background-color: #f8f9fa; color: #495057;">
                
                <label for="quantity" class="form_label" style="display: block; margin-bottom: 6px; font-weight: 500; font-size: 0.9em; color: #495057;">Quantity in Stock</label>
                <input type="number" id="quantity" name="quantity" class="form_input" placeholder="e.g., 100" min="0" required title="Quantity should be zero or greater." style="width: 100%; padding: 10px 12px; margin-bottom: 15px; border: 1px solid #ced4da; border-radius: 6px; font-size: 0.95em; box-sizing: border-box; background-color: #f8f9fa; color: #495057;">
                
                <label for="url" class="form_label" style="display: block; margin-bottom: 6px; font-weight: 500; font-size: 0.9em; color: #495057;">Image File Name (e.g., product_image.jpg)</label>
                <input type="text" id="url" name="url" class="form_input" placeholder="Located in assets/images/" required style="width: 100%; padding: 10px 12px; margin-bottom: 15px; border: 1px solid #ced4da; border-radius: 6px; font-size: 0.95em; box-sizing: border-box; background-color: #f8f9fa; color: #495057;">
                
                <label for="category" class="form_label" style="display: block; margin-bottom: 6px; font-weight: 500; font-size: 0.9em; color: #495057;">Category</label>
                <input type="text" id="category" name="category" class="form_input" placeholder="e.g., Fruits, Beverages, Electronics" required style="width: 100%; padding: 10px 12px; margin-bottom: 15px; border: 1px solid #ced4da; border-radius: 6px; font-size: 0.95em; box-sizing: border-box; background-color: #f8f9fa; color: #495057;">

                <button type="submit" class="form_button" style="width: 100%; background-image: linear-gradient(to right, #1d976c, #93f9b9); color: #004d40; padding: 12px; border: none; border-radius: 8px; font-size: 1.05em; font-weight: 600; cursor: pointer; text-transform: uppercase; letter-spacing: 0.5px; margin-top: 10px; box-shadow: 0 3px 8px rgba(0, 150, 100, 0.3);">Add Product</button>
            </form>
        </div>

        <!-- Bulk Upload Form -->
        <div class="add_product_form" style="width: 100%; max-width: 650px; background-image: linear-gradient(135deg, #f2f6f8 0%, #d9e2ec 100%); padding: 25px 30px; border-radius: 12px; box-shadow: 0 6px 20px rgba(0,0,0,0.08); border:1px solid #cdd7e1; box-sizing: border-box;">
            <h2 style="text-align: center; margin-top: 0; margin-bottom: 20px; font-size: 1.7em; font-weight: 500; color: #3b5998; border-bottom: 2px solid #8b9dc3; padding-bottom:8px;">Bulk Upload Products via CSV</h2>
            <form action="<%= request.getContextPath() %>/BulckUpload" method="post" enctype="multipart/form-data" style="display: flex; flex-direction: column; align-items: flex-start; gap: 12px;">
                <label style="font-weight: 500; font-size: 0.95em; color: #4a5568;">Select CSV File:</label>
                <input type="file" name="file" accept=".csv" required style="padding: 8px; border: 1px solid #bcccdc; border-radius: 5px; background-color: #f9fbfd; font-size:0.9em; width: 100%;">
                <input type="submit" value="Upload CSV" style="align-self: center; background-image: linear-gradient(to right, #4e54c8, #8f94fb); color: white; padding: 10px 22px; border: none; border-radius: 20px; font-size: 0.95em; cursor: pointer; font-weight: 500; box-shadow: 0 2px 6px rgba(70, 80, 200, 0.3); margin-top:10px;">
            </form>
            <% String uploadMsg = (String) request.getAttribute("uploadMsg"); %>
            <% if (uploadMsg != null && !uploadMsg.trim().isEmpty()) { %>
                <p style="margin-top: 15px; padding: 10px; text-align:center; border-radius: 5px; background-color: <%= uploadMsg.toLowerCase().contains("success") ? "#e6ffed" : "#ffeeed" %>; color: <%= uploadMsg.toLowerCase().contains("success") ? "#28a745" : "#dc3545" %>; border: 1px solid <%= uploadMsg.toLowerCase().contains("success") ? "#badbcc" : "#f5c6cb" %>; font-size:0.9em; font-weight:500;"><%= uploadMsg %></p>
            <% } %>
        </div>
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