# 🛒 E-Commerce Data Analysis & Customer Segmentation

An end-to-end data analytics project analyzing transactional patterns, unit economics, and customer behavior across **541,000+ retail records** (2009–2011). This project integrates **Python (Pandas, Seaborn)** for data cleaning and RFM segmentation, **MySQL** for relational business intelligence queries, and **Power BI** for executive-level visualization.

---

## 📊 Dashboard Preview
<img width="1038" height="585" alt="Dashboard of E-commerce" src="https://github.com/user-attachments/assets/4a960a6e-e26b-4a74-a64e-e4833b8812cf" />

---

## 🚀 Key Highlights & Insights
* **Global Sales Volume:** Analyzed over **$8.9M in total revenue** across 19,000+ unique customer transactions.
* **Customer Lifetime Value (RFM):** Segmented the customer base into Champions, Loyal Customers, At-Risk Accounts, and Lost Customers to guide targeted retention marketing.
* **Repeat Buyer Trends:** Discovered that single-time buyers account for a massive portion of historical acquisition leaks, proving the need for automated post-purchase onboarding loops.
* **Top-Selling Inventory:** Identified high-velocity stock codes (such as decorative items and gift sets) driving the bulk of inventory turnover.

---

## 🛠️ Tech Stack & Workflow
1. **Data Preprocessing & EDA (Python):** Handled missing `customer_id` rows, dropped cancelled/returned transactions (`Quantity > 0`, invoice prefix checks), engineered revenue metrics (`Quantity * Price`), and built a quartile-based RFM scoring model.

2. **Database Management & Querying (MySQL):** Stored clean relational datasets and authored 14 structured business queries utilizing window functions, subqueries, aggregations, and date formatting.

3. **Interactive Reporting (Power BI):** Designed a clean executive dashboard featuring dynamic regional slices, monthly revenue trends, customer status breakdowns, and top-selling descriptions.

---

## 🔍 Core Business Questions Solved via MySQL
* **Overall Key Metrics:** Calculated total revenue, unique customers, order volume, and active date ranges.
* **Unit Economics & Anomaly Checks:** Verified minimum/maximum pricing boundaries and quantity distributions.
* **RFM Scoring & Tiers:** Calculated Recency, Frequency, and Monetary values to categorize buyers into high-value vs. low-value segments.
* **Geographic Distribution:** Evaluated country-wise customer concentration and global revenue share.
* **Time-Series Trends:** Computed monthly revenue growth, running totals, peak order hours, and day-of-week purchasing habits.

---

## 📁 Repository File Structure

```text
├── Online-Retail-II.csv            # Raw transactional dataset (500k+ rows)
├── e_commerce_eda.ipynb                # Python Jupyter Notebook (Data Cleaning & RFM Model)
├── e_commerce_queries.sql              # MySQL script containing 14 business queries
├── e_commerce_dashboard.pbix           # Power BI interactive report source file
├── e_commerce_dashboard.png            # Executive dashboard screenshot preview
├── LICENSE                             # MIT Open Source License
└── README.md                           # Comprehensive project documentation


## 👨‍💻 Author
**Mayur Sarode**
* Data Analytics & Business Intelligence Portfolio
