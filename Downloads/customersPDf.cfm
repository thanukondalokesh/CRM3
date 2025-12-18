<cfsetting showdebugoutput="false">
<cfcontent reset="true">

<!-- ============================ FETCH CUSTOMERS ================================ -->
<cfquery name="getCustomers" datasource="#application.datasource#">
    SELECT id, username, name, email, phone, created_at
    FROM customers
    ORDER BY id DESC
</cfquery>

<!-- ============================ FETCH ADMIN EMAIL ================================ -->
<cfquery name="getAdminEmail" datasource="#application.datasource#">
    SELECT email
    FROM users
    WHERE isadmin = 1
</cfquery>

<cfset adminEmail = getAdminEmail.email>

<!-- ============================ SEND MAIL TO ADMIN ================================ -->
<cfmail
    to="#adminEmail#"
    from="#session.email#"
    subject="User Activity: Customer PDF Access by #session.username#"
    type="html">

    <cfoutput>
        Hello Admin,<br><br>

        User <strong>#session.username#</strong> has accessed the CRM3 Customer List PDF<br><br>

        Access Type:
        <cfif structKeyExists(url, "download") AND url.download EQ 1>
            <strong>Opened in New Tab</strong>
        <cfelse>
            <strong>Downloaded</strong>
        </cfif>

        <br><br>
        User Email : #session.email#<br><br>
        Date: #dateFormat(now(),"dd-MM-yyyy")# #timeFormat(now(),"hh:mm:ss tt")#
    </cfoutput>

</cfmail>

<!-- ============================ LOG DOWNLOAD ONLY WHEN NEEDED ================================ -->
<cfif structKeyExists(url, "download") AND url.download EQ 1>
    <cfquery datasource="#application.datasource#">
        INSERT INTO pdf_download_logs (userName)
        VALUES (
            <cfqueryparam value="#session.username#" cfsqltype="cf_sql_varchar">
        )
    </cfquery>
</cfif>

<!-- ============================ GENERATE PDF (SAVED TO FILE) ================================ -->
<cfset pdfPath = expandPath("CustomerReport.pdf")>

<cfdocument format="PDF" filename="#pdfPath#" overwrite="yes">

    <h2 style="text-align:center;">Customer List - PDF Report</h2>

    <cfoutput>
        <div style="text-align:right; font-size:12px;">
            #dayOfWeekAsString(dayOfWeek(now()))#,
            #dateFormat(now(),"dd-MM-yyyy")# |
            #timeFormat(now(),"hh:mm:ss tt")#
        </div>
    </cfoutput>

    <br><hr>

    <table border="1" cellpadding="6" width="100%">
        <tr style="background-color:#e0e0e0; font-weight:bold;">
            <th>ID</th>
            <th>Username</th>
            <th>Name</th>
            <th>Email</th>
            <th>Phone</th>
            <th>Created On</th>
        </tr>

        <cfoutput query="getCustomers">
            <tr>
                <td>#id#</td>
                <td>#username#</td>
                <td>#name#</td>
                <td>#email#</td>
                <td>#phone#</td>
                <td>#dateFormat(created_at,'dd-MM-yyyy')#</td>
            </tr>
        </cfoutput>
    </table>

</cfdocument>

<!-- ============================ OPEN IN NEW TAB + AUTO DOWNLOAD ================================ -->
<cfheader name="Content-Disposition" value="inline; filename=CustomerReport.pdf">
<cfheader name="Content-Type" value="application/pdf">
<cfcontent type="application/pdf" file="#pdfPath#" deleteFile="false">
