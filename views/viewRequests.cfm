<!-- MUST BE FIRST -->
<cfsetting showdebugoutput="false">

<!DOCTYPE html>
<html>
<head>
    <title>View Requests</title>

    <link rel="stylesheet" href="../css/viewRequests.css">
    <link rel="stylesheet" href="../css/pagination.css">

    <script src="../scriptjs/viewRequests.js"></script>
    <script src="../scriptjs/pagination.js"></script>
    
</head>

<body>
<cfoutput>




<div class="top-row">
    <a href="submitRequest.cfm" class="link-submit">+ Submit New Request</a>

    <form action="../views/home.cfm" method="get">
        <button type="submit" class="btn-back">← Back to Home</button>
    </form>
</div>



<hr>

<!-- Search / Filter -->
<div class="filter-form">

    <label for="department">Department:</label>
    <select id="department">
        <option value="">--All Departments--</option>
        <option value="HR">HR</option>
        <option value="Finance">Finance</option>
        <option value="IT">IT</option>
        <option value="Sales">Sales</option>
        <option value="Admin">Admin</option>
    </select>

    <input type="text" id="searchText" placeholder="Search title or description">
    <button id="clearBtn" class="btn-clear">Clear</button>

</div>



<div style="text-align:right;">
  <button onclick="openAndDownload()" class="pdf-btn">
    View & Download PDF Report
  </button>
</div>

<hr>

<h2>All Requests</h2>

<table id="reqTable">
    <tr>
        <th>ID</th>
        <th>User</th>
        <th>Department</th>
        <th>Title</th>
        <th>Description</th>
        <th>Date</th>
        <th>Action</th>
    </tr>

    <tbody id="reqBody"></tbody>
</table>

<!-- Pagination buttons appear here -->
<div class="pagination"></div>

</cfoutput>
</body>
</html>

<!-- ================= AJAX API ================= -->
<cfif structKeyExists(url, "ajax")>
    <cfparam name="url.department" default="">
    <cfparam name="url.searchText" default="">

    <cfquery name="q" datasource="#application.datasource#">
        SELECT *
        FROM requests
        WHERE 1=1
        <cfif len(trim(url.department))>
            AND Department = <cfqueryparam value="#url.department#" cfsqltype="cf_sql_varchar">
        </cfif>
        <cfif len(trim(url.searchText))>
            AND (
                Title LIKE <cfqueryparam value="%#url.searchText#%" cfsqltype="cf_sql_varchar">
                OR Description LIKE <cfqueryparam value="%#url.searchText#%" cfsqltype="cf_sql_varchar">
            )
        </cfif>
        ORDER BY id DESC
    </cfquery>

    <cfset result = []>

    <cfloop query="q">
        <cfset arrayAppend(result, {
            "id" = q.id,
            "username" = q.username,
            "department" = q.department,
            "title" = q.title,
            "description" = q.description,
            "date" = q.action_time
        })>
    </cfloop>

    <cfcontent type="application/json">
    <cfoutput>#serializeJSON(result)#</cfoutput>
    <cfabort>
</cfif>
