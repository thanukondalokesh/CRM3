function openModal() {
    document.getElementById("uploadModal").style.display = "block";
}

function closeModal() {
    document.getElementById("uploadModal").style.display = "none";
}

function editAbout() {
    document.getElementById("aboutText").style.display = "none";
    document.getElementById("aboutForm").style.display = "block";
}

function cancelAbout() {
    document.getElementById("aboutText").style.display = "block";
    document.getElementById("aboutForm").style.display = "none";
}
function viewImage() {
    document.getElementById("viewImageModal").style.display = "flex";
}

function closeImageView() {
    document.getElementById("viewImageModal").style.display = "none";
}

// Close on outside click
window.onclick = function(event) {
    let modal = document.getElementById("viewImageModal");
    if (event.target === modal) {
        modal.style.display = "none";
    }
}

// ======================= SHOW POPUP MESSAGES ========================= //
window.onload = function () {
    const params = new URLSearchParams(window.location.search);
    const msg = params.get("msg");

    if (msg === "upload_success") {
        alert("Image uploaded successfully!");
    }
    else if (msg === "upload_fail") {
        alert("Failed to upload image. Try again.");
    }
    else if (msg === "delete_success") {
        alert("Profile picture deleted successfully.");
    }
    else if (msg === "delete_fail") {
        alert("Failed to delete picture. Try again.");
    }
    else if (msg === "about_success") {
        alert("About information updated successfully.");
    }
};

// ======================= DELETE CONFIRMATION ========================= //
function confirmDelete() {
    return confirm("Are you sure you want to delete your profile picture?");
}
