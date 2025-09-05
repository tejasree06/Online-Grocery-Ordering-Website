<%@ page
    import="java.sql.*, Util.*, Dao.CustomerOperations, Model.Customer, java.util.ArrayList"%>
<%@ page session="true"%>
<%@ page contentType="text/html; charset=UTF-8"%>

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

    ArrayList<Customer> customerList = null;
    String pageErrorMessage = null;

    try {
        customerList = CustomerOperations.getAllCustomers();
        if (customerList == null) { // Ensure list is not null for the loop
            customerList = new ArrayList<>();
            // pageErrorMessage = "Could not retrieve customer data or no customers found."; // Optional: set error if null is unexpected
        }
    } catch (Exception e) {
        e.printStackTrace();
        pageErrorMessage = "Error retrieving customer list: " + e.getMessage();
        customerList = new ArrayList<>(); // Initialize to empty list on error to prevent NPE in loop
    }
%>

<!DOCTYPE html>
<html lang="en" style="height: 100%; margin: 0; padding: 0;">
<head>
<title>View Customers - Admin</title>
<%-- <link rel="stylesheet" href="assets/style.css"> --%>
<link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<%-- <link rel="stylesheet"
    href="<%=request.getContextPath() %>/assets/css/nav_bar.css"> --%>
<%-- <link rel="stylesheet"
    href="<%=request.getContextPath() %>/assets/css/view_customer.css"> --%>
<style>
    /* Basic body, table, and utility resets */
    body {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: 'Segoe UI', Arial, sans-serif;
        color: #2c3e50; /* Slightly softer dark color for text */
    }
    table {
        border-collapse: collapse;
        width: 95%; /* Responsive width */
        margin: 25px auto;
        box-shadow: 0 3px 10px rgba(0,0,0,0.1); /* Subtle shadow */
    }
    th, td {
        border: 1px solid #ced4da; /* Light, neutral border */
        padding: 10px 12px;
        text-align: left;
        vertical-align: middle;
    }
    th {
        font-weight: 600; /* Bold headers */
    }
    /* Icon basic style */
    .fa {
        margin-left: 5px;
    }
