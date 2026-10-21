# SQL Analysis Methodology
## E-Commerce Business Analytics & Customer Intelligence

| Project Attribute | Details |
|---|---|
| Database | `ecommerce_customer_intelligence` |
| Database platform | MySQL 8.0 |
| Dataset | Brazilian E-Commerce Public Dataset by Olist |
| Analysis layer | SQL business analysis |
| Primary objective | Convert transactional data into reliable business metrics and actionable operational insights |

---

## 1. Executive Overview

This project applies SQL-based business analysis to the Brazilian E-Commerce Public Dataset by Olist. It examines sales performance, product and category contribution, customer purchasing behavior, geographic distribution, payment activity, delivery performance, customer reviews, and order-status patterns.

The analytical objective is to understand how the observed e-commerce operation performs across commercial and operational dimensions, identify areas requiring management attention, and establish an evidence-based foundation for a Power BI business intelligence report.

The analysis emphasizes reliable metric definitions, appropriate aggregation, cross-table consistency, data-quality investigation, and business interpretation. Findings are treated as observations from the available dataset rather than proof of causation or guarantees of future performance.

## 2. Business Objectives

The SQL analysis addresses the following business objectives:

1. **Measure sales performance:** Establish core measures for delivered orders, product revenue, freight, and average order value.
2. **Understand sales trends:** Examine monthly and yearly performance while accounting for incomplete periods.
3. **Evaluate product performance:** Identify categories contributing the most product revenue.
4. **Analyze customer behavior:** Compare one-time and repeat purchasing patterns.
5. **Assess geographic performance:** Compare customer demand, revenue contribution, and freight burden across locations.
6. **Understand payment activity:** Examine payment methods, installment patterns, and differences between payment totals and item-plus-freight totals.
7. **Evaluate delivery operations:** Measure delivery duration, lateness, and variation across states.
8. **Examine customer experience:** Analyze review-score distributions and their association with delivery performance.
9. **Investigate order outcomes:** Examine order statuses and cancellation patterns, including periods with limited data coverage.

These objectives provide the analytical foundation for business recommendations and the subsequent Power BI report.

## 3. Dataset and Source Tables

The analysis uses nine source tables from the Olist dataset.

| Source table | Recorded rows | Analytical purpose |
|---|---:|---|
| `olist_orders_dataset` | 99,441 | Order lifecycle, purchase timestamps, status and delivery dates |
| `olist_customers_dataset` | 99,441 | Customer identifiers and geographic attributes |
| `olist_geolocation_dataset` | 1,000,163 | Geographic reference data |
| `olist_order_items_dataset` | 112,650 | Product items, item prices, freight and seller references |
| `olist_order_payments_dataset` | 103,886 | Payment types, values and installments |
| `olist_order_reviews_dataset` | 99,224 | Customer review scores and review records |
| `olist_products_dataset` | 32,951 | Product attributes and category identifiers |
| `olist_sellers_dataset` | 3,095 | Seller information and geographic attributes |
| `product_category_name_translation` | 71 | Translation of product-category names |

**Data interpretation note:** These are recorded source-table row counts, not counts of unique customers, unique products sold, or delivered orders. Tables have different grains and should not be joined or aggregated without considering their relationships.

## 4. SQL Analysis Architecture

The analysis is organized into nine SQL files under `sql/business_analysis/`.

| SQL file | Analytical scope | Business purpose |
|---|---|---|
| `01_sales_performance.sql` | Overall sales performance and KPIs | Establish baseline commercial metrics |
| `02_monthly_yearly_sales_trends.sql` | Monthly and yearly trends | Examine changes in sales activity over time |
| `03_product_category_analysis.sql` | Product and category performance | Identify major category revenue contributors |
| `04_customer_analysis.sql` | Customer purchasing behavior | Compare purchasing frequency and customer-level revenue |
| `05_geographic_analysis.sql` | Geographic performance | Assess regional demand and freight burden |
| `06_payment_analysis.sql` | Payment activity and reconciliation | Understand payment methods, installments and monetary discrepancies |
| `07_delivery_performance.sql` | Delivery duration and lateness | Assess delivery outcomes and geographic variation |
| `08_review_analysis.sql` | Review scores and delivery relationships | Examine customer feedback and operational associations |
| `09_order_status_analysis.sql` | Order statuses and cancellations | Understand order outcomes and monthly cancellation patterns |

The file structure separates business questions into manageable analytical units while retaining a consistent project-wide methodology.

## 5. Analytical Methodology

### 5.1 Data exploration and scope

The source tables and recorded row counts were reviewed to understand the available entities, transactional relationships, and scope of analysis.

The project distinguishes order-level, item-level, payment-record-level, customer-level, and review-record-level measurements. This distinction is important because the same order can contain multiple items, multiple payment records, or multiple review records.

