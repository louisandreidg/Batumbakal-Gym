const modules = {
    members: {
        title: "Members",
        description: "Manage registered gym members.",
        endpoint: "/api/members",
        key: "memberId",
        fields: [
            ["firstName", "First Name", "text", true],
            ["lastName", "Last Name", "text", true],
            ["email", "Email", "email", true],
            ["contactNumber", "Contact Number", "text", true],
            ["emergencyContact", "Emergency Contact", "text", true],
            ["status", "Status", "select", true, ["Active", "Inactive"]],
            ["trainerId", "Trainer ID", "number", false]
        ]
    },
    trainers: {
        title: "Trainers",
        description: "Manage gym trainers.",
        endpoint: "/api/trainers",
        key: "trainerId",
        fields: [
            ["firstName", "First Name", "text", true],
            ["lastName", "Last Name", "text", true],
            ["specialty", "Specialty", "text", false],
            ["contactNumber", "Contact Number", "text", false]
        ]
    },
    plans: {
        title: "Membership Plans",
        description: "Manage available membership plans.",
        endpoint: "/api/membership-plans",
        key: "planId",
        fields: [
            ["planName", "Plan Name", "text", true],
            ["durationMonths", "Duration (Months)", "number", true],
            ["price", "Price", "number", true]
        ]
    },
    memberships: {
        title: "Memberships",
        description: "Manage member subscriptions.",
        endpoint: "/api/memberships",
        key: "membershipId",
        fields: [
            ["memberId", "Member ID", "number", true],
            ["planId", "Plan ID", "number", true],
            ["startDate", "Start Date", "date", true],
            ["endDate", "End Date", "date", true],
            ["status", "Status", "select", true, ["Active", "Expired", "Cancelled"]]
        ]
    },
    payments: {
        title: "Payments",
        description: "Manage membership payments.",
        endpoint: "/api/payments",
        key: "paymentId",
        fields: [
            ["membershipId", "Membership ID", "number", true],
            ["amount", "Amount", "number", true],
            ["paymentDate", "Payment Date", "date", true],
            ["paymentMethod", "Payment Method", "select", true, ["Cash", "GCash", "Credit Card", "Bank Transfer"]]
        ]
    },
    classes: {
        title: "Classes",
        description: "Manage scheduled gym classes.",
        endpoint: "/api/classes",
        key: "classId",
        fields: [
            ["className", "Class Name", "text", true],
            ["trainerId", "Trainer ID", "number", true],
            ["room", "Room", "text", true],
            ["classDate", "Class Date", "date", true],
            ["startTime", "Start Time", "time", true],
            ["endTime", "End Time", "time", true],
            ["capacity", "Capacity", "number", true]
        ]
    },
    enrollments: {
        title: "Class Enrollments",
        description: "Manage member class registrations.",
        endpoint: "/api/class-enrollments",
        key: ["memberId", "classId"],
        fields: [
            ["memberId", "Member ID", "number", true],
            ["classId", "Class ID", "number", true],
            ["enrollmentDate", "Enrollment Date", "date", true]
        ]
    },
    attendance: {
        title: "Attendance",
        description: "Manage member attendance records.",
        endpoint: "/api/attendance",
        key: "attendanceId",
        fields: [
            ["memberId", "Member ID", "number", true],
            ["checkInTime", "Check-in Time", "datetime-local", true]
        ]
    }
};

let currentModule = "members";
let currentRecords = [];
let editingRecord = null;

const tableHead = document.getElementById("tableHead");
const tableBody = document.getElementById("tableBody");
const modal = document.getElementById("modal");
const recordForm = document.getElementById("recordForm");
const formFields = document.getElementById("formFields");
const message = document.getElementById("message");

function escapeHTML(value) {
    return String(value ?? "").replace(/[&<>"']/g, character => ({
        "&": "&amp;",
        "<": "&lt;",
        ">": "&gt;",
        '"': "&quot;",
        "'": "&#039;"
    })[character]);
}

function showMessage(text, isError = false) {
    message.textContent = text;
    message.style.color = isError ? "#bd3030" : "#218838";
}

async function loadRecords() {
    const config = modules[currentModule];

    try {
        const response = await fetch(config.endpoint);

        if (!response.ok) {
            throw new Error("Unable to load records.");
        }

        currentRecords = await response.json();
        renderTable();
        showMessage("");
    } catch (error) {
        currentRecords = [];
        renderTable();
        showMessage(error.message, true);
    }
}

function renderTable() {
    const search = document.getElementById("searchInput").value.toLowerCase();

    const filteredRecords = currentRecords.filter(record =>
        Object.values(record).some(value =>
            String(value ?? "").toLowerCase().includes(search)
        )
    );

    document.getElementById("recordCount").textContent =
        `${filteredRecords.length} records`;

    if (filteredRecords.length === 0) {
        tableHead.innerHTML = "";
        tableBody.innerHTML =
            `<tr><td colspan="10">No records found.</td></tr>`;
        return;
    }

    const columns = Object.keys(filteredRecords[0]);

    tableHead.innerHTML = `
        <tr>
            ${columns.map(column =>
                `<th>${escapeHTML(column)}</th>`
            ).join("")}
            <th>Actions</th>
        </tr>
    `;

    tableBody.innerHTML = filteredRecords.map(record => {
        const index = currentRecords.indexOf(record);

        return `
            <tr>
                ${columns.map(column =>
                    `<td>${escapeHTML(record[column])}</td>`
                ).join("")}
                <td>
                    <button class="edit-button" data-action="edit" data-index="${index}">Edit</button>
                    <button class="delete-button" data-action="delete" data-index="${index}">Delete</button>
                </td>
            </tr>
        `;
    }).join("");
}

function openModal(record = null) {
    const config = modules[currentModule];

    editingRecord = record;
    formFields.innerHTML = "";

    document.getElementById("formTitle").textContent =
        record ? "Edit Record" : "Add Record";

    config.fields.forEach(field => {
        const [name, label, type, required, options] = field;
        const value = record ? record[name] ?? "" : "";
        const isKey = Array.isArray(config.key)
            ? config.key.includes(name)
            : false;

        let control;

        if (type === "select") {
            control = `
                <select name="${name}" ${required ? "required" : ""}>
                    ${options.map(option => `
                        <option value="${option}" ${value === option ? "selected" : ""}>
                            ${option}
                        </option>
                    `).join("")}
                </select>
            `;
        } else {
            control = `
                <input
                    type="${type}"
                    name="${name}"
                    value="${escapeHTML(value)}"
                    ${required ? "required" : ""}
                    ${record && isKey ? "readonly" : ""}
                    ${type === "number" ? 'step="any"' : ""}
                >
            `;
        }

        formFields.innerHTML += `
            <div class="form-group">
                <label>${label}</label>
                ${control}
            </div>
        `;
    });

    modal.classList.add("show");
}

function closeModal() {
    modal.classList.remove("show");
    recordForm.reset();
    editingRecord = null;
}

async function saveRecord(event) {
    event.preventDefault();

    const config = modules[currentModule];
    const formData = new FormData(recordForm);
    const record = {};

    config.fields.forEach(field => {
        const name = field[0];
        const type = field[2];
        const value = formData.get(name);

        record[name] = value === ""
            ? null
            : type === "number"
                ? Number(value)
                : value;
    });

    let url = config.endpoint;
    let method = "POST";

    if (editingRecord) {
        method = "PUT";

        if (Array.isArray(config.key)) {
            url += "/" + config.key.map(key => editingRecord[key]).join("/");
        } else {
            url += "/" + editingRecord[config.key];
        }
    }

    try {
        const response = await fetch(url, {
            method,
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(record)
        });

        if (!response.ok) {
            const errorText = await response.text();
            throw new Error(errorText || "Unable to save record.");
        }

        closeModal();
        await loadRecords();
        showMessage("Record saved successfully.");
    } catch (error) {
        showMessage(error.message, true);
    }
}

async function deleteRecord(record) {
    const config = modules[currentModule];

    if (!confirm("Are you sure you want to delete this record?")) {
        return;
    }

    let url = config.endpoint;

    if (Array.isArray(config.key)) {
        url += "/" + config.key.map(key => record[key]).join("/");
    } else {
        url += "/" + record[config.key];
    }

    try {
        const response = await fetch(url, {
            method: "DELETE"
        });

        if (!response.ok) {
            const errorText = await response.text();
            throw new Error(errorText || "Unable to delete record.");
        }

        await loadRecords();
        showMessage("Record processed successfully.");
    } catch (error) {
        showMessage(error.message, true);
    }
}

function switchModule(moduleName) {
    currentModule = moduleName;

    document.querySelectorAll(".nav-item").forEach(button => {
        button.classList.toggle(
            "active",
            button.dataset.module === moduleName
        );
    });

    document.getElementById("sectionTitle").textContent =
        modules[moduleName].title;

    document.getElementById("sectionDescription").textContent =
        modules[moduleName].description;

    document.getElementById("searchInput").value = "";

    loadRecords();
}

document.getElementById("navigation").addEventListener("click", event => {
    const button = event.target.closest("[data-module]");

    if (button) {
        switchModule(button.dataset.module);
    }
});

document.getElementById("addButton").addEventListener("click", () => {
    openModal();
});

document.getElementById("closeModal").addEventListener("click", closeModal);
document.getElementById("cancelButton").addEventListener("click", closeModal);
document.getElementById("searchInput").addEventListener("input", renderTable);
recordForm.addEventListener("submit", saveRecord);

tableBody.addEventListener("click", event => {
    const button = event.target.closest("[data-action]");

    if (!button) {
        return;
    }

    const record = currentRecords[Number(button.dataset.index)];

    if (button.dataset.action === "edit") {
        openModal(record);
    }

    if (button.dataset.action === "delete") {
        deleteRecord(record);
    }
});

switchModule("members");