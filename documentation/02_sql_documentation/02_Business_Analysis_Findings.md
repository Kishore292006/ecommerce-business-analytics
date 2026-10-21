# Business Analysis Findings
## E-Commerce Business Analytics & Customer Intelligence

## 1. Executive Summary

This analysis examines sales performance, product categories, customer purchasing behavior, geographic differences, payment activity, delivery performance, customer reviews, and order outcomes using the Brazilian E-Commerce Public Dataset by Olist.

The SQL analysis recorded 96,478 delivered orders, R$13.22 million in product revenue, and R$2.20 million in freight for the reported delivered-order sales population. It also identified differences in customer purchasing patterns, geographic freight burden, delivery outcomes, and review scores.

Several data-quality and coverage issues require attention when interpreting the findings. These include orders without associated item records, payment reconciliation differences, multiple review records, delivery-analysis population differences, and incomplete order coverage in late 2018.

The purpose of this document is to consolidate the available evidence into business-relevant findings while distinguishing measured results from interpretations and recommendations.

## 2. Sales Performance and Trends

### Recorded results

| Metric | Recorded value |
|---|---:|
| Delivered orders | 96,478 |
| Product revenue | R$13,221,498.11 |
| Freight | R$2,198,275.64 |
| Product revenue plus freight | R$15,419,773.75 |
| Average order value | R$159.83 |
| Average items per delivered order | 1.14 |

These figures are taken from the completed SQL analysis. KPI definitions and population rules should be retained when reproducing the figures in Power BI.

### Annual performance

| Year | Delivered orders | Product revenue | Freight |
|---|---:|---:|---:|
| 2016 | 267 | R$40,470.98 | R$6,182.76 |
| 2017 | 43,428 | R$5,962,902.01 | R$958,633.23 |
| 2018 | 52,783 | R$7,218,125.12 | R$1,233,459.65 |

**Finding:** The recorded 2018 totals exceed the recorded 2017 totals. However, the dataset has incomplete calendar coverage, particularly in 2016 and the final months of 2018. These figures should not be presented as a verified full-year growth comparison.

### Business implication

Sales reporting should distinguish product revenue from freight and should use comparable reporting periods. Monthly and yearly performance visuals must flag incomplete periods and avoid misleading growth calculations.

## 3. Product and Category Performance

### Top categories by product revenue

| Rank | Product category | Product revenue |
|---:|---|---:|
| 1 | Health and beauty | R$1,233,131.72 |
| 2 | Watches and gifts | R$1,166,176.98 |
| 3 | Bed, bath and table | R$1,023,434.76 |
| 4 | Sports and leisure | R$954,852.55 |
| 5 | Computers and accessories | R$888,724.61 |
| 6 | Furniture and decor | R$711,927.69 |
| 7 | Housewares | R$615,628.69 |
| 8 | Cool stuff | R$610,204.10 |
| 9 | Auto | R$578,966.65 |
| 10 | Toys | R$471,286.48 |

The top three categories accounted for **25.89% of total product revenue**, according to the completed category analysis.

### Business interpretation

Revenue is concentrated among several leading categories, while other categories contribute smaller individual amounts.

Category revenue is a useful measure of commercial contribution, but it does not establish profitability, inventory efficiency, or product demand independently of order volume and product mix.

### Recommended action

Use category revenue alongside order volume and other available measures to identify leading categories and areas that may warrant deeper investigation. Avoid allocating resources solely on revenue rankings without considering costs, margins, and operational constraints, which are not established by this analysis.

## 4. Customer Purchasing Behavior

### One-time versus repeat customers

| Customer group | Customers | Delivered orders | Product revenue | Average product revenue per customer |
|---|---:|---:|---:|---:|
| One-time customers | 90,557 | 90,557 | R$12,493,089.36 | R$137.96 |
| Repeat customers | 2,801 | 5,921 | R$728,408.75 | R$260.05 |

Repeat customers represented approximately 3% of the analyzed customer population. Their average product revenue per customer was approximately 1.88 times that of one-time customers.

### Business interpretation

The observed data shows that repeat customers placed more than one delivered order and contributed higher average product revenue per customer within the analyzed population.

This is a descriptive association. It does not establish why customers returned or prove that a retention campaign would generate a particular financial return.

### Recommended action

Investigate repeat-purchase patterns and consider testing customer retention initiatives. Any future initiative should be evaluated using measurable outcomes such as repeat-purchase rate, incremental revenue, and campaign cost rather than assuming that the observed difference guarantees future results.

## 5. Geographic Performance

### Leading states by product revenue

| State | Delivered orders | Product revenue | Freight |
|---|---:|---:|---:|
| São Paulo (SP) | 40,501 | R$5,067,633.16 | R$702,069.99 |
| Rio de Janeiro (RJ) | 12,350 | R$1,759,651.13 | Not included here |
| Minas Gerais (MG) | 11,354 | R$1,552,481.83 | Not included here |

