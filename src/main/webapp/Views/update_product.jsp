<%@ page session="true"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="Dao.ProductDAO, Model.*"%> <%-- Assuming Model.Product is in Model.* --%>
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

    String id = request.getParameter("id");
    ProductDAO productDAO = new ProductDAO();
    Product product = null;
    String pageErrorMessage = null;

    if (id == null || id.trim().isEmpty()) {
        // If ID is missing, redirect back to view_product.jsp, optionally with an error message
        // sessionObj.setAttribute("errorMessageViewProduct", "Product ID is required to update."); // Example for alerts.jsp
        response.sendRedirect(request.getContextPath() + "/Views/view_product.jsp");
        return;
    }

    try {
        product = productDAO.getProductById(id); // Assumes getProductById(String id)
        if (product == null) {
            // If product not found, redirect, optionally with error
            // sessionObj.setAttribute("errorMessageViewProduct", "Product with ID " + id + " not found.");
            response.sendRedirect(request.getContextPath() + "/Views/view_product.jsp");
            return;
        }
    } catch (Exception e) {
        e.printStackTrace();
        pageErrorMessage = "Error retrieving product details: " + e.getMessage();
        // If there's an error, we can't populate the form, so it's best to redirect or show a full-page error
        // For now, an error message will be shown above the form if 'product' remains null.
        // If critical, consider redirecting:
        // response.sendRedirect(request.getContextPath() + "/Views/view_product.jsp");
        // return;
    }
%>
<!DOCTYPE html>
<html lang="en" style="height: 100%; margin: 0; padding: 0;">
<head>
<title>Update Product - Admin</title>
<%-- <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/assets/css/update_product.css"> --%>
<%-- <link rel="stylesheet" href="<%=request.getContextPath() %>/assets/css/nav_bar.css"> --%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

