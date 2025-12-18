<cfparam name="url.step" default="">

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Login Page</title>
  <link rel="stylesheet" href="../css/loginpage.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <script src="../scriptjs/loginpage.js"></script>
</head>

<body>
  <div class="form-container">
    <h2>Login</h2>

    <!-- Ensure session exists -->
    <cfif NOT structKeyExists(session,"initialized")>
      <cfset session.initialized = true>
    </cfif>

    <!-- Handle login post -->
    <cfif structKeyExists(form,"login")>
      <cfquery name="checkUser" datasource="#application.datasource#">
        SELECT id, username, password, profile_image_path, email, about, isAdmin
        FROM users
        WHERE username = <cfqueryparam value="#form.username#" cfsqltype="cf_sql_varchar">
          AND password = <cfqueryparam value="#form.password#" cfsqltype="cf_sql_varchar">
      </cfquery>

      <cfif checkUser.recordCount EQ 1>
        <cfset session.loggedIn = true>
        <cfset session.userId = checkUser.id>
        <cfset session.username = checkUser.username>
        <cfset session.profilepath = checkUser.profile_image_path>
        <cfset session.email = checkUser.email>
        <cfset session.about = checkUser.about>
        <cfset session.adminstatus = checkUser.isAdmin>

        <cflog file="app_log" text="User login: #session.username# at #now()#">

        <cflocation url="home.cfm">
      <cfelse>
        <cfset errorMsg = "Invalid username or password. Please try again.">
        <cflog file="app_log" text="Failed login attempt for '#form.username#' at #now()#">
      </cfif>
    </cfif>

    <cfif structKeyExists(variables,"errorMsg")>
      <div class="message"><cfoutput>#errorMsg#</cfoutput></div>
    </cfif>

    <form action="loginpage.cfm" method="post" id="loginForm">
      <label>Username:</label>
      <input type="text" name="username" id="loginUsername" required>

      <label>Password:</label>
      <div class="password-wrapper">
        <input type="password" name="password" id="loginPassword" placeholder="Enter Password" required>
        <i class="fa-solid fa-eye eye-icon" id="toggleLoginPassword"></i>
      </div>

      <input type="submit" name="login" value="Login" class="login-btn">
    </form>

    <a href="register.cfm" class="register-link">Register here</a>
    <a href="forgotPassword.cfm" class="forgot-link">Forgot Password?</a>

  </div>
</body>
</html>
