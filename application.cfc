<!--- /CRM/Application.cfc --->
<cfcomponent output="false">

    <!-- BASIC SETTINGS -->
    <cfset this.name               = "CRM">
    <cfset this.sessionManagement  = true>
    <cfset this.sessionTimeout     = createTimeSpan(0,0,30,0)>
    <cfset this.applicationTimeout = createTimeSpan(1,0,0,0)>

    <!-- APPLICATION START -->
    <cffunction name="onApplicationStart" returntype="boolean">
        <cfset application.datasource = "CRM">
        <cfset application.mailFrom   = "noreply@crmapp.com">
        <cfreturn true>
    </cffunction>

    <!-- ====================================================== -->
    <!-- MAIN REQUEST HANDLER (Correct place for header/footer) -->
    <!-- ====================================================== -->
    <cffunction name="onRequest" access="public" output="true">
        <cfargument name="targetPage" required="true">

        <cfset var pageName = lCase(arguments.targetPage)>
        <cfset var currentPage = lCase(listLast(arguments.targetPage, "/"))>

        <!-- 1️⃣ MANUAL APP RESTART -->
        <cfif structKeyExists(url, "restart")>
            <cfset onApplicationStart()>
            <cfoutput>Application Reloaded!</cfoutput>
            <cfabort>
        </cfif>

        <!-- 2️⃣ DIRECTLY RUN CFCs (no header/footer) -->
        <cfif right(pageName, 4) EQ "cfc">
            <cfsetting showdebugoutput="false">
            <cfinclude template="#arguments.targetPage#">
            <cfabort>
        </cfif>

        <!-- 3️⃣ PUBLIC PAGES (allowed without login) -->
        <cfset noLoginPages = "loginpage.cfm,forgotpassword.cfm,forgototp.cfm,register.cfm,logout.cfm">

        <!-- LOGIN ENFORCEMENT -->
        <cfif NOT listFindNoCase(noLoginPages, currentPage)>
            <cfif NOT structKeyExists(session, "loggedIn") OR session.loggedIn NEQ true>
                <cflocation url="/CRM3/views/loginpage.cfm" addtoken="false">
                <cfabort>
            </cfif>
        </cfif>

        <!-- 4️⃣ SHOW HEADER FOR LOGGED-IN USERS ONLY -->
        <cfif NOT listFindNoCase(noLoginPages, currentPage)>
            <!-- IMPORTANT: header inside body -->
            <cfinclude template="/CRM3/includes/header.cfm">
        </cfif>

        <!-- 5️⃣ LOAD MAIN VIEW -->
        <cfinclude template="#arguments.targetPage#">

        <!-- 6️⃣ SHOW FOOTER FOR REGULAR PAGES -->
        <cfif NOT listFindNoCase(noLoginPages, currentPage)>
            <cfinclude template="/CRM3/includes/footer.cfm">
        </cfif>

    </cffunction>

</cfcomponent>
