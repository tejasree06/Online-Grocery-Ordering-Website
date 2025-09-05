<%@ page
    import="java.sql.*, Util.DatabaseConnection, Dao.WishListOperations, Dao.CustomerOperations, java.util.ArrayList, Model.Customer"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page session="true"%>
<%@ include file="../assets/alerts.jsp"%> <%-- This include remains as is --%>
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
   
    // boolean showAlert = false; // showAlert logic from original was a bit tangled with the alert, handled by direct JS now.
    
    double wCount = 0;
    double value = 0;
    ArrayList<Customer> domains = null;
    String pageErrorMessage = null; // For displaying errors from the try-catch block

    try { 
        double wishlistValueAndQuantity[] = WishListOperations.wishlistQuantityAndvalue();
        if (wishlistValueAndQuantity != null && wishlistValueAndQuantity.length >= 2) { // Add null and length check
            wCount = wishlistValueAndQuantity[0];
            value = wishlistValueAndQuantity[1];
        } else {
            // Handle case where DAO method might return null or unexpected array
            wCount = 0; // Default value
            value = 0;  // Default value
            System.err.println("Admin Dashboard: wishlistQuantityAndvalue() returned null or invalid array.");
        }
        
        domains = CustomerOperations.emailDomains();
        if (domains == null) { // Ensure domains is not null for the loop
            domains = new ArrayList<>();
        }
    
%>
<!DOCTYPE html>
<html lang="en" style="height: 100%; margin: 0; padding: 0;">
<head>
<title>Admin Dashboard</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"> <%-- For My Profile icon --%>

<%-- <link rel="stylesheet" href="<%=request.getContextPath() %>/assets/css/nav_bar.css"> --%>
<%-- <link rel="stylesheet" href="<%=request.getContextPath() %>/assets/css/admin_dashboard.css"> --%>
<style>
    /* Basic body, table, and utility resets */
    body {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: 'Segoe UI', Arial, sans-serif; /* Typical admin panel font */
        color: #212529; /* Dark text for readability */
    }
    table {
        border-collapse: collapse;
        width: 80%; /* Adjust as needed */
        margin: 25px auto;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1); /* Subtle shadow for the table */
    }
    th, td {
        border: 1px solid #dee2e6; /* Light grey borders for cells */
        padding: 10px 14px;
        text-align: left;
        vertical-align: middle;
    }
    th {
        font-weight: 600; /* Bold headers */
    }
    /* Icon basic style */
    .fa {
        margin-left: 6px; /* Spacing for icons in links */
    }
