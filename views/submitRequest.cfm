<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Submit New Request</title>

    <!-- CSS FILE -->
    <link rel="stylesheet" type="text/css" href="../css/submitRequest.css">
</head>

<body>



<!-- Default Form Params -->
<cfparam name="form.department" default="">
<cfparam name="form.title" default="">
<cfparam name="form.description" default="">
<cfset result = ""> <!-- To store success or error -->

<!-- ================= FORM SUBMIT LOGIC ================= -->
<cfif structKeyExists(form, "submit")>

    <cftry>

        <!-- Validation -->
        <cfif len(trim(form.department)) EQ 0 OR len(trim(form.title)) EQ 0 OR len(trim(form.description)) EQ 0>
            <cfset result = "error">
        <cfelse>

            <!-- INSERT request -->
            <cfquery datasource="#application.datasource#">
                INSERT INTO requests (username, department, title, description, action_time)
                VALUES (
                    <cfqueryparam value="#session.username#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#form.department#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#form.title#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#form.description#" cfsqltype="cf_sql_longvarchar">,
                    NOW()
                )
            </cfquery>

            <!-- INSERT log -->
            <cfquery datasource="#application.datasource#">
                INSERT INTO action_logs (username, action, description)
                VALUES (
                    <cfqueryparam value="#session.username#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="CREATE" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="Created a new request in #form.department# department" cfsqltype="cf_sql_varchar">
                )
            </cfquery>

            <cfset result = "success">
        </cfif>

        <cfcatch>
            <cfset result = "error">
        </cfcatch>

    </cftry>

</cfif>

<!-- ================= CENTER FORM ================= -->
<div class="form-box">

    <h2>Submit Request</h2>

    <form method="post"  target="_blank">

        <label>Department</label>
        <select name="department" required>
            <option value="">-- Select Department --</option>
            <option value="HR">HR</option>
            <option value="IT">IT</option>
            <option value="Finance">Finance</option>
            <option value="Sales">Sales</option>
            <option value="Admin">Admin</option>
        </select>

        <label>Title</label>
        <input type="text" name="title" required>

        <label>Description</label>
        <textarea name="description" required></textarea>

        <button type="submit" class="btn-submit" name="submit">Submit</button>
    </form>

</div>

<!-- Back Button -->
<div class="back-button">
  <form action="../views/home.cfm" method="get">
    <button type="submit" class="btn-back">← Back to Home</button>
  </form>
</div>
<hr>

<!-- ============ POPUP MESSAGES (Success / Error) ============ -->
<cfif result EQ "success">
<script>
    alert("Submit Request Added Successfully!");
    window.location.href = "viewRequests.cfm";
</script>

<cfelseif result EQ "error">
<script>
    alert("Submit Request Failed! Please fill all fields or try again.");
    window.location.href = "submitRequest.cfm";
</script>

</cfif>

</body>
</html>
