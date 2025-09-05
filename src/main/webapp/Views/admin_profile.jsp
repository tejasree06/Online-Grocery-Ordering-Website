<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.servlet.http.HttpSession"%>
<%@ page import="Model.Customer, Dao.*"%> <%-- Assuming Dao.CaserCipher is within Dao.* --%>
<!DOCTYPE html>
<html lang="en" style="height: 100%; margin: 0; padding: 0;">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<%-- <link href="styles.css" rel="stylesheet"> --%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"> <%-- For Font Awesome icons --%>
<%-- <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/assets/css/admin_profile.css"> --%>
<%-- <link rel="stylesheet" href="<%=request.getContextPath() %>/assets/css/nav_bar.css"> --%>
<title>Admin Profile</title>
<style>
    /* Basic body resets and utility styles */
    body {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        color: #333;
    }
    /* Placeholder styling attempt */
    input::placeholder, textarea::placeholder {
        color: #a0aec0 !important; opacity: 1 !important;
    }
    input:-ms-input-placeholder, textarea:-ms-input-placeholder { color: #a0aec0 !important; }
    input::-ms-input-placeholder, textarea::-ms-input-placeholder { color: #a0aec0 !important; }
    /* Basic icon styling */
    .fa {
        margin-left: 5px; margin-right: 3px; vertical-align: middle;
    }
</style>
</head>
<%
    HttpSession sessionObj = request.getSession(false);
    
    if ((sessionObj == null || sessionObj.getAttribute("customerID") == null)){
        response.sendRedirect(request.getContextPath() + "/Login.jsp");
        return;
    }
    else if (!(sessionObj.getAttribute("role").equals("admin"))){
        response.sendRedirect(request.getContextPath() + "/Login.jsp");
        return;
    }

    Customer customer = null;
    String customerName = "Admin"; // Default
    String email = "";
    String address = "";
    String contact = "";
    String decryptedPassword = "";
    String pageErrorMessage = null; // For potential errors from decryption

    Object customerAttr = sessionObj.getAttribute("customer");
    if (customerAttr instanceof Customer) {
        customer = (Customer) customerAttr;
        customerName = (customer.getCustomerName() != null && !customer.getCustomerName().trim().isEmpty()) ? customer.getCustomerName() : "Admin User";
        email = (customer.getEmail() != null) ? customer.getEmail() : "";
        // Address might be optional for an admin, provide default
        address = (customer.getAddress() != null && !customer.getAddress().trim().isEmpty()) ? customer.getAddress() : "N/A"; 
        contact = (customer.getContact() != null) ? customer.getContact() : "";
        
        if (customer.getPassword() != null) {
             try {
                decryptedPassword = CaserCipher.decrypt(customer.getPassword());
            } catch (Exception e) {
                decryptedPassword = "Error retrieving"; 
                pageErrorMessage = "Could not decrypt password information.";
                e.printStackTrace(); 
            }
        } else {
            decryptedPassword = ""; // Or "Not Set"
        }
    } else {
        // This case should ideally not happen if session checks are good
        pageErrorMessage = "Admin user data not found in session. Please re-login.";
        // You might want to redirect to login here as well if 'customer' is essential.
        // response.sendRedirect(request.getContextPath() + "/Login.jsp");
        // return;
    }
%>

<body style="min-height: 100%; background-image: linear-gradient(to bottom, #f0f4f8, #dde1e7); line-height: 1.6; padding-top: 75px; /* Account for fixed navbar */ box-sizing: border-box;">

    <section style="padding: 20px; display: flex; flex-direction: column; align-items: center; gap: 25px; box-sizing: border-box;">
        <!--Navigation bar-->
        <nav class="navbar" style="background-image: linear-gradient(to right, #232526, #414345); color: #e0e0e0; padding: 10px 35px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2); position: fixed; top: 0; left: 0; width: 100%; z-index: 1000; box-sizing: border-box;">
            <ul class="nav_list" style="list-style: none; margin: 0; padding: 0; display: flex; align-items: center; gap:15px;">
                <li><a href="<%= request.getContextPath() %>/Views/admin_dashboard.jsp" style="color: #cfd8dc; text-decoration: none; font-size: 0.9em; padding: 6px 10px;">Home</a></li>
                <li><a href="<%= request.getContextPath() %>/AdminProfileServlet" style="color: #ffffff; text-decoration: none; font-size: 0.9em; padding: 6px 12px; background-image: linear-gradient(to right, #007bff, #0056b3); border-radius:5px; font-weight:500;">My Profile <i class="fa fa-user" style="color:#b0bec5;"></i></a></li>
                <!-- <li><a href="<%= request.getContextPath() %>/Views/add_admin.jsp" style="color: #cfd8dc; text-decoration: none; font-size: 0.9em; padding: 6px 10px;">Add Admin</a></li>-->
                <li><a href="<%= request.getContextPath() %>/Views/add_product.jsp" style="color: #cfd8dc; text-decoration: none; font-size: 0.9em; padding: 6px 10px;">Add Product</a></li>
                <li><a href="<%= request.getContextPath() %>/Views/view_product.jsp" style="color: #cfd8dc; text-decoration: none; font-size: 0.9em; padding: 6px 10px;">View Products</a></li>
                <li><a href="<%= request.getContextPath() %>/Views/view_customer.jsp" style="color: #cfd8dc; text-decoration: none; font-size: 0.9em; padding: 6px 10px;">View Customers</a></li>
            </ul>
             <ul style="list-style: none; margin: 0; padding: 0;">
                <li><a href="<%= request.getContextPath() %>/logout" class="btn_logout" style="background-image: linear-gradient(to right, #757F9A, #D7DDE8); color: #333; padding: 7px 18px; text-decoration: none; border-radius: 20px; font-size: 0.9em; font-weight: 500; border: none; cursor: pointer; box-shadow: 0 1px 3px rgba(0,0,0,0.15);">Logout</a></li>
             </ul>
        </nav>

        <% if (pageErrorMessage != null) { %>
            <div style="width:100%; max-width: 580px; text-align:center; padding:12px 18px; margin-bottom:15px; background-image:linear-gradient(to right, #ffdde1, #ee9ca7); color:#9d2848; border:1px solid #f48fb1; border-radius:8px; font-size:0.95em;">
                <i class="fa fa-exclamation-circle" style="margin-right:8px;"></i> <%= pageErrorMessage %>
            </div>
        <% } %>

        <form action="<%= request.getContextPath() %>/profile" method="post" style="width: 100%; max-width: 580px; box-sizing: border-box;"> <%-- Action should be /AdminProfileServlet probably --%>
            <div class="container" style="display: flex; justify-content: center; width: 100%; box-sizing: border-box;">
                <div class="card" style="background-image: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%); padding: 25px 30px; border-radius: 12px; box-shadow: 0 7px 20px rgba(0, 0, 0, 0.12); width: 100%; border:1px solid #dce4f0; box-sizing: border-box;">
                    <h2 style="text-align: center; color: #2c3e50; margin-top: 0; margin-bottom: 25px; font-size: 1.7em; font-weight: 600;">Admin Account</h2>
                    
                    <div class="form-group" style="margin-bottom: 18px; position: relative;">
                        <label for="name" style="display: block; margin-bottom: 5px; font-weight: 500; color: #495057; font-size: 0.9em;">Name</label>
                        <input type="text" name="customername" id="name" value="<%= customerName %>"
                               onkeypress="return /^[a-zA-Z\s]*$/.test(event.key)" maxlength="50" required
                               style="width: 100%; padding: 9px 12px; padding-right: 30px; border: 1px solid #ced4da; border-radius: 6px; font-size: 0.95em; box-sizing: border-box; background-color: #fdfdff; color: #343a40;">
                        <span class="edit-icon" style="position: absolute; right: 10px; top: 36px; color: #78909c; font-size: 0.85em; cursor:pointer;"><i class="fa fa-pencil"></i></span>
                    </div>

                    <div class="form-group" style="margin-bottom: 18px; position: relative;">
                        <label for="email" style="display: block; margin-bottom: 5px; font-weight: 500; color: #495057; font-size: 0.9em;">Email</label>
                        <input type="email" name="email" id="email" value="<%= email %>"
                               pattern="^[a-zA-Z0-9._]+@[a-zA-Z]+\.[a-zA-Z]{2,}$"
                               onkeypress="return /[^\s]$/.test(event.key)" title="Enter a Valid email." required
                               style="width: 100%; padding: 9px 12px; padding-right: 30px; border: 1px solid #ced4da; border-radius: 6px; font-size: 0.95em; box-sizing: border-box; background-color: #fdfdff; color: #343a40;">
                        <span class="edit-icon" style="position: absolute; right: 10px; top: 36px; color: #78909c; font-size: 0.85em; cursor:pointer;"><i class="fa fa-pencil"></i></span>
                        <% if (request.getAttribute("errorMessage")!=null){ %>
                            <p class="error-message" style="color: #c62828; background-color:#ffebee; border: 1px solid #ef9a9a; padding: 8px 10px; border-radius: 5px; margin-top: 8px; font-size: 0.85em;"><%= request.getAttribute("errorMessage") %></p>
                        <% } %>
                    </div>

                    <div class="form-group" style="margin-bottom: 18px; position: relative;">
                        <label for="address" style="display: block; margin-bottom: 5px; font-weight: 500; color: #495057; font-size: 0.9em;">Address (Optional for Admin)</label>
                        <input type="text" name="address" id="address" value="<%= address %>"
                               style="width: 100%; padding: 9px 12px; padding-right: 30px; border: 1px solid #ced4da; border-radius: 6px; font-size: 0.95em; box-sizing: border-box; background-color: #fdfdff; color: #343a40;">
                        <span class="edit-icon" style="position: absolute; right: 10px; top: 36px; color: #78909c; font-size: 0.85em; cursor:pointer;"><i class="fa fa-pencil"></i></span>
                    </div>

                    <div class="form-group" style="margin-bottom: 18px; position: relative;">
                        <label for="contact" style="display: block; margin-bottom: 5px; font-weight: 500; color: #495057; font-size: 0.9em;">Mobile</label>
                        <input type="text" name="contact" id="contact" value="<%= contact %>"
                               pattern="[0-9]{10}" maxlength="10"
                               onkeypress="return event.charCode>=48 && event.charCode<=57" title="Enter only 10 digits" required
                               style="width: 100%; padding: 9px 12px; padding-right: 30px; border: 1px solid #ced4da; border-radius: 6px; font-size: 0.95em; box-sizing: border-box; background-color: #fdfdff; color: #343a40;">
                        <span class="edit-icon" style="position: absolute; right: 10px; top: 36px; color: #78909c; font-size: 0.85em; cursor:pointer;"><i class="fa fa-pencil"></i></span>
                    </div>
                    
                    <div class="form-group" style="margin-bottom: 25px; position: relative;">
                        <label for="password" style="display: block; margin-bottom: 5px; font-weight: 500; color: #495057; font-size: 0.9em;">Password</label>
                        <input type="text" name="password" id="password" value="<%= decryptedPassword %>"
                               pattern="(?=.*[a-zA-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,}" 
                               title="Password should contain at least one uppercase, one lowercase, one special character, one digit, and be at least 8 characters long." required
                               style="width: 100%; padding: 9px 12px; padding-right: 30px; border: 1px solid #ced4da; border-radius: 6px; font-size: 0.95em; box-sizing: border-box; background-color: #fdfdff; color: #343a40;">
                        <span class="edit-icon" style="position: absolute; right: 10px; top: 36px; color: #78909c; font-size: 0.85em; cursor:pointer;"><i class="fa fa-pencil"></i></span>
                    </div>

                    <button type="submit" value="Submit" style="width: 100%; background-image: linear-gradient(to right, #02aab0, #00cdac); color: white; border: none; padding: 11px 15px; border-radius: 8px; font-size: 1em; font-weight: 600; cursor: pointer; text-transform: uppercase; letter-spacing: 0.5px; margin-top: 10px; box-shadow: 0 3px 8px rgba(0, 120, 120, 0.25); box-sizing: border-box;">Update My Profile</button>
                </div>
            </div>
        </form>

        <!-- Deactivate Own Admin Account Form -->
        <form action="<%= request.getContextPath() %>/deactivatecustomer" method="post" onsubmit="return confirm('DANGER! Are you absolutely sure you want to deactivate YOUR OWN admin account? This action is irreversible and will lock you out.');" style="width: 100%; max-width: 580px; box-sizing: border-box; margin-top:15px;">
            <div class="container" style="display: flex; justify-content: center; width: 100%; box-sizing: border-box;">
                <div class="card" style="background-image: linear-gradient(135deg, #FFEEEE 0%, #FDCFCF 100%); padding: 20px 25px; border-radius: 10px; box-shadow: 0 5px 15px rgba(200, 0, 0, 0.15); width: 100%; border: 1px solid #f8c2c2; text-align:center; box-sizing: border-box;">
                    <h3 style="color: #a94442; margin-top:0; margin-bottom:12px; font-weight:500; font-size: 1.1em;">Deactivate This Admin Account</h3>
                    <input type="hidden" name="action" value="deactivate_admin_self"> <%-- Clarify action for servlet --%>
                    <button type="submit" value="delete_account" style="background-image: linear-gradient(to right, #d32f2f, #b71c1c); color: white; border: none; padding: 9px 18px; border-radius: 6px; font-size: 0.95em; font-weight: 500; cursor: pointer; box-shadow: 0 2px 6px rgba(176, 0, 32, 0.35); box-sizing: border-box;">Delete My Admin Account</button>
                </div>
            </div>
        </form>
         <%-- Placeholder for success/update message if needed later
            <div class="update" style="text-align: center; margin-top: 10px; width: 100%; max-width: 580px;">
                <% if(request.getAttribute("updateMessage")!=null){ %>
                <p id="updateMessage" style="background-image:linear-gradient(to right, #a8e063, #56ab2f); color:white; padding:10px 15px; border-radius:6px; display:inline-block; box-shadow:0 2px 6px rgba(50,150,50,0.2);"><%= request.getAttribute("updateMessage") %></p>
                <%}%>
            </div>
        --%>
    </section>
    <script>
        // Basic script to make edit icons toggle readonly (example, needs refinement for actual edit UX)
        // This is beyond inline CSS but included for interactivity.
        // Note: Direct DOM manipulation to make fields editable is better, this is a simple toggle.
        document.querySelectorAll('.edit-icon').forEach(icon => {
            icon.addEventListener('click', function() {
                const inputField = this.previousElementSibling;
                if (inputField) {
                    // For real editing, you'd change styles, perhaps enable, and have a save mechanism
                    // For now, let's just focus the input.
                    inputField.focus();
                    // Example of toggling a class:
                    // inputField.classList.toggle('editing-field');
                }
            });
        });
    </script>
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