### 5.2 Relational analysis and join control

SQL joins connect relevant entities, including orders, customers, order items, products, payments, sellers, and reviews.

Join conditions and aggregation levels must be selected according to the business question. Joining an order to multiple order items or payment records can multiply rows and inflate sums if the data is aggregated at the wrong grain.

Where metrics require order-level totals, item or payment records should be aggregated to the appropriate order level before being combined with other one-to-many relationships.

### 5.3 Aggregation and segmentation

The analysis uses SQL aggregation functions, including `COUNT`, `SUM`, `AVG`, `MIN`, and `MAX`, to calculate business measures.

Results are segmented by dimensions relevant to each business question, including:

- Purchase month and year
- Product category
- Customer purchasing frequency
- State and city
- Payment method and installments
- Order status
- Delivery performance
- Customer review score

Percentages and rates must use a clearly defined denominator. Comparisons are meaningful only when the included populations and metric definitions are compatible.

### 5.4 Time-based analysis

Purchase timestamps support monthly and yearly sales and cancellation analysis. Delivery timestamps support delivery-duration and estimated-versus-actual comparisons.

Incomplete periods require special treatment. A month containing only a few recorded orders cannot be compared directly with a fully represented month without considering coverage.

Month-over-month and year-over-year calculations must also account for missing months. A previous-row calculation can compare nonconsecutive calendar months when gaps exist; calendar-aware comparisons are preferable when evaluating period changes.

### 5.5 Customer purchasing analysis

Customer analysis examines the number of qualifying delivered orders associated with a customer and compares purchasing behavior between one-time and repeat customers.

These findings describe the observed customer population. They do not independently establish customer lifetime value, retention causes, or the likely impact of a marketing campaign.

### 5.6 Delivery and customer-experience analysis

Delivery analysis compares actual delivery timestamps with estimated delivery timestamps and examines delivery duration and delays.

Review analysis evaluates the distribution of review scores and compares review outcomes between delivery-performance groups.

Any relationship between late delivery and low review scores is interpreted as an association. Other factors may influence customer satisfaction, and the observed relationship alone does not prove causation.

### 5.7 Financial reconciliation

Payment analysis compares payment totals with the sum of item prices and freight for comparable orders.

Differences are treated as reconciliation exceptions requiring investigation. They should not automatically be classified as overcharges, fraud, or incorrect customer billing without additional evidence.

## 6. KPI Definitions and Measurement Rules

The following definitions establish the intended meaning of the principal measures. Exact implementation details must remain consistent with the corresponding SQL queries and Power BI measures.

| KPI | Definition | Measurement consideration |
|---|---|---|
| Total orders | Count of order records in the selected population | State filters and date filters affect the result |
| Delivered orders | Count of orders with status `delivered` | This status count differs from delivery analyses requiring valid timestamps |
| Product revenue | Sum of product item prices for the specified order population | Excludes freight unless explicitly included |
| Freight | Sum of freight values for the specified order population | Should be reported separately from product revenue |
| Product revenue plus freight | Product revenue plus associated freight | May differ from payment totals |
| Average order value (AOV) | Defined revenue measure divided by the corresponding number of eligible orders | Revenue numerator and order denominator must refer to the same population |
| Repeat customer | Customer with more than one qualifying delivered order | Depends on the customer identifier and qualifying order definition |
| On-time delivery rate | Eligible delivered orders classified as on time or early divided by eligible orders in the same comparison | The timestamp or calendar-day classification rule must be stated |
| Cancellation rate | Canceled orders divided by all eligible orders in the same purchase period | Incomplete periods can make the rate misleading |
| Low review-score rate | Review records with scores of 1 or 2 divided by the specified review-record population | Review records are not automatically equivalent to unique orders |
| Freight burden | Freight divided by product revenue for the same population | Sensitive to geography, order mix and the selected population |

### KPI governance

Before a KPI is published in the dashboard or executive summary:

1. Confirm the business definition and population.
2. Confirm the aggregation grain and denominator.
3. Check for duplicate multiplication caused by joins.
4. Check relevant missing values and exclusions.
5. Confirm that the SQL result and Power BI measure use compatible rules.
6. Document material differences between related calculations.

A KPI should not be presented as fully validated when its definition or eligible population remains unresolved.

## 7. Data-Quality Findings and Analytical Caveats

The SQL analysis identified the following issues that require context when interpreting results.

### 7.1 Orders without associated order items

A total of **775 orders** were identified without associated order-item records.

This affects analyses that depend on item prices, freight, or product attributes. Such orders should not automatically be assigned zero product revenue without first understanding their status and the intended metric population.

### 7.2 Product-category mapping

The recorded checks identified:

