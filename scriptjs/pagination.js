/* ============================================================================
   pagination.js  
   - Works for STATIC + AJAX tables
   - Safe for header toggle
============================================================================ */

function setupPagination() {

    const pageSize = 5;
    let currentPage = 1;
    let currentBlock = 1;

    const table = document.querySelector("table");
    if (!table) return;

    const allRows = Array.from(table.querySelectorAll("tr"));
    if (allRows.length <= 1) return;

    const headerRow = allRows[0];
    const dataRows = allRows.slice(1);
    const paginationDiv = document.querySelector(".pagination");
    if (!paginationDiv) return;

    paginationDiv.innerHTML = "";

    function renderPage(page) {
        currentPage = page;

        const start = (page - 1) * pageSize;
        const end = start + pageSize;

        headerRow.style.display = "";

        dataRows.forEach(row => row.style.display = "none");
        dataRows.slice(start, end).forEach(row => row.style.display = "");

        renderPaginationButtons();
    }

    function renderPaginationButtons() {
        const totalPages = Math.ceil(dataRows.length / pageSize);
        const pagesPerBlock = 15;

        paginationDiv.innerHTML = "";

        const blockStart = (currentBlock - 1) * pagesPerBlock + 1;
        const blockEnd = Math.min(blockStart + pagesPerBlock - 1, totalPages);

        const prevBtn = document.createElement("button");
        prevBtn.textContent = "Previous";
        prevBtn.disabled = currentPage === 1;
        prevBtn.onclick = () => {
            if (currentPage - 1 < blockStart) currentBlock--;
            renderPage(currentPage - 1);
        };
        paginationDiv.appendChild(prevBtn);

        for (let i = blockStart; i <= blockEnd; i++) {
            const btn = document.createElement("button");
            btn.textContent = i;
            btn.className = (i === currentPage) ? "active" : "";
            btn.onclick = () => renderPage(i);
            paginationDiv.appendChild(btn);
        }

        const nextBtn = document.createElement("button");
        nextBtn.textContent = "Next";
        nextBtn.disabled = currentPage === totalPages;
        nextBtn.onclick = () => {
            if (currentPage + 1 > blockEnd) currentBlock++;
            renderPage(currentPage + 1);
        };
        paginationDiv.appendChild(nextBtn);
    }

    renderPage(1);
}

/* ✅ AUTO-RUN FOR STATIC PAGES */
document.addEventListener("DOMContentLoaded", () => {
    setupPagination();
});
