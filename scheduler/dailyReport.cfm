<cfsetting showdebugoutput="false">

<!-- Fetch Admin Email -->
<cfquery name="admin" datasource="#application.datasource#">
    SELECT email 
    FROM users 
    WHERE isadmin = 1 
    LIMIT 1
</cfquery>

<cfset adminEmail = admin.email>

<!-- Fetch Today’s PDF Downloads -->
<cfquery name="todayLogs" datasource="#application.datasource#">
    SELECT userName, downloadedAt
    FROM pdf_download_logs
    WHERE DATE(downloadedAt) = CURDATE()
    ORDER BY downloadedAt DESC
</cfquery>

<!-- Build Email Body -->
<cfset emailBody = "
<h2>CRM3 Daily Customer PDF Download Report</h2>
Date: #dateFormat(now(), 'dd-MM-yyyy')#<br><br>
">

<cfif todayLogs.recordCount EQ 0>
    <cfset emailBody &= "<strong>No PDF downloads today.</strong>">
<cfelse>
    <cfset emailBody &= "
    <table border='1' cellpadding='6' cellspacing='0'>
        <tr>
            <th>User</th>
            <th>Date & Time</th>
        </tr>
    ">
    
    <cfoutput query="todayLogs">
        <cfset emailBody &= "
        <tr>
            <td>#userName#</td>
            <td>#dateFormat(downloadedAt,'dd-MM-yyyy')# #timeFormat(downloadedAt,'hh:mm:ss tt')#</td>
        </tr>
        ">
    </cfoutput>

    <cfset emailBody &= "</table>">
</cfif>

<!-- Send Email -->
<cfmail 
    to="#adminEmail#"
    from="noreply@crm.com"
    subject="Daily PDF Download Report"
    type="html">

    #emailBody#

</cfmail>

<!-- Log Scheduler Execution -->
<cfquery datasource="#application.datasource#">
    INSERT INTO scheduler_logs (taskName, executedAt, status, message)
    VALUES (
        'Daily PDF Download Report',
        NOW(),
        'Success',
        'Report sent to admin'
    )
</cfquery>