- 32,328 product records with a matched category
- 610 product records without a matched category
- 13 records with missing category translations

These conditions can affect category-level completeness. Category revenue results should disclose the treatment of missing or untranslated categories.

### 7.3 Payment reconciliation differences

Among **98,665 compared orders**, 249 had an absolute difference greater than R$1 between payment totals and item-plus-freight totals.

The average absolute difference across all compared orders was recorded as R$0.03.

One investigated order had item-plus-freight totals of R$1,403.66 and a payment total of R$1,586.47, a difference of R$182.81. The available analysis did not establish the cause.

These differences require investigation before conclusions are drawn about billing accuracy or financial loss.

### 7.4 Payment-record exceptions

The payment checks identified nine zero-value payment records: six vouchers and three records with payment type `not_defined`.

Two credit-card payment records had zero installments, with values of R$58.69 and R$129.94.

These records should be retained for investigation until their meaning is understood; they should not be removed solely because their values appear unusual.

### 7.5 Multiple review records

The review table contained **99,224 review records associated with 98,673 distinct orders**. The recorded checks identified 547 orders with multiple review records, including orders with as many as three records.

Multiple review records may require separate treatment depending on the analytical question. Review-level averages and percentages must not be described as unique-order metrics unless the calculation explicitly establishes one record per order.

### 7.6 Delivery metric differences

Delivery and review analyses produced different eligible counts under different joins and comparison rules.

For example, the delivery analysis recorded 96,470 eligible orders for its actual-versus-estimated comparison, while the review analysis used review records joined to delivered orders with the required timestamps.

The difference should be understood through eligibility rules, review-record multiplicity and timestamp availability rather than resolved by assuming one count is incorrect.

### 7.7 Incomplete monthly order coverage

The order-status analysis identified only 16 orders in September 2018 and four orders in October 2018. The early dataset also had limited coverage in 2016, including only four orders in September and 324 in October.

The September and October 2018 cancellation rates are mathematically correct for their observed populations but are not representative of normal monthly performance. November 2016 had no returned records in the monthly query; this should not be interpreted as proof of complete source coverage.

These periods must be flagged or excluded from representative monthly comparisons until their coverage is validated.

### 7.8 Delivery outliers

The delivery analysis identified unusually long delivery delays, including a recorded maximum delay of 188 calendar days. A cluster of delayed orders was also observed around March and April 2018.

The analysis identifies these as investigation priorities. It does not establish the operational cause of the delays.

## 8. Interpretation and Recommendation Standards

Business recommendations derived from the SQL analysis must follow these principles:

- **Traceability:** Each important claim must be linked to a query result or documented calculation.
- **Business relevance:** Explain why the finding matters to revenue, customer experience, fulfillment, payment operations, or another defined business objective.
- **Proportionality:** The strength of the recommendation must match the strength of the evidence.
- **No unsupported causality:** Observational relationships must not be presented as proof that one factor caused another.
- **Data transparency:** Material exclusions, coverage limitations and unresolved discrepancies must be disclosed.
- **Actionability:** Recommendations should identify a practical next step, such as investigating a delay cluster or validating a payment discrepancy, rather than relying on generic advice.

The final business recommendations will be consolidated after the individual SQL findings have been documented and checked for consistency.

## 9. Reproducibility and Documentation Structure

The SQL source files are maintained in:

`sql/business_analysis/`

The SQL methodology and analytical findings are documented in:

`documentation/02_sql_documentation/`

Project-level objectives, consolidated business findings and limitations are maintained in:

`documentation/01_project_documentation/`

Power BI implementation details, measures, dashboard pages and visual interpretations will be maintained in:

`documentation/03_power_bi_documentation/`

The final GitHub README will provide a concise overview of the project, its tools, the major verified findings, dashboard previews, reproduction instructions and limitations.

## 10. Scope and Limitations

This project analyzes the available Olist transactional dataset. Its findings describe the observed records and the definitions used in the SQL analysis.

The available data does not, by itself, establish actual profit, full customer lifetime value, marketing attribution, or the causal impact of operational changes. Those questions would require additional data or suitable analytical designs.

The results should not automatically be generalized to every e-commerce business. Any unresolved data-quality issue that materially affects a reported KPI must be disclosed alongside the result.

## 11. Completion Standard

The SQL documentation will be considered ready for portfolio publication when:

- Business questions and analytical methods are clearly explained.
- KPI definitions and denominators are explicit.
- Reported figures are traceable to the existing SQL outputs.
- Join-grain risks and data-quality exceptions are addressed.
- Findings are separated from hypotheses and recommendations.
- Material limitations are documented.
- SQL conclusions are consistent with the measures presented in Power BI.

This methodology provides a consistent analytical standard for the remaining SQL documentation and the subsequent business intelligence report.