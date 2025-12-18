<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Activity Logs</title>
  <link rel="stylesheet" href="../css/viewlogs.css">
  <link rel="stylesheet" href="../css/pagination.css">

</head>

<body>

<cfparam name="url.page" default="1">



<!-- Fetch logs -->
<cfquery name="logs" datasource="#application.datasource#">
    SELECT id, userName, action, description, action_time
    FROM action_logs
    ORDER BY action_time DESC
    
</cfquery>


<cfoutput>



<div class="container">

  <h2>Activity Logs</h2>

  <table class="data-table">
    <tr>
        <th>ID</th>
        <th>User</th>
        <th>Action</th>
        <th>Description</th>
        <th>Date</th>
    </tr>

    <cfif logs.recordCount EQ 0>
        <tr><td colspan="5" class="no-records">No logs found.</td></tr>
    <cfelse>
        <cfloop query="logs">
            <tr>
                <td>#id#</td>
                <td>#userName#</td>
                <td>#action#</td>
                <td>#description#</td>
                <td>
                    <cfif isDate(action_time)>
                        #dateFormat(action_time, "dd-MMM-yyyy")# #timeFormat(action_time, "hh:mm tt")#
                    <cfelse>
                        -
                    </cfif>
                </td>
            </tr>
        </cfloop>
    </cfif>
  </table>


<!-- =================== PAGINATION (same as customers.cfm) =================== -->

<div class="pagination">
</div>


<!-- Back to Home -->
<div class="back-button">
    <form action="../views/home.cfm" method="get">
      <button type="submit" class="btn-back">← Back to Home</button>
    </form>
</div>

</div>
</cfoutput>

<script src="../scriptjs/pagination.js"></script>

</body>
</html>
    