</style>
</head>
<body style="min-height: 100%; background-image: linear-gradient(to bottom, #e9efff, #dfe9f3); padding-top: 70px; /* Account for fixed navbar */ box-sizing: border-box;">

    <nav class="navbar" style="background-image: linear-gradient(to right, #2c3e50, #34495e); color: #ecf0f1; padding: 10px 30px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.18); position: fixed; top: 0; left: 0; width: 100%; z-index: 1000; box-sizing: border-box;">
        <ul class="nav_list" style="list-style: none; margin: 0; padding: 0; display: flex; align-items: center; gap: 18px;">
            <li><a href="admin_dashboard.jsp" style="color: #ffffff; background-image: linear-gradient(to right, #1abc9c, #16a085); padding: 7px 14px; border-radius: 5px; text-decoration: none; font-size: 0.95em; font-weight:500;">Home</a></li>
            <li><a href="<%= request.getContextPath() %>/AdminProfileServlet" style="color: #bdc3c7; text-decoration: none; font-size: 0.9em; padding: 7px 10px;">My Profile <i class="fa fa-user"></i></a></li>
            
            <li><a href="add_product.jsp" style="color: #bdc3c7; text-decoration: none; font-size: 0.9em; padding: 7px 10px;">Add Product</a></li>
            <li><a href="view_product.jsp" style="color: #bdc3c7; text-decoration: none; font-size: 0.9em; padding: 7px 10px;">View Products</a></li>
            <li><a href="view_customer.jsp" style="color: #bdc3c7; text-decoration: none; font-size: 0.9em; padding: 7px 10px;">View Customers</a></li>
        </ul>
        <ul style="list-style: none; margin: 0; padding: 0;">
             <li><a href="<%= request.getContextPath() %>/logout" class="btn_logout" style="background-image: linear-gradient(to right, #e74c3c, #c0392b); color: white; padding: 8px 18px; text-decoration: none; border-radius: 5px; font-size: 0.9em; font-weight: 500; border: none; cursor: pointer; box-shadow: 0 1px 4px rgba(0,0,0,0.2);">Logout</a></li>
        </ul>
    </nav>

    <div style="max-width: 1100px; margin: 0 auto; padding: 25px 20px; box-sizing: border-box;">
        <h2 class="page_heading" style="text-align: center; font-size: 2.2em; margin-top: 10px; margin-bottom: 35px; font-weight: 400; background-image: linear-gradient(to right, #74ebd5, #acb6e5); -webkit-background-clip: text; color: transparent; padding-bottom: 8px;">
            Welcome, <span class="admin_name" style="font-weight: 600; background-image: linear-gradient(to right, #ff9a9e, #fecfef); -webkit-background-clip: text; color: transparent;">Admin!</span>
        </h2>

        <% if (pageErrorMessage != null) { // Display error if data fetching failed %>
            <div style="text-align:center; padding:15px; margin:20px auto; background-image: linear-gradient(to top, #ffdde1, #ffb8c6); border:1px solid #f48fb1; border-radius:8px; color:#c2185b; font-size:1.05em; box-shadow: 0 2px 6px rgba(200,0,50,0.1);">
                <i class="fa fa-exclamation-triangle" style="margin-right: 8px; font-size: 1.2em;"></i> <%= pageErrorMessage %>
            </div>
        <% } else { %>

            <div class="summary" style="padding: 20px; margin-bottom: 30px; background-image: linear-gradient(120deg, #fdfbfb 0%, #ebedee 100%); border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.08); text-align: center; border: 1px solid #d1d9e6;">
                <h3 style="font-size: 1.25em; color: #34495e; margin-top: 0; margin-bottom: 15px; font-weight: 500;">
                    Total Items in All Wishlists: <span style="font-weight: 700; color: #16a085;"><%= String.format("%.0f", wCount) %></span> <%-- Format to show as whole number --%>
                </h3>

                <form method="post" style="margin: 0;"> <%-- Action not needed if only JS alert --%>
                    <button type="button" name="fetchTotal" onclick="alertFunction()" style="background-image: linear-gradient(to right, #6a11cb 0%, #2575fc 100%); color: white; padding: 10px 20px; border: none; border-radius: 25px; font-size: 0.95em; cursor: pointer; font-weight: 500; line-height: 1.3; box-shadow: 0 2px 6px rgba(50,50,150,0.25);">
                        Click to Get<br>Total Wishlist Value
                    </button>
                </form>
                <script>
                    function alertFunction() { // JS stays as per original structure
                        alert("Total order value in all wishlists: Rs.<%= String.format("%.2f", value) %>");
                    }
                </script>
            </div>

            <h3 style="text-align:center; font-size: 1.4em; color: #2c3e50; margin-top: 35px; margin-bottom: 20px; font-weight: 500; border-bottom: 2px solid #7f8c8d; padding-bottom: 10px;">Customer Count by Email Domain</h3>
            <% if (domains.isEmpty()) { %>
                <p style="text-align:center; font-size: 1.05em; color: #7f8c8d; background-color:#f8f9fa; padding: 15px; border-radius: 6px;">No customer email domain data available at the moment.</p>
            <% } else { %>
                <table style="background-color: #ffffff; border: 1px solid #bdc3c7;">
                    <thead style="background-image: linear-gradient(to bottom, #34495e, #2c3e50); color: #ecf0f1;">
                        <tr>
                            <th style="padding: 12px 15px; border-right: 1px solid #4a6276;">Email Domain</th>
                            <th style="padding: 12px 15px; text-align: center;">Customer Count</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%  for(Customer domain : domains){ 
                        String domainName = (domain.getDomain() != null) ? domain.getDomain() : "Unknown";
                        int domainCount = domain.getNoOfCustomersDomains();
                    %>
                        <tr style="background-color: #f9f9f9;"> 
                            <td style="padding: 10px 15px; border-right: 1px solid #e0e0e0; border-bottom: 1px solid #e0e0e0; color: #34495e; font-weight: 500;"><%= domainName %></td>
                            <td style="padding: 10px 15px; text-align: center; border-bottom: 1px solid #e0e0e0; color: #2980b9; font-size: 1.1em; font-weight: bold;"><%= domainCount %></td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            <% } %>
        <% } // End of else block (if no pageErrorMessage) %>
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
<%
    } catch(Exception e) {
        // Store the error message to be displayed in the body
        pageErrorMessage = "An error occurred while loading dashboard data: " + e.getMessage();
        e.printStackTrace(); // Log for developer
        
        // Attempt to render a partial page with the error if the above code hasn't fully run.
        // This might be redundant if structure is correct, but provides a fallback.
        // Note: if error happens *before* <!DOCTYPE html>, this out.println will be in wrong place.
        if (out != null && domains == null) { // Check if 'out' is available and critical data is not loaded
             out.println("<!DOCTYPE html><html lang=\"en\"><head><title>Error</title><style>body{font-family:Arial,sans-serif; padding:20px; text-align:center; background-color:#fdecea; color:#a94442;} .error-box{background-color:#f2dede; border:1px solid #ebccd1; padding:15px; border-radius:5px;}</style></head><body>");
             out.println("<div class='error-box'><h2>Dashboard Unavailable</h2><p>We encountered an issue loading the dashboard data. Please try again later.</p><p><i>Error: " + e.getMessage() + "</i></p></div>");
             out.println("</body></html>");
        }
    } 
%>