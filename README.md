#End to End ETL: Candidate Selection

## 1. Dimensional Data Model (DDM) - Star Schema

To ensure high performance for analytical queries and dashboards, the data architecture was designed following a strict Star Schema methodology. This separation into Facts and Dimensions guarantees data integrity, avoids redundancy, and allows scalable aggregations for our specific KPIs.

### Star Schema Diagram
![Star Schema Diagram](<img width="1009" height="519" alt="star-shema" src="https://github.com/user-attachments/assets/502f63bc-5183-4062-8ad3-32edd523556c" />
)

### Design Justification

The decision to separate the raw CSV into a central Fact table surrounded by five Dimension tables responds to the specific reporting requirements:

#### A. Dimension Tables (Context)
*   **`dim_date`:** A dedicated date dimension is critical for time-series analysis. Extracting the `year` explicitly fulfills the requirement for the *"Hires by year"* KPI, avoiding heavy runtime date parsing functions on the database engine.
*   **`dim_country`:** Normalizing countries prevents string manipulation errors and accelerates grouping operations for the *"Hires by country over years"* KPI.
*   **`dim_technology` & `dim_seniority`:** Categorical data that requires frequent grouping for the pie and bar chart KPIs. Normalizing these allows for distinct counting and future expansion without altering the fact table structure.
*   **`dim_candidate`:** Stores personally identifiable information (PII) such as Name and Email. Keeping this separated from the fact table reduces the row size of analytical queries that do not require personal data, significantly improving performance.

#### B. Fact Table (Metrics & Events)
*   **`fact_applications`:** This is the central repository holding the Foreign Keys (FK) linking to all dimensions.
    *   **Metrics stored:** It contains the purely numerical values (`yoe`, `code_challenge_score`, `technical_interview_score`).
    *   **Business Rule Pre-computation:** The `is_hired` field is implemented as a boolean. Instead of calculating `(code_challenge_score >= 7 AND technical_interview_score >= 7)` every time a dashboard loads, this transformation is handled during the ETL phase. This shift from "compute on read" to "compute on write" drastically minimizes query latency in the Data Warehouse.
