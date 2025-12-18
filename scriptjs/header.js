document.addEventListener("DOMContentLoaded", function () {
    const menu = document.getElementById("dropdownMenu");
    const toggle = document.getElementById("menuToggle");

    toggle.addEventListener("click", () => {
        menu.style.display = menu.style.display === "block" ? "none" : "block";
    });

    // Click outside to close
    document.addEventListener("click", function(e) {
        if (!toggle.contains(e.target) && !menu.contains(e.target)) {
            menu.style.display = "none";
        }
    });
});
