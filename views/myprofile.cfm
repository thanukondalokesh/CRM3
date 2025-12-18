


<!-- Fetch User -->
<cfset imageFile = trim(session.profilepath)>
<cfset defaultImage = "../uploads/default piture image.png">

<!-- Always load default image if no uploaded image -->
<cfif len(imageFile) AND fileExists(expandPath("../uploads/#imageFile#"))>
    <cfset imageURL = "../uploads/#imageFile#">
<cfelse>
    <cfset imageURL = defaultImage>
</cfif>

<!-- =============== UPLOAD LOGIC ================= -->
<cfif structKeyExists(form, "btnUpload")>
    <cftry>

        <cfset uploadPath = expandPath("../uploads")>

        <!-- Upload image -->
        <cffile 
            action="upload"
            fileField="uploadFile"
            destination="#uploadPath#"
            nameConflict="makeUnique"
            result="fileDetails">

        <!-- Resize & Crop -->
        <cfset img = imageRead(fileDetails.serverDirectory & "/" & fileDetails.serverFile)>
        <cfset imageScaleToFit(img, 500, 500)>

        <cfset size = min(img.width, img.height)>
        <cfset x = int((img.width - size) / 2)>
        <cfset y = int((img.height - size) / 2)>
        <cfset imageCrop(img, x, y, size, size)>

        <cfset finalFile = fileDetails.serverDirectory & "/" & fileDetails.serverFile>
        <cfset imageWrite(img, finalFile)>

        <!-- Save to session -->
        <cfset session.profilepath = fileDetails.serverFile>

        <!-- Save to DB -->
        <cfquery datasource="#application.datasource#">
            UPDATE users
            SET profile_image_path =
                <cfqueryparam value="#fileDetails.serverFile#" cfsqltype="cf_sql_varchar">
            WHERE username =
                <cfqueryparam value="#session.username#" cfsqltype="cf_sql_varchar">
        </cfquery>

        <cflocation url="myprofile.cfm?msg=upload_success" addtoken="false">

        <cfcatch>
            <cflocation url="myprofile.cfm?msg=upload_fail" addtoken="false">
        </cfcatch>

    </cftry>
</cfif>

<!-- =============== DELETE PHOTO ================= -->
<cfif structKeyExists(url, "deletePic")>
    <cfif len(session.profilepath)>
        <cftry>

            <cffile action="delete" file="#expandPath('../uploads/#session.profilepath#')#">

            <cfquery datasource="#application.datasource#">
                UPDATE users SET profile_image_path = NULL
                WHERE username =
                    <cfqueryparam value="#session.username#" cfsqltype="cf_sql_varchar">
            </cfquery>

            <cflocation url="myprofile.cfm?msg=delete_success" addtoken="false">

            <cfcatch>
                <cflocation url="myprofile.cfm?msg=delete_fail" addtoken="false">
            </cfcatch>

        </cftry>
    </cfif>
</cfif>

<!-- =============== UPDATE ABOUT ================= -->
<cfif structKeyExists(form, "btnSaveAbout")>
    <cfquery datasource="#application.datasource#">
        UPDATE users
        SET about = <cfqueryparam value="#form.aboutText#" cfsqltype="cf_sql_varchar">
        WHERE username = <cfqueryparam value="#session.username#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <cfset session.about = form.aboutText>
    <cflocation url="myprofile.cfm?msg=about_success" addtoken="false">
</cfif>


<!-- =============== FRONTEND UI ================= -->
<!DOCTYPE html>
<html>
<head>
    <title>My Profile</title>
    <link rel="stylesheet" href="../css/myprofile.css">
    <script src="../scriptjs/myprofile.js"></script>
</head>

<body>

<div class="profile-container">
<h2>My Profile  </h2>

    <div class="image-section">
        <cfoutput>
            <img src="#imageURL#" class="profile-pic" onclick="viewImage()">
        </cfoutput>
        <button class="edit-btn" onclick="openModal()">Edit Photo</button>

        <a href="myprofile.cfm?deletePic=1"
           onclick="return confirmDelete();"
           class="delete-photo">Remove Photo</a>
    </div>

    <div class="info-section">
        <cfoutput>
            <p><b>Username:</b> #session.username#</p>
            <p><b>Email:</b> #session.email#</p>

            <div class="about-box">
                <p><b>About:</b>
                    <span id="aboutText">#session.about#</span>
                    <i class="edit-icon" onclick="editAbout()">✏️</i>
                </p>

                <form id="aboutForm" method="post" style="display:none;">
                    <textarea name="aboutText" class="about-input">#session.about#</textarea>
                    <br>
                    <button type="submit" name="btnSaveAbout" class="save-btn">Save</button>
                    <button type="button" onclick="cancelAbout()" class="cancel-btn">Cancel</button>
                </form>
            </div>
        </cfoutput>
    </div>

    <a href="../views/home.cfm" class="forgot-link">← Back to Home</a>
</div>

<!-- Upload Modal -->
<div id="uploadModal" class="modal">
    <div class="modal-content">
        <h3>Change Profile Picture</h3>

        <form method="post" enctype="multipart/form-data">
            <input type="file" name="uploadFile" accept="image/*" required><br>
            <button type="submit" name="btnUpload" class="save-btn">Upload</button>
        </form><br>

        <button class="close-btn" onclick="closeModal()">Close</button>
    </div>
</div>

<!-- View Full Image Modal -->
<div id="viewImageModal" class="modal">
    <div class="image-view-box">
        <span class="close-full-img" onclick="closeImageView()">✖</span>

        <cfoutput>
            <img src="#imageURL#" id="fullImage" class="full-image">
        </cfoutput>
    </div>
</div>

<!-- Toast Message -->
<cfif structKeyExists(url, "msg")>
    <div class="toast">
        <cfoutput>#url.msg#</cfoutput>
    </div>
</cfif>

</body>
</html>
