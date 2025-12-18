// /CRM3/scriptjs/viewRequests.js

window.addEventListener("DOMContentLoaded", () => {
    initRequestPage();
});

function initRequestPage() {
    loadRequests();

    const clearBtn = document.getElementById("clearBtn");
    const searchEl = document.getElementById("searchText");
    const deptEl = document.getElementById("department");

    if (clearBtn) {
        clearBtn.onclick = (e) => {
            e.preventDefault();
            deptEl.value = "";
            searchEl.value = "";
            loadRequests();
        };
    }

    if (searchEl) searchEl.addEventListener("keyup", loadRequests);
    if (deptEl) deptEl.addEventListener("change", loadRequests);
}

function loadRequests() {
    const dept = document.getElementById("department").value;
    const search = document.getElementById("searchText").value;

    fetch(
        `viewRequests.cfm?ajax=1&department=${encodeURIComponent(dept)}&searchText=${encodeURIComponent(search)}`
    )
        .then(res => res.json())
        .then(data => {
            renderTable(data);
            setupPagination();
        })
        .catch(err => {
            console.error("Failed to load requests", err);
        });
}

function renderTable(data) {
    const tbody = document.getElementById("reqBody");
    tbody.innerHTML = "";

    if (!data || data.length === 0) {
        tbody.innerHTML = "<tr><td colspan='7'>No records found</td></tr>";
        return;
    }

    data.forEach(r => {
        tbody.innerHTML += `
        <tr>
            <td>${r.id}</td>
            <td>${r.username}</td>
            <td>${r.department}</td>
            <td>${r.title}</td>
            <td>${r.description}</td>
            <td>${formatDate(r.date)}</td>
            <td>
                <a href="editRequest.cfm?id=${r.id}" class="btn-edit">Edit</a>
                <a href="deleteRequest.cfm?id=${r.id}" class="btn-delete"
                   onclick="return confirm('Are you sure you want to delete this record?');">
                   Delete
                </a>
            </td>
        </tr>`;
    });
}

function formatDate(dt) {
    if (!dt) return "-";
    try { return new Date(dt).toLocaleString(); }
    catch { return dt; }
}

/* ===== PDF BUTTON HANDLER ===== */
function openAndDownload() {

    const dept = document.getElementById("department").value;
    const search = document.getElementById("searchText").value;

    let url = "../Downloads/viewrequests_pdf.cfm";

    if (dept !== "") {
        url += "?department=" + encodeURIComponent(dept);
    }

    if (search.trim() !== "") {
        url += (url.includes("?") ? "&" : "?") +
               "searchText=" + encodeURIComponent(search);
    }

    window.open(url, "_blank");
}
