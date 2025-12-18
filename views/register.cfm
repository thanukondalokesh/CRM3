<!--- register.cfm --->

<cfparam name="url.step" default="">
<!-- AJAX CHECK for username/email exists -->
<cfif structKeyExists(url, "check") AND structKeyExists(url, "value")>

    <cfset checkVal = trim(url.value)>

    <cfif url.check EQ "username">
        <cfquery name="chk" datasource="#application.datasource#">
            SELECT id FROM users WHERE username = <cfqueryparam value="#checkVal#" cfsqltype="cf_sql_varchar">
        </cfquery>

    <cfelseif url.check EQ "email">
        <cfquery name="chk" datasource="#application.datasource#">
            SELECT id FROM users WHERE email = <cfqueryparam value="#checkVal#" cfsqltype="cf_sql_varchar">
        </cfquery>
    </cfif>

    <cfif chk.recordCount GT 0>
        EXISTS
    <cfelse>
        OK
    </cfif>

    <cfabort>
</cfif>


<!DOCTYPE html>
<html>
<head>
  <title>User Registration</title>
  <link rel="stylesheet" href="../css/register.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <script src="../scriptjs/register.js"></script>
</head>

<body>

<header><h2>Register New User</h2></header>
<div class="container">

<!-- Ensure session exists -->
<cfif NOT structKeyExists(session,"initialized")>
  <cfset session.initialized = true>
</cfif>

<!-- ========================================================= -->
<!-- STEP 1 : SHOW THE REGISTRATION FORM                       -->
<!-- ========================================================= -->
<cfif url.step EQ "">

  <!-- SERVER-SIDE ERROR SHOW -->
  <cfif structKeyExists(session,'regError')>
    <cfoutput>
        <div style="color:red; font-weight:bold; margin-bottom:10px;">#session.regError#</div>
    </cfoutput>
    <cfset structDelete(session,'regError')>
</cfif>


  <form method="post" action="register.cfm?step=sendOTP" id="registerForm" novalidate>

    <label>Username:</label>
    <input type="text" name="username" id="username" required>
    <div id="usernameMsg" class="msg"></div>


    <label>Password:</label>
    <div class="password-wrapper">
      <input type="password" name="password" id="password" required placeholder="Enter Password">
      <i class="fa-solid fa-eye eye-icon" id="togglePassword"></i>

    </div>

    <label>Confirm Password:</label>
    <div class="password-wrapper">
      <input type="password" name="confirmPassword" id="confirmPassword" required placeholder="Re-enter Password">
      <i class="fa-solid fa-eye eye-icon" id="toggleConfirmPassword"></i>
    </div>

    <div id="matchMessage" style="margin-top:5px; font-weight:bold;"></div>

    <label>Email:</label>
    <input type="email" name="email" id="email" required>
    <div id="emailMsg" class="msg"></div>

    <div id="formError" style="color:red; font-weight:bold; margin-top:10px;"></div>

    <input type="submit" value="Send OTP" id="sendOtpBtn">
  </form>

  <br>
  Already have an account? <a href="loginpage.cfm">Login</a>
  <cfabort>
</cfif>




<!-- ========================================================= -->
<!-- STEP 2 : SEND OTP                                         -->
<!-- ========================================================= -->
<cfif url.step EQ "sendOTP">

  <cfparam name="form.username" default="">
  <cfparam name="form.password" default="">
  <cfparam name="form.confirmPassword" default="">
  <cfparam name="form.email" default="">

  <!-- Validate password match -->
  <cfif trim(form.password) NEQ trim(form.confirmPassword)>
    <cfset session.regError = "Passwords do not match.">
    <cflog file="registration" text="Password mismatch for user: #form.username#">
    <cflocation url="register.cfm">
  </cfif>

  <!-- Password rule validation -->
  <cfset pw = trim(form.password)>
  <cfif len(pw) LT 8 OR reFind("[A-Z]", pw) EQ 0 OR reFind("[a-z]", pw) EQ 0 OR reFind("[^A-Za-z0-9]", pw) EQ 0>
    <cfset session.regError = "Password must be 8+ chars, include uppercase, lowercase, and special character.">
    <cflog file="registration" text="Password rule failed for user: #form.username#">
    <cflocation url="register.cfm">
  </cfif>

  <!-- CHECK IF USERNAME EXISTS -->
  <cfquery name="checkUser" datasource="#application.datasource#">
    SELECT id FROM users WHERE username = <cfqueryparam value="#form.username#" cfsqltype="cf_sql_varchar">
  </cfquery>

  <cfif checkUser.recordCount GT 0>
    <cfset session.regError = "Username already exists. Choose another.">
    <cflog file="registration" text="Username already exists: #form.username#">
    <cflocation url="register.cfm">
  </cfif>

  <!-- CHECK IF EMAIL EXISTS -->
