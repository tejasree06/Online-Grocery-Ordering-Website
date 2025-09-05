<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page
    import="java.sql.*, Model.Cart, Dao.CartOperations, Dao.CustomerOperations, java.util.ArrayList"%>
<%@ page import="javax.servlet.http.HttpSession"%>
<%@ page import="Model.Customer" %> <%-- Added for consistency if user name is needed --%>
<!DOCTYPE html>
<html lang="en" style="height: 100%; margin: 0; padding: 0;">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<%-- <link href="styles.css" rel="stylesheet"> --%>
<link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<%-- <link rel="stylesheet" type="text/css"
    href="<%= request.getContextPath() %>/assets/css/CartStyles.css"> --%>
<title>Grocery Cart</title>
<style>
    /* Basic body styles and resets - crucial for consistent presentation */
    body {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        color: #333; /* Default text color */
    }
    /* Attempt to style placeholders (limited support without external CSS) */
    input::placeholder, textarea::placeholder {
        color: #9e9e9e !important; /* Softer placeholder color */
        opacity: 1 !important;
    }
    input:-ms-input-placeholder, textarea:-ms-input-placeholder { /* IE */
        color: #9e9e9e !important;
    }
    input::-ms-input-placeholder, textarea::-ms-input-placeholder { /* Edge */
        color: #9e9e9e !important;
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
    int customerId=(int)sessionObj.getAttribute("customerID");
    double total=0.00;
    int totalItems=0;
    
    String address = "Not Available"; // Default address
    ArrayList<Cart> cart = null;
    String pageErrorMessage = null; // For displaying general errors

    try {
        // Fetch address (ensure CustomerOperations.getAddress is robust)
        String fetchedAddress = CustomerOperations.getAddress(customerId);
        if (fetchedAddress != null && !fetchedAddress.trim().isEmpty()) {
            address = fetchedAddress;
        }

        // Fetch cart items (ensure CartOperations.fetchCart is robust)
        cart = CartOperations.fetchCart(customerId);
        if (cart == null) { // If DAO returns null, treat as empty
            cart = new ArrayList<>();
        }
        session.setAttribute("cart-items", cart); // Set for checkout process

%>

<body style="min-height: 100%; background-image: linear-gradient(to top, #cfd9df 0%, #e2ebf0 100%); line-height: 1.6; padding-top: 75px; /* Account for fixed navbar */ box-sizing: border-box;">

    <section id="home_page" style="padding-bottom: 25px; box-sizing: border-box;">

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

        <main style="max-width: 1200px; margin: 0 auto; padding: 20px 15px; box-sizing: border-box;">
            <section class="cart_page">
                <h2 class="page_name" style="text-align: center; font-size: 2.3em; margin-bottom: 30px; font-weight: 500; background-image: linear-gradient(to right, #fc5c7d, #6a82fb); -webkit-background-clip: text; color: transparent;">Your Shopping Basket</h2>
                
                <% if (cart.isEmpty()) { %>
                    <div style="text-align: center; padding: 40px 25px; margin: 20px auto; max-width: 700px; background-image: linear-gradient(to top, #a1c4fd 0%, #c2e9fb 100%); border: 1px solid #81d4fa; border-radius: 12px; box-shadow: 0 5px 15px rgba(129, 212, 250, 0.3);">
                        <i class="fa fa-shopping-basket" style="font-size: 3em; color: #039be5; margin-bottom: 15px; display: block;"></i>
                        <p style="font-size: 1.3em; color: #1e3a8a; margin-bottom: 10px; font-weight: 500;">Your basket feels a bit light!</p>
                        <p style="font-size: 0.95em; color: #1c3d5a; line-height: 1.5;">Add some amazing products to your cart and let's get this checkout party started.</p>
                        <a href="<%= request.getContextPath() %>/Home.jsp" style="display: inline-block; margin-top: 20px; background-image: linear-gradient(to right, #4facfe 0%, #00f2fe 100%); color: #0d47a1; padding: 10px 25px; text-decoration: none; border-radius: 25px; font-weight: 600; font-size: 1em; box-shadow: 0 3px 8px rgba(0,0,0,0.1);">Explore Products</a>
                    </div>
                <% } else { %>
                    <div class="cart" style="display: flex; flex-wrap: wrap; gap: 25px; box-sizing: border-box;">

                        <div class="cart_items" style="flex: 2; min-width: 300px; box-sizing: border-box;">
                            <% for(Cart item:cart){ 
                                // Defensive coding for item properties
                                String itemUrl = (item != null && item.getUrl() != null && !item.getUrl().trim().isEmpty()) ? item.getUrl().trim() : "default_item_image.png";
                                String itemName = (item != null && item.getProductname() != null) ? item.getProductname() : "Product";
                                String itemDesc = (item != null && item.getProductDesc() != null) ? item.getProductDesc() : "No description.";
                                double itemPrice = (item != null) ? item.getPrice() : 0.0;
                                String itemProductId = (item != null && item.getProductId() != null) ? String.valueOf(item.getProductId()) : "0"; // Assuming getProductId() might return int or String
                                int itemQuantity = (item != null) ? item.getQuantity() : 0;
                                int itemMaxQuantity = (item != null) ? item.getProductQuantity() : 1;
                                int displayMax = itemMaxQuantity >= 6 ? 6 : itemMaxQuantity;
                                if (displayMax < 1) displayMax = 1; // Ensure min is at least 1

                                total += itemQuantity * itemPrice;
                                totalItems += itemQuantity;
                            %>
                            <div class="cart_item" style="display: flex; gap: 15px; align-items: flex-start; background-image: linear-gradient(135deg, #ffffff 0%, #f0f2f5 100%); padding: 18px; margin-bottom: 18px; border-radius: 10px; box-shadow: 0 4px 12px rgba(0,0,0,0.07); border: 1px solid #e4e7eb;">
                                <img src="<%= request.getContextPath() %>/assets/images/<%= itemUrl %>" alt="<%= itemName %>" style="width: 100px; height: 100px; object-fit: cover; border-radius: 8px; border: 1px solid #dfe3e8;">
                                <div class="cart_item_details" style="flex-grow: 1; display: flex; flex-direction: column;">
                                    <div class="cart_item_name_description" style="margin-bottom: 8px;">
                                        <h3 class="cart_item_name" style="font-size: 1.1em; color: #1a237e; margin: 0 0 4px 0; font-weight: 600;"><%= itemName %></h3>
                                        <p class="cart_item_description" style="font-size: 0.85em; color: #546e7a; margin: 0 0 6px 0; line-height: 1.4;"><%= itemDesc %></p>
                                        <h4 class="cart_item_price" style="font-size: 1em; color: #0d47a1; margin: 0; font-weight: 500;">Rs.<%= String.format("%.2f", itemPrice) %></h4>
                                    </div>
                                    <form action="<%= request.getContextPath() %>/QuantityUpdateServlet" method="post" style="margin-top: auto; display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 10px;">
                                        <div class="item_quantity" style="display: flex; align-items: center; gap: 8px;">
                                            <input type="hidden" name="productId" value="<%= itemProductId %>">
                                            <input type="hidden" class="input_quantity" name="oldquantity" value="<%= itemQuantity %>" min="1" required>
                                            <div class="cart_quantity">
                                                <label for="quantity_<%=itemProductId%>" style="font-size:0.8em; color: #455a64; margin-right: 5px; display:none;">Qty:</label>
                                                <input type="number" id="quantity_<%=itemProductId%>" class="input_quantity" name="quantity" value="<%= itemQuantity %>" min="1" max="<%= displayMax %>" onchange="this.form.submit()" required
                                                       style="width: 60px; padding: 7px; text-align: center; border: 1px solid #b0bec5; border-radius: 6px; font-size: 0.95em; background-color: #eceff1;">
                                            </div>
                                        </div>
                                        <button type="submit" class="btn_trash" formaction="<%= request.getContextPath() %>/RemoveFromCartServlet" title="Remove Item"
                                                style="background-image: linear-gradient(to right, #ff8a65, #ff7043); color: white; padding: 7px 12px; border: none; border-radius: 6px; cursor: pointer; font-size: 0.85em; display: flex; align-items: center; min-width: 80px; justify-content:center;">
                                            Remove <i class="fa fa-trash" style="margin-left: 5px;"></i>
                                        </button>
                                    </form>
                                </div>
                            </div>
                            <% } %>
                        </div>

                        <form action="<%= request.getContextPath() %>/checkout" method="post" style="flex: 1; min-width: 280px; box-sizing: border-box;">
                            <div class="cart_summary" style="background-image: linear-gradient(to bottom, #e0f7fa 0%, #b2ebf2 100%); padding: 20px 25px; border-radius: 10px; box-shadow: 0 5px 18px rgba(0, 0, 0, 0.1); border: 1px solid #a7ffeb;">
                                <div class="summary">
                                    <h3 style="font-size: 1.4em; color: #004d40; margin-top: 0; margin-bottom: 18px; text-align: center; border-bottom: 1px solid #4db6ac; padding-bottom: 10px;">Order Summary</h3>
                                    <div class="address" style="margin-bottom: 12px;">
                                        <p style="font-size: 0.9em; color: #00695c; margin: 0 0 4px 0; font-weight: 500;">Shipping Address:</p>
                                        <div class="cart_address" style="font-size: 0.95em; color: #004d40; background-color: #e0f2f1; padding: 8px 10px; border-radius: 5px; min-height: 30px;"><%= address %></div>
                                        <input type="hidden" name="address" value="<%= address %>">
                                    </div>

                                    <div class="subtotal" style="display: flex; justify-content: space-between; margin-bottom: 8px; font-size: 0.95em;">
                                        <p style="margin: 0; color: #00695c;">Subtotal (<%=totalItems %> Items):</p>
                                        <p class="cart_subtotal_value" style="margin: 0; color: #004d40; font-weight: 500;">Rs.<%= String.format("%.2f", total) %></p>
                                    </div>

                                    <div class="shipping" style="display: flex; justify-content: space-between; margin-bottom: 8px; font-size: 0.95em;">
                                        <p style="margin: 0; color: #00695c;">Shipping Fees:</p>
                                        <p class="cart_shipping_value" style="margin: 0; color: #004d40; font-weight: 500;">Rs.10.99</p>
                                    </div>

                                    <hr style="border: none; border-top: 1px dashed #4db6ac; margin: 15px 0;">

                                    <div class="total" style="display: flex; justify-content: space-between; font-size: 1.1em; font-weight: bold;">
                                        <p style="margin: 0; color: #004d40;">TOTAL:</p>
                                        <p class="cart_total_value" style="margin: 0; color: #004d40;">Rs.<%= String.format("%.2f", (total + 10.99)) %></p>
                                    </div>
                                    
                                    <div class="checkout" style="margin-top: 25px;">
                                        <button type="submit" class="btn_checkout" style="width: 100%; background-image: linear-gradient(to right, #00c6ff, #0072ff); color: white; padding: 12px; border: none; border-radius: 8px; font-size: 1.05em; font-weight: 600; cursor: pointer; text-transform: uppercase; letter-spacing: 0.5px; box-shadow: 0 3px 8px rgba(0, 114, 255, 0.3);">Proceed to Checkout</button>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                <% } %>
            </section>
        </main>
    </section>

<%
    String successMessage = request.getParameter("success");
    String errorMessageParam = request.getParameter("error"); // Renamed to avoid conflict with pageErrorMessage
%>
<script>
    <% if (successMessage != null && !successMessage.trim().isEmpty()) { %>
        alert("<%= successMessage.replace("\"", "\\\"").replace("\'", "\\\'") %>"); // Sanitize for JS
    <% } %>

    <% if (errorMessageParam != null && !errorMessageParam.trim().isEmpty()) { %>
        alert("<%= errorMessageParam.replace("\"", "\\\"").replace("\'", "\\\'") %>"); // Sanitize for JS
    <% } %>
    <%-- Display general page error message if set from DAO/logic failures --%>
    <% if (pageErrorMessage != null && !pageErrorMessage.trim().isEmpty()) { %>
        alert("<%= pageErrorMessage.replace("\"", "\\\"").replace("\'", "\\\'") %>"); // Sanitize for JS
    <% } %>
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
<%
    } catch(Exception e){
        e.printStackTrace(); // For server logs
        // Attempt to display an error on the page without breaking full HTML structure
        out.println("<div style='text-align:center; padding:25px; margin:80px auto 20px auto; max-width:600px; background-image: linear-gradient(to top, #fde2e2 0%, #fad0c4 100%); border:1px solid #ffab91; border-radius:10px; box-shadow: 0 3px 10px rgba(200,50,50,0.1);'>");
        out.println("<i class='fa fa-exclamation-circle' style='font-size:2.5em; color:#d32f2f; margin-bottom:12px; display:block;'></i>");
        out.println("<p style='font-size:1.2em; color:#b71c1c; font-weight:500; margin-bottom:8px;'>Error Loading Cart</p>");
        out.println("<p style='font-size:0.95em; color:#c62828;'>We encountered a problem while trying to display your shopping cart. Please try refreshing the page. If the issue persists, contact support.</p>");
        out.println("</div>");
        // It's generally better to ensure main body and html tags are closed by structure above.
        // If the exception happens mid-rendering of complex nested tags, a fully formed error display *inside* the page is tricky.
    }
%>