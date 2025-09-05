<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.servlet.http.HttpSession"%>
<%@ page import="Model.Customer, Dao.CaserCipher"%> <%-- Removed Dao.CustomerOperations.* as it's not used directly in this JSP part --%>
<!DOCTYPE html>
<html lang="en" style="height: 100%; margin: 0; padding: 0;">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<%-- <link href="styles.css" rel="stylesheet"> --%>
<link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<%-- <link rel="stylesheet" type="text/css"
    href="<%= request.getContextPath() %>/assets/css/profileStyles.css"> --%>
<title>Grocery Profile</title>
<style>
    /* Basic body styles and resets */
    body {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        color: #333; /* Default text color */
    }
    /* Attempt to style placeholders (limited support without external CSS) */
    input::placeholder, textarea::placeholder {
        color: #a0aec0 !important; /* Lighter placeholder color */
        opacity: 1 !important;
    }
    input:-ms-input-placeholder, textarea:-ms-input-placeholder { /* IE */
        color: #a0aec0 !important;
    }
    input::-ms-input-placeholder, textarea::-ms-input-placeholder { /* Edge */
        color: #a0aec0 !important;
    }
    /* Ensure icons inherit color properly and have some space */
    .fa {
        margin-left: 5px;
        margin-right: 3px;
        vertical-align: middle; /* Better alignment with text */
    }
</style>
</head>
<%
    HttpSession sessionObj=request.getSession(false);
    
    if((sessionObj==null|| sessionObj.getAttribute("customerID")==null) ){
        response.sendRedirect(request.getContextPath()+"/Login.jsp");
        return;
    }
    else if(!(sessionObj.getAttribute("role")).equals("customer")){
        response.sendRedirect(request.getContextPath()+"/Login.jsp");
        return;
    }
    Customer customer = null;
    String customerName = "Guest";
    String email = "";
    String address = "";
    String contact = "";
    String decryptedPassword = "";

    Object customerAttr = sessionObj.getAttribute("customer");
    if (customerAttr instanceof Customer) {
        customer = (Customer) customerAttr;
        customerName = customer.getCustomerName() != null ? customer.getCustomerName() : "N/A";
        email = customer.getEmail() != null ? customer.getEmail() : "N/A";
        address = customer.getAddress() != null ? customer.getAddress() : "N/A";
        contact = customer.getContact() != null ? customer.getContact() : "N/A";
        if (customer.getPassword() != null) {
             try {
                decryptedPassword = CaserCipher.decrypt(customer.getPassword());
            } catch (Exception e) {
                // Log error or handle appropriately, e.g., show "Error decrypting password"
                decryptedPassword = "Could not display"; 
                e.printStackTrace(); 
            }
        } else {
            decryptedPassword = "";
        }
    } else {
        // Handle case where customer object is not found or is of wrong type, redirect or show error
        response.sendRedirect(request.getContextPath()+"/Login.jsp?error=session_invalid");
        return;
    }
%>

