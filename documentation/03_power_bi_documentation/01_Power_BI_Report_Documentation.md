# Power BI Report Documentation
## E-Commerce Business Analytics & Customer Intelligence

### 1. Overview

This document describes the Power BI report developed for the E-Commerce Business Analytics & Customer Intelligence project using the Brazilian Olist e-commerce dataset.

The report transforms validated SQL analysis results into interactive visualizations and business KPIs to support understanding of sales performance, product categories, customer purchasing behavior, geographic revenue distribution, delivery performance, and customer satisfaction.

### 2. Tools and Technologies

- **Power BI Desktop:** Dashboard development and data visualization
- **Power Query:** Data import and preparation
- **DAX:** Measures and KPI calculations
- **MySQL:** Data analysis and validation
- **Brazilian Olist e-commerce dataset:** Source data

### 3. Report Structure

The report contains four pages.

#### Page 1 — Executive Sales Overview

**Purpose:** Provide a high-level summary of sales performance and business trends.

**Key metrics:**
- Delivered orders
- Product revenue
- Freight charges
- Revenue plus freight
- Average order value

**Visualizations:**
- Monthly product revenue
- Monthly delivered orders
- Executive insights and data-coverage notes

#### Page 2 — Product & Category Performance

**Purpose:** Identify the product categories generating the most revenue and compare category revenue with item volume.

**Key metrics:**
- Product revenue
- Number of product categories
- Top category revenue
- Units sold

**Visualizations:**
- Top 10 product categories by revenue
- Top 5 categories by revenue
- Category revenue table
- Top 10 categories by units sold

#### Page 3 — Customer & Geographic Insights

**Purpose:** Understand customer purchasing behavior, customer value, and geographic revenue distribution.

**Key metrics:**
- Repeat customers
- One-time customers
- Repeat customer rate
- Total purchasing customers
- Average revenue per repeat customer
- Average revenue per one-time customer

**Visualizations:**
- Top 10 states by product revenue
- Product revenue comparison between one-time and repeat customers
- Customer insights

#### Page 4 — Delivery & Customer Experience

**Purpose:** Evaluate delivery reliability and examine how delivery performance relates to customer review scores.

**Key metrics:**
- On-time delivery rate
- Late deliveries
- Average delivery days
- Average delay days
- Average customer review score

**Visualizations:**
- On-time versus late deliveries
- Average review score for on-time versus late deliveries
- Delivery and customer experience insights

### 4. Key DAX Measures

The report uses DAX measures to calculate business KPIs, including:

- Product Revenue
- Delivered Orders
- Average Order Value
- Units Sold
- Repeat Customers
- One-Time Customers
- Repeat Customer Rate
- Total Customers
- Repeat Customer Revenue
- One-Time Customer Revenue
- Average Revenue per Repeat Customer
- Average Revenue per One-Time Customer
- On-Time Delivery Rate
- Late Deliveries
- Average Delivery Days
- Average Delay Days
- Average Review Score
- Average Review Score for On-Time Deliveries
- Average Review Score for Late Deliveries

The measures use the report's existing data model and filter context. Exact definitions should be taken from the DAX formulas implemented in the Power BI file.

### 5. Validated Business Findings

The report incorporates findings from the completed SQL analysis:

- Delivered-order product revenue was R$13,221,498.11.
- Freight charges were R$2,198,275.64.
- There were 96,478 delivered orders.
- Health & Beauty was the highest-revenue product category in the SQL analysis.
- São Paulo generated the highest product revenue among Brazilian states.
- Repeat customers represented approximately 3% of purchasing customers under the project's repeat-customer definition.
- Average product revenue per repeat customer was R$260.05, compared with R$137.96 per one-time customer.
- The on-time or early delivery rate was 91.89% among eligible delivered orders.
- Late deliveries had a lower average review score than on-time or early deliveries: 2.57 versus 4.29.

### 6. Data Quality and Limitations

- Some periods in the dataset have incomplete coverage. Missing months should not automatically be interpreted as zero business activity.
- Delivery performance calculations exclude orders with missing actual or estimated delivery dates.
- Repeat-customer analysis uses `customer_unique_id` to identify customers across customer records.
- Review-score comparisons describe associations and do not establish that delivery delays alone caused lower customer ratings.
- Average Order Value is displayed as R$137.04 in the current report. This figure requires separate reconciliation with the reported product revenue and delivered-order count before it can be described as mathematically validated.

### 7. Business Applications

The report can help business stakeholders:

- Monitor overall sales performance and monthly trends.
- Identify high-revenue product categories.
- Compare revenue generation with item sales volume.
- Understand repeat purchasing and differences in customer value.
- Identify high-revenue geographic markets.
- Monitor delivery reliability and investigate late-delivery patterns.
- Examine customer satisfaction alongside delivery performance.

### 8. Report File

The interactive report is maintained in:

`power_bi/ecommerce_business_analytics.pbix`

Dashboard screenshots are stored in the project's screenshots folder for inclusion in the GitHub README.

### 9. Conclusion

The Power BI report converts the project's SQL findings into a four-page business intelligence report. It combines sales, product, customer, geographic, delivery, and review-score analysis in a single report, supported by documented data limitations and business recommendations.