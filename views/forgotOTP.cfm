<!--- /CRM/forgotOTP.cfm --->
<cfparam name="url.step" default="">

<!DOCTYPE html>
<html>
<head>
    <title>Reset Password using OTP</title>
    <link rel="stylesheet" href="../css/forgot.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>

<body>
<div class="form-container">

<!-- =======================
     STEP 0 : SEND OTP
=========================== -->
<cfif url.step EQ "sendOTP">

    <!-- Generate OTP -->
    <cfset session.otp = randRange(100000,999999)>
    <cfset session.otpExpiry = dateAdd("n", 2, now())>

    <!-- Send email -->
    <cfmail to="#session.forgot_email#" from="admin@gmail.com" subject="Your OTP Code">
Hello #session.forgot_username#,

Your OTP for password reset is: #session.otp#
It will expire in 2 minutes.
    </cfmail>

    <script>alert("OTP sent to your email.");</script>
    <cflocation url="forgotOTP.cfm?step=verifyOTP">
</cfif>

<!-- =======================
     STEP 1 : VERIFY OTP
=========================== -->
<cfif url.step EQ "verifyOTP">

    <h2>Verify OTP</h2>

    <cfif now() GT session.otpExpiry>
        <div class="message" style="color:red;">OTP expired!</div>
        <form method="post" action="forgotOTP.cfm?step=sendOTP">
            <button class="login-btn" style="background:green;">Resend OTP</button>
        </form>
        <cfabort>
    </cfif>

    <form method="post" action="forgotOTP.cfm?step=verifyAction">
        <label>Enter OTP:</label>
        <input type="text" name="otp" maxlength="6" required>

        <button class="login-btn">Verify OTP</button>
    </form>

    <form method="post" action="forgotOTP.cfm?step=sendOTP">
        <button class="login-btn" style="margin-top:10px;background:green;">Resend OTP</button>
    </form>

    <a href="forgotPassword.cfm" class="forgot-link">Back</a>
    <cfabort>
</cfif>

<!-- =======================
     STEP 2 : VERIFY ACTION
=========================== -->
<cfif url.step EQ "verifyAction">

    <cfif trim(form.otp) EQ trim(session.otp)>
        <script>alert("OTP verified! Reset password.");</script>
        <cflocation url="forgotOTP.cfm?step=resetPassword">
    <cfelse>
        <script>alert("Invalid OTP.");</script>
        <cflocation url="forgotOTP.cfm?step=verifyOTP">
    </cfif>

</cfif>

<!-- =======================
     STEP 3 : RESET PASSWORD FORM
=========================== -->
<cfif url.step EQ "resetPassword">

    <h2>Reset Password</h2>

    <form id="resetForm" method="post" action="forgotOTP.cfm?step=resetAction">

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

        <button class="login-btn">Reset Password</button>
    </form>

    <script src="../scriptjs/forgot.js"></script>
    <a href="forgotPassword.cfm" class="register-link">Back</a>

    <cfabort>
</cfif>

<!-- =======================
     STEP 4 : RESET ACTION
=========================== -->
<cfif url.step EQ "resetAction">

    <cfset pw = trim(form.newPassword)>

    <!-- Strength check -->
    <cfif NOT reFind("(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}", pw)>
        <script>alert("Weak password! Follow rules.");</script>
        <cflocation url="forgotOTP.cfm?step=resetPassword">
    </cfif>

    <cfif pw NEQ trim(form.confirmPassword)>
        <script>alert("Passwords do not match.");</script>
        <cflocation url="forgotOTP.cfm?step=resetPassword">
    </cfif>

    <!-- Update password -->
    <cfquery datasource="#application.datasource#">
        UPDATE users
        SET password = <cfqueryparam value="#pw#" cfsqltype="cf_sql_varchar">
        WHERE id = <cfqueryparam value="#session.forgot_userid#" cfsqltype="cf_sql_integer">
    </cfquery>

    <script>
        alert("Password reset successfully!");
        window.location = "loginpage.cfm";
    </script>

    <cfabort>
</cfif>

</div>
</body>
</html>