<body style="min-height: 100%; background-image: linear-gradient(to top left, #e0f2f1, #e1f5fe); line-height: 1.6; padding-top: 80px; /* Account for fixed navbar */ box-sizing: border-box;">

    <section style="padding: 20px; display: flex; flex-direction: column; align-items: center; gap: 30px; box-sizing: border-box;">
        <!--Navigation bar-->
       <!--  <nav class="navbar" style="background-image: linear-gradient(to right, #673ab7, #3f51b5); color: white; padding: 10px 40px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2); position: fixed; top: 0; left: 0; width: 100%; z-index: 1000; box-sizing: border-box;">
            <ul class="nav_list" style="list-style: none; margin: 0; padding: 0; display: flex; align-items: center;">
                <li style="margin-right: 25px;"><a href="<%= request.getContextPath() %>/Home.jsp" style="color: white; text-decoration: none; font-size: 1.2em; font-weight: 600; display: flex; align-items: center;">
                    <i class="fa fa-home" aria-hidden="true" style="font-size: 1.2em; margin-right: 8px;"></i>Home
                </a></li>
            </ul>
            <ul class="right_nav" style="list-style: none; margin: 0; padding: 0; display: flex; align-items: center;">
                <li style="margin-left: 20px;"><a href="<%= request.getContextPath() %>/profile" style="color: #c5cae9; text-decoration: none; font-size: 0.95em; display: flex; align-items: center; font-weight: 500;">My Profile <i class="fa fa-user" style="color: #b39ddb;"></i></a></li>
                <li style="margin-left: 20px;"><a href="<%= request.getContextPath() %>/MyOrdersServlet" style="color: white; text-decoration: none; font-size: 0.95em; display: flex; align-items: center;">My Orders <i class="fa fa-list-alt" style="color: #b39ddb;"></i></a></li>
                <li style="margin-left: 20px;"><a href="<%= request.getContextPath() %>/Views/WishList.jsp" style="color: white; text-decoration: none; font-size: 0.95em; display: flex; align-items: center;">Wish List <i class="fa fa-heart" style="color: #f8bbd0;"></i></a></li>
                <li style="margin-left: 20px;"><a href="<%= request.getContextPath() %>/Views/Cart.jsp" style="color: white; text-decoration: none; font-size: 0.95em; display: flex; align-items: center;">Cart <i class="fa fa-shopping-cart" style="color: #90caf9;"></i></a></li>
                <li style="margin-left: 25px;"><a href="<%= request.getContextPath() %>/logout" class="btn_logout" style="background-image: linear-gradient(to right, #d32f2f, #f44336); color: white; padding: 8px 18px; text-decoration: none; border-radius: 20px; font-size: 0.95em; font-weight: 500; border: none; cursor: pointer; box-shadow: 0 2px 5px rgba(0,0,0,0.15);">Logout</a></li>
            </ul>
        </nav> -->
        <nav class="navbar" style="background-image: linear-gradient(to right, #4a00e0, #8e2de2); color: white; padding: 10px 40px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2); position: fixed; top: 0; left: 0; width: 100%; z-index: 1000; box-sizing: border-box;">
            <ul class="nav_list" style="list-style: none; margin: 0; padding: 0; display: flex; align-items: center;">
                <li style="margin-right: 25px;"><a href="<%= request.getContextPath() %>/Home.jsp" style="color: white; text-decoration: none; font-size: 1.3em; font-weight: 600; display: flex; align-items: center;">
                    <i class="fa fa-home" aria-hidden="true" style="font-size: 1.2em; margin-right: 8px;"></i>Home
                </a></li>
            </ul>
            <ul class="right_nav" style="list-style: none; margin: 0; padding: 0; display: flex; align-items: center;">
                <li style="margin-left: 20px;"><a href="<%= request.getContextPath() %>/profile" style="color: white; text-decoration: none; font-size: 0.95em; display: flex; align-items: center;">My Profile <i class="fa fa-user" style="color: #ede7f6;"></i></a></li>
               
                <li style="margin-left: 20px;"><a href="<%= request.getContextPath() %>/Views/WishList.jsp" style="color: white; text-decoration: none; font-size: 0.95em; display: flex; align-items: center;">Wish List <i class="fa fa-heart" style="color: #f8bbd0;"></i></a></li>
                <li style="margin-left: 20px;"><a href="<%= request.getContextPath() %>/MyOrdersServlet" style="color: white; text-decoration: none; font-size: 0.95em; display: flex; align-items: center;">My Orders <i class="fa fa-list-alt" style="color: #ede7f6;"></i></a></li>
                <li style="margin-left: 20px;"><a href="<%= request.getContextPath() %>/Views/Cart.jsp" style="color: white; text-decoration: none; font-size: 0.95em; display: flex; align-items: center;">Cart <i class="fa fa-shopping-cart" style="color: #c5cae9;"></i></a></li>
                <li style="margin-left: 25px;"><a href="<%= request.getContextPath() %>/logout" class="btn_logout" style="background-image: linear-gradient(to right, #ff7e5f, #feb47b); color: white; padding: 8px 18px; text-decoration: none; border-radius: 20px; font-size: 0.95em; font-weight: 500; border: none; cursor: pointer; box-shadow: 0 2px 5px rgba(0,0,0,0.15);">Logout</a></li>
            </ul>
        </nav>

        <!-- Profile Update Form -->
        <form action="<%= request.getContextPath() %>/profile" method="post" style="width: 100%; max-width: 600px; box-sizing: border-box;">
            <div class="container" style="display: flex; justify-content: center; width: 100%; box-sizing: border-box;">
                <div class="card" style="background-image: linear-gradient(135deg, #ffffff 0%, #f0f4f8 100%); padding: 25px 30px; border-radius: 12px; box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1); width: 100%; box-sizing: border-box;">
                    <h2 style="text-align: center; color: #2c3e50; margin-top: 0; margin-bottom: 25px; font-size: 1.8em; font-weight: 600;">My Account</h2>
                    
                    <div class="form-group" style="margin-bottom: 20px; position: relative;">
                        <label for="name" style="display: block; margin-bottom: 6px; font-weight: 500; color: #4a5568; font-size: 0.9em;">Name</label>
                        <input type="text" name="customername" id="name" value="<%= customerName %>"
                               onkeypress="return /^[a-zA-Z\s]*$/.test(event.key)" maxlength="50" required
                               style="width: 100%; padding: 10px 12px; padding-right: 35px; /* space for icon */ border: 1px solid #cbd5e0; border-radius: 8px; font-size: 1em; box-sizing: border-box; background-color: #fdfdfe; color: #2d3748;">
                        <span class="edit-icon" style="position: absolute; right: 12px; top: 38px; /* Adjust top based on input+label */ color: #718096; font-size: 0.9em;"><i class="fa fa-pencil"></i></span>
                    </div>

                    <div class="form-group" style="margin-bottom: 20px; position: relative;">
                        <label for="email" style="display: block; margin-bottom: 6px; font-weight: 500; color: #4a5568; font-size: 0.9em;">Email</label>
                        <input type="email" name="email" id="email" value="<%= email %>"
                               pattern="^[a-zA-Z0-9._]+@[a-zA-Z]+\.[a-zA-Z]{2,}$"
                               onkeypress="return /[^\s]$/.test(event.key)" title="Enter a Valid email." required
                               style="width: 100%; padding: 10px 12px; padding-right: 35px; border: 1px solid #cbd5e0; border-radius: 8px; font-size: 1em; box-sizing: border-box; background-color: #fdfdfe; color: #2d3748;">
                        <span class="edit-icon" style="position: absolute; right: 12px; top: 38px; color: #718096; font-size: 0.9em;"><i class="fa fa-pencil"></i></span>
                    </div>

                    <div class="form-group" style="margin-bottom: 20px; position: relative;">
                        <label for="address" style="display: block; margin-bottom: 6px; font-weight: 500; color: #4a5568; font-size: 0.9em;">Address</label>
                        <input type="text" name="address" id="address" value="<%= address %>" required
                               style="width: 100%; padding: 10px 12px; padding-right: 35px; border: 1px solid #cbd5e0; border-radius: 8px; font-size: 1em; box-sizing: border-box; background-color: #fdfdfe; color: #2d3748;">
                        <span class="edit-icon" style="position: absolute; right: 12px; top: 38px; color: #718096; font-size: 0.9em;"><i class="fa fa-pencil"></i></span>
                    </div>

                    <div class="form-group" style="margin-bottom: 20px; position: relative;">
                        <label for="contact" style="display: block; margin-bottom: 6px; font-weight: 500; color: #4a5568; font-size: 0.9em;">Mobile</label>
                        <input type="text" name="contact" id="contact" value="<%= contact %>"
                               pattern="[0-9]{10}" maxlength="10"
                               onkeypress="return event.charCode>=48 && event.charCode<=57" title="Enter only 10 digits" required
                               style="width: 100%; padding: 10px 12px; padding-right: 35px; border: 1px solid #cbd5e0; border-radius: 8px; font-size: 1em; box-sizing: border-box; background-color: #fdfdfe; color: #2d3748;">
                        <span class="edit-icon" style="position: absolute; right: 12px; top: 38px; color: #718096; font-size: 0.9em;"><i class="fa fa-pencil"></i></span>
                    </div>
                    
                    <div class="form-group" style="margin-bottom: 25px; position: relative;">
                        <label for="password" style="display: block; margin-bottom: 6px; font-weight: 500; color: #4a5568; font-size: 0.9em;">Password</label>
                        <input type="text" name="password" id="password" value="<%= decryptedPassword %>"
                               pattern="(?=.*[a-zA-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,}" 
                               title="Min 8 chars: 1 letter, 1 number, 1 special char" required
                               style="width: 100%; padding: 10px 12px; padding-right: 35px; border: 1px solid #cbd5e0; border-radius: 8px; font-size: 1em; box-sizing: border-box; background-color: #fdfdfe; color: #2d3748;">
                        <span class="edit-icon" style="position: absolute; right: 12px; top: 38px; color: #718096; font-size: 0.9em;"><i class="fa fa-pencil"></i></span>
                    </div>

                    <button type="submit" value="Submit" style="width: 100%; background-image: linear-gradient(to right, #1fa2ff, #12d8fa, #a6ffcb); color: #004085; border: none; padding: 12px 15px; border-radius: 8px; font-size: 1.1em; font-weight: 600; cursor: pointer; text-transform: uppercase; letter-spacing: 0.5px; margin-top: 10px; box-shadow: 0 4px 10px rgba(0, 123, 255, 0.2); box-sizing: border-box;">Update Profile</button>
                    
                    <% if (request.getAttribute("errorMessage")!=null){ %>
                        <p class="error-message" style="color: white; background-image: linear-gradient(to right, #c62828, #e53935); padding: 10px 15px; border-radius: 6px; margin-top: 20px; font-size: 0.95em; text-align: center; box-sizing: border-box;"><%= request.getAttribute("errorMessage") %></p>
                    <%} %>
                </div>
            </div>
        </form>

        <!-- Deactivate Account Form -->
        <form action="<%= request.getContextPath() %>/deactivatecustomer" method="post" onsubmit="return confirm('Are you sure you want to deactivate your account? This action cannot be undone.');" style="width: 100%; max-width: 600px; box-sizing: border-box;">
            <div class="container" style="display: flex; justify-content: center; width: 100%; box-sizing: border-box;">
                <div class="card" style="background-image: linear-gradient(135deg, #fff1f2 0%, #ffcdd2 100%); padding: 25px 30px; border-radius: 12px; box-shadow: 0 6px 15px rgba(200, 0, 0, 0.1); width: 100%; box-sizing: border-box; text-align:center;">
                    <h3 style="color: #b71c1c; margin-top:0; margin-bottom:15px; font-weight:500;">Account Deactivation</h3>
                    <input type="hidden" name="action" value="delete_account"> <%-- Example hidden input --%>
                    <button type="submit" value="deactivate account" style="background-image: linear-gradient(to right, #ef5350, #d32f2f); color: white; border: none; padding: 10px 20px; border-radius: 8px; font-size: 1em; font-weight: 500; cursor: pointer; box-shadow: 0 3px 8px rgba(176, 0, 32, 0.3); box-sizing: border-box;">Delete My Account</button>
                </div>
            </div>
        </form>

        <!-- Update Message Area -->
        <div class="update" style="text-align: center; margin-top: 10px; width: 100%; max-width: 600px; box-sizing: border-box;">
            <% if(request.getAttribute("message")!=null){ %>
            <p id="message" style="background-image: linear-gradient(to right, #43a047, #66bb6a); color: white; padding: 12px 18px; border-radius: 8px; display: inline-block; box-shadow: 0 3px 8px rgba(0, 105, 0, 0.2); font-size: 1em; font-weight: 500;"><%= request.getAttribute("message") %></p>
            <%}%>
        </div>
    </section>
    <script>
        // Optional: Add any client-side logic here if needed, though not directly related to inline CSS.
        // For example, edit icon functionality if it's supposed to make fields editable
        // (but with current HTML, fields are always editable).
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