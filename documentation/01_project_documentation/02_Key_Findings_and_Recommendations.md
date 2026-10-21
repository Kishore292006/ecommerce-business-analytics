# Key Findings and Business Recommendations

## 1. Executive Summary

SQL analysis of the Brazilian E-Commerce Public Dataset by Olist examined sales, products, customers, payments, geography, delivery performance, reviews, and order status.

The analysis identified strong sales concentration in a small group of product categories, a low repeat-customer rate, geographic differences in freight burden, and a clear association between late delivery and lower customer review scores.

## 2. Key Findings

### 2.1 Sales Performance

- Product revenue across delivered orders was **R$13.22 million**.
- Freight charges totalled **R$2.20 million**.
- Combined product revenue and freight was **R$15.42 million**.
- Average order value, based on product revenue and delivered orders, was **R$159.83**.
- Freight represented approximately **14.26%** of combined product revenue and freight.

**Business implication:** Freight is a material component of the delivered-order transaction value and should be considered when evaluating customer costs and geographic performance.

### 2.2 Product Category Performance

The three highest-revenue categories were:

| Category | Product Revenue |
|---|---:|
| Health & Beauty | R$1,233,131.72 |
| Watches & Gifts | R$1,166,176.98 |
| Bed, Bath & Table | R$1,023,434.76 |

Together, these categories contributed **25.89% of total product revenue**.

**Business implication:** These categories are important contributors to revenue and warrant closer monitoring of sales trends, availability, and customer demand.

### 2.3 Customer Purchasing Behaviour

- One-time customers: **90,557**.
- Repeat customers: **2,801**.
- Repeat customers averaged **2.11 delivered orders per customer**.
- Average product revenue per repeat customer was **R$260.05**, compared with **R$137.96** for one-time customers.

**Business implication:** Repeat customers had higher average product revenue per customer in this dataset. Customer retention and repeat-purchase behaviour are worthwhile areas for further investigation. This observed difference does not establish that retention initiatives would cause higher revenue.

### 2.4 Geographic Performance and Freight

São Paulo recorded **40,501 delivered orders** and approximately **R$5.07 million** in product revenue, making it the largest state market in the analysis.

Freight-to-product-revenue ratios were comparatively high in several states, including:

- Maranhão: **26.32%**
- Rondônia: **24.70%**
- Amazonas: **24.51%**
- Sergipe: **24.24%**
- Piauí: **24.15%**

**Business implication:** Geographic differences in freight burden may affect delivery economics. These states are candidates for further investigation into shipping costs, carrier coverage, and logistics efficiency. The ratio alone does not establish that freight costs are avoidable or unprofitable.

### 2.5 Payment Methods

Credit cards accounted for **78.34% of the payment value** analysed, followed by boleto at **17.92%**.

**Business implication:** Credit-card payments dominate the observed payment mix. Payment reporting should distinguish payment records from unique orders because an order may have multiple payment records.

### 2.6 Delivery Performance and Customer Reviews

- Eligible delivered orders analysed for timeliness: **96,470**.
- Orders delivered on time or early: **88,644**.
- On-time-or-early delivery rate: **91.89%**.
- Late deliveries: **7,826**.
- Average delivery duration: **12.50 calendar days**.

The review analysis showed a strong association between delivery timing and customer ratings:

| Delivery group | Average review score | Low scores (1–2) |
|---|---:|---:|
| On time | 4.29 | 9.23% |
| Late | 2.57 | 54.03% |

The review counts represent review records associated with delivery groups, not necessarily unique orders.

**Business implication:** Late delivery is strongly associated with poorer customer feedback in the analysed records. Delivery reliability is therefore a priority for operational investigation, although the analysis does not prove that delays alone caused lower scores.

### 2.7 Order Status and Data Quality

The order-status analysis recorded **625 canceled orders** and **609 unavailable orders**. The dataset also contains incomplete periods and payment discrepancies that require careful interpretation.

**Business implication:** Order-status reporting should distinguish cancellations from unavailable orders and account for incomplete monthly coverage. Small monthly samples should not be interpreted as stable trends.

## 3. Recommended Business Actions

| Priority | Recommendation | Evidence and rationale |
|---|---|---|
| High | Investigate late-delivery patterns by state, carrier, and delivery timeline. | Late orders had substantially lower average review scores. |
| High | Review logistics costs and carrier coverage in high freight-burden states. | Several states had freight-to-product-revenue ratios above 24%. |
| Medium | Analyse repeat-purchase behaviour by product category and time since previous purchase. | Repeat customers had higher average product revenue per customer. |
| Medium | Monitor revenue and demand across the leading product categories. | The three leading categories contributed 25.89% of product revenue. |
| Medium | Strengthen order-status and payment-reconciliation reporting. | The analysis identified status inconsistencies, multiple payment records, and individual payment discrepancies requiring investigation. |

These recommendations are proposed actions for further analysis and operational review. Their financial impact has not been measured by this project.

## 4. Interpretation and Limitations

- Revenue figures refer to the defined delivered-order analysis; product revenue and freight are reported separately.
- Some periods have incomplete data coverage, limiting full-year comparisons.
- Customer, payment, and review records may not map one-to-one to orders.
- Associations between delivery performance and review scores do not establish causation.
- Freight ratios are indicators for investigation, not direct measures of state-level profitability.
- Unexplained payment discrepancies should be investigated rather than assigned an assumed cause.

## 5. Conclusion

The analysis highlights three key areas for business attention: product-category revenue concentration, repeat-customer behaviour, and delivery performance. The results provide a basis for targeted commercial and operational investigation while maintaining clear distinctions between measured findings, potential explanations, and recommendations.
