# SQL Validation and Data Quality
## E-Commerce Business Analytics & Customer Intelligence

## 1. Purpose

This document records the data-quality checks, metric-validation considerations, and unresolved exceptions identified during the SQL analysis of the Brazilian E-Commerce Public Dataset by Olist.

The objective is to establish a transparent basis for interpreting analytical results and preparing the Power BI report. It distinguishes verified observations from unresolved causes and defines the controls required before metrics are used for business decisions.

This document complements the SQL methodology and business findings documents. It focuses on the reliability and limitations of the analysis rather than repeating every business result.

## 2. Validation Scope

The completed SQL work investigated the following areas:

- Source-table row counts and relationships.
- Orders without associated order-item records.
- Product-category mapping and translation coverage.
- Payment totals compared with item and freight totals.
- Unusual payment records.
- Multiple review records associated with orders.
- Delivery timestamp eligibility and calculation differences.
- Incomplete monthly order coverage.
- KPI definitions, denominators, and aggregation grain.

These checks identify issues that may affect specific analyses. They do not establish that every source-table record is incorrect or that every exception represents a business error.

## 3. Source Data and Record-Grain Controls

The project uses nine primary source tables, including orders, customers, order items, payments, reviews, products, sellers, geolocation, and category translations.

These tables do not share the same record grain.

| Entity | Typical analytical grain | Main validation concern |
|---|---|---|
| Orders | One row per order | Order status and timestamp eligibility |
| Order items | One row per order item | Multiple items per order can multiply joined rows |
| Payments | One row per payment record | An order can have multiple payment records |
| Customers | One row per customer record | Customer identifiers and customer-level aggregation |
| Reviews | One row per review record | Multiple review records can be associated with an order |
| Products | One row per product record | Missing category mappings and attributes |
| Sellers | One row per seller record | Seller-level joins and geographic analysis |
| Geolocation | Multiple geographic reference records | Duplicate or repeated geographic coordinates may affect joins |
| Category translations | One row per translated category | Missing mappings or translations |

### Validation principle

Before aggregating a joined dataset, confirm the intended grain of the metric.

For example, summing payment values after joining payment records directly to multiple order-item rows can duplicate payment amounts. Likewise, counting review records is not necessarily equivalent to counting unique reviewed orders.

Metrics should be calculated at the appropriate grain, and joins should be reviewed whenever totals change unexpectedly.

## 4. Data-Quality Findings

### 4.1 Orders without order-item records

**Recorded finding:** 775 orders were identified without associated order-item records.

**Potential impact:** These orders may be absent from item-based revenue calculations or may produce incomplete results in analyses that require product and freight information.

**Required control:**

- Identify the status and relevant attributes of the affected orders.
- Determine whether the analysis requires order-item data.
- Document exclusions where they affect a reported metric.
- Do not automatically assign zero product revenue without confirming the intended business definition.

**Status:** Identified; underlying causes have not been established.

### 4.2 Product-category mapping and translation

The recorded checks identified:

| Category-mapping outcome | Product records |
|---|---:|
| Matched category | 32,328 |
| Missing category match | 610 |
| Missing category translation | 13 |

The recorded product table contains 32,951 rows.

**Potential impact:** Missing mappings or translations can reduce the completeness of category-level reporting and leave some products outside translated category labels.

**Required control:**

- Distinguish products with missing category identifiers from categories without translations.
- Document how unmapped products are handled in category analysis.
- Avoid silently removing unmatched products when calculating overall product totals.
- Use consistent category labels in SQL and Power BI.

**Status:** Exceptions identified; their causes and business significance require separate assessment.

### 4.3 Payment reconciliation

The completed analysis compared payment totals with item-plus-freight totals for 98,665 orders.

| Validation measure | Recorded result |
|---|---:|
| Orders compared | 98,665 |
| Orders with absolute difference greater than R$1 | 249 |
| Average absolute difference across the compared population | R$0.03 |
| Largest specifically investigated difference | R$182.81 |

The investigated order had the following recorded values:

| Component | Value |
|---|---:|
| Item-plus-freight total | R$1,403.66 |
| Payment total | R$1,586.47 |
| Difference: payment minus item-plus-freight | +R$182.81 |

