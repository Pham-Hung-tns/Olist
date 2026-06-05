# Comprehensive Data Analysis of Olist Store E-Commerce Platform

## Table of Contents

- [Research Considerations](#research-considerations)
  - [1. Portuguese Language Text Processing Constraints (NLP Limitation)](#1-portuguese-language-text-processing-constraints-nlp-limitation)
  - [2. Market Basket Analysis Findings](#2-market-basket-analysis-findings)
  - [3. Customer Segmentation Methodology](#3-customer-segmentation-methodology)
- [1. Project Overview](#1-project-overview)
- [2. Exploratory Data Analysis (EDA)](#2-exploratory-data-analysis-eda)
- [3. Problem Diagnosis](#3-problem-diagnosis)
- [4. MECE Framework](#4-mece-framework)
- [5. Data Modeling](#5-data-modeling)
- [6. Key Insights](#6-key-insights)
- [7. Strategic Recommendations](#7-strategic-recommendations)

---

## Research Considerations

### 1. Portuguese Language Text Processing Constraints (NLP Limitation)

  The Portuguese language presents inherent challenges to the keyword extraction process through Aspect-Based Sentiment Analysis (ABSA), resulting in limitations regarding absolute accuracy. Nevertheless, employing root word identification through fundamental lexicon translation methodologies has successfully facilitated the extraction and classification of four distinct error categories: Logistics, Seller, Product, and Customer Service. Among these categories, Seller-related errors (specification mismatches and stock deficiencies) and Logistics failures emerge as the most frequently cited concerns within customer feedback.

### 2. Market Basket Analysis Findings

  Empirical analysis reveals that co-purchased products are predominantly concentrated within two product categories: "bead_bath_tables" and "housewares." This distribution pattern indicates that other product categories are purchased only when customers identify genuine necessity—a pattern characterized by isolated transactions without sustained cross-purchase behavior or strategic product recommendations. Consequently, the implementation of cross-sell algorithms is not feasible given the current data characteristics and market dynamics.

### 3. Customer Segmentation Methodology

To facilitate customer portfolio stratification for marketing campaign optimization, two methodological approaches have been evaluated:

- **Baseline Model (RFM + K-Means Clustering)**: This approach prioritizes interpretability and operational accessibility for the operations team.
- **Advanced Model (Gaussian Mixture Models - GMM)**: This method addresses K-Means limitations through soft clustering capabilities, enabling identification of borderline customer cohorts (e.g., customers positioned between churn-risk and retention-focus segments).

However, due to the Olist dataset's inherent sparsity (97% of customers execute single transactions), the Frequency variable exhibits substantial noise. While GMM provides probabilistic insights of greater sophistication, K-Means generates sufficiently distinct cluster boundaries to enable the Marketing team to establish Rule-based Automation protocols (automated email distribution workflows). Therefore, this analysis recommends RFM + K-Means implementation for Phase 1, with GMM consideration contingent upon accumulation of repeat purchase data (Frequency > 2) across the user base.

**The following table presents the four customer segments identified within this analytical framework:**

| Customer Segment | Characterization | Purchase Behavior |
|------------------|------------------|-------------------|
| **High Ticket One-Off** | Customers executing substantial initial purchases (exceptionally high AOV). Due to high product valuation, their shipping fee ratios remain comparatively low. | Single transaction occurrence |
| **Price-Sensitive** | Customers purchasing low-value items but experiencing disproportionately elevated shipping fee ratios relative to transaction value. | Single transaction followed by permanent churn |
| **Sleeping VIPs** | Previously high-value customers (elevated Monetary score) with multiple transaction history, currently inactive (high Recency). | Extended inactivity period |
| **Recent Customers** | Customers executing transactions in recent periods (very low Recency). Insufficient temporal data to predict VIP elevation or churn probability. | Recent transaction engagement |

---

## 1. Project Overview

This project presents a comprehensive end-to-end analytical framework for Brazilian e-commerce platform data, encompassing data preprocessing, exploratory analysis, visualization, insight extraction, and actionable recommendation formulation. 
The dataset is available at: https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce?select=olist_customers_dataset.csv

---

## 2. Exploratory Data Analysis (EDA)

Comprehensive data exploration through SQL-based methodologies has revealed several critical dataset characteristics:

- **Diminished Customer Retention**: The customer return rate stands at 3.12% (representing 98,666K+ orders and 94,983K customer accounts)
- **Limited Product Category Diversification**: Co-purchased products concentrate within two categories: "bead_bath_tables" and "housewares." Alternative product categories are purchased only upon explicit customer need, reflecting isolated transactions without cross-category encouragement or demand stimulus.
- **Revenue Growth Plateau**: Despite 2018 revenues exceeding corresponding 2017 figures, monthly revenues demonstrate stagnation—a phenomenon characterized as "quality-eroding growth."

---

## 3. Problem Diagnosis

Primary factors contributing to diminished customer satisfaction and review scores:

- **Extended Delivery Timeframes**: Prolonged shipping duration combined with elevated shipping cost proportions relative to product value at initial purchase
- **Seller Experience Degradation**: Suboptimal vendor performance (evidenced by depressed review scores)
- **Product Quality Deficiencies**: Quality issues stemming from both logistics-induced damage and inherent product characteristics

---

## 4. MECE Framework

To systematically address identified issues, a Mutually Exclusive, Collectively Exhaustive (MECE) framework has been constructed to decompose relevant stakeholder categories:

- **Customer Segment**: Olist customer profile and purchasing behavioral patterns
- **Seller Community**: E-commerce platform vendors
- **Product Portfolio**: Vendor-offered products and categorical classifications
- **Logistics Operations**: Temporal requirements for merchandise transportation from seller to customer

![MECE Tree Diagram](MECE%20tree.png)

---

## 5. Data Modeling

Results derived from Aspect-Based Sentiment Analysis (ABSA) and K-Means Clustering algorithms.

![Data Modeling](Visualize%20in%20PowerBI/Data%20Modeling.png)

---

## 6. Key Insights

- **Growth Trajectory Analysis (Growth Trend)**: The Olist platform experienced exceptionally rapid growth during the 2017 Black Friday promotion, subsequently straining operational logistics capacity throughout 2018. Late delivery rates increased by 3.42% relative to 2016 and 1.16% relative to 2017. Consequently, although 2018 monthly revenues remained elevated compared to 2017, revenue growth demonstrates stagnation—a phenomenon characterized as "quality-eroding growth."

- **Business Model Structural Constraints (Business Model Constraint)**: The core product portfolio comprises durable goods with extended replacement cycles. This inherent characteristic fundamentally constrains customer retention rates at approximately 3%.

- **Revenue Stream Risk Assessment (Revenue at Risk)**: High-value customer segments experience the most severe logistics impact, with late delivery rates reaching 10.75% in 2018, directly compromising the Lifetime Value (LTV) of the platform's most valuable customer cohorts.

- **Geographic Supply-Demand Imbalance (Geographic Imbalance) Generating Excessive Shipping Costs**: A substantial misalignment exists between demand distribution and supply concentration. Approximately 90% of sellers cluster in the Southeast region (São Paulo), while customers distribute nationally. This geographic disparity necessitates inter-state shipments, imposing shipping cost burdens of 30-40% of transaction value upon price-sensitive customer segments, directly undermining repurchase motivation.

- **Carrier Operational Inefficiency (Carrier Inefficiency)**: Root-cause analysis of late deliveries indicates that over 60% (4.72K orders) of failures result entirely from carrier fault, whereas seller-originated errors account for 12.5%. Geographic distance combined with limited carrier capacity generates acute review score deterioration: deliveries exceeding 14 days consistently receive ratings below 3 stars.

- **Product and Service Quality Crisis (Product and Service Quality Crisis)**: Across all four customer segments, the two predominant complaint categories are shipping delays and product defects. Customers express dissatisfaction not only regarding extended wait periods but also regarding receipt of defective merchandise, specification mismatches, or seller description inaccuracies (particularly among high-value customers with expectations aligned to their substantial expenditures).

![Operations & CX Diagnostic](Visualize%20in%20PowerBI/Operations%20%26%20CX%20Diagnostic.png)

---

## 7. Strategic Recommendations

- **Logistics Restructuring Initiative (Resolving 60% of Carrier Faults and Excessive Shipping Costs)**: Implement cross-docking warehouse infrastructure or subsidized fulfillment services in Northern and Northeastern regions. Olist should negotiate stringent Service Level Agreements (SLAs) with carriers, implementing penalty provisions for late deliveries attributable to carrier fault. These measures aim to reduce inter-state transit duration and reduce shipping cost proportions below 15% thresholds.

- **Supply Source Quality Assurance Enhancement (Resolving Product and Service Defects)**: Establish a Seller Credibility Scoring System (Seller Penalty Score). Vendors with persistent specification mismatch rates, missing product components, or consistently low quality ratings (1-2 stars) will face visibility suppression (shadowbanning) or permanent account suspension to protect high-value customer segments.

- **Customer Reactivation and Basket Optimization Strategy (Stimulating Revenue Growth)**:
  - **New Customer Cohort (Recent Customers)**: Leveraging Apriori algorithm (Market Basket Analysis), immediately deploy cross-sell functionality recommending complementary product combinations (Bed_Bath_Table & Home_Comfort bundles). Implement a Freeship Combo policy (free shipping for 3+ item purchases within 10km delivery range) to incentivize shopping basket diversification and logistics cost optimization.
  - **Returning Customer Cohort (Sleeping VIPs)**: Establish automated Marketing workflow systems (CRM Automation) targeting both Recent Customers and Sleeping VIPs. Emphasize complementary accessories and high-turnover products (Health_Beauty category) according to consumption depletion cycles, minimizing dependency upon products with extended lifecycle patterns.