<cfquery name="checkEmail" datasource="#application.datasource#">
    SELECT id FROM users WHERE email = <cfqueryparam value="#form.email#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfif checkEmail.recordCount GT 0>
    <cfset session.regError = "Email already exists. Enter a new email.">
    <cflocation url="register.cfm">
</cfif>


  <!-- SAVE DATA INTO SESSION -->
  <cfset session.regUser = form.username>
  <cfset session.regPassword = form.password>
  <cfset session.regEmail = form.email>

  <!-- GENERATE OTP -->
  <cfset session.regOTP = randRange(100000,999999)>
  <cfset session.regOtpExpiry = dateAdd("n", 2, now())>

  <cflog file="registration" text="OTP Generated for #session.regEmail#: #session.regOTP#">

  <!-- SEND OTP EMAIL -->
  <cfmail to="#session.regEmail#" from="your_email@gmail.com" subject="Registration OTP">
Hello #session.regUser#,
Your OTP is: #session.regOTP#
Valid for 2 minutes.
  </cfmail>

  <cflog file="registration" text="OTP Email sent to #session.regEmail#">

  <cflocation url="register.cfm?step=verifyOTP">
</cfif>




<!-- ========================================================= -->
<!-- STEP 3 : VERIFY OTP                                       -->
<!-- ========================================================= -->
<cfif url.step EQ "verifyOTP">

  <cfif NOT structKeyExists(session,"regOTP")>
    <script>alert("Session expired. Please register again.");</script>
    <cflog file="registration" text="OTP missing / session expired. Redirecting.">
    <cflocation url="register.cfm">
  </cfif>

  <h3>Enter OTP sent to your Email</h3>

  <form method="post" action="register.cfm?step=verifyOTP">
    <input type="text" name="enterOTP" maxlength="6" required>
    <input type="submit" value="Verify OTP">
  </form>

  <cfif structKeyExists(form,"enterOTP")>

    <!-- OTP Expired -->
    <cfif now() GT session.regOtpExpiry>
      <cflog file="registration" text="OTP expired for user: #session.regUser#">
      <script>alert("OTP expired. Sending new OTP.");</script>
      <cflocation url="register.cfm?step=sendOTP">
    </cfif>

    <!-- OTP Match -->
    <cfif trim(form.enterOTP) EQ trim(session.regOTP)>
      <cflog file="registration" text="OTP verified for user: #session.regUser#">
      <cflocation url="register.cfm?step=createUser">
    <cfelse>
      <cflog file="registration" text="Invalid OTP entered for #session.regUser#">
      <script>alert("Invalid OTP! Try again.");</script>
      <cflocation url="register.cfm?step=verifyOTP">
    </cfif>

  </cfif>

</cfif>




<!-- ========================================================= -->
<!-- STEP 4 : CREATE USER                                      -->
<!-- ========================================================= -->
<cfif url.step EQ "createUser">

  <cfif NOT structKeyExists(session,'regUser')>
    <script>alert("Session expired. Please register again.");</script>
    <cflog file="registration" text="Session lost before DB insert.">
    <cflocation url="register.cfm">
  </cfif>

  <!-- INSERT USER INTO DB -->
  <cfquery datasource="#application.datasource#">
    INSERT INTO users(username, password, email)
    VALUES(
      <cfqueryparam value="#session.regUser#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#session.regPassword#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#session.regEmail#" cfsqltype="cf_sql_varchar">
    )
  </cfquery>

  <cflog file="registration" text="User successfully created: #session.regUser#">

  <script>
    alert("Registration Successful!");
    window.location.href = "loginpage.cfm";
  </script>

  <cfabort>
</cfif>

</div>
</body>
</html>
