<!DOCTYPE html>
<html>
<head>
    <title>CRM Home</title>
    <link rel="stylesheet" href="../css/home.css">
</head>

<body>

    <!-- Welcome Text -->
    <div class="home-content">
        <cfoutput>
            <h1 class="welcome-text">Welcome User, #session.username#!</h1>
        </cfoutput>

        <!-- Buttons -->
        <div class="home-buttons">

            <a href="/CRM3/views/viewRequests.cfm" class="btn btn-blue">
                View Requests
            </a>

            <a href="/CRM3/views/myprofile.cfm" class="btn btn-green">
                Go To My Profile
            </a>

            <cfif structKeyExists(session, "adminstatus") AND session.adminstatus EQ "1">
                <a href="/CRM3/views/customers.cfm" class="btn btn-orange">
                    Customers Management
                </a>
            </cfif>

        </div>
    </div>

</body>
</html>