The order had one recorded credit-card payment with 10 installments. The available analysis did not establish why the difference occurred.

**Potential impact:** Reconciliation differences may affect financial reporting if payment totals and item-plus-freight totals are treated as interchangeable.

**Required control:**

- Compare values at the same order grain.
- Confirm that the two totals use compatible inclusion rules.
- Investigate material exceptions individually.
- Document unresolved differences rather than assigning unsupported causes.
- Do not label an exception as fraud, an overcharge, or a financial loss without supporting evidence.

**Status:** Exceptions identified; causes remain unresolved.

### 4.4 Unusual payment records

The payment checks identified nine zero-value payment records.

| Payment type | Zero-value records |
|---|---:|
| Voucher | 6 |
| Not defined | 3 |
| **Total** | **9** |

Two credit-card payment records had zero installments, with recorded values of R$58.69 and R$129.94. Their combined payment value was R$188.63.

**Potential impact:** Unusual payment records can affect payment-method summaries or installment analysis if interpreted without considering the source system's conventions.

**Required control:**

- Preserve the original records for traceability.
- Check the relevant payment type, value, and installment fields.
- Document how unusual records are treated in individual metrics.
- Do not automatically remove or reclassify them based solely on their appearance.

**Status:** Identified; no cause has been established.

### 4.5 Multiple review records

The recorded review checks identified:

| Measure | Recorded result |
|---|---:|
| Total review records | 99,224 |
| Distinct orders represented | 98,673 |
| Orders with multiple review records | 547 |
| Total review records associated with those orders | 1,098 |
| Maximum review records for one order | 3 |

Multiple review records should not automatically be classified as invalid duplicates. Their interpretation depends on the source structure and the purpose of the analysis.

**Potential impact:** Review-level averages and percentages may differ from order-level metrics when some orders have multiple review records.

**Required control:**

- State whether a metric counts review records or unique orders.
- Use a consistent rule when comparing delivery groups.
- Investigate multiple records before considering deduplication.
- Avoid deleting records without a documented rule and an understanding of their meaning.

**Status:** Identified; no automatic deletion is recommended.

## 5. Delivery and Review Metric Consistency

The delivery and review analyses used different eligibility rules and analytical grains.

### Recorded delivery results

| Measure | Recorded result |
|---|---:|
| Eligible orders in actual-versus-estimated delivery comparison | 96,470 |
| On-time-or-early orders | 88,644 |
| Late orders | 7,826 |
| On-time-or-early rate | 91.89% |

### Recorded review comparison

| Delivery group | Review records | Average review score | Low-score share |
|---|---:|---:|---:|
| On time | 88,653 | 4.29 | 9.23% |
| Late | 7,700 | 2.57 | 54.03% |

The review comparison counts review records joined to eligible delivered orders. Its counts differ from the delivery analysis, which counts eligible orders under its own rules.

The available findings do not establish that these differences are caused by one specific issue. Join multiplicity, timestamp eligibility, missing values, and comparison rules are relevant factors to investigate.

### Required control

Before comparing these measures in Power BI:

1. State the population and grain of each metric.
2. Apply consistent definitions of on-time and late delivery where direct comparison is intended.
3. Determine whether review metrics count records or unique orders.
4. Document the treatment of missing timestamps and excluded records.
5. Avoid combining these counts as though they represent the same population.

### Calendar-day versus timestamp comparisons

Timestamp comparisons and `DATEDIFF` calculations can classify some orders differently.

For example, an order can be delivered later than its estimated timestamp on the same calendar date. A timestamp-based rule may classify it as late, while a calendar-day difference may be zero.

Delivery duration and delay definitions must therefore be stated explicitly. A delay of zero calendar days does not necessarily mean that the actual delivery timestamp was earlier than the estimate.

**Status:** Differences identified; metric definitions must remain explicit in reporting.

## 6. Incomplete Monthly Order Coverage

The order-status analysis identified uneven coverage across purchase months.

