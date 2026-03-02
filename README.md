# 📊 AdventureWorks 2019 - Sales Performance Analysis

## 📌 Project Overview
This project analyzes sales performance using the AdventureWorks 2019 database.  
The goal is to evaluate revenue growth, territory performance, and long-term business trends using SQL Server and Power BI.

---

## 🏢 Business Problem

AdventureWorks wants to evaluate long-term revenue growth and identify high-performing territories.  
Management needs a clear view of:

- Is revenue growing sustainably?
- Which territories drive the most revenue?
- Which regions show strongest long-term growth (CAGR)?
- Where should expansion strategy focus?

This project answers those questions using structured SQL analysis and interactive dashboards.

---

## 🎯 Business Objectives
- Analyze Year-over-Year (YoY) revenue growth
- Calculate 4-year CAGR (Compound Annual Growth Rate)
- Evaluate revenue performance by Sales Territory
- Identify top-performing regions and growth trends
- Build an interactive Power BI dashboard for business users

---

## 🛠 Tools & Technologies
- SQL Server (T-SQL)
- Window Functions (LAG)
- CTE (Common Table Expressions)
- Power BI (Data Modeling & Visualization)
- GitHub (Project Documentation)

---

## 📂 Dataset
Database: AdventureWorks2019  
Main tables used:
- Sales.SalesOrderHeader
- Sales.SalesTerritory

---

## 🔎 Key Analysis

### 1️⃣ Yearly Revenue & YoY Growth
- Aggregated revenue by year
- Used LAG() to calculate previous year revenue
- Calculated YoY growth %

### 2️⃣ 4-Year CAGR
CAGR Formula:
Applied to:
- Overall company revenue
- Revenue by Territory

### 3️⃣ Territory Performance
- Joined SalesOrderHeader with SalesTerritory
- Calculated revenue contribution %
- Ranked territories by growth

---

## 📊 Dashboard Highlights (Power BI)
- KPI Cards (Total Revenue, YoY %, CAGR)
- Revenue Trend Line
- Revenue by Territory (Bar Chart)
- Growth % by Territory
- Interactive Filters (Year, Territory)

---
## 📊 Key Results

- Total Revenue (4 years): $123216786,11
- 4-Year CAGR: 51.24%
- Highest Revenue Territory: Southwest
- Fastest Growing Territory (CAGR): France
- Average YoY Growth: 47,30%

---
## 📈 Key Insights
- Revenue shows consistent upward growth trend
- North America contributes the highest revenue share
- Some territories show higher CAGR despite lower total revenue
- Growth rate analysis helps identify emerging markets

---

## 🚀 Business Impact
This analysis helps management:
- Monitor revenue growth trends
- Compare performance across territories
- Identify high-growth regions
- Support strategic expansion decisions

---

## 👤 Author
Nam Tran
Aspiring Financial Data Analyst  
Focus: SQL • Power BI • Financial Analytics
