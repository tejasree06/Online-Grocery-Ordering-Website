<%@ page
    import="java.sql.*, Util.DatabaseConnection, Dao.WishListOperations, java.util.ArrayList, Model.WishList"%>
<%@ page session="true"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%
    HttpSession sessionObj = request.getSession(false);
    if ((sessionObj == null || sessionObj.getAttribute("customerID") == null)) {
        response.sendRedirect(request.getContextPath() + "/Login.jsp");
        return;
    } else if (!(sessionObj.getAttribute("role").equals("admin"))) {
        response.sendRedirect(request.getContextPath() + "/Login.jsp");
        return;
    }

    int customerId = 0;
    String customerIdParam = request.getParameter("customerId");
    ArrayList<WishList> wl = null; 
    String pageErrorMessage = null; // For displaying errors

    if (customerIdParam == null || customerIdParam.trim().isEmpty()) {
        pageErrorMessage = "Customer ID is required to view the wishlist.";
        // To effectively show this message on view_customer.jsp, you'd need to pass it back
        // For now, we'll just redirect, but an ideal solution would use request attributes + forward
        response.sendRedirect(request.getContextPath() + "/Views/view_customer.jsp"); // Ensure this path is correct
        return;
    }

    try {
        customerId = Integer.parseInt(customerIdParam.trim());
        wl = WishListOperations.viewWishlistById(customerId);
        if (wl == null) { // Ensure wl is not null for safety in the loop
            wl = new ArrayList<>();
            // Optionally, set a message if a null return from DAO is unexpected
            // pageErrorMessage = "Could not retrieve wishlist data or wishlist is empty."; 
        }
    } catch (NumberFormatException e) {
        pageErrorMessage = "Invalid Customer ID format: '" + customerIdParam + "'. Please provide a numeric ID.";
        wl = new ArrayList<>(); // Initialize to empty list to avoid NPE later
        // Redirect or forward to an error display or back to customer list
        // For simplicity here, error will be shown on this page if wl is empty due to this
    } catch (Exception e) { 
        e.printStackTrace(); 
        pageErrorMessage = "An unexpected error occurred while retrieving the wishlist: " + e.getMessage();
        wl = new ArrayList<>(); // Initialize to empty list
    }
%>
<!DOCTYPE html>
<html lang="en" style="height: 100%; margin: 0; padding: 0;">
<head>
<title>Customer Wishlist - Admin</title>
<%-- <link rel="stylesheet" href="assets/style.css"> --%>
<%-- <link rel="stylesheet" href="<%=request.getContextPath() %>/assets/css/view_wishlist.css"> --%>
<%-- <link rel="stylesheet" href="<%=request.getContextPath() %>/assets/css/nav_bar.css"> --%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

<style>
    /* Basic body and table resets */
    body {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: 'Segoe UI', Arial, sans-serif; /* Admin panel typical font */
        color: #333;
    }
    table {
        border-collapse: collapse; /* Important for table borders */
        width: 95%; /* Make table responsive to a degree */
        margin: 25px auto; /* Center table */
    }
    th, td {
        border: 1px solid #dee2e6; /* Lighter, more modern border color */
        padding: 10px 12px; /* Spacing within cells */
        text-align: left; /* Align text to the left by default */
        vertical-align: middle; /* Align content vertically */
    }
    th {
        font-weight: 600; /* Make headers bold */
    }
    img {
        display: block; /* Remove extra space below images */
        max-width: 80px; /* Constrain image width for this table */
        max-height: 80px; /* Constrain image height */
        height: auto; /* Maintain aspect ratio */
        border-radius: 4px; /* Slightly rounded corners for images */
        border: 1px solid #f0f0f0; /* Subtle image border */
    }
    /* Icon basic style */
    .fa {
        margin-left: 5px;
    }
