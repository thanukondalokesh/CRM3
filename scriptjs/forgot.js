// forgot.js
// Enhanced password rule messages + match check + visibility toggle

document.addEventListener("DOMContentLoaded", function () {

    // =======================
    // LIVE PASSWORD MATCH
    // =======================
    const pw1 = document.getElementById("newPassword");
    const pw2 = document.getElementById("confirmPassword");
    const msg = document.getElementById("matchMessage");

    if (pw1 && pw2 && msg) {
        function checkMatch() {
            if (!pw1.value && !pw2.value) {
                msg.textContent = "";
                return;
            }

            if (pw1.value === pw2.value) {
                msg.style.color = "green";
                msg.textContent = "Passwords match ✔";
            } else {
                msg.style.color = "red";
                msg.textContent = "Passwords do not match ✖";
            }
        }

        pw1.addEventListener("input", checkMatch);
        pw2.addEventListener("input", checkMatch);
    }

    // =======================
    // PASSWORD RULE VALIDATION
    // =======================
    function validateRules(pw) {
        if (pw.length < 8) return "Password must be at least 8 characters.";
        if (!/[A-Z]/.test(pw)) return "Include at least 1 uppercase letter.";
        if (!/[a-z]/.test(pw)) return "Include at least 1 lowercase letter.";
        if (!/[0-9]/.test(pw)) return "Include at least 1 number.";
        if (!/[^A-Za-z0-9]/.test(pw)) return "Include at least 1 special character.";
        return "";
    }

    // =======================
    // PASSWORD SHOW / HIDE
    // =======================
    document.querySelectorAll("[data-toggle-pw]").forEach(function (icon) {
        icon.addEventListener("click", function () {
            const targetId = icon.getAttribute("data-toggle-pw");
            togglePassword(targetId, icon);
        });
    });

    function togglePassword(inputId, iconElement) {
        const input = document.getElementById(inputId);
        if (!input) return;

        if (input.type === "password") {
            input.type = "text";
            iconElement.classList.remove("fa-eye");
            iconElement.classList.add("fa-eye-slash");
        } else {
            input.type = "password";
            iconElement.classList.remove("fa-eye-slash");
            iconElement.classList.add("fa-eye");
        }
    }

    // =======================
    // FORM VALIDATION BEFORE SUBMIT
    // =======================
    const form = document.getElementById("resetForm");

    if (form) {
        form.addEventListener("submit", function (e) {

            const p1 = pw1.value.trim();
            const p2 = pw2.value.trim();

            // Check rules one by one
            const ruleMessage = validateRules(p1);
            if (ruleMessage !== "") {
                alert(ruleMessage);
                e.preventDefault();
                return;
            }

            // Match check
            if (p1 !== p2) {
                alert("Passwords do not match.");
                e.preventDefault();
                return;
            }
        });
    }
});
