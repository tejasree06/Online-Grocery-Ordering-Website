<%-- OnlineOrdering/src/main/webapp/Views/navbar_customer.jsp --%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    HttpSession navSession = request.getSession(false);
    boolean isLoggedIn = (navSession != null && navSession.getAttribute("customerID") != null);
%>
<!--  <nav class="navbar" style="background-image: linear-gradient(to right, #0f0c29, #302b63, #24243e); color: #e0e0e0; padding: 10px 35px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 5px 15px rgba(0, 0, 0, 0.25); position: fixed; top: 0; left: 0; width: 100%; z-index: 1000; box-sizing: border-box;">
    <ul class="nav_list" style="list-style: none; margin: 0; padding: 0; display: flex; align-items: center;">
        <li style="margin-right: 20px;"><a href="<%= request.getContextPath() %>/Home.jsp" style="color: #fafafa; text-decoration: none; font-size: 1.15em; font-weight: 500; display: flex; align-items: center; padding: 5px 0;">
            <i class="fa fa-home" aria-hidden="true" style="font-size: 1.2em; margin-right: 7px; color: #82b1ff;"></i>Home
        </a></li>
    </ul>
    <% if(isLoggedIn) { %>
    <ul class="right_nav" style="list-style: none; margin: 0; padding: 0; display: flex; align-items: center; gap: 18px;">
        <li><a href="<%= request.getContextPath() %>/profile" style="color: #cfd8dc; text-decoration: none; font-size: 0.9em; display: flex; align-items: center;">My Profile <i class="fa fa-user" style="color: #90a4ae;"></i></a></li>
        <li><a href="<%= request.getContextPath() %>/MyOrdersServlet" style="color: #cfd8dc; text-decoration: none; font-size: 0.9em; display: flex; align-items: center;">My Orders <i class="fa fa-list-alt" style="color: #90a4ae;"></i></a></li>
        <li><a href="<%= request.getContextPath() %>/Views/WishList.jsp" style="color: #cfd8dc; text-decoration: none; font-size: 0.9em; display: flex; align-items: center;">Wish List <i class="fa fa-heart" style="color: #f8bbd0;"></i></a></li>
        <li><a href="<%= request.getContextPath() %>/Views/Cart.jsp" style="color: #cfd8dc; text-decoration: none; font-size: 0.9em; display: flex; align-items: center;">Cart <i class="fa fa-shopping-cart" style="color: #78909c;"></i></a></li>
        <li><a href="<%= request.getContextPath() %>/logout" class="btn_logout" style="background-image: linear-gradient(to bottom right, #6a11cb, #2575fc); color: white; padding: 7px 18px; text-decoration: none; border-radius: 20px; font-size: 0.9em; font-weight: 500; border: none; cursor: pointer; box-shadow: 0 2px 4px rgba(0,0,0,0.2);">Logout</a></li>
    </ul>
    <% } %>
</nav>-->
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