</style>
</head>
<body style="min-height: 100%; background-image: linear-gradient(to bottom, #f4f6f9, #e9ecef); padding-top: 70px; /* Account for fixed navbar */ box-sizing: border-box;">

    <nav class="navbar" style="background-image: linear-gradient(to right, #2c3e50, #34495e); color: #ecf0f1; padding: 10px 30px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.18); position: fixed; top: 0; left: 0; width: 100%; z-index: 1000; box-sizing: border-box;">
        <ul class="nav_list" style="list-style: none; margin: 0; padding: 0; display: flex; align-items: center; gap: 18px;">
            <li><a href="admin_dashboard.jsp" style="color: #bdc3c7; text-decoration: none; font-size: 0.9em; padding: 7px 10px;">Home</a></li>
            <li><a href="<%= request.getContextPath() %>/AdminProfileServlet" style="color: #bdc3c7; text-decoration: none; font-size: 0.9em; padding: 7px 10px;">My Profile <i class="fa fa-user"></i></a></li>
           <!-- <li><a href="add_admin.jsp" style="color: #bdc3c7; text-decoration: none; font-size: 0.9em; padding: 7px 10px;">Add Admin</a></li> -->
            <li><a href="add_product.jsp" style="color: #bdc3c7; text-decoration: none; font-size: 0.9em; padding: 7px 10px;">Add Product</a></li>
            <li><a href="view_product.jsp" style="color: #bdc3c7; text-decoration: none; font-size: 0.9em; padding: 7px 10px;">View Products</a></li>
            <li><a href="view_customer.jsp" style="color: #bdc3c7; text-decoration: none; font-size: 0.9em; padding: 7px 10px;">View Customers</a></li>
        </ul>
        <ul style="list-style: none; margin: 0; padding: 0;">
             <li><a href="<%= request.getContextPath() %>/logout" class="btn_logout" style="background-image: linear-gradient(to right, #e74c3c, #c0392b); color: white; padding: 8px 18px; text-decoration: none; border-radius: 5px; font-size: 0.9em; font-weight: 500; border: none; cursor: pointer; box-shadow: 0 1px 4px rgba(0,0,0,0.2);">Logout</a></li>
        </ul>
    </nav>

    <div style="padding: 20px; max-width: 1200px; margin: 0 auto; box-sizing: border-box;">
        <h2 style="text-align: center; color: #2c3e50; margin-top: 20px; margin-bottom: 30px; font-size: 2em; font-weight: 500; border-bottom: 2px solid #95a5a6; padding-bottom: 10px; background-image: linear-gradient(45deg, #ff9a9e 0%, #fad0c4 99%, #fad0c4 100%); -webkit-background-clip: text; color: transparent;">
            Wishlist for Customer ID: <span style="background-image: linear-gradient(45deg, #667eea 0%, #764ba2 100%); -webkit-background-clip: text; color: transparent; font-weight: 600;"><%= customerId %></span>
        </h2>

        <% if (pageErrorMessage != null) { %>
            <p style="text-align:center; font-size: 1.05em; color: #a94442; background-color: #f8d7da; border: 1px solid #f5c6cb; padding: 12px 15px; border-radius: 6px; margin-bottom: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.05);">
                <i class="fa fa-exclamation-circle" style="margin-right: 8px;"></i> <%= pageErrorMessage %>
            </p>
        <% } %>

        <% if (wl.isEmpty() && pageErrorMessage == null) { // If list is empty and no major error
        %>
            <p style="text-align:center; font-size: 1.05em; color: #155724; background-color: #d4edda; border: 1px solid #c3e6cb; padding: 12px 15px; border-radius: 6px; margin-bottom: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.05);">
                <i class="fa fa-heart-o" style="margin-right: 8px;"></i> This customer's wishlist is currently empty.
            </p>
        <% } else if (!wl.isEmpty()) { // Wishlist has items, display the table
        %>
            <table style="border: 1px solid #cbd5e0; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08); background-color: #fff;">
                <thead style="background-image: linear-gradient(to bottom, #34495e, #2c3e50); color: #f8f9fa;">
                    <tr>
                        <th style="padding: 12px 15px; border-right: 1px solid #4a6276; text-align:center;">Product ID</th>
                        <th style="padding: 12px 15px; border-right: 1px solid #4a6276; text-align:center;">Image</th>
                        <th style="padding: 12px 15px; border-right: 1px solid #4a6276;">Name</th>
                        <th style="padding: 12px 15px; border-right: 1px solid #4a6276; max-width: 300px; word-wrap: break-word;">Description</th>
                        <th style="padding: 12px 15px; border-right: 1px solid #4a6276; text-align:right;">Price (Rs.)</th>
                        <th style="padding: 12px 15px; text-align:center;">Category</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    for(WishList item: wl) {
                        // Defensive null checks for display safety
                        String itemProductIdStr = (item != null && item.getProductId() != null) ? item.getProductId() : "N/A"; // Assuming getProductId returns String
                        String itemUrl = (item != null && item.getUrl() != null && !item.getUrl().trim().isEmpty()) ? item.getUrl().trim() : "default_image.png"; 
                        String itemName = (item != null && item.getProductName() != null) ? item.getProductName() : "Unknown Product";
                        String itemDesc = (item != null && item.getProductDesc() != null && !item.getProductDesc().trim().isEmpty()) ? item.getProductDesc() : "No description provided.";
                        double itemPrice = (item != null) ? item.getPrice() : 0.0;
                        String itemCategory = (item != null && item.getCategory() != null) ? item.getCategory() : "Uncategorized";
                %>
                    <tr style="background-color: #fdfdfe;"> {/* Can alternate: index % 2 == 0 ? #fdfdfe : #f8f9fa */}
                        <td style="text-align:center; padding: 10px 12px; border-bottom: 1px solid #e9ecef; color: #343a40;"><%= itemProductIdStr %></td>
                        <td style="text-align:center; padding: 8px 10px; border-bottom: 1px solid #e9ecef;"><img src="<%= request.getContextPath() %>/assets/images/<%= itemUrl %>" alt="<%= itemName %> Image"></td>
                        <td style="padding: 10px 12px; border-bottom: 1px solid #e9ecef; color: #0056b3; font-weight: 500;"><%= itemName %></td>
                        <td style="padding: 10px 12px; border-bottom: 1px solid #e9ecef; font-size: 0.9em; color: #495057; max-width: 300px; word-wrap: break-word; line-height:1.4;"><%= itemDesc %></td>
                        <td style="text-align:right; padding: 10px 12px; border-bottom: 1px solid #e9ecef; color: #1e7e34; font-weight: 500;"><%= String.format("%.2f", itemPrice) %></td>
                        <td style="text-align:center; padding: 10px 12px; border-bottom: 1px solid #e9ecef; color: #5a6268;"><%= itemCategory %></td>
                    </tr>
                <%
                    } // End for loop
                %>
                </tbody>
            </table>
        <%
            } // End if-else for wl.isEmpty()
        %>
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