São Paulo contributed the largest recorded product revenue among the reported states.

### Geographic freight burden

Freight burden is defined here as freight divided by product revenue for the same geographic population.

The highest recorded freight-burden percentages among the analyzed states included:

| State | Freight as a share of product revenue |
|---|---:|
| Maranhão (MA) | 26.32% |
| Rondônia (RO) | 24.70% |
| Amazonas (AM) | 24.51% |
| Sergipe (SE) | 24.24% |
| Piauí (PI) | 24.15% |
| Tocantins (TO) | 23.98% |

São Paulo's recorded freight burden was 13.85% under the same analysis definition.

### Business interpretation

The results show geographic variation in recorded revenue and freight burden. A high freight-to-product-revenue ratio indicates that shipping represents a larger component relative to product revenue in that region.

It does not, on its own, prove that shipping is overpriced or operationally inefficient. Differences in distance, order value, product mix, and other factors may contribute.

### Recommended action

Prioritize further investigation of regions with high freight burden and compare those results with delivery performance. Use geographic results to guide investigation rather than assuming that a high ratio automatically identifies a logistics failure.

## 6. Payment Analysis

### Payment method distribution

| Payment method | Payment records | Orders represented | Payment value |
|---|---:|---:|---:|
| Credit card | 76,795 | 76,505 | R$12,542,084.19 |
| Boleto | 19,784 | 19,784 | R$2,869,361.27 |
| Voucher | 5,775 | 3,866 | R$379,436.87 |
| Debit card | 1,529 | 1,528 | R$217,989.79 |
| Not defined | 3 | 3 | R$0.00 |

Credit-card payments represented the largest payment value in the recorded analysis. Payment records and unique orders are different measures because an order can have multiple payment records.

### Reconciliation findings

The completed checks identified 249 orders with an absolute difference greater than R$1 between payment totals and item-plus-freight totals among 98,665 compared orders. The average absolute difference across the compared population was R$0.03.

One investigated order had item-plus-freight value of R$1,403.66 and payment value of R$1,586.47, a difference of R$182.81. The cause was not established.

The analysis also identified nine zero-value payment records and two credit-card records with zero installments.

### Business interpretation

Credit cards dominate recorded payment value, while reconciliation exceptions and unusual payment records warrant further investigation.

These findings do not establish fraud, overcharging, or a systemic payment-processing problem.

### Recommended action

Investigate the largest reconciliation exceptions first, confirm how multiple payment records are represented, and document the treatment of zero-value or unusual records before using payment totals for financial reporting.

## 7. Delivery Performance

### Overall results

| Metric | Recorded result |
|---|---:|
| Eligible delivered orders in actual-versus-estimated comparison | 96,470 |
| Orders delivered on time or early | 88,644 |
| Orders classified as late | 7,826 |
| Recorded on-time-or-early rate | 91.89% |
| Average delay among late deliveries | 8.87 calendar days |
| Maximum recorded delay | 188 calendar days |

These results reflect the specific eligibility and comparison rules used in the completed delivery analysis.

### Geographic variation

The highest recorded late-delivery rates among the states meeting the analysis threshold included:

| State | Eligible delivered orders | Late orders | Late-delivery rate |
|---|---:|---:|---:|
| Alagoas (AL) | 397 | 95 | 23.93% |
| Maranhão (MA) | 717 | 141 | 19.67% |
| Piauí (PI) | 476 | 76 | 15.97% |
| Ceará (CE) | 1,279 | 196 | 15.32% |
| Sergipe (SE) | 335 | 51 | 15.22% |
| Bahia (BA) | 3,256 | 457 | 14.04% |
| Rio de Janeiro (RJ) | 12,350 | 1,664 | 13.47% |

The analysis used a minimum eligible-order threshold of 100 for this state comparison.

### Business interpretation

The recorded late-delivery rate varies by state, making geographic segmentation useful for identifying regions that warrant further operational review.

The analysis also identified unusually long delays and a cluster of delayed deliveries around March and April 2018. The underlying causes have not been established.

### Recommended action

Investigate high late-delivery-rate regions and extreme delay cases. Review the relevant orders and operational records before attributing the patterns to a particular carrier, region, or process.

## 8. Customer Review and Satisfaction Analysis

### Overall review distribution

| Review score | Review records | Share |
|---:|---:|---:|
| 1 | 11,424 | 11.51% |
| 2 | 3,151 | 3.18% |
| 3 | 8,179 | 8.24% |
| 4 | 19,142 | 19.29% |
| 5 | 57,328 | 57.78% |

Scores of 4 or 5 accounted for 77.07% of recorded reviews, while scores of 1 or 2 accounted for 14.69%.

