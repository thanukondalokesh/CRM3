# CRM3
# CRM3 – Customer Relationship Management Application

## 📌 Project Overview

CRM3 is a **Customer Relationship Management (CRM) web application** developed as part of my learning and internship practice. This project demonstrates my understanding of **web application development**, **backend logic**, **AJAX-based interactions**, and **version control using Git & GitHub**.

The application allows managing **users, requests, logs, and customers**, with proper separation of concerns using a controller-based architecture.

---

## 🛠️ Technologies Used

* **Backend:** ColdFusion (CFML)
* **Frontend:** HTML, CSS, JavaScript (AJAX)
* **Database:** MySQL
* **Version Control:** Git & GitHub
* **Server:** Adobe ColdFusion

---

## ✨ Features Implemented

### 🔹 User & Profile Module

* User profile view
* Upload profile picture
* Delete profile picture
* Update "About" information

### 🔹 Request Management Module

* Submit new requests
* View all requests
* Edit and update requests
* Delete requests
* Automatic action logging

### 🔹 Logs Module

* View user action logs
* Sorted by latest activity

### 🔹 Users Module

* View registered users list
* Fetch admin email dynamically

### 🔹 Customer Management Module (AJAX Based)

* View customer list with pagination
* Search customers
* Add new customer
* Edit customer details
* Delete customer
* Email existence validation

### 🔹 PDF & Email Module

* Detect PDF access
* Send email notification to admin

---

## 🗂️ Project Structure

```
CRM3/
│
├── controller.cfc          # Main application controller
├── components/
│   └── CustomerService.cfc # Business logic for customers
├── assets/
│   ├── js/
│   │   └── customers.js    # AJAX logic for customers
│   └── css/
├── uploads/                # Profile image uploads
├── index.cfm               # Application entry point
└── README.md               # Project documentation
```

---

## 🔄 Application Flow (MVC Style)

1. **CFM Pages** trigger actions
2. Requests are routed to **controller.cfc**
3. Controller interacts with **Service (CFC)**
4. Database operations performed
5. Response returned to UI (HTML / JSON)

---

## 📦 Git & GitHub Work Done

* Created a new Git repository named **CRM3**
* Initialized Git in local project folder
* Added project files and committed changes
* Linked local repository with GitHub
* Resolved merge conflicts and pushed code successfully

---

## 🚀 How to Run the Project

1. Place the CRM3 folder inside ColdFusion `wwwroot`
2. Configure the datasource in `Application.cfc`
3. Start ColdFusion server
4. Open browser and run:

   ```
   http://localhost:8500/CRM3
   ```

---

## 🎯 Learning Outcomes

* Hands-on experience with ColdFusion MVC structure
* Strong understanding of AJAX and JSON handling
* Improved debugging skills
* Practical Git & GitHub workflow knowledge

---

## 👤 Author

**Lokesh Thanukonda**
MCA Graduate | Java & Full Stack Learner

---

> This project is created for learning and demonstration purposes.