| Period | Total orders | Canceled orders | Cancellation rate |
|---|---:|---:|---:|
| September 2016 | 4 | 2 | 50.00% |
| October 2016 | 324 | 24 | 7.41% |
| January–December 2017 | Substantial monthly coverage | Varies | Varies |
| January–August 2018 | Substantial monthly coverage | Varies | Varies |
| September 2018 | 16 | 15 | 93.75% |
| October 2018 | 4 | 4 | 100.00% |

The September and October 2018 rates are mathematically correct for the recorded populations. However, the denominators are extremely small, so the rates are not representative of normal monthly performance.

November 2016 had no records returned by the monthly query, and December 2016 had only one order. The absence of returned records should not automatically be interpreted as proof of complete source coverage.

### Required control

- Distinguish missing months from months with zero cancellations.
- Identify incomplete periods before calculating trend comparisons.
- Avoid presenting sparse months as representative performance.
- Use comparable periods for annual and monthly comparisons.
- Clearly document any exclusions or reporting cutoffs.

**Status:** Coverage limitation identified; the cause of the sparse late-2018 records has not been established.

## 7. KPI Validation Rules

The following controls should be applied before publishing the final dashboard.

| KPI | Validation requirement |
|---|---|
| Total orders | Confirm the order population and status filters |
| Delivered orders | Distinguish status counts from timestamp-eligible delivery counts |
| Product revenue | Confirm item-price aggregation and avoid duplicate joins |
| Freight | Aggregate freight at the appropriate grain |
| Product revenue plus freight | Confirm compatible populations and inclusion rules |
| Average order value | Use a consistent revenue numerator and eligible-order denominator |
| Repeat-customer rate | Define the customer population and qualifying order criteria |
| On-time delivery rate | State the comparison rule and eligible population |
| Cancellation rate | Use the same purchase-period population for numerator and denominator |
| Low review-score rate | State whether the measure counts review records or unique orders |
| Freight burden | Calculate freight divided by product revenue for the same population |

### Validation principles

1. **Consistent definitions:** SQL and Power BI must implement the same KPI rules.
2. **Consistent populations:** Numerators and denominators must refer to compatible populations.
3. **Correct aggregation grain:** One-to-many joins must not inflate totals.
4. **Explicit exclusions:** Exclusions and missing-value handling must be documented.
5. **Traceable results:** Every published metric should be traceable to its source query or documented calculation.
6. **Transparent limitations:** Unresolved discrepancies must remain visible wherever they affect interpretation.

## 8. Reporting and Governance Recommendations

The following controls are recommended for the final portfolio report:

| Control | Implementation |
|---|---|
| KPI definition register | Maintain the definition, numerator, denominator, population and exclusions for each major KPI |
| Reconciliation review | Track material payment differences and their investigation status |
| Data-coverage checks | Flag incomplete months and unavailable comparison periods |
| Join-grain review | Document the grain of tables used in multi-table aggregations |
| Review-count consistency | Distinguish review records from unique reviewed orders |
| Dashboard consistency | Align SQL outputs, Power BI measures and written interpretations |
| Evidence traceability | Link each important finding to the relevant SQL analysis and recorded result |

These controls improve the reliability and explainability of the analysis. They do not imply that every identified exception has already been resolved.

## 9. Outstanding Issues

The following matters remain unresolved based on the recorded analysis:

- The causes of payment reconciliation differences have not been established.
- The causes of unusual payment records have not been established.
- Multiple review records have not been classified as valid or invalid duplicates.
- Differences between delivery and review eligible counts require careful interpretation.
- The reason for sparse late-2018 order coverage has not been established.
- The causes of unusually long delivery delays have not been established.

These issues should be described accurately in the final report. They must not be presented as resolved merely because they have been documented.

## 10. Conclusion

The SQL validation work identified several issues that affect how the e-commerce results should be interpreted. These include incomplete order-item associations, category-mapping gaps, payment reconciliation exceptions, multiple review records, differences between delivery-analysis populations, and incomplete monthly coverage.

The findings reinforce the importance of defining metrics precisely, controlling aggregation grain, investigating exceptions, and disclosing limitations.

The final Power BI dashboard should use consistent KPI definitions and clearly flag metrics whose interpretation is affected by unresolved data-quality issues. This approach makes the project more transparent, technically defensible, and suitable for a professional portfolio.