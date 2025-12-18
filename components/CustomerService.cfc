<cfcomponent output="false">

    <!-- CHECK EMAIL EXISTS -->
<cffunction name="emailExists" access="remote" returnformat="json" returntype="any">
    <cfargument name="email" required="true">
    <cfargument name="id" required="false" default="0">

    <cfquery name="q" datasource="#application.datasource#">
        SELECT id FROM customers
        WHERE email = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">
        AND id != <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer">
    </cfquery>

    <cfif q.recordcount GT 0>
        <cfreturn { "exists": true }>
    <cfelse>
        <cfreturn { "exists": false }>
    </cfif>
</cffunction>


    <!-- ========================= -->
    <!-- GET CUSTOMERS (PAGINATION) -->
    <!-- ========================= -->
   <cffunction name="getCustomers" access="remote" returntype="any"
    returnFormat="json" output="false">

    <cfargument name="search" default="">
    <cfargument name="page" default="1">
    <cfargument name="pageSize" default="5">

    <!-- FIXED: Rename variables -->
    <cfset var localPage = val(arguments.page)>
    <cfset var localPageSize = val(arguments.pageSize)>
    <cfset var localStart = (localPage - 1) * localPageSize>

    <!-- Fetch Paginated records -->
    <cfquery name="q" datasource="#application.datasource#">
        SELECT id, username,name, email, phone
        FROM customers
        WHERE name LIKE <cfqueryparam value="%#arguments.search#%" cfsqltype="cf_sql_varchar">
           OR email LIKE <cfqueryparam value="%#arguments.search#%" cfsqltype="cf_sql_varchar">
        ORDER BY id DESC
        LIMIT <cfqueryparam value="#localPageSize#" cfsqltype="cf_sql_integer">
        OFFSET <cfqueryparam value="#localStart#" cfsqltype="cf_sql_integer">
    </cfquery>

    <!-- Total Records -->
    <cfquery name="totalQ" datasource="#application.datasource#">
        SELECT COUNT(*) AS total
        FROM customers
        WHERE name LIKE <cfqueryparam value="%#arguments.search#%" cfsqltype="cf_sql_varchar">
           OR email LIKE <cfqueryparam value="%#arguments.search#%" cfsqltype="cf_sql_varchar">
    </cfquery>

    <!-- Convert Query to Array -->
    <cfset var result = []>
    <cfloop query="q">
        <cfset arrayAppend(result, {
            "id" = q.id,
            "username" = q.username,
            "name" = q.name,
            "email" = q.email,
            "phone" = q.phone
        })>
    </cfloop>

    <!-- Return Paginated JSON -->
    <cfreturn {
        "data" = result,
        "total" = totalQ.total,
        "page" = localPage,
        "pageSize" = localPageSize
    }>

</cffunction>

    <!-- ========================= -->
    <!-- GET SINGLE CUSTOMER -->
    <!-- ========================= -->
    <cffunction name="getCustomer" access="remote" returntype="any"
        returnFormat="json" output="false">
        <cfargument name="id" required="true">

        <cfquery name="q" datasource="#application.datasource#">
            SELECT * FROM customers
            WHERE id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer">
        </cfquery>

        <cfif q.recordCount EQ 0>
            <cfreturn {}> 
        </cfif>

        <cfreturn {
            "id" = q.id,
            "name" = q.name,
            "email" = q.email,
            "phone" = q.phone
        }>
    </cffunction>


    <!-- ========================= -->
    <!-- SAVE CUSTOMER (ADD/UPDATE) -->
    <!-- ========================= -->
    <cffunction name="saveCustomer" access="remote" returntype="any"
        returnFormat="json" output="false">

        <cfargument name="id" default="">
        <cfargument name="name" required="true">
        <cfargument name="email" required="true">
        <cfargument name="phone" required="true">

        <!-- INSERT -->
        <cfif arguments.id EQ "" OR arguments.id EQ 0>
            <cfquery datasource="#application.datasource#">
                INSERT INTO customers(username, name, email, phone)
                VALUES(
                    <cfqueryparam value="#session.username#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.name#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.phone#" cfsqltype="cf_sql_varchar">
                )
            </cfquery>
            <cfset msg = "Customer added Successfully">

        <cfelse>
        <!-- UPDATE -->
            <cfquery datasource="#application.datasource#">
                UPDATE customers
                SET 
                    username = <cfqueryparam value="#session.username#" cfsqltype="cf_sql_varchar">,
                    name = <cfqueryparam value="#arguments.name#" cfsqltype="cf_sql_varchar">,
                    email = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">,
                    phone = <cfqueryparam value="#arguments.phone#" cfsqltype="cf_sql_varchar">
                WHERE id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer">
            </cfquery>
            <cfset msg = "Customer updated Successfully">
        </cfif>

        <cfreturn { "success": true, "message": msg }>
    </cffunction>


    <!-- ========================= -->
    <!-- DELETE CUSTOMER -->
    <!-- ========================= -->
    <cffunction name="deleteCustomer" access="remote" returntype="any"
        returnFormat="json" output="false">
        <cfargument name="id" required="true">

        <cfquery datasource="#application.datasource#">
            DELETE FROM customers
            WHERE id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer">
        </cfquery>

        <cfreturn { "success": true, "message": "Customer deleted Successfully" }>
    </cffunction>

</cfcomponent>
