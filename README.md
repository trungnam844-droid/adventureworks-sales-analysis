# 📊 Financial Performance & Growth Analysis – AdventureWorks 2019

## 📌 Project Overview
This project delivers a financial performance analysis using the AdventureWorks2019 database.  

The objective is to evaluate revenue growth sustainability, profitability trends, and territory performance over a 4-year period using advanced SQL techniques and an interactive Power BI dashboard.

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
- Analyze Year-over-Year (YoY) revenue and profit growth
- Calculate 4-year CAGR (Compound Annual Growth Rate)
- Evaluate revenue and profitability by Sales Territory
- Measure gross margin and contribution %
- Identify high-growth and high-margin regions
- Build an executive-level Power BI dashboard  

---

## 🛠 Tools & Technologies
- SQL Server (T-SQL)
- Window Functions (LAG)
- CTE (Common Table Expressions)
- Power BI (Data Modeling & Visualization)
- GitHub (Project Documentation)

---

## 🧠 SQL Techniques Demonstrated
- CTE (Common Table Expressions)
- Window Functions (LAG)
- Financial KPI calculation (YoY, CAGR)
- Multi-table JOIN
- NULL handling (NULLIF)
- Revenue aggregation and growth modeling
- FIRST_VALUE() & LAST_VALUE()
- Window Frame specification
- CAGR calculation using POWER()
- Financial modeling logic in SQL

---

## 📂 Dataset
Database: AdventureWorks2019  
Main tables used:
- Sales.SalesOrderHeader
- Sales.SalesTerritory
- Sales.SalesOrderDetail
- Production.Product
- Production.ProductSubcategory
- Production.ProductCategory  

---

## 🔎 Key Analysis

### 1️⃣ Yearly Revenue & YoY Growth
- Aggregated revenue by year
- Used LAG() to calculate previous year revenue
- Calculated YoY growth %
- Compared revenue growth with profit growth to assess growth quality

### 2️⃣ 4-Year CAGR
CAGR Formula: CAGR = (Ending Value / Beginning Value) ^ (1 / Number of Years) - 1
Applied to:
- Overall company revenue
- Revenue by Territory
- Measured sustainable long-term growth using CAGR to complement YoY analysis.

### 3️⃣ Territory Financial Performance
- Joined SalesOrderHeader with SalesTerritory
- Calculated revenue and profit contribution %
- Analyzed Gross Margin % by territory
- Ranked territories by revenue and CAGR
- Identified high-growth vs high-revenue markets

---

## 📊 Dashboard Highlights (Power BI)
- Executive KPI Cards (Revenue, Profit, Margin %, YoY %, CAGR)
- Revenue vs Profit Trend Analysis
- Territory Contribution & Growth Comparison
- Profitability by Product Category
- Interactive filtering for dynamic financial analysis

---
## 📊 Key Results

- Total Revenue (4 years): $123.22M
- Total Profit (4 years): $9.37M
- Average Gross Margin: 8.53%
- 4-Year CAGR: 51.24%
- Average YoY Growth: 47.30%
- Highest Revenue Territory: Southwest
- Fastest Growing Territory (CAGR): France

---
## 📈 Key Insights
- Revenue shows consistent upward growth trend
- North America region, particularly Southwest territory, dominates revenue contribution
- Some territories show higher CAGR despite lower total revenue
- Growth rate analysis helps identify emerging markets
- Gross margin remains relatively stable at 8.53%, indicating consistent cost structure despite rapid revenue growth

---

## 🚀 Business Impact
This analysis enables management to:
- Assess revenue sustainability and growth quality
- Compare financial performance across territories
- Identify high-growth and high-margin regions
- Support data-driven strategic expansion decisions
- Monitor profitability beyond top-line revenue metric

---

## 👤 Author
Nam Tran
Aspiring Financial Data Analyst  
Focus: SQL • Power BI • Financial Analytics
