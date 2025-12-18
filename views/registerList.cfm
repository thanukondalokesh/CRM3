

<cfquery name="list" datasource="#application.datasource#">
    SELECT id, username,email, isadmin
    FROM users
</cfquery>

<!DOCTYPE html>
<html>
<head>
    <title>User Registration List</title>
    <link rel="stylesheet" href="../css/registerList.css">
    <link rel="stylesheet" href="../css/pagination.css">


</head>
<body>
<h2> User Registration List </h2>

<table border="1" cellpadding="5" cellspacing="0">
    <tr>
        <th>ID</th>
        <th>Username</th>
        <th>Email</th>
        <th>Status</th>
    </tr>

    <cfif list.recordCount EQ 0>
        <tr><td colspan="3">No list found</td></tr>
    <cfelse>
        <tbody id="dataRows">
        <cfoutput query="list">
            <tr>
                <td>#id#</td>
                <td>#username#</td>
                <td>#email#</td>
                <td>
                    <cfif isadmin EQ 1>
                        <span class="status-admin">Admin</span>
                    <cfelse>
                        <span class="status-general">General User</span>
                    </cfif>
                </td>

            </tr>
        </cfoutput>
        </tbody>
    </cfif>
</table>

<!-- PAGINATION BUTTONS WILL APPEAR HERE -->
<div class="pagination"></div>

<script src="../scriptjs/pagination.js"></script>

</body>
</html>
