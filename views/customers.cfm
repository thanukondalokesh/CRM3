<!--- /CRM/views/customers.cfm --->
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Customers AJAX</title>

    <link rel="stylesheet" href="../css/customer.css">
    <script src="../scriptjs/customers.js"></script>
</head>

<body>


<br>

    <div class="top-btn-row">
    <a href="../views/home.cfm" class="btn-back-link">← Back to Home</a>

    <a href="/CRM3/Downloads/customersPDF.cfm?download=1"
       target="_blank" id="pdfLink" class="btn-success">
       Download Customers PDF
    </a>
</div>





<!-- ======================  TWO COLUMN SECTION  ====================== -->
<section class="content-row" style="margin-top: 25px;">


    <!-- LEFT FORM -->
    <aside class="left-box">
        <div class="card">
            <h2 class="section-title">Customer</h2>

            <!-- REAL AJAX FORM -->
            <form id="customerForm" onsubmit="saveCustomer(event)">

                <!-- Hidden Id -->
                <input type="hidden" id="id">

                <label class="label">Name</label>
                <input type="text" id="name" class="input" required>

                <label class="label">Email</label>
                <input type="email" id="email" class="input" required>

                <label class="label">Phone</label>
                <input type="text" id="phone" class="input" maxlength="10" pattern="\d{10}" required>

                <br><br>

                <!-- FORM BUTTONS -->
                <div class="form-actions">
                    <button id="saveBtn" type="submit" class="btn-primary">Save</button>

                    <button id="updateBtn" type="submit" class="btn-primary" style="display:none;">Update</button>

                    <button type="button" class="btn-clear" onclick="resetForm()">Clear</button>
                </div>

            </form>
        </div>
    </aside>


    <!-- RIGHT SEARCH PANEL -->
<aside class="right-box">
    <div class="card search-card">
        <h2 class="section-title">Search</h2>

        <div class="search-row">
            <input type="text" id="searchBox" class="search-input"
                   placeholder="Search by name or email"
                   onkeyup="loadCustomers()">

            <button id="clearBtn" class="btn-clear" onclick="clearSearch()">Clear</button>
        </div>
        <br>

        <div class="search-note">Typing will search automatically.</div>
    </div>
</aside>


</section>



<!-- ======================  TABLE LIST  ====================== -->

<h2 class="section-title">Customer List</h2>

<div class="table-wrap">
    <table class="data-table">
        <thead>
            <tr>
                <th>ID</th><th>User</th><th>Name</th><th>Email</th><th>Phone</th><th>Actions</th>
            </tr>
        </thead>
        <tbody id="customerTable"></tbody>
    </table>

    <div id="pagination" style="margin-top:20px;"></div>
</div>


<!-- ========================================= -->
<!-- ==== EDIT POPUP MODAL (ADDED HERE) ====== -->
<!-- ========================================= -->
<div id="editModal" class="modal-overlay">
    <div class="modal-box">
        <h2>Edit Customer</h2>

        <label>Name</label>
        <input type="text" id="edit_name" class="input">

        <label>Email</label>
        <input type="email" id="edit_email" class="input">

        <label>Phone</label>
        <input type="text" id="edit_phone" class="input">

        <div class="modal-actions">
            <button class="action-btn btn-edit" onclick="updateCustomer()">Update</button>
            <button class="action-btn btn-delete" onclick="closeModal()">Cancel</button>
        </div>

        <input type="hidden" id="edit_id">
    </div>
</div>
<!-- ========================================= -->
<!-- ===== END POPUP MODAL ==================== -->
<!-- ========================================= -->

<!-- EMAIL ALREADY EXISTS POPUP -->
<div id="emailExistsModal" class="modal-overlay">
    <div class="modal-box">
        <h3 style="margin-top:0; text-align:center; color:#d93025;">
            ⚠ Email Already Exists
        </h3>
        <p style="text-align:center; font-size:16px;">
            This email already exists. Please enter a different email.
        </p>

        <div class="modal-actions">
            <button class="btn-primary" onclick="closeEmailPopup()">OK</button>
        </div>
    </div>
</div>


</body>
</html>
