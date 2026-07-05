UPI Transaction Insights Dashboard

An end-to-end data analysis project simulating a fintech company's UPI (Unified Payments Interface) transaction data - from raw dataset generation through cleaning, SQL analysis, and an interactive Power BI dashboard, culminating in business-facing insights and recommendations.

Built to demonstrate the full data-to-decision workflow expected of a Data/Business Analyst role: generating and cleaning data, writing analytical SQL, building stakeholder-ready visualizations, and translating findings into actionable business recommendations.


Project Overview


Dataset: 9,467 simulated UPI transactions across 2024
Tools used: Python (pandas), Excel, SQLite, Power BI, DAX
Workflow: Dataset generation → Data cleaning (Excel + pandas) → SQL analysis → Dashboard → Insight writeup



Folder Structure

FolderContents1_dataset_generation/Python script generating a realistic synthetic UPI transaction dataset2_data_cleaning/Data cleaning using Excel and pandas: handling nulls, formatting, deduplication3_sql_analysis/7 SQL queries answering key business questions, plus the CSV export script4_powerbi_dashboard/The .pbix Power BI file and page-by-page screenshots5_insights_summary/Full written analysis: findings + business recommendationsexports/CSV outputs of each SQL query, used to power the Power BI dashboard


Dashboard Preview

Page 1 - Executive Overview: Success/failure rates, failure reason breakdown, payment method comparison
Page 2 - Regional & Payment Insights: City tier performance (volume vs. transaction value)
Page 3 - User Behavior & Segmentation: Cohort retention trends, RFM user segmentation

(See 4_powerbi_dashboard/screenshots/ for page previews)


Key Findings


21.35% of transactions fail - a systemic reliability issue, not specific to any payment method or city tier
Network Error + Timeout account for ~38% of failures - the largest controllable share, pointing to infrastructure as the top fix priority
Retention drops from 91.56% (January cohort) to 50.33% (June cohort) - signals a need for stronger new-user onboarding
Only 1.2% of users are "High Value" (RFM segmentation), yet they likely drive disproportionate transaction value - a strong case for a targeted loyalty program
Tier 3 cities have the highest average transaction value despite the lowest volume  an underleveraged growth opportunity


Full analysis with business recommendations: 5_insights_summary/insights_summary.md


Tech Stack


Python - dataset generation, data cleaning (pandas)
Excel -data cleaning and initial validation
SQLite - analytical querying
Power BI - dashboarding and DAX measures
Git/GitHub - version control and portfolio hosting



Author

Harsh - BTech Computer Science student.
