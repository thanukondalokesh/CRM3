<!-- includes/header.cfm -->

<link rel="stylesheet" href="/CRM3/css/header.css">
<script src="/CRM3/scriptjs/header.js" defer></script>

<div class="topbar">
    <div class="menu-icon" id="menuToggle">☰</div>

    <div class="right-info">
        Logged in as |
        <cfoutput>
            <span>#session.username#</span>
        </cfoutput>
        <a href="/CRM3/logout.cfm" class="logout-btn">Logout</a>
    </div>
</div>

<!-- Floating Menu -->
<div id="dropdownMenu" class="dropdown-menu">

    <a href="/CRM3/views/home.cfm">Home Page</a>
    <a href="/CRM3/views/myprofile.cfm">My Profile</a>

    <cfif structKeyExists(session, "adminstatus") AND session.adminstatus EQ "1">
        <a href="/CRM3/views/viewLogs.cfm">View Logs</a>
        <a href="/CRM3/views/customers.cfm">Customers Management</a>
        <a href="/CRM3/views/registerList.cfm">Users Register List</a>
    </cfif>

    <a href="/CRM3/views/submitRequest.cfm">Submit Request</a>
    <a href="/CRM3/views/viewRequests.cfm">View Requests</a>

</div>
