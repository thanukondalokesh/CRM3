<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Request</title>
    <link rel="stylesheet" href="../css/editRequest.css">

    </head>
<body>



<!-- ========= GET REQUEST ID ========= -->
<cfparam name="url.id" default="0">

<!-- ========= FETCH EXISTING REQUEST ========= -->
<cfquery name="getRequest" datasource="#application.datasource#">
    SELECT * FROM requests 
    WHERE id = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer">
</cfquery>

<!-- ========= UPDATE LOGIC ========= -->
<cfif structKeyExists(form, "update")>
    <cfif len(trim(form.department)) EQ 0 OR len(trim(form.title)) EQ 0 OR len(trim(form.description)) EQ 0>
        <cfset updated = "failed">
    <cfelse>
        <cftry>

            <!-- Update request -->
            <cfquery datasource="#application.datasource#">
                UPDATE requests
                SET 
                    username   = <cfqueryparam value="#session.username#" cfsqltype="cf_sql_varchar">,
                    department = <cfqueryparam value="#form.department#" cfsqltype="cf_sql_varchar">,
                    title      = <cfqueryparam value="#form.title#" cfsqltype="cf_sql_varchar">,
                    description= <cfqueryparam value="#form.description#" cfsqltype="cf_sql_varchar">
                WHERE id     = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer">
            </cfquery>

            <!-- Log the update -->
            <cfquery datasource="#application.datasource#">
                INSERT INTO action_logs (userName, action, description)
                VALUES (
                    <cfqueryparam value="#session.userName#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="EDIT" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="Edited request ID #url.id#" cfsqltype="cf_sql_varchar">
                )
            </cfquery>

            <cfset updated = "success">

        <cfcatch>
            <cfset updated = "failed">
        </cfcatch>
        </cftry>
    </cfif>
</cfif>

<!-- ========= POPUP (SUCCESS / FAILED) ========= -->
<cfif structKeyExists(variables, "updated")>
<script>
    <cfif updated EQ "success">
        alert("Request Updated Successfully!");
    <cfelse>
        alert("Request Update Failed!");
    </cfif>

    window.location.href = "viewRequests.cfm";
</script>
</cfif>

<!-- ========= DISPLAY FORM ========= -->
<cfoutput query="getRequest">

<div class="container">
    <div class="form-box">

        <h2>Edit Request</h2>

        <form method="post" action="editRequest.cfm?id=#id#">

            <!-- Department -->
            <label for="department">Department</label>
            <select name="department" id="department" required>
                <option value="">--Select Department--</option>
                <option value="HR"      <cfif department EQ "HR">selected</cfif>>HR</option>
                <option value="IT"      <cfif department EQ "IT">selected</cfif>>IT</option>
                <option value="Finance" <cfif department EQ "Finance">selected</cfif>>Finance</option>
                <option value="Sales"   <cfif department EQ "Sales">selected</cfif>>Sales</option>
                <option value="Admin"   <cfif department EQ "Admin">selected</cfif>>Admin</option>
            </select>

            <!-- Title -->
            <label>Title</label>
            <input type="text" name="title" value="#title#" required>

            <!-- Description -->
            <label>Description</label>
            <textarea name="description" required>#description#</textarea>

            <!-- BUTTON ROW -->
            <div class="button-row">
                <button type="submit" name="update" class="btn-update">Update</button>
                <a href="viewRequests.cfm" class="btn-cancel">Cancel</a>
            </div>

        </form>

    </div>
</div>

</cfoutput>

</body>
</html>
