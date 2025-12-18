<!--- /CRM/forgotPassword.cfm ---> 
<cfparam name="url.step" default="">

<!DOCTYPE html>
<html>
<head>
    <title>Forgot / Reset Password</title>
    <link rel="stylesheet" href="../css/forgot.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<div class="form-container">

<!-- =======================
     STEP 0 : ENTER USERNAME
=========================== -->
<cfif url.step EQ "">
    <h2>Forgot Password</h2>
    <form method="post" action="forgotPassword.cfm?step=confirmUser">
        <label>Enter Username or Email:</label>
        <input type="text" name="username" required>
        <input type="submit" value="Next" class="login-btn">
    </form>
    <a href="loginpage.cfm" class="register-link">Back to Login</a>
    <cfabort>
</cfif>

<!-- =======================
     STEP 1 : CONFIRM USER
=========================== -->
<cfif url.step EQ "confirmUser">

    <cfquery name="checkUser" datasource="#application.datasource#">
        SELECT id, username, email
        FROM users
        WHERE username = <cfqueryparam value="#form.username#" cfsqltype="cf_sql_varchar">
           OR email    = <cfqueryparam value="#form.username#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <cfif checkUser.recordCount EQ 0>
        <script>
            alert("No matching user found.");
            window.location = "forgotPassword.cfm";
        </script>
        <cfabort>
    </cfif>

    <!-- Save user -->
    <cfset session.forgot_userid = checkUser.id>
    <cfset session.forgot_username = checkUser.username>
    <cfset session.forgot_email = checkUser.email>

    <h2>Choose Reset Method <span style="color:red;">OR</span> Send OTP</h2>

    <cfoutput>
        <p><b>Username:</b> #session.forgot_username#</p>
        <p><b>Email:</b> #session.forgot_email#</p>
    </cfoutput>

    <!-- RESET LINK OPTION -->
    <form method="post" action="forgotPassword.cfm?step=sendLink">
        <input type="submit" value="Send Reset Link" class="login-btn">
    </form>

    <br>

    <!-- OTP OPTION (GOES TO forgotOTP.cfm) -->
    <form method="post" action="forgotOTP.cfm?step=sendOTP">
        <input type="submit" value="Send OTP To Email" class="login-btn" style="background:#28a745;">
    </form>

    <a href="forgotPassword.cfm" class="forgot-link">Back</a>
    <cfabort>
</cfif>


<!-- =======================
     STEP 2 : SEND RESET LINK
=========================== -->
<cfif url.step EQ "sendLink">

    <cfset resetToken = createUUID()>
    <cfset resetExpiry = dateAdd("n", 15, now())>

    <cfquery datasource="#application.datasource#">
        UPDATE users
        SET reset_token  = <cfqueryparam value="#resetToken#" cfsqltype="cf_sql_varchar">,
            reset_expiry = <cfqueryparam value="#resetExpiry#" cfsqltype="cf_sql_timestamp">
        WHERE id = <cfqueryparam value="#session.forgot_userid#" cfsqltype="cf_sql_integer">
    </cfquery>

    <!-- Build reset URL -->
    <cfset protocol = (CGI.HTTPS EQ "on" ? "https://" : "http://")>
    <cfset resetURL = protocol & CGI.SERVER_NAME & ":" & CGI.SERVER_PORT & "/CRM/forgotPassword.cfm?step=resetPassword&token=" & URLEncodedFormat(resetToken)>

    <!-- Send email -->
    <cfmail to="#session.forgot_email#" from="admin@gmail.com" subject="Password Reset Link">
    Hello #session.forgot_username#,

    Click the link below to reset your password. This link is valid for 15 minutes:

    #resetURL#
    </cfmail>

    <script>
        alert("Reset link sent to your email.");
        window.location = "forgotPassword.cfm";
    </script>
    <cfabort>
</cfif>

<!-- =======================
     STEP 3 : SHOW RESET FORM
