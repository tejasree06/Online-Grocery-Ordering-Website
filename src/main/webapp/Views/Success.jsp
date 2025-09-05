<%@ page
	import="java.sql.*, Util.DatabaseConnection, Dao.WishListOperations, Dao.CustomerOperations, java.util.ArrayList, Model.Customer"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page session="true"%>
<%@ include file="../assets/alerts.jsp"%>
<%
	HttpSession sessionObj=request.getSession(false);
	
	if(sessionObj==null|| sessionObj.getAttribute("customerID")==null){
		response.sendRedirect(request.getContextPath()+"/Login.jsp");
		return;
	}
   
    
%>
<!DOCTYPE html>
<html>
<head>
<title>Orders placed</title>

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" type="text/css"
	href="<%= request.getContextPath() %>/assets/css/homeStyles.css">

</head>
<body>
	<nav class="navbar">
		<ul class="nav_list">
			<li><a href="<%= request.getContextPath() %>/Home.jsp">Home
					<i class="fa fa-home" aria-hidden="true"></i>
			</a></li>
		</ul>
		<ul class="right_nav">
			<li><a href="<%= request.getContextPath() %>/profile">My
					Profile <i class="fa fa-regular fa-user"></i>
			</a></li>
			<li><a href="<%= request.getContextPath() %>/Views/WishList.jsp">Wish
					List <i class="fa fa-light fa-heart"></i>
			</a></li>
			<li><a href="<%= request.getContextPath() %>/Views/Cart.jsp">Cart
					<i class="fa fa-shopping-cart"></i>
			</a></li>
			<li><a href="<%= request.getContextPath() %>/logout"
				class="btn_logout">Logout</a></li>
		</ul>
	</nav>



	<div class="summary">
		<h1>Order Placed Succesfully</h1>
	</div>
</body>
</html>