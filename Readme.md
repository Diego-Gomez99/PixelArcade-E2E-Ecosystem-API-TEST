## 🕹️PixelArcade - E2E API Test Automation & DB Integrity Suite

![Postman](https://img.shields.io/badge/Postman-FF6C37?style=for-the-badge&logo=postman&logoColor=white)
![Newman](https://img.shields.io/badge/Newman-212121?style=for-the-badge&logo=npm&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)
![Git](https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white)

## 📌Project Overview
This repository contains an API test automation suite and database data integrity verification scripts for the **PixelArcade** ecosystem.
The primary objective is to validate the critical **Checkout** transaction flow and corresponding item entitlement (**Fulfillment**) in the user's inventory.

---

## 🏗️ Architecture & Project Structure

```text
PixelArcade_QA_Portfolio/
├── 📁 database/
│   ├── Pixel_Arcade_Ecosystem_DATA_INTEGRITY.sql       # DDL, Schema & Mock Data
│   ├── Pixel_Arcade_Ecosystem_Duplicate_Payments.sql   # Duplicate transaction detection
│   ├── Pixel_Arcade_Ecosystem_Missing_Fulfillment.sql # Unfulfilled completed payment checks
│   └── Pixel_Arcade_Ecosystem_Orphan_Inventory.sql   # Orphaned inventory records audit
│
├── 📁 postman/
│   ├── PixelArcade_QA_API.postman_collection.json     # Test scripts & requests collection
│   └── Staging_Env.json                               # Environment variables (baseUrl, IDs)
│
├── 📁 reports/
│   └── .gitkeep                                       # Output directory for Newman HTML reports
│
├── .gitignore
└── README.md
```

---

## 🧪API Test Coverage (Postman)
The Postman collection covers happy path flows, edge cases, negative scenarios, and Dynamic paremeter passing between requests:

| Suite / Folder | Endpoint | Method | ID | Objective / Assertions |
|---|---|---|---|---|
| `02_Store_&_Checkout` | `/purchases/checkout` | `POST` | **TC-01** | Validates HTTP `201 Created`, response latency `< 500ms`, and dynamically extracts `purchase_id` to environment. |
| `02_Store_&_Checkout` | `/purchases/checkout` | `POST` | **TC-02** | Validates error handling for HTTP `400 Bad Request` on incomplete payloads using Mock Headers (`x-mock-response-code`). |
| `03_Inventory_Fulfillment` | `/inventory/:user_id` | `GET` | **TC-03** | Validates HTTP `200 OK`, JSON schema structure, and confirms `item_id: 1` entitlement. |

---

## 🗄️Database Integrity Verification (PostgreSQL)
To guarantee end-to-end data consistency between the API layer and the relational database, advanced SQL verification scripts are provided under /database/:

*1**Schema & Data Integrity:** Primary/Foreign key constraints and data type setup.
*2**Missing Fulfillment Audit:** Indetifies transactions marked as '"COMPLETED"' whose '"item_id"' failed to reflect in '"user_inventory"'(**LEFT JOIN**/**IS NULL**).
*3**Duplicate Payment:** Uses SQL aggregations (**COUNT**,**HAVING**) to detect duplicate payment processing within identical timeframes.
*4**Orphan Inventory Clean-up:** Audits inventory ítems lacking active user or valid transaction references.

---

## 🚀Headless Execution via Newman (CLI)

**Prerequisites**

* Node.js(v18+)
* Newman and the 'htmlextra' reporter installed globally:
  
    → npm install -g newman newman-reporter-htmlextra

**Run Suite & Generate HTML Report**
Run the following command from the project root directory:

    → newman run postman/PixelArcade_QA_API.postman_collection.json \-e postman/Staging_Env.json \ -r "cli,htmlextra" \--reporter-htmlextra-export reports/reporte-api.html
  
---

## 🔎QA Analysis & Root Cause Diagnosis (RCA)
During headless executions via Newman against simulated enviroments (Postman Mock Servers):

* **Cloud Latency & Cold Starts:** Fluctuations in response time assertions (e.g '> 500ms' or initial server warm-up delays) may occur.
* **Technical Assessment:** Response time assertions failures in mock runs represents an enviromental limitations of cloud-shared mock serves('mock.pstm.io') rather than a
  functional API defect.
* **Recommendation:** Indedicated CI/CD Staging pipelines, keep strict SLAs('< 500ms'). For shared mock server execution, adjust threshold to '< 3000ms'.
