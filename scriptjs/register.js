// register.js - password validate, eye toggle, live username/email check
document.addEventListener("DOMContentLoaded", function () {

    const pwd = document.getElementById("password");
    const cpwd = document.getElementById("confirmPassword");
    const username = document.getElementById("username");
    const email = document.getElementById("email");
    const matchMessage = document.getElementById("matchMessage");
    const formError = document.getElementById("formError");
    const form = document.getElementById("registerForm");

    // ===========================
    // PASSWORD EYE ICON TOGGLE
    // ===========================
    document.getElementById("togglePassword").onclick = () => toggleEye(pwd, "togglePassword");
    document.getElementById("toggleConfirmPassword").onclick = () => toggleEye(cpwd, "toggleConfirmPassword");

    function toggleEye(field, iconId) {
        let icon = document.getElementById(iconId);
        if (field.type === "password") {
            field.type = "text";
            icon.classList.replace("fa-eye", "fa-eye-slash");
        } else {
            field.type = "password";
            icon.classList.replace("fa-eye-slash", "fa-eye");
        }
    }

    // ===========================
    // LIVE PASSWORD MATCH
    // ===========================
    function checkMatch() {
        if (!pwd.value || !cpwd.value) {
            matchMessage.textContent = "";
            return;
        }

        if (pwd.value === cpwd.value) {
            matchMessage.style.color = "green";
            matchMessage.textContent = "✔ Passwords match";
        } else {
            matchMessage.style.color = "red";
            matchMessage.textContent = "❌ Passwords do not match";
        }
    }

    pwd.addEventListener("input", checkMatch);
    cpwd.addEventListener("input", checkMatch);

    // ===========================
    // PASSWORD RULE CHECK
    // ===========================
    function validateRules(pw) {
        if (pw.length < 8) return "Password must be at least 8 characters.";
        if (!/[A-Z]/.test(pw)) return "Include at least 1 uppercase letter.";
        if (!/[a-z]/.test(pw)) return "Include at least 1 lowercase letter.";
        if (!/[0-9]/.test(pw)) return "Include at least 1 number.";
        if (!/[^A-Za-z0-9]/.test(pw)) return "Include at least 1 special character.";
        return "";
    }

    // ===========================
    // AJAX — CHECK USERNAME
    // ===========================
    username.addEventListener("blur", function () {
        if (!username.value.trim()) return;

        fetch("register.cfm?check=username&value=" + encodeURIComponent(username.value))
            .then(r => r.text())
            .then(res => {
                if (res === "EXISTS") {
                    formError.textContent = "Username already exists, enter a new username.";
                } else {
                    formError.textContent = "";
                }
            });
    });

    // ===========================
    // AJAX — CHECK EMAIL
    // ===========================
    email.addEventListener("blur", function () {
        if (!email.value.trim()) return;

        fetch("register.cfm?check=email&value=" + encodeURIComponent(email.value))
            .then(r => r.text())
            .then(res => {
                if (res === "EXISTS") {
                    formError.textContent = "Email already exists, enter a new email.";
                } else {
                    formError.textContent = "";
                }
            });
    });

    // ===========================
    // FINAL VALIDATION BEFORE SUBMIT
    // ===========================
    form.addEventListener("submit", function (e) {
        formError.textContent = "";

        const pwMsg = validateRules(pwd.value);
        if (pwMsg !== "") {
            e.preventDefault();
            formError.textContent = pwMsg;
            return;
        }

        if (pwd.value !== cpwd.value) {
            e.preventDefault();
            formError.textContent = "Passwords do not match.";
            return;
        }
    });

});