### Relationship between delivery timing and review scores

The completed review analysis recorded the following results for review records joined to eligible delivered orders:

| Delivery group | Review records | Average review score | Low-score records (1–2) | Low-score share |
|---|---:|---:|---:|---:|
| On time | 88,653 | 4.29 | 8,186 | 9.23% |
| Late | 7,700 | 2.57 | 4,160 | 54.03% |

These counts are review records, not necessarily unique orders. The review analysis used different join and eligibility rules from the overall delivery analysis, so its counts should not be substituted directly into delivery KPIs.

### Business interpretation

Late-delivery review records had a substantially lower average score and a higher share of low scores than on-time review records in the observed data.

This is a strong association and a useful operational signal. It does not prove that delivery timing is the sole cause of dissatisfaction.

### Recommended action

Prioritize investigation of late-delivery cases associated with low review scores. Use additional order and operational information to identify possible contributing factors before recommending specific corrective actions.

## 9. Order Status and Cancellation Analysis

### Recorded order-status distribution

| Order status | Orders | Share |
|---|---:|---:|
| Delivered | 96,478 | 97.02% |
| Shipped | 1,107 | 1.11% |
| Canceled | 625 | 0.63% |
| Unavailable | 609 | 0.61% |
| Invoiced | 314 | 0.32% |
| Processing | 301 | 0.30% |
| Created | 5 | 0.01% |
| Approved | 2 | 0.00% |

The status counts total 99,441 orders. Displayed percentages are rounded.

### Cancellation patterns

The monthly cancellation analysis identified 73 canceled orders in February 2018 and 84 in August 2018. August's recorded cancellation count was the highest among the listed months.

However, September and October 2018 contained only 16 and 4 total orders, respectively, in the observed purchase-timestamp population. Their cancellation rates of 93.75% and 100% should not be interpreted as representative monthly performance.

### Business interpretation

Order-status analysis provides visibility into completed and non-completed order outcomes. Monthly cancellation counts and rates can help identify periods requiring investigation, but the denominator and data coverage must be considered.

### Recommended action

Investigate cancellation spikes in months with substantial order volume, including February and August 2018. Validate order coverage and investigate the operational reasons for cancellations before drawing conclusions about their causes.

## 10. Consolidated Business Priorities

Based on the recorded SQL findings, the following priorities are appropriate for further investigation.

| Priority | Business area | Recommended next step | Evidence basis |
|---|---|---|---|
| High | Delivery operations | Investigate high late-delivery-rate states and extreme delay cases | Geographic variation and unusually long delays |
| High | Customer experience | Examine low-score reviews associated with late deliveries | Strong observed association between delivery timing and review scores |
| High | Data quality | Investigate material payment reconciliation differences | 249 compared orders exceeded the R$1 absolute-difference threshold |
| High | Reporting quality | Standardize KPI definitions and flag incomplete periods | Different eligible populations and sparse late-2018 records |
| Medium | Customer retention | Examine repeat-purchase behavior and evaluate retention initiatives | Repeat customers had higher observed average product revenue per customer |
| Medium | Category strategy | Compare category revenue with other available commercial measures | Top three categories contributed 25.89% of product revenue |
| Medium | Logistics cost | Investigate regions with high freight burden | Meaningful geographic variation in freight relative to product revenue |

These priorities are based on the available analysis and are not quantified estimates of financial return.

## 11. Cross-Analysis Data Limitations

The findings should be interpreted with the following limitations in mind:

1. **Different grains:** Orders, order items, payment records, customers, and reviews are different analytical units.
2. **Incomplete time coverage:** Some months are missing or sparsely represented, particularly in 2016 and late 2018.
3. **Metric definitions:** Revenue, freight, AOV, delivery timing, and cancellation rates depend on their specific population and calculation rules.
4. **Unresolved reconciliation exceptions:** The cause of identified payment differences has not been established.
5. **Multiple review records:** Review-level counts do not automatically equal unique-order counts.
6. **Observational evidence:** The analyses identify associations and patterns but do not establish causal effects.
7. **Profitability limitations:** The available results do not establish actual profit or complete product-level margins.

The final dashboard and executive report should disclose limitations wherever they materially affect a reported KPI or conclusion.

## 12. Conclusion

The SQL analysis provides a multi-dimensional view of the recorded e-commerce operation. It establishes baseline sales measures, identifies leading product categories, describes repeat-purchase behavior, highlights geographic variation in freight burden and delivery performance, and reveals a strong association between delivery timing and customer review scores.

The most important next steps are to investigate operational outliers, maintain consistent KPI definitions, account for incomplete reporting periods, and validate material reconciliation differences.

These findings will inform the Power BI report and the final project recommendations. All published conclusions should remain traceable to the recorded SQL outputs and should distinguish evidence from hypotheses.