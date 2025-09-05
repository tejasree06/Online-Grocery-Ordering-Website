<%@ page session="true"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../assets/alerts.jsp"%>
<%
	HttpSession sessionObj=request.getSession(false);
if((sessionObj==null|| sessionObj.getAttribute("customerID")==null)){
	
	response.sendRedirect(request.getContextPath()+"/Login.jsp");
	return;
}
else if(!(sessionObj.getAttribute("role").equals("admin"))){
	response.sendRedirect(request.getContextPath()+"/Login.jsp");
	return;
}
%>
<!DOCTYPE html>
<html>
<head>
<title>Add Admin</title>
<link rel="stylesheet"
	href="<%=request.getContextPath() %>/assets/css/add_admin.css">
<link rel="stylesheet"
	href="<%=request.getContextPath() %>/assets/css/nav_bar.css">
</head>
<body>
	<nav class="navbar">
		<ul class="nav_list">
			<li><a href="admin_dashboard.jsp">Home</a></li>
			<li><a
				href="<%= request.getContextPath() %>/AdminProfileServlet">My
					Profile <i class="fa fa-regular fa-user"></i>
			</a></li>
			<li><a href="add_admin.jsp">Add Admin</a></li>
			<li><a href="add_product.jsp">Add Product</a></li>
			<li><a href="view_product.jsp">View Products</a></li>
			<li><a href="view_customer.jsp">View Customers</a></li>
			<li><a href="<%= request.getContextPath() %>/logout"
				class="btn_logout">Logout</a></li>
		</ul>
	</nav>
	<h2 class="page_heading">Add New Admin</h2>
	<form action="<%= request.getContextPath() %>/AddAdmin" method="post"
		class="add_admin_form">
		<label for="name" class="form_label">Full Name</label> <input
			type="text" id="name" name="name" class="form_input"
			placeholder="Enter full name"
			onkeypress="return /^[a-zA-Z\s]*$/.test(event.key)" maxlength=50
			required> <label for="email" class="form_label">Email</label>
		<input type="email" id="email" name="email" class="form_input"
			placeholder="Enter email"
			pattern="^[a-zA-Z0-9._]+@[a-zA-Z]+\.[a-zA-Z]{2,}$"
			onkeypress="return /[^\s]$/.test(event.key)"
			title="Enter a Valid email." required> <label for="password"
			class="form_label">Password</label> <input type="password"
			id="password" name="password" class="form_input"
			placeholder="Enter password"
			pattern="(?=.*[a-zA-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,}"
			title="Password should contain atleast one Upper case,atlest One special char, atleast one capital letter and length sholud be atleast 8."
			required> <label for="address" class="form_label">Address</label>
		<input type="text" id="address" name="address" class="form_input"
			placeholder="Enter address" required> <label
			for="contactNumber" class="form_label">Contact Number</label> <input
			type="text" id="contactNumber" name="contactNumber"
			class="form_input" placeholder="Enter contact number"
			pattern="[0-9]{10}" maxlength="10"
			onkeypress="return event.charCode>=48 && event.charCode<=57"
			title="Enter only 10 digits" required>

		<button type="submit" class="form_button">Add Admin</button>
		<% if (request.getAttribute("errorMessage")!=null){ %>
		<p class="error-message"><%= request.getAttribute("errorMessage") %>
			<%} %>
		
	</form>
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