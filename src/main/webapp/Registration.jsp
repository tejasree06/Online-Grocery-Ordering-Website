<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
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

  <section id="registration_page" style="width: 100%; padding: 20px; box-sizing: border-box;">
    <div class="register" style="background-color: #ffffff; padding: 30px 40px; border-radius: 10px; box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1); width: 100%; max-width: 420px; margin: 0 auto; text-align: center; box-sizing: border-box;">
      <h1 class="logo" style="font-size: 2.5em; font-weight: 700; color: #007bff; margin-bottom: 15px; letter-spacing: -1px; margin-top: 0; padding: 0; box-sizing: border-box;">Online Grocery</h1>
      <h2 class="title_create_account" style="font-size: 1.8em; color: #333; margin-bottom: 10px; font-weight: 600; margin-top: 0; padding: 0; box-sizing: border-box;">Create Account</h2>
      <p class="description_signup" style="font-size: 0.95em; color: #666; margin-bottom: 25px; margin-top: 0; padding: 0; box-sizing: border-box;">Please sign up to continue</p>

      <form action="<%= request.getContextPath() %>/RegisterCustomerServlet" id="register_details" method="post" onsubmit="return validatePasswords()" style="display: flex; flex-direction: column; box-sizing: border-box;">
        <div class="user_details" style="position: relative; margin-bottom: 20px; text-align: left; box-sizing: border-box;">
          <label for="customer_name" style="display: none;"></label>
          <i class="fa fa-user-o" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #aaa; font-size: 1.1em;"></i>
          <input type="text" id="customer_name" name="customername" placeholder="NAME" maxlength="50" pattern="^(?=.*[a-zA-Z])[A-Za-z ]+$" onkeypress="return /^[a-zA-Z\s]*$/.test(event.key)" required
                 style="width: 100%; padding: 12px 15px 12px 45px; border: 1px solid #ddd; border-radius: 6px; font-size: 0.95em; color: #333; transition: border-color 0.3s ease, box-shadow 0.3s ease; box-sizing: border-box;">
        </div>

        <div class="user_details" style="position: relative; margin-bottom: 20px; text-align: left; box-sizing: border-box;">
          <label for="email_id" style="display: none;"></label>
          <i class="fa fa-envelope-o" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #aaa; font-size: 1.1em;"></i>
          <input type="email" id="email_id" name="email" placeholder="EMAIL" pattern="^[a-zA-Z0-9._]+@[a-zA-Z]+\.[a-zA-Z]{2,}$" title="Enter a Valid email." onkeypress="return /[^\s]$/.test(event.key)" required
                 style="width: 100%; padding: 12px 15px 12px 45px; border: 1px solid #ddd; border-radius: 6px; font-size: 0.95em; color: #333; transition: border-color 0.3s ease, box-shadow 0.3s ease; box-sizing: border-box;">
          <% if (request.getAttribute("errorMessage") != null) { %>
            <p class="error-message" style="color: #dc3545; font-size: 0.9em; text-align: left; background-color: transparent; border: none; padding: 5px 0 0 0; margin-top: -10px; margin-bottom: 10px; box-sizing: border-box;"><%= request.getAttribute("errorMessage") %></p>
          <% } %>
        </div>

        <div class="user_details" style="position: relative; margin-bottom: 20px; text-align: left; box-sizing: border-box;">
          <label for="address" style="display: none;"></label>
          <i class="fa fa-address-card-o" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #aaa; font-size: 1.1em;"></i>
          <input type="text" id="address" name="address" placeholder="ADDRESS" required
                 style="width: 100%; padding: 12px 15px 12px 45px; border: 1px solid #ddd; border-radius: 6px; font-size: 0.95em; color: #333; transition: border-color 0.3s ease, box-shadow 0.3s ease; box-sizing: border-box;">
        </div>

        <div class="user_details" style="position: relative; margin-bottom: 20px; text-align: left; box-sizing: border-box;">
          <label for="contant_number" style="display: none;"></label>
          <i class="fa fa-mobile" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #aaa; font-size: 1.1em;"></i>
          <input type="tel" id="contant_number" name="contact" placeholder="MOBILE NUMBER" pattern="[0-9]{10}" maxlength="10" onkeypress="return event.charCode >= 48 && event.charCode <= 57" title="Enter only 10 digits" required
                 style="width: 100%; padding: 12px 15px 12px 45px; border: 1px solid #ddd; border-radius: 6px; font-size: 0.95em; color: #333; transition: border-color 0.3s ease, box-shadow 0.3s ease; box-sizing: border-box;">
        </div>

        <div class="user_details" style="position: relative; margin-bottom: 20px; text-align: left; box-sizing: border-box;">
          <label for="password" style="display: none;"></label>
          <i class="fa fa-lock" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #aaa; font-size: 1.1em;"></i>
          <input type="password" id="password" name="password" placeholder="PASSWORD" pattern="(?=.*[a-zA-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,}" title="Password should contain at least one uppercase, one special character, one digit, and be at least 8 characters long." required
                 style="width: 100%; padding: 12px 15px 12px 45px; border: 1px solid #ddd; border-radius: 6px; font-size: 0.95em; color: #333; transition: border-color 0.3s ease, box-shadow 0.3s ease; box-sizing: border-box;">
        </div>

        <div class="user_details" style="position: relative; margin-bottom: 20px; text-align: left; box-sizing: border-box;">
          <label for="confirm_password" style="display: none;"></label>
          <span id="error-message" style="display: block; color: #dc3545; font-size: 0.85em; margin-top: -10px; margin-bottom: 10px; text-align: left; padding-left: 5px; box-sizing: border-box;"></span>
          <i class="fa fa-lock" style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #aaa; font-size: 1.1em;"></i>
          <input type="password" id="confirm_password" placeholder="CONFIRM PASSWORD"
                 style="width: 100%; padding: 12px 15px 12px 45px; border: 1px solid #ddd; border-radius: 6px; font-size: 0.95em; color: #333; transition: border-color 0.3s ease, box-shadow 0.3s ease; box-sizing: border-box;">
        </div>

        <div class="terms_conditions" style="display: flex; align-items: center; justify-content: flex-start; margin-bottom: 20px; font-size: 0.9em; color: #555; box-sizing: border-box;">
          <input type="checkbox" id="check_terms" name="terms_conditions" required
                 style="margin-right: 8px; transform: scale(1.1); accent-color: #007bff; box-sizing: border-box;">
          <label for="check_terms" style="font-weight: normal; display: inline; box-sizing: border-box;">I agree to the Terms and Conditions</label>
        </div>

        <button type="submit" class="btn_signup"
                style="background-color: #007bff; color: white; padding: 12px 20px; border: none; border-radius: 6px; cursor: pointer; font-size: 1.05em; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; transition: background-color 0.3s ease, transform 0.2s ease; margin-top: 10px; margin-bottom: 20px; box-sizing: border-box;">Sign Up</button>
      </form>

      <p class="description_signin" style="font-size: 0.95em; color: #666; margin-bottom: 0; /* Adjusted margin from original for better spacing after button */ margin-top: 0; padding: 0; box-sizing: border-box;">
        Already have an account?
        <a href="<%= request.getContextPath() %>/Login.jsp" class="signin" style="color: #007bff; text-decoration: none; font-weight: 600;">Sign in</a>
      </p>
    </div>
  </section>

  <script>
    function validatePasswords() {
      const pass = document.getElementById("password").value;
      const cpass = document.getElementById("confirm_password").value;
      const errorMessageSpan = document.getElementById("error-message"); // Renamed variable to avoid conflict

      if (pass !== cpass) {
        errorMessageSpan.textContent = "Password and confirm password are not matching";
        return false;
      } else {
        errorMessageSpan.textContent = "";
        return true;
      }
    }
    // Note: Inline CSS cannot handle :focus or :hover states.
    // For example, the input field focus outline (box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);)
    // and button hover effects (background-color: #0056b3; transform: translateY(-2px);)
    // from the original CSS will not apply with purely inline styles.
  </script>
</body>
</html>