<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.servlet.http.HttpSession"%>
<!DOCTYPE html>
<html lang="en" style="height: 100%; margin: 0; padding: 0;">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<%-- <link href="styles.css" rel="stylesheet"> --%> <%-- Original CSS --%>
<link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<%-- <link rel="stylesheet" type="text/css"
    href="<%= request.getContextPath() %>/assets/css/homeStyles.css"> --%> <%-- Original CSS --%>
<title>Grocery</title>
<style>
    /* Basic body styles for overall page structure */
    body {
        margin: 0;
        padding: 0;
        box-sizing: border-box; /* Apply box-sizing globally as a reset */
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        color: #333; /* Default text color, can be overridden */
    }
    /* Attempt to style placeholders (limited support without external CSS) */
    input::placeholder, textarea::placeholder {
        color: #777 !important; /* Softer placeholder color */
        opacity: 1 !important;
    }
    input:-ms-input-placeholder, textarea:-ms-input-placeholder { /* IE */
        color: #777 !important;
    }
    input::-ms-input-placeholder, textarea::-ms-input-placeholder { /* Edge */
        color: #777 !important;
    }
    /* Ensure icons inherit color properly and have some space */
    .fa {
        margin-left: 5px;
        margin-right: 2px;
    }
</style>
</head>
<body style="min-height: 100%; background-image: linear-gradient(to bottom right, #e0f7fa, #fce4ec); line-height: 1.6; padding-top: 80px; /* Account for fixed navbar */">

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

String userName = "User"; // Default
if(sessionObj.getAttribute("customerName") != null){
    userName = (String) sessionObj.getAttribute("customerName");
    // For simplicity, let's just take the first name if available
    if(userName.contains(" ")){
        userName = userName.substring(0, userName.indexOf(" "));
    }
}


ResultSet rs = null;
String searchQuery = request.getParameter("search");
String selectedCategory = request.getParameter("category");
String sortBy = request.getParameter("sortBy");

Connection connection = null;
PreparedStatement categoryPs = null;
ResultSet categoryRs = null;
PreparedStatement ps = null;