=========================== -->
<cfif url.step EQ "resetPassword">

    <cfif NOT structKeyExists(url, "token") OR len(trim(url.token)) EQ 0>
        <script>
            alert("Invalid or missing reset link.");
            window.location = "forgotPassword.cfm";
        </script>
        <cfabort>
    </cfif>

    <cfset decodedToken = urlDecode(url.token)>

    <cfquery name="tokenCheck" datasource="#application.datasource#">
        SELECT id, reset_expiry, reset_token
        FROM users
        WHERE reset_token = <cfqueryparam value="#decodedToken#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <cfif tokenCheck.recordCount EQ 0 OR now() GT tokenCheck.reset_expiry>
        <script>
            alert("Invalid or expired reset link.");
            window.location = "forgotPassword.cfm";
        </script>
        <cfabort>
    </cfif>

    <h2>Reset Password</h2>

    <form id="resetForm" method="post" action="forgotPassword.cfm?step=resetAction">
        <cfoutput>
            <input type="hidden" name="token" value="#decodedToken#">
        </cfoutput>

        <label>New Password:</label>
        <div class="input-group">
            <input type="password" id="newPassword" name="newPassword" required>
            <i class="fa fa-eye toggle-icon" data-toggle-pw="newPassword"></i>
        </div>

        <label>Confirm Password:</label>
        <div class="input-group">
            <input type="password" id="confirmPassword" name="confirmPassword" required>
            <i class="fa fa-eye toggle-icon" data-toggle-pw="confirmPassword"></i>
        </div>

        <p id="matchMessage" style="color:red; margin-top:5px;"></p>

        <button type="submit" class="login-btn">Reset Password</button>
    </form>

    <script src="../scriptjs/forgot.js" defer></script>
    <a href="loginpage.cfm" class="register-link">Back to Login</a>

    <cfabort>
</cfif>

<!-- =======================
     STEP 4 : RESET ACTION
=========================== -->
<cfif url.step EQ "resetAction">

    <cfif NOT structKeyExists(form, "token") OR len(trim(form.token)) EQ 0>
        <script>
            alert("Invalid or missing token.");
            window.location = "forgotPassword.cfm";
        </script>
        <cfabort>
    </cfif>

    <cfset decodedToken = urlDecode(form.token)>
    <cfset pw = trim(form.newPassword)>

    <cfquery name="chk" datasource="#application.datasource#">
        SELECT id, reset_expiry
        FROM users
        WHERE reset_token = <cfqueryparam value="#decodedToken#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <cfif chk.recordCount EQ 0 OR now() GT chk.reset_expiry>
        <script>
            alert("Invalid or expired reset token.");
            window.location = "forgotPassword.cfm";
        </script>
        <cfabort>
    </cfif>

    <!-- Password strength -->
    <cfif NOT reFind("(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}", pw)>
        <script>
            alert("Password must include uppercase, lowercase, number, and a special character.");
            window.location = "forgotPassword.cfm?step=resetPassword&token=#URLEncodedFormat(decodedToken)#";
        </script>
        <cfabort>
    </cfif>

    <!-- Password match -->
    <cfif pw NEQ trim(form.confirmPassword)>
        <script>
            alert("Passwords do not match.");
            window.location = "forgotPassword.cfm?step=resetPassword&token=#URLEncodedFormat(decodedToken)#";
        </script>
        <cfabort>
    </cfif>

    <!-- Update password -->
    <cfquery datasource="#application.datasource#">
        UPDATE users
        SET password     = <cfqueryparam value="#pw#" cfsqltype="cf_sql_varchar">,
            reset_token  = NULL,
            reset_expiry = NULL
        WHERE id = <cfqueryparam value="#chk.id#" cfsqltype="cf_sql_integer">
    </cfquery>

    <script>
        alert("Password reset successful!");
        window.location = "loginpage.cfm";
    </script>
    <cfabort>

</cfif>

</div>
</body>
</html>