</style>
</head>
<body style="min-height: 100%; background-image: linear-gradient(to bottom, #f4f6f9, #e9ecef); padding-top: 70px; /* Consistent with other admin pages */ box-sizing: border-box;">

    <nav class="navbar" style="background-image: linear-gradient(to right, #2c3e50, #34495e); color: #ecf0f1; padding: 10px 30px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.18); position: fixed; top: 0; left: 0; width: 100%; z-index: 1000; box-sizing: border-box;">
        <ul class="nav_list" style="list-style: none; margin: 0; padding: 0; display: flex; align-items: center; gap: 18px;">
            <li><a href="admin_dashboard.jsp" style="color: #bdc3c7; text-decoration: none; font-size: 0.9em; padding: 7px 10px;">Home</a></li>
            <li><a href="<%= request.getContextPath() %>/AdminProfileServlet" style="color: #bdc3c7; text-decoration: none; font-size: 0.9em; padding: 7px 10px;">My Profile <i class="fa fa-user"></i></a></li>
         <!--    <li><a href="add_admin.jsp" style="color: #bdc3c7; text-decoration: none; font-size: 0.9em; padding: 7px 10px;">Add Admin</a></li>-->
            <li><a href="add_product.jsp" style="color: #bdc3c7; text-decoration: none; font-size: 0.9em; padding: 7px 10px;">Add Product</a></li>
            <li><a href="view_product.jsp" style="color: #bdc3c7; text-decoration: none; font-size: 0.9em; padding: 7px 10px;">View Products</a></li>
            <li><a href="view_customer.jsp" style="color: #ffffff; background-image: linear-gradient(to right, #3498db, #2980b9); padding: 7px 14px; border-radius: 5px; text-decoration: none; font-size: 0.95em; font-weight:500;">View Customers</a></li>
        </ul>
        <ul style="list-style: none; margin: 0; padding: 0;">
             <li><a href="<%= request.getContextPath() %>/logout" class="btn_logout" style="background-image: linear-gradient(to right, #e74c3c, #c0392b); color: white; padding: 8px 18px; text-decoration: none; border-radius: 5px; font-size: 0.9em; font-weight: 500; border: none; cursor: pointer; box-shadow: 0 1px 4px rgba(0,0,0,0.2);">Logout</a></li>
        </ul>
    </nav>

    <div style="padding: 20px; max-width: 1200px; margin: 0 auto; box-sizing: border-box;">
        <h2 style="text-align: center; color: #2c3e50; margin-top: 20px; margin-bottom: 30px; font-size: 2.1em; font-weight: 500; border-bottom: 2px solid #7f8c8d; padding-bottom: 10px; background-image: linear-gradient(to right, #8e44ad, #9b59b6); -webkit-background-clip: text; color: transparent;">Customer Management</h2>

        <% if (pageErrorMessage != null) { %>
            <p style="text-align:center; font-size: 1.1em; color: #a94442; background-color: #f2dede; border: 1px solid #ebccd1; padding: 15px; border-radius: 6px; margin-bottom: 20px;">
                <%= pageErrorMessage %>
            </p>
        <% } %>

        <% if (customerList.isEmpty() && pageErrorMessage == null) { // If list is empty and no major error occurred %>
            <p style="text-align:center; font-size: 1.1em; color: #31708f; background-color: #d9edf7; border: 1px solid #bce8f1; padding: 15px; border-radius: 6px;">
                No customer records found in the system.
            </p>
        <% } else if (!customerList.isEmpty()) { // Only show table if there's data %>
            <table border="1" style="border: 1px solid #bcccdc; background-color: #fff;">
                <thead style="background-image: linear-gradient(to bottom, #34495e, #2c3e50); color: #ecf0f1;">
                    <tr>
                        <th style="padding: 12px 15px; border-right: 1px solid #4a6276; text-align:center;">ID</th>
                        <th style="padding: 12px 15px; border-right: 1px solid #4a6276;">Name</th>
                        <th style="padding: 12px 15px; border-right: 1px solid #4a6276;">Email</th>
                        <th style="padding: 12px 15px; border-right: 1px solid #4a6276;">Address</th>
                        <th style="padding: 12px 15px; border-right: 1px solid #4a6276; text-align:center;">Contact</th>
                        <th style="padding: 12px 15px; border-right: 1px solid #4a6276; text-align:center;">Status</th>
                        <th style="padding: 12px 15px; text-align:center;">Action</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    for(Customer customer : customerList) {
                        // Basic null checks for display safety
                        int custId = customer.getCustomerId(); // Assuming this is always int
                        String custName = (customer.getCustomerName() != null) ? customer.getCustomerName() : "N/A";
                        String custEmail = (customer.getEmail() != null) ? customer.getEmail() : "N/A";
                        String custAddress = (customer.getAddress() != null && !customer.getAddress().trim().isEmpty()) ? customer.getAddress() : "Not Provided";
                        String custContact = (customer.getContact() != null) ? customer.getContact() : "N/A";
                        String custStatus = (customer.getStatus() != null) ? customer.getStatus() : "Unknown";
                %>
                    <tr style="background-color: #fdfdfd;">
                        <td style="text-align:center; padding: 10px 12px; border-bottom: 1px solid #e0e6ef; color: #34495e;"><%= custId %></td>
                        <td style="padding: 10px 12px; border-bottom: 1px solid #e0e6ef; font-weight:500; color: #2980b9;"><%= custName %></td>
                        <td style="padding: 10px 12px; border-bottom: 1px solid #e0e6ef; color: #2c3e50;"><%= custEmail %></td>
                        <td style="padding: 10px 12px; border-bottom: 1px solid #e0e6ef; color: #34495e; font-size:0.9em;"><%= custAddress %></td>
                        <td style="text-align:center; padding: 10px 12px; border-bottom: 1px solid #e0e6ef; color: #34495e;"><%= custContact %></td>
                        <td style="text-align:center; padding: 10px 12px; border-bottom: 1px solid #e0e6ef; font-weight: 500; color: <%= "Active".equalsIgnoreCase(custStatus) ? "#27ae60" : "#c0392b" %>;"><%= custStatus %></td>
                        <td style="text-align:center; padding: 10px 12px; border-bottom: 1px solid #e0e6ef;">
                            <a class="btn_wishlist" href="view_wishlist.jsp?customerId=<%= custId %>" style="text-decoration:none; background-image: linear-gradient(to right, #8e44ad, #9b59b6); color:white; padding: 6px 12px; border-radius: 4px; font-size:0.85em; display:inline-flex; align-items:center; box-shadow: 0 1px 3px rgba(0,0,0,0.1);">
                                View Wishlist <i class="fa fa-heart" style="color:#f1c40f;"></i>
                            </a>
                        </td>
                    </tr>
                <%
                    } // End for loop
                %>
                </tbody>
            </table>
        <% } // End if-else for !customerList.isEmpty() %>
    </div>
    <br>
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