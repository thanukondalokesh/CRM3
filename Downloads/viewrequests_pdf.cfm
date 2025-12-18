<cfsetting showdebugoutput="false">

<!-- READ FILTERS -->
<cfparam name="url.department" default="">
<cfparam name="url.searchText" default="">

<!-- FETCH REQUESTS (FILTERED) -->
<cfquery name="getRequests" datasource="#application.datasource#">
    SELECT
        id,
        username,
        department,
        title,
        description,
        action_time
    FROM requests
    WHERE 1 = 1

    <cfif trim(url.department) NEQ "">
        AND department = <cfqueryparam value="#url.department#" cfsqltype="cf_sql_varchar">
    </cfif>

    <cfif trim(url.searchText) NEQ "">
        AND (
            title LIKE <cfqueryparam value="%#url.searchText#%" cfsqltype="cf_sql_varchar">
            OR description LIKE <cfqueryparam value="%#url.searchText#%" cfsqltype="cf_sql_varchar">
        )
    </cfif>

    ORDER BY id DESC
</cfquery>

<!-- FETCH ADMIN EMAIL -->
<cfquery name="getUserEmail" datasource="#application.datasource#">
    SELECT email FROM users WHERE isadmin = 1
</cfquery>

<cfset adminEmail = getUserEmail.email>

<!-- SEND MAIL -->
<cfmail 
    to="#adminEmail#" 
    from="#session.email#" 
    subject="User Activity: PDF Access by #session.username#" 
    type="html">
<cfoutput>
    Hello Admin,<br><br>
    User <strong>#session.username#</strong> accessed View Requests PDF.<br><br>
    Date & Time: #dateFormat(now(),"dd-MM-yyyy")# #timeFormat(now(),"hh:mm:ss tt")#
</cfoutput>
</cfmail>

<!-- PDF HEADER -->
<cfheader name="Content-Disposition" value="inline; filename=ViewRequestsReport.pdf">

<!-- GENERATE PDF -->
<cfdocument format="PDF" marginTop="1" marginBottom="1" marginLeft="1" marginRight="1">

    <cfset currentDay  = dayOfWeekAsString(dayOfWeek(now()))>
    <cfset currentDate = dateFormat(now(), "dd-MM-yyyy")>
    <cfset currentTime = timeFormat(now(), "hh:mm:ss tt")>

    <h2 style="text-align:center;">View Requests - PDF Report</h2>

    <cfoutput>
        <div style="text-align:right; font-size:12px;">
            #currentDay#, #currentDate# | #currentTime#
        </div>
    </cfoutput>

    <hr>

    <table border="1" cellpadding="6" cellspacing="0" width="100%">
        <tr style="background-color:#e0e0e0; font-weight:bold;">
            <th>ID</th>
            <th>Department</th>
            <th>Title</th>
            <th>Description</th>
            <th>Date</th>
        </tr>

        <cfoutput query="getRequests">
            <tr>
                <td>#id#</td>
                <td>#department#</td>
                <td>#title#</td>
                <td>#description#</td>
                <td>#dateFormat(action_time,"dd-MM-yyyy")#</td>
            </tr>
        </cfoutput>
    </table>

</cfdocument>