<style>
    /* Basic body and form element resets */
    body {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: 'Segoe UI', Arial, sans-serif;
        color: #34495e; /* Consistent admin text color */
    }
    input[type="text"], input[type="number"], textarea {
        width: 100%;
        padding: 10px 12px;
        margin-bottom: 15px;
        border: 1px solid #ced4da; /* Standard border */
        border-radius: 6px;
        font-size: 0.95em;
        box-sizing: border-box; /* Important for width 100% and padding */
        background-color: #f8f9fa; /* Light background for inputs */
        color: #495057;
    }
    textarea {
        resize: vertical; /* Allow vertical resize */
        min-height: 80px;
    }
    label.form_label { /* Using a class from original HTML */
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
<body style="min-height: 100%; background-image: linear-gradient(to bottom, #eef2f3, #dbe2e7); padding-top: 70px; /* Admin theme background */ box-sizing: border-box;">

    <nav class="navbar" style="background-image: linear-gradient(to right, #2c3e50, #34495e); color: #ecf0f1; padding: 10px 30px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.18); position: fixed; top: 0; left: 0; width: 100%; z-index: 1000; box-sizing: border-box;">
        <ul class="nav_list" style="list-style: none; margin: 0; padding: 0; display: flex; align-items: center; gap: 18px;">
            <li><a href="admin_dashboard.jsp" style="color: #bdc3c7; text-decoration: none; font-size: 0.9em; padding: 7px 10px;">Home</a></li>
           <!--   <li><a href="add_admin.jsp" style="color: #bdc3c7; text-decoration: none; font-size: 0.9em; padding: 7px 10px;">Add Admin</a></li>-->
            <li><a href="add_product.jsp" style="color: #bdc3c7; text-decoration: none; font-size: 0.9em; padding: 7px 10px;">Add Product</a></li>
            <li><a href="view_product.jsp" style="color: #bdc3c7; text-decoration: none; font-size: 0.9em; padding: 7px 10px;">View Products</a></li>
            <li><a href="view_customer.jsp" style="color: #bdc3c7; text-decoration: none; font-size: 0.9em; padding: 7px 10px;">View Customers</a></li>
            <li><a href="<%= request.getContextPath() %>/AdminProfileServlet" style="color: #bdc3c7; text-decoration: none; font-size: 0.9em; padding: 7px 10px;">My Profile <i class="fa fa-user"></i></a></li>
        </ul>
        <ul style="list-style: none; margin: 0; padding: 0;">
             <li><a href="<%= request.getContextPath() %>/logout" class="btn_logout" style="background-image: linear-gradient(to right, #e74c3c, #c0392b); color: white; padding: 8px 18px; text-decoration: none; border-radius: 5px; font-size: 0.9em; font-weight: 500; border: none; cursor: pointer; box-shadow: 0 1px 4px rgba(0,0,0,0.2);">Logout</a></li>
        </ul>
    </nav>

    <div style="max-width: 700px; margin: 20px auto; padding: 25px 30px; background-image: linear-gradient(135deg, #ffffff 0%, #e9edf2 100%); border-radius: 12px; box-shadow: 0 6px 20px rgba(0,0,0,0.1); border:1px solid #d8e0ea; box-sizing: border-box;">
        <h2 class="page_heading" style="text-align: center; margin-top: 0; margin-bottom: 25px; font-size: 1.9em; font-weight: 500; background-image: linear-gradient(to right, #f39c12, #e67e22); -webkit-background-clip: text; color: transparent; border-bottom: 2px solid #f1c40f; padding-bottom:10px;">Update Product Details</h2>

        <% if (pageErrorMessage != null) { %>
            <p style="text-align:center; font-size: 1em; color: #8a6d3b; background-color: #fcf8e3; border: 1px solid #faebcc; padding: 12px; border-radius: 6px; margin-bottom: 20px;">
                <i class="fa fa-exclamation-triangle" style="margin-right:8px;"></i> <%= pageErrorMessage %>
                 <%-- If product is null due to error, can't show form --%>
                 <% if (product == null) { 
                    out.println(" Form cannot be displayed."); 
                    out.println("</div></body></html>"); // Close essential tags before returning
                    return; 
                 } %>
            </p>
        <% } else if (product == null) { // Should be caught by initial redirect, but as a fallback
             out.println("<p style='text-align:center;color:red;'>Critical error: Product data is not available. Cannot display form.</p>");
             out.println("</div></body></html>"); return;
           }
        %>

        <form action="<%= request.getContextPath() %>/ProductServlet" method="post" class="add_product_form update_product_form">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="<%= (product != null && product.getId() != null) ? product.getId() : "" %>"> <%-- getId returns String --%>

            <label for="name" class="form_label">Product Name</label>
            <input type="text" id="name" name="name" class="form_input" value="<%= (product != null && product.getName() != null) ? product.getName() : "" %>" placeholder="Enter Product Name" required>
            
            <label for="description" class="form_label">Description</label>
            <textarea id="description" name="description" class="form_input" placeholder="Enter Description" maxlength="255" required style="min-height:100px;"><%= (product != null && product.getDescription() != null) ? product.getDescription() : "" %></textarea>

            <label for="price" class="form_label">Price (Rs.)</label>
            <input type="number" id="price" name="price" class="form_input" value="<%= (product != null) ? product.getPrice() : "0.00" %>" placeholder="e.g., 199.99" min="0" step="0.01" required>

            <label for="quantity" class="form_label">Quantity</label>
            <input type="number" id="quantity" name="quantity" class="form_input" value="<%= (product != null) ? product.getQuantity() : "0" %>" placeholder="e.g., 50" min="0" required>
            
            <label for="url" class="form_label">Image URL (e.g., image_name.jpg)</label>
            <input type="text" id="url" name="url" class="form_input" value="<%= (product != null && product.getUrl() != null) ? product.getUrl() : "" %>" placeholder="Enter Image File Name (e.g., apple.jpg)" required>
            
            <label for="category" class="form_label">Category</label>
            <input type="text" id="category" name="category" class="form_input" value="<%= (product != null && product.getCategory() != null) ? product.getCategory() : "" %>" placeholder="e.g., Fruits, Electronics" required>

            <button type="submit" class="form_button" style="width: 100%; background-image: linear-gradient(to right, #00b09b, #96c93d); color: white; padding: 12px; border: none; border-radius: 8px; font-size: 1.05em; font-weight: 600; cursor: pointer; text-transform: uppercase; letter-spacing: 0.5px; margin-top: 20px; box-shadow: 0 3px 8px rgba(0, 150, 130, 0.3);">Update Product</button>
        </form>
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