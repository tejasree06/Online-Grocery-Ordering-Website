<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<% response.setHeader("cache-control", "no-cache, no-store, must-revalidate");
   response.setHeader("pragma", "no-cache");
   response.setHeader("Expires", "0"); %>
<!DOCTYPE html>
<html lang="en" style="height: 100%;">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
  <!-- <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/assets/css/styles.css"> <!-- Original CSS link, now commented out or removed -->
  <title>Grocery</title>
  <style>
    /* Basic body styles that are hard to inline directly on <html> or multiple elements effectively without a style tag */
    body {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }
    /* Forcing placeholder styles since ::placeholder cannot be inlined */
    input::placeholder {
        color: #bbb !important; /* Added !important to try to override browser defaults */
        opacity: 1 !important;
    }
    input:-ms-input-placeholder {
        color: #bbb !important;
    }
    input::-ms-input-placeholder {
        color: #bbb !important;
    }
  </style>
</head>
<body style="margin: 0; padding: 0; box-sizing: border-box; height: 100%; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7f6; display: flex; align-items: center; justify-content: center; color: #333; line-height: 1.6;">

  <section id="login_page" style="width: 100%; padding: 20px; box-sizing: border-box;">
    <div class="login" style="background-color: #ffffff; padding: 30px 40px; border-radius: 10px; box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1); width: 100%; max-width: 420px; margin: 0 auto; text-align: center; box-sizing: border-box;">
      <h1 class="logo" style="font-size: 2.5em; font-weight: 700; color: #007bff; margin-bottom: 15px; letter-spacing: -1px; margin-top: 0; padding: 0; box-sizing: border-box;">Online Grocery</h1>
      <h2 class="title_login_account" style="font-size: 1.8em; color: #333; margin-bottom: 10px; font-weight: 600; margin-top: 0; padding: 0; box-sizing: border-box;">Login</h2>
      <p class="description_signin" style="font-size: 0.95em; color: #666; margin-bottom: 25px; margin-top: 0; padding: 0; box-sizing: border-box;">Please sign in to continue</p>

      <% if (request.getAttribute("errorMessage") != null) { %>
        <p class="error-message" style="color: #dc3545; background-color: #f8d7da; border: 1px solid #f5c6cb; padding: 10px 15px; border-radius: 5px; margin-bottom: 15px; font-size: 0.9em; text-align: center; margin-top: 0; box-sizing: border-box;"><%= request.getAttribute("errorMessage") %></p>
      <% } %>

      <form action="<%= request.getContextPath() %>/LoginCustomerServlet" id="login_details" method="post" style="display: flex; flex-direction: column; box-sizing: border-box;">
        <div class="user_details" style="position: relative; margin-bottom: 20px; text-align: left; box-sizing: border-box;">
          <label for="customer_id" style="display: none;"></label>
          <i class="fa fa-user-o" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #aaa; font-size: 1.1em;"></i>
          <input type="text" id="customer_id" name="email" placeholder="USER EMAIL" required
                 style="width: 100%; padding: 12px 15px 12px 45px; border: 1px solid #ddd; border-radius: 6px; font-size: 0.95em; color: #333; transition: border-color 0.3s ease, box-shadow 0.3s ease; box-sizing: border-box;">
        </div>

        <div class="user_details" style="position: relative; margin-bottom: 20px; text-align: left; box-sizing: border-box;">
          <label for="password" style="display: none;"></label>
          <i class="fa fa-lock" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #aaa; font-size: 1.1em;"></i>
          <input type="password" id="password" name="password" placeholder="PASSWORD" required
                 style="width: 100%; padding: 12px 15px 12px 45px; border: 1px solid #ddd; border-radius: 6px; font-size: 0.95em; color: #333; transition: border-color 0.3s ease, box-shadow 0.3s ease; box-sizing: border-box;">
        </div>

        <button type="submit" class="btn_signin"
                style="background-color: #007bff; color: white; padding: 12px 20px; border: none; border-radius: 6px; cursor: pointer; font-size: 1.05em; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; transition: background-color 0.3s ease, transform 0.2s ease; margin-top: 10px; margin-bottom: 20px; box-sizing: border-box;">Sign In</button>
      </form>

      <p class="description_signup" style="font-size: 0.95em; color: #666; margin-bottom: 25px; margin-top: 0; padding: 0; box-sizing: border-box;">
        Don't have an account?
        <a href="<%= request.getContextPath() %>/Registration.jsp" class="signup" style="color: #007bff; text-decoration: none; font-weight: 600;">Sign up</a>
      </p>
    </div>
  </section>

  <script>
    // Disable back button after logout
    window.onload = function () {
      if (document.getElementById("login_details")) { // Check if element exists
        document.getElementById("login_details").reset();
      }
    }
    // Note: Inline CSS cannot handle :focus or :hover states.
    // For example, the input field focus outline (box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);)
    // and button hover effects (background-color: #0056b3; transform: translateY(-2px);)
    // from the original CSS will not apply with purely inline styles.
  </script>
  
</body>
</html>