// /CRM/scriptjs/customers.js

const api = "/CRM3/components/CustomerService.cfc";

let currentPage = 1;
let pageSize = 5;

// Escape HTML
function escapeHTML(t) {
    return t?.replace(/[&<>"']/g, m => ({
        "&": "&amp;", "<": "&lt;", ">": "&gt;",
        '"': "&quot;", "'": "&#039;"
    })[m]);
}

// ===========================================
// LOAD CUSTOMERS
// ===========================================
async function loadCustomers() {
    const search = document.getElementById("searchBox").value || "";

    const res = await fetch(
        `${api}?method=getCustomers&returnformat=json&page=${currentPage}&pageSize=${pageSize}&search=${encodeURIComponent(search)}`
    );

    const result = await res.json();

    const tbody = document.getElementById("customerTable");
    tbody.innerHTML = "";

    result.data.forEach(c => {
        tbody.innerHTML += `
            <tr>
                <td>${c.id}</td>
                <td>${escapeHTML(c.username)}</td>
                <td>${escapeHTML(c.name)}</td>
                <td>${escapeHTML(c.email)}</td>
                <td>${escapeHTML(c.phone)}</td>
                <td>
                    <button class="action-btn btn-edit" onclick="editCustomer(${c.id})">Edit</button>
                    <button class="action-btn btn-delete" onclick="deleteCustomer(${c.id})">Delete</button>
                </td>
            </tr>`;
    });

    updatePagination(result.total);
}

// ===========================================
// PAGINATION
// ===========================================
function updatePagination(totalRecords) {
    const totalPages = Math.ceil(totalRecords / pageSize);
    const p = document.getElementById("pagination");

    let html = `<div class="pagination-container">`;

    if (currentPage > 1) {
        html += `<button class="page-btn" onclick="gotoPage(${currentPage - 1})">Previous</button>`;
    }

    for (let i = 1; i <= totalPages; i++) {
        html += `<button class="page-btn ${i === currentPage ? 'active-page' : ''}" onclick="gotoPage(${i})">${i}</button>`;
    }

    if (currentPage < totalPages) {
        html += `<button class="page-btn" onclick="gotoPage(${currentPage + 1})">Next</button>`;
    }

    html += `</div>`;
    p.innerHTML = html;
}

function gotoPage(page) {
    currentPage = page;
    loadCustomers();
}

// ===========================================
// SAVE CUSTOMER  (FULLY FIXED)
// ===========================================
async function saveCustomer(e) {
    e.preventDefault();

    let name = document.getElementById("name").value.trim();
    let email = document.getElementById("email").value.trim();
    let phone = document.getElementById("phone").value.trim();

    // 1. Check email exists
    let check = await fetch(`${api}?method=emailExists&email=${encodeURIComponent(email)}&returnformat=json`);
    check = await check.json();

    if (check.exists) {
        showEmailPopup();
        return;
    }

    // 2. Save customer using CFC
    let formData = new FormData();
    formData.append("method", "saveCustomer");  // IMPORTANT
    formData.append("name", name);
    formData.append("email", email);
    formData.append("phone", phone);

    let res = await fetch(api, {
        method: "POST",
        body: formData
    });

    let result = await res.json();

    if (result.status === true || result.success === true) {
    alert(result.message || "Customer saved successfully");
    resetForm();
    loadCustomers();
}

     else {
        alert(result.message || "Save failed");
    }
}

// ===========================================
// EDIT CUSTOMER
// ===========================================
async function editCustomer(id) {
    const res = await fetch(`${api}?method=getCustomer&id=${id}&returnformat=json`);
    const c = await res.json();

    document.getElementById("edit_id").value = c.id;
    document.getElementById("edit_name").value = c.name;
    document.getElementById("edit_email").value = c.email;
    document.getElementById("edit_phone").value = c.phone;

    document.getElementById("editModal").style.display = "flex";
}

function closeModal() {
    document.getElementById("editModal").style.display = "none";
}

// ===========================================
// UPDATE CUSTOMER
// ===========================================
async function updateCustomer() {
    const id = document.getElementById("edit_id").value;
    const name = document.getElementById("edit_name").value.trim();
    const email = document.getElementById("edit_email").value.trim();
    const phone = document.getElementById("edit_phone").value.trim();

    if (!id || !name || !email) {
        alert("Name & Email required.");
        return;
    }

    // Check email exists
    let checkRes = await fetch(`${api}?method=emailExists&email=${encodeURIComponent(email)}&id=${id}&returnformat=json`);
    let check = await checkRes.json();

    if (check.exists) {
        showEmailPopup();
        return;
    }

    // Update using same CFC saveCustomer
    let formData = new FormData();
    formData.append("method", "saveCustomer");
    formData.append("id", id);
    formData.append("name", name);
    formData.append("email", email);
    formData.append("phone", phone);

    let res = await fetch(api, {
        method: "POST",
        body: formData
    });

    let result = await res.json();

    if (result.status === true || result.success === true) {
    alert(result.message || "Customer updated successfully");
    closeModal();
    loadCustomers();
}

     else {
        alert(result.message || "Update failed");
    }
}

// ===========================================
// DELETE CUSTOMER
// ===========================================
async function deleteCustomer(id) {
    if (!confirm("Are you sure you want to delete this record?")) return;

    const res = await fetch(`${api}?method=deleteCustomer&id=${id}&returnformat=json`);
    const result = await res.json();

    alert(result.message);
    loadCustomers();
}

// ===========================================
// FORM RESET
// ===========================================
function resetForm() {
    document.getElementById("customerForm").reset();
    document.getElementById("id").value = "";
}

// ===========================================
// EMAIL POPUP
// ===========================================
function showEmailPopup() {
    document.getElementById("emailExistsModal").style.display = "flex";
}

function closeEmailPopup() {
    document.getElementById("emailExistsModal").style.display = "none";
}




// ===========================================
// INIT
// ===========================================
window.onload = function () {
    loadCustomers();
    setupPDFDownload();
};

function clearSearch() {
    document.getElementById("searchBox").value = "";
    loadCustomers();
}