try {
    String url = "jdbc:derby:C:\\Users\\sadhu\\eclipse-workspace\\OnlineOrdering\\onlinedb;"; // Consider moving to a config file
    Class.forName("org.apache.derby.jdbc.EmbeddedDriver");
    connection = DriverManager.getConnection(url);

    String categorySql = "SELECT DISTINCT CATEGORY FROM Product ORDER BY CATEGORY ASC";
    categoryPs = connection.prepareStatement(categorySql);
    categoryRs = categoryPs.executeQuery();

    String sql = "SELECT PRODUCTNAME, PRODUCTDESC, PRODUCTPRICE, PRODUCTURL, PRODUCTID, QUANTITY FROM Product WHERE QUANTITY > 0"; // Only show in-stock
    
    if (searchQuery != null && !searchQuery.trim().isEmpty()) {
        sql += " AND LOWER(PRODUCTNAME) LIKE LOWER(?)";
    }
    if (selectedCategory != null && !selectedCategory.isEmpty()) {
        sql += " AND CATEGORY = ?";
    }

    if ("lowToHigh".equals(sortBy)) {
        sql += " ORDER BY PRODUCTPRICE ASC";
    } else if ("highToLow".equals(sortBy)) {
        sql += " ORDER BY PRODUCTPRICE DESC";
    } else {
        sql += " ORDER BY PRODUCTNAME ASC"; // Default sort
    }

    ps = connection.prepareStatement(sql);
    int paramIndex = 1;
    if (searchQuery != null && !searchQuery.trim().isEmpty()) {
        ps.setString(paramIndex++, "%" + searchQuery.trim() + "%");
    }
    if (selectedCategory != null && !selectedCategory.isEmpty()) {
        ps.setString(paramIndex++, selectedCategory);
    }

    rs = ps.executeQuery();
%>

    <!-- NAV BAR AND HOME PAGE -->
    <section id="home_page" style="padding-bottom: 20px; box-sizing: border-box;">
        <!-- Navigation bar -->
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

        <!-- Search, Filter & Sort Form -->
        <form action="<%= request.getContextPath() %>/Home.jsp" method="GET" class="filter-search"
            style="margin: 25px auto; padding: 20px 25px; background-image: linear-gradient(to bottom right, #ffffff, #f0f4f8); border-radius: 12px; box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08); display: flex; flex-wrap: wrap; justify-content: center; align-items: center; gap: 15px; max-width: 900px; box-sizing: border-box;">
            
            <input type="text" name="search" placeholder="Search products..." value="<%= (searchQuery != null) ? searchQuery : "" %>"
                   style="padding: 10px 15px; border: 1px solid #ced4da; border-radius: 20px; font-size: 0.95em; min-width: 220px; flex-grow: 1; box-shadow: inset 0 1px 3px rgba(0,0,0,0.06); background-color: #fff;">

            <select name="category" onchange="this.form.submit()"
                    style="padding: 10px 15px; border: 1px solid #ced4da; border-radius: 20px; font-size: 0.95em; background-color: #fff; cursor: pointer; min-width: 180px; flex-grow: 1;">
                <option value="">All Categories</option>
                <% while (categoryRs.next()) { 
                    String category = categoryRs.getString("CATEGORY"); // Use getColumnLabel if column name case sensitivity is an issue
                %>
                <option value="<%= category %>" <%= category.equals(selectedCategory) ? "selected" : "" %>><%= category %></option>
                <% } %>
            </select>

            <select name="sortBy" onchange="this.form.submit()"
                    style="padding: 10px 15px; border: 1px solid #ced4da; border-radius: 20px; font-size: 0.95em; background-color: #fff; cursor: pointer; min-width: 180px; flex-grow: 1;">
                <option value="">Sort By</option>
                <option value="lowToHigh" <%= "lowToHigh".equals(sortBy) ? "selected" : "" %>>Price: Low to High</option>
                <option value="highToLow" <%= "highToLow".equals(sortBy) ? "selected" : "" %>>Price: High to Low</option>
            </select>

            <button type="submit" class="btn_search" style="padding: 10px 25px; background-image: linear-gradient(to right, #11998e, #38ef7d); color: white; border: none; border-radius: 20px; font-size: 1em; font-weight: 600; cursor: pointer; box-shadow: 0 3px 8px rgba(20, 150, 130, 0.3); min-width: 120px; flex-grow: 0.5;">Search</button>
        </form>

        <!-- Product Listing -->
        <div class="home_page_details" style="padding: 0 30px; max-width: 1400px; margin: 0 auto; box-sizing: border-box;">
            <h2 class="name_display" style="text-align: center; font-size: 2.2em; color: #3E5151; /* Dark teal */ margin-bottom: 30px; font-weight: 300;">
                Hello <span class="user_name" style="font-weight: 600; color: #4a00e0;"><%= userName %>!</span>
            </h2>
            <div class="product_container" style="display: flex; flex-wrap: wrap; gap: 25px; justify-content: center; box-sizing: border-box;">
                <% 
                boolean hasProducts = false;
                while (rs.next()) { 
                    hasProducts = true;
                    String productId = rs.getString(5);
                    String productName = rs.getString(1);
                    String productDesc = rs.getString(2);
                    double productPrice = rs.getDouble(3);
                    String productUrl = rs.getString(4);
                    int maxQuantity = rs.getInt(6);
                    if(maxQuantity > 6) { maxQuantity = 6; } // Limit shown max
                %>
                <div class="product_card" style="background-image: linear-gradient(to bottom right, #fdfbfb, #ebedee); border: 1px solid #e0e0e0; border-radius: 15px; box-shadow: 0 6px 18px rgba(0, 0, 0, 0.07); width: 300px; display: flex; flex-direction: column; overflow: hidden; box-sizing: border-box; transition: transform 0.2s ease-in-out; /* No hover effect with inline :( */">
                    <div class="product_image" style="width: 100%; height: 220px; overflow: hidden; background-color: #f5f5f5;">
                        <img src="<%= request.getContextPath() %>/assets/images/<%= productUrl %>" alt="<%= productName %>"
                             style="width: 100%; height: 100%; object-fit: cover; display: block;">
                    </div>
                    <div class="product_details" style="padding: 20px; display: flex; flex-direction: column; flex-grow: 1; background-color: #fff;">
                        <div class="product_name_and_wishlist" style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 10px;">
                            <h3 class="product_name" style="font-size: 1.25em; color: #2c3e50; margin: 0; font-weight: 600; flex-grow: 1; line-height: 1.3;"><%= productName %></h3>
                            <form action="<%= request.getContextPath() %>/AddToWishListServlet" method="post" style="margin: 0; margin-left: 10px;">
                                <input type="hidden" name="productId" value="<%= productId %>">
                                <button type="submit" class="btn_wishlist" onclick="wishlistProduct()" title="Add to Wishlist"
                                        style="background-image: linear-gradient(to right, #ff8177 0%, #ff867a 0%, #ff8c7f 21%, #f99185 52%, #cf556c 78%, #b12a5b 100%); border: none; color: white; width: 38px; height: 38px; border-radius: 50%; cursor: pointer; display: flex; align-items: center; justify-content: center; font-size: 1.1em; box-shadow: 0 2px 4px rgba(200, 80, 100, 0.3);">
                                    <i class="fa fa-heart"></i>
                                </button>
                            </form>
                        </div>

                        <p class="product_description" style="font-size: 0.88em; color: #555; margin: 0 0 15px 0; flex-grow: 1; line-height: 1.5; min-height: 50px; /* Ensure some space for description */"><%= productDesc %></p>

                        <form action="<%= request.getContextPath() %>/AddToCartServlet" method="post" style="margin-top: auto;">
                            <div class="product_price_and_quantity" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
                                <h3 class="price" style="font-size: 1.3em; color: #007991; /* Deep teal/blue */ margin: 0; font-weight: 700;">Rs.<%= String.format("%.2f", productPrice) %></h3>
                                <input type="number" class="input_quantity" name="quantity" value="1" min="1" max="<%= maxQuantity %>" title="Max quantity: <%= maxQuantity %>" required
                                       style="width: 65px; padding: 8px 10px; text-align: center; border: 1px solid #ccc; border-radius: 8px; font-size: 0.95em; background-color: #fcfcfc;">
                            </div>
                            <input type="hidden" name="productId" value="<%= productId %>">
                            <button type="submit" class="btn_add_to_cart" onclick="addedProduct()"
                                    style="width: 100%; background-image: linear-gradient(to right, #00c9ff, #92fe9d); color: #004d40; /* Dark green text */ border: none; padding: 12px; border-radius: 10px; font-size: 1em; font-weight: 600; cursor: pointer; text-transform: uppercase; letter-spacing: 0.5px; box-shadow: 0 3px 8px rgba(0, 180, 200, 0.3);">Add To Cart</button>
                        </form>
                    </div>
                </div>
                <% } 
                if (!hasProducts) { %>
                <p style="font-size: 1.2em; color: #777; text-align: center; width: 100%; padding: 40px 0;">No products found matching your criteria. Try adjusting your search or filters!</p>
                <% } %>
            </div>
        </div>
    </section>
    <script>
       function addedProduct() {
            alert("Product added to cart!"); // Slightly improved alert
        }
       function wishlistProduct() {
           alert("Product added to wishlist!"); // Slightly improved alert
       }
       // Note: Effects like card hover (transform) are not applied due to inline CSS limitations.
   </script>
   <%@include file="footer.jsp" %>
</body>
</html>
<%
} catch (Exception e) {
    // A more user-friendly error could be shown on the page itself if needed
    e.printStackTrace(); // For server logs
    out.println("<p style='text-align:center; color: red; font-size:1.2em; padding: 20px;'>An error occurred while loading products. Please try again later.</p>");
} finally {
    // Close resources in finally block
    try { if (categoryRs != null) categoryRs.close(); } catch (SQLException e) { e.printStackTrace(); }
    try { if (categoryPs != null) categoryPs.close(); } catch (SQLException e) { e.printStackTrace(); }
    try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
    try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
    try { if (connection != null) connection.close(); } catch (SQLException e) { e.printStackTrace(); }
}
%>