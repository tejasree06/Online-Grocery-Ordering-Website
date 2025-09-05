<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page
    import="java.sql.*, Dao.WishListOperations, Model.WishList, java.util.ArrayList"%>
<%@ page import="javax.servlet.http.HttpSession"%>
<%@ page import="Model.Customer" %> <%-- Assuming Model.Customer is available for user name --%>
<!DOCTYPE html>
<html lang="en" style="height: 100%; margin: 0; padding: 0;">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<%-- <link href="styles.css" rel="stylesheet"> --%>
<link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<%-- <link rel="stylesheet" type="text/css"
    href="<%= request.getContextPath() %>/assets/css/homeStyles.css"> --%>
<title>Grocery Wishlist</title>
<style>
    /* Minimal body resets and ::placeholder attempts - essential for basic presentation */
    body {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        color: #333; /* Default text color, can be overridden */
    }
    input::placeholder { /* Attempt to style placeholders */
        color: #b0bec5 !important; opacity: 1 !important;
    }
    input:-ms-input-placeholder { color: #b0bec5 !important; }
    input::-ms-input-placeholder { color: #b0bec5 !important; }
    .fa { /* Basic icon spacing */
        margin-left: 5px; margin-right: 3px; vertical-align: middle;
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

    String displayName = "User"; // Default
    Object customerAttr = sessionObj.getAttribute("customer");
    if (customerAttr instanceof Model.Customer) {
        Model.Customer currentCustomer = (Model.Customer) customerAttr;
        if (currentCustomer.getCustomerName() != null && !currentCustomer.getCustomerName().trim().isEmpty()) {
            String fullName = currentCustomer.getCustomerName();
            displayName = fullName.contains(" ") ? fullName.substring(0, fullName.indexOf(" ")) : fullName;
        }
    }

    ArrayList<WishList> wl = null;
    String errorMessage = null; // For user-friendly error display

    try {
        wl = WishListOperations.viewWishlistById(customerId);
        if (wl == null) { // Ensure wl is not null to prevent NPE in the loop
            wl = new ArrayList<>();
        }
%>

<body style="min-height: 100%; background-image: linear-gradient(to right top, #fdfbfb, #ebedee, #dadedf, #c9ced1, #b7bfc4); line-height: 1.6; padding-top: 75px; /* Account for fixed navbar */ box-sizing: border-box;">

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

        <div class="home_page_details" style="padding: 15px 25px; max-width: 1300px; margin: 0 auto; box-sizing: border-box;">
            <h2 class="name_display" style="text-align: center; font-size: 2.1em; margin-top:10px; margin-bottom: 35px; font-weight: 400; color: black; padding: 5px 0;">
    Your Cherished Items, <span class="user_name" style="font-weight: 600;"><%= displayName %>!</span>
</h2>
            
            <% if (wl.isEmpty()) { %>
                <div style="text-align: center; padding: 35px 25px; margin: 20px auto; max-width: 650px; background-image: linear-gradient(to top, #fff1eb 0%, #ace0f9 100%); border: 1px solid #b3e5fc; border-radius: 10px; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);">
                    <i class="fa fa-heartbeat" style="font-size: 2.8em; color: #ff8a80; margin-bottom: 15px; display: block;"></i>
                    <p style="font-size: 1.25em; color: #37474f; margin-bottom: 8px;">Your Wishlist Awaits Your Treasures!</p>
                    <p style="font-size: 0.95em; color: #546e7a; line-height: 1.5;">Looks like you haven't added any items yet. <br>Click the heart on products you love to save them here.</p>
                    <a href="<%= request.getContextPath() %>/Home.jsp" style="display: inline-block; margin-top: 20px; background-image: linear-gradient(to right, #00f260, #0575e6); color: white; padding: 9px 22px; text-decoration: none; border-radius: 22px; font-weight: 500; font-size: 0.95em; box-shadow: 0 2px 6px rgba(0, 128, 0, 0.3);">Discover Products</a>
                </div>
            <% } else { %>
                <div class="product_container" style="display: flex; flex-wrap: wrap; gap: 22px; justify-content: center; box-sizing: border-box;">
                    <%  for(WishList item: wl){ 
                        String itemUrl = (item != null && item.getUrl() != null && !item.getUrl().trim().isEmpty()) ? item.getUrl().trim() : "default_product_placeholder.png";
                        String itemName = (item != null && item.getProductName() != null) ? item.getProductName() : "Product";
                        String itemDesc = (item != null && item.getProductDesc() != null) ? item.getProductDesc() : "Description not available.";
                        double itemPrice = (item != null) ? item.getPrice() : 0.0;
                       String productId = (item != null && item.getProductId()!=null) ?item.getProductId():"0"; // Must be int if your model returns int
                    %>
                    <div class="product_card" style="background-image: linear-gradient(135deg, #ffffff 0%, #ece9e6 100%); border: 1px solid #d7ccc8; border-radius: 12px; box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08); width: 290px; display: flex; flex-direction: column; overflow: hidden; box-sizing: border-box;">
                        <div class="product_image" style="width: 100%; height: 200px; overflow: hidden; background-color: #f5f5f5;">
                            <img src="<%= request.getContextPath() %>/assets/images/<%= itemUrl %>"
                                 alt="<%= itemName %>"
                                 style="width: 100%; height: 100%; object-fit: cover; display: block;">
                        </div>
                        <div class="product_details" style="padding: 18px; display: flex; flex-direction: column; flex-grow: 1; background-color: transparent;">
                            <div class="product_name_and_wishlist" style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 8px;">
                                <h3 class="product_name" style="font-size: 1.15em; color: #1a237e; /* Indigo */ margin: 0; font-weight: 600; flex-grow: 1; line-height: 1.3;"><%= itemName %></h3>
                                <form action="<%= request.getContextPath() %>/RemoveFromWishList" method="post" style="margin: 0 0 0 8px; padding:0;">
                                    <input type="hidden" name="productId" value="<%= productId %>">
                                    <button class="btn_wishlist" onclick="removeWishlistProduct()" title="Remove from Wishlist"
                                            style="background-image: linear-gradient(to top, #ff0844 0%, #ffb199 100%); border: none; color: white; width: 36px; height: 36px; border-radius: 50%; cursor: pointer; display: flex; align-items: center; justify-content: center; font-size: 1em; box-shadow: 0 1px 3px rgba(200, 0, 50, 0.3);">
                                        <i class="fa fa-times" style="margin:0;"></i>
                                    </button>
                                </form>
                            </div>
                            <p class="product_description" style="font-size: 0.85em; color: #424242; margin: 0 0 12px 0; flex-grow: 1; line-height: 1.4; min-height: 45px;"><%= itemDesc %></p>
                            <form action="<%= request.getContextPath() %>/AddToCartServlet" method="post" style="margin-top: auto;">
                                <div class="product_price_and_quantity" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
                                    <h3 class="price" style="font-size: 1.2em; color: #2e7d32; /* Green */ margin: 0; font-weight: bold;">Rs.<%= String.format("%.2f", itemPrice) %></h3>
                                    <input type="number" class="input_quantity" name="quantity" value="1" min="1" required
                                           style="width: 60px; padding: 7px 9px; text-align: center; border: 1px solid #a5d6a7; border-radius: 6px; font-size: 0.9em; background-color: #e8f5e9;">
                                </div>
                                <input type="hidden" name="productId" value="<%= productId %>">
                                <button type="submit" class="btn_add_to_cart" onclick="addedProduct()"
                                        style="width: 100%; background-image: linear-gradient(to right, #ff758c 0%, #ff7eb3 100%); color: white; border: none; padding: 11px; border-radius: 8px; font-size: 0.95em; font-weight: 500; cursor: pointer; text-transform: uppercase; letter-spacing: 0.4px; box-shadow: 0 2px 5px rgba(255, 100, 150, 0.3);">Move to Cart</button>
                            </form>
                        </div>
                    </div>
                    <% } // End for loop %>
                </div>
            <% } // End if-else empty wl %>
        </div>
    </section>
    <script>
       function addedProduct() {
            alert("Product added to cart"); // Kept original as requested
        }
       function removeWishlistProduct() {
           alert("Product removed from wishlist"); // Kept original
       }
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
        // User-friendly error display if something goes wrong loading wishlist data
        out.println("<div style='text-align:center; padding:25px; margin:80px auto 20px auto; max-width:600px; background-image: linear-gradient(to top, #ffcbd1 0%, #fce1e4 100%); border:1px solid #f48fb1; border-radius:10px; box-shadow: 0 3px 10px rgba(200,0,0,0.1);'>");
        out.println("<i class='fa fa-server' style='font-size:2.5em; color:#c62828; margin-bottom:12px; display:block;'></i>");
        out.println("<p style='font-size:1.2em; color:#ad1457; font-weight:500; margin-bottom:8px;'>We're having a little trouble...</p>");
        out.println("<p style='font-size:0.95em; color:#880e4f;'>Your wishlist couldn't be loaded right now. Please refresh the page or try again in a few moments.</p>");
        out.println("</div>");
        // Ensure remaining HTML of body and html tags are closed if error happens mid-page, though 'return' in session check handles this better.
        // This catch is primarily for errors *after* session check during data fetching or rendering.
    }
%>