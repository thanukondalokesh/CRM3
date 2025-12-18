

<cfparam name="url.id" default="0">


  <cfquery datasource="#application.datasource#">
    DELETE FROM requests WHERE id = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer">
  </cfquery>

    <!-- Log action -->
 <cfquery name="logAction" datasource="#application.datasource#">
    INSERT INTO action_logs (userName, action, description)
    VALUES (
        <cfqueryparam value="#session.userName#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="DELETE" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="Deleted request ID: #url.id#" cfsqltype="cf_sql_varchar">
    )
</cfquery>

  <cflocation url="viewRequests.cfm">
  



