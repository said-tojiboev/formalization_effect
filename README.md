# Firm Formalization and Performance in Central Asia

## Research Background

This project replicates and extends the core findings of Assenova & Sorenson (2017), *"Legitimacy and the Benefits of Firm Formalization,"* using firm-level data from the **World Bank Enterprise Surveys** for five Central Asian countries: **Uzbekistan, Kazakhstan, Kyrgyzstan, Tajikistan, and Turkmenistan**. The survey data were collected between **2023 and 2024**, offering recent insights into firm behavior in transition economies.

While the original paper examined how firm registration (formalization) influences outcomes such as **employment** and **sales**, this study expands that analysis in two important ways:

1. **Geographical extension**: Applying the framework to **transition economies** of Central Asia, where institutional environments differ from those in Latin America or Sub-Saharan Africa.
2. **Conceptual extension**: Introducing a **moderation analysis** to examine whether **the effect of registration is different for female-owned firms**, thereby exploring the intersection of **gender and firm legitimacy**.

This allows us to answer the following research questions:

- Do registered firms perform better in terms of **employment** and **sales**?
- How do these effects vary across **countries** and **firm age**?
- Does **gender ownership** moderate the effect of registration on performance?

The analysis involves multiple methods:
- **OLS regressions with and without interaction terms**
- **Matching using genetic algorithms**
- **Multilevel modeling with country-specific slopes**

---

## Descriptive Statistics (Cleaned Dataset)

After preparing the data, we summarize the key variables:

| Variable         | Description                                             |
|------------------|---------------------------------------------------------|
| `ln_sales`       | Natural log of total annual sales                       |
| `ln_emp`         | Natural log of number of employees                      |
| `registered`     | 1 if firm was registered at founding, 0 otherwise       |
| `firm_age`       | Firm age = 2024 - founding year                         |
| `init_size`      | Log of initial number of employees                      |
| `experience`     | Years of experience of the top manager                  |
| `female_owner`   | 1 if the principal owner is female, 0 otherwise         |

### Summary Table

| Variable        | Mean  | SD   | Min  | Median | Max  |
|-----------------|-------|------|------|--------|------|
| `ln_sales`      | 19.3  | 3.4  | 8.9  | 19.6   | 32.0 |
| `ln_emp`        | 3.3   | 1.3  | 0.7  | 3.0    | 7.8  |
| `registered`    | 0.9   | 0.3  | 0.0  | 1.0    | 1.0  |
| `firm_age`      | 13.5  | 9.5  | 1.0  | 11.0   | 91.0 |
| `init_size`     | 2.5   | 1.1  | 0.7  | 2.2    | 8.7  |
| `experience`    | 14.0  | 8.5  | 1.0  | 12.0   | 50.0 |
| `female_owner`  | 0.2   | 0.4  | 0.0  | 0.0    | 1.0  |

---

### Key observations

- **High registration rate** (90%) indicates formalization is the norm among surveyed firms in these countries.
- **Wide variation in firm age and size**: Ranges from newly established startups to legacy firms over 90 years old.
- **Low female ownership** (20%) highlights a gender gap in firm leadership—an important motivation for the gender-based interaction analysis later in the study.
- **Managerial experience** shows substantial heterogeneity, supporting the use of matching and multilevel models to control for human capital factors.

---

## Sample Composition and Visualization.

After summarizing firm characteristics, we explored how the sample is distributed across countries and by firm registration status (formal vs. informal).

### Bar Plot: Number of Formal and Informal Firms by Country

![Rplot01](https://github.com/user-attachments/assets/1f2e20f6-4a0e-442b-9800-86362563e4bd)


### Key observations

- **Kazakhstan** and **Uzbekistan** had the highest number of formal firms (849 and 739, respectively).
- The number of **informal firms** is much lower across all countries — the smallest being in **Tajikistan** (23 firms).
- This suggests an **imbalance in registration status**, with formal firms dominating the sample — a known issue in Enterprise Survey data.
- The imbalance needs to be accounted for when interpreting results, especially in **matching or regression models** that assume comparability across groups.

### Geographic Distribution: Choropleth Maps

![Screenshot 2025-06-11 164738](https://github.com/user-attachments/assets/1b683489-54c4-4c50-af2e-14cae17de9c1)


### Key Observations

- **Formal firms** are more concentrated in Kazakhstan and Uzbekistan, indicated by darker green regions.
- **Informal firms** are fewer and more spread out, with some concentration in **Tajikistan** and **Turkmenistan**.
- Countries with fewer informal firms (e.g., **Tajikistan**) may lead to **less precise estimates** when comparing registered vs. unregistered firms.

---

## Linear Probability Model (LPM): Determinants of Registration

We estimate a **Linear Probability Model (LPM)** to examine which firm characteristics predict whether a business is registered at the time of founding. The dependent variable is binary:

> `registered = 1` if the firm was registered at the time of start,  
> `0` otherwise.

### Covariates Included

- `female_owner`: Dummy for whether the firm is female-owned  
- `firm_age`: Age of the firm in years  
- `init_size`: Log of number of employees at founding  
- `manager_experience`: Years of top manager’s experience  
- `size`: Categorical firm size based on locality population:
  - `size2`: City with population over 1 million (**reference category**)  
  - `size3`: City with population between 250,000 and 1 million  
  - `size4`: Town with population between 50,000 and 250,000  
  - `size5`: Locality with population less than 50,000  
- `country`: Country fixed effects (Uzbekistan as reference)

### Result Visualization

Visual results are presented with confidence intervals (horizontal bars). If the interval crosses the red vertical line at 0, the effect is **not statistically significant** at the 95% level.
![Rplot](https://github.com/user-attachments/assets/1fcbc163-be67-44a4-bec2-9b2969a58504)


### Key Observations

The only significant predictor of being formal at founding is firm age, and interestingly, the relationship is negative — suggesting older firms in the dataset were less likely to have registered from the start. This could reflect that informal firms survive and age, or that new firms are more likely to register upfront due to regulatory changes or incentives.

---

## Effect of Registration by Firm Age

This figure investigates the possibility of differential survival bias in estimating the effects of firm registration. Specifically, it addresses the concern that better-performing firms may be more likely to register at founding, and that weaker informal firms may exit early and not appear in the sample. If that’s the case, the observed performance differences between formal and informal firms might reflect selection effects rather than causal benefits of registration.

To explore this, we estimate the effect of registration on firm outcomes (ln employment and ln sales) separately for each firm age, from 1 to 20 years. This approach allows us to observe how the impact of formalization evolves over the firm lifecycle and to detect potential survival-driven biases.



### Visualization

The effects of registration on employment and sales are plotted across firm ages with corresponding 95% confidence intervals.
Each point shows the **average difference in log sales or log employment** between:

🔹 **Firms that were registered at founding (formal)**  
vs.  
🔸 **Firms that were not registered at founding (informal)**  

**among firms that are the same age** (e.g., all 3-year-old firms).

> **"At this firm age, how much better (or worse) are formal firms performing compared to informal ones, on average?"**

- If a point is **above zero**, formal firms perform **better** on that outcome.
- If a point is **below zero**, informal firms perform **better** on that outcome.
- If the **confidence interval includes zero**, the difference is **not statistically significant**.

![Rplot04](https://github.com/user-attachments/assets/04be9fb6-a131-4652-8b85-99f2addd53dd)


### Key Observations

#### 🔵 Ln Sales (Blue Line)

- For young firms, the effect of registration on sales is mostly positive: formal firms tend to perform better in their early years.

- As firm age increases, the effect declines and even turns negative (around ages 10–16), suggesting that older informal firms are more competitive — likely because only the most resilient informal firms survive.

- This implies that younger informal firms are disadvantaged, but those that endure may catch up or even outperform formal firms in terms of sales.


#### 🔴 Ln Employment (Red Line)

- The effect is mostly flat and close to zero, with modest positive values in the early and middle years.

- This suggests that registration has a limited or inconsistent effect on employment, and that gap doesn't significantly change as firms age.


---

## Overall Matching Effects (Full Sample)

To estimate the **average treatment effect of registration** across all countries in the sample, we use **Genetic Matching (GenMatch)** with the following covariates:

### Covariates Used for Matching
- Matching was done using three key covariates: `firm_age`, `init_size`, and `manager_experience`.
- `GenMatch` was used to optimize the covariate balance across the treated (registered) and control (informal) firms.
- Outcome variables: `ln_emp` (log of employment) and `ln_sales` (log of annual sales).
- The estimated quantity is the **Average Treatment Effect on the Treated (ATT)**.

### Results

| Outcome   | Estimate | Std. Error | T-statistic | P-value | Interpretation |
|-----------|----------|------------|-------------|---------|----------------|
| ln_emp    | -0.249   | 0.075      | -3.30       | 0.001   | **Negative and statistically significant.** Registration is associated with a **~25% decrease in employment** (log points), suggesting that formal firms may hire fewer workers, potentially due to higher regulatory or tax-related labor costs. |
| ln_sales  | 0.078    | 0.264      | 0.30        | 0.768   | **Positive but not statistically significant.** No strong evidence that formalization impacts sales on average across all firms. |

These findings align with Assenova & Sorenson (2017), who argue that the benefits of formalization may be offset by new compliance burdens, especially for smaller firms with limited capacity to absorb the associated costs.

---

## Effect of Registration by Country (Matching Estimation)

To assess cross-country differences in the **impact of firm registration**, we use **Genetic Matching** (GenMatch) to estimate the effect of registration on:

- **Employment** (`ln_emp`)
- **Sales** (`ln_sales`)

Separate models are estimated for each country, controlling for:
- **Firm age**
- **Initial firm size (log employees at founding)**
- **Manager experience**

### Visualization 1: Effect of Registration on Employment by Country
![Rplot05](https://github.com/user-attachments/assets/0d8ecc8b-9b73-49a8-a0b2-73512bc7e0ca)


- Each point represents the estimated effect of registration on log employment.
- Horizontal lines represent **95% confidence intervals**.
- A **dashed red vertical line** at 0 indicates **no effect**.

### Key Observations:

- All countries have negative point estimates, meaning formal firms tend to employ fewer people than informal ones after matching.
- The largest negative effect is seen in Kazakhstan, followed by Tajikistan and Uzbekistan.
- Turkmenistan shows almost no difference, with a point estimate very close to zero.
- None of the effects are significantly positive, suggesting no employment advantage from registration in these contexts.
- This supports the idea that registration does not increase employment — and in some countries, it may even be associated with reduced employment.
- The variation across countries suggests that local institutional or regulatory environments may shape how registration affects firm behavior.

---

### Visualization 2: Effect of Registration on Sales by Country
![Rplot06](https://github.com/user-attachments/assets/44f95e27-e77b-442a-abd9-8474b832909c)


- Each point shows the estimated effect of registration on log sales.
- Horizontal lines represent **95% confidence intervals**.
- The **red dashed line** marks 0 (no effect).

### Key Observations:

- All five countries show negative point estimates, meaning that formally registered firms tend to have lower sales than comparable informal firms after matching on observable characteristics (firm age, founding size, manager experience).
- Kazakhstan shows the largest negative effect, with formal firms having substantially lower log sales than informal firms.
- Kyrgyzstan and Turkmenistan also show moderate negative effects, though the confidence intervals are wide, indicating high uncertainty in those estimates.
- Uzbekistan and Tajikistan show small negative effects close to zero, with large confidence intervals — suggesting the difference is not statistically significant.
- These results suggest that formalization may not provide sales advantages to firms in these countries — or that informal firms that survive may be particularly strong in sales performance.

This could reflect:
- Weak enforcement of benefits tied to formal registration.
- Informal firms having competitive advantages (e.g., lower taxes or less regulatory burden).
- Selection bias — only stronger informal firms may survive long enough to be observed.
- Together with the employment results, these findings question the assumption that registration automatically leads to better firm outcomes.

---

## OLS Regressions: Effect of Registration on Firm Outcomes

We estimate four OLS models to assess how firm registration at the time of founding affects **log sales** and **log employment**.

### Model Specifications

- **Basic Models (1 & 2)**: Include controls for firm age, founding size, and country fixed effects.
- **Full Models (3 & 4)**: Add manager experience, female ownership, and firm size category.

| Variable                   | Ln Sales (Basic) | Ln Employment (Basic) | Ln Sales (Full) | Ln Employment (Full) |
|----------------------------|------------------|------------------------|------------------|------------------------|
| **Registered at Start**    | −0.172 (0.131)    | −0.211*** (0.058)      | −0.177 (0.130)    | −0.217*** (0.058)      |
| **Ln Firm Age**            | 0.017*** (0.005)  | 0.011*** (0.002)       | 0.019*** (0.005)  | 0.011*** (0.002)       |
| **Ln Employees (Founding)**| 0.831*** (0.036)  | 0.742*** (0.016)       | 0.838*** (0.036)  | 0.746*** (0.016)       |
| **Manager Experience**     | –                | –                      | 0.001 (0.005)     | 0.003 (0.002)          |
| **Female Owner**           | –                | –                      | −0.379*** (0.095) | −0.129** (0.042)       |

### Model Fit Statistics

|                         | Basic (Sales) | Basic (Emp) | Full (Sales) | Full (Emp) |
|-------------------------|----------------|-------------|----------------|-------------|
| **Observations**        | 2599           | 2599        | 2599           | 2599        |
| **R²**                  | 0.641          | 0.485       | 0.646          | 0.492       |
| **Adjusted R²**         | 0.640          | 0.484       | 0.645          | 0.489       |
| **F-statistic**         | 660.710        | 349.064     | 393.604        | 208.492     |
| **RMSE**                | 2.04           | 0.90        | 2.02           | 0.90        |

---

### Key Takeaways

- **Registration at founding** has a **significant negative effect on employment**, but **no significant effect on sales** in both basic and full models.
- **Firm age** and **initial firm size** are strong positive predictors of both sales and employment.
- **Female ownership** is associated with **lower sales and employment**, with statistically significant effects.
- **Manager experience** has **no statistically significant effect** on either outcome.
- The inclusion of additional controls (Full Models) slightly improves the explanatory power (R²), particularly for sales.

---

## Multilevel Models: Effect of Registration with Random Slopes by Country

In cross-country analyses, assuming the same effect across all countries may overlook real differences in context. That’s why we use random effects, which allow both the baseline outcomes (intercepts) and the impact of registration (slopes) to vary across countries. This approach captures country-level heterogeneity and provides a more flexible and realistic understanding of how registration affects firm outcomes differently in each context.

To account for these differences, **country-level heterogeneity**, we estimate **hierarchical linear models (HLMs)** with **random slopes for the registration variable by country**.

Each model includes:
- Fixed effects: registered, female ownership, firm age, initial size, manager experience, firm size
- Random effects: varying intercept and slope for registration by country

---

### Model 1: Ln Employment (Multilevel)

#### Model Summary

- **REML Criterion**: 6884.5  
- **Number of Observations**: 2599  
- **Countries (groups)**: 5  

#### Random Effects

| Effect       | Variance | Std.Dev. | Correlation |
|--------------|----------|----------|-------------|
| Intercept    | 0.129    | 0.359    | –           |
| Registered   | 0.039    | 0.197    | −0.97       |
| Residual     | 0.809    | 0.900    | –           |

#### Fixed Effects

| Variable             | Estimate   | Std. Error | Significance |
|----------------------|------------|------------|---------------|
| Intercept            | 1.553      | 0.180      | ***           |
| Registered           | −0.205     | 0.107      | *             |
| Female Owner         | −0.132     | 0.042      | **            |
| Ln Firm Age          | 0.0099     | 0.0022     | ***           |
| Ln Employees (Founding) | 0.747   | 0.016      | ***           |
| Manager Experience   | 0.0029     | 0.0024     | ns            |
| Size 3               | −0.148     | 0.046      | **            |
| Size 4               | −0.220     | 0.049      | ***           |
| Size 5               | −0.236     | 0.070      | **            |

#### Key Takeaways

- **Registration** has a **negative and marginally significant effect** on employment.  
- **Female ownership** continues to show a **significant negative effect**.  
- **Firm age and size** are strong positive predictors.  
- **Larger firms (size categories 3–5)** have **lower employment** compared to the baseline, likely reflecting structural differences.

---

## Model 2: Ln Sales (Multilevel)

### Model Summary

- **REML Criterion**: 11099.8  
- **Number of Observations**: 2599  
- **Countries (groups)**: 5  

#### Random Effects

| Effect       | Variance | Std.Dev. | Correlation |
|--------------|----------|----------|-------------|
| Intercept    | 9.919    | 3.149    | –           |
| Registered   | 0.117    | 0.343    | −0.45       |
| Residual     | 4.093    | 2.023    | –           |

#### Fixed Effects

| Variable             | Estimate   | Std. Error | Significance |
|----------------------|------------|------------|---------------|
| Intercept            | 16.046     | 1.421      | ***           |
| Registered           | −0.154     | 0.206      | ns            |
| Female Owner         | −0.378     | 0.095      | ***           |
| Ln Firm Age          | 0.0179     | 0.0051     | ***           |
| Ln Employees (Founding) | 0.839   | 0.036      | ***           |
| Manager Experience   | 0.0005     | 0.0055     | ns            |
| Size 3               | −0.446     | 0.103      | ***           |
| Size 4               | −0.485     | 0.111      | ***           |
| Size 5               | −0.484     | 0.157      | **            |

#### Key Takeaways

- **Registration** has **no significant effect** on sales overall, with substantial variance across countries.
- **Female-owned firms** show **significantly lower sales**, mirroring employment results.
- **Initial size** and **firm age** strongly predict higher sales.
- Larger size categories (3–5) have **significantly lower sales** than the baseline, suggesting structural or sector-specific patterns.

---

### Summary Table

| Outcome     | Effect of Registration | Significant? | Random Slope Variance |
|-------------|------------------------|--------------|------------------------|
| Employment  | −0.205                 | * (p < 0.1)  | 0.039                  |
| Sales       | −0.154                 | No           | 0.117                  |

---

### Final Notes

- **Negative correlation** between the intercept and registration slopes in both models (−0.97 for employment, −0.45 for sales) suggests that countries with higher baseline outcomes may experience **smaller (or negative) returns from formalization**.
- These models highlight the **importance of accounting for country-level heterogeneity** when analyzing the effects of registration.

---

## Country-Specific Effects of Registration (HLM Estimates)

To further explore how the **impact of registration** varies across countries, we extract and visualize the **random slope estimates** for the `registered` variable from the multilevel models (HLMs). This gives us the **total effect of registration by country** (fixed effect + country-specific random effect).

Confidence intervals are constructed using ±0.1 for employment and ±0.2 for sales as approximations.

---

### Plot 1: Estimated Effect of Registration on Employment by Country (HLM)
![Rplot07](https://github.com/user-attachments/assets/dab176e0-5b46-4858-9194-b1091004af43)

### Key Takeaways

- **Kazakhstan** and **Turkmenistan** show the **strongest negative effects** of registration on employment, with estimated effects close to or below −0.4 log points.
- **Uzbekistan** and **Tajikistan** also exhibit **moderate negative effects**.
- **Kyrgyzstan** has the **least negative** (closest to zero) effect among all countries.

These results suggest that in some countries (e.g., Kazakhstan, Turkmenistan), **formalization may be associated with substantial reductions in employment**, potentially due to regulatory compliance or tax burdens on formal firms.

---

## Plot 2: Estimated Effect of Registration on Sales by Country (HLM)
![Rplot08](https://github.com/user-attachments/assets/1ba7ea1e-29ac-4155-9e74-f8bafb8f30ec)

### Key Takeaways

- **Kazakhstan** is again the most negatively affected in terms of sales, with an effect around **−0.6 log points**.
- **Other countries** (e.g., Turkmenistan, Tajikistan, Uzbekistan, Kyrgyzstan) show **smaller and more varied effects**, but all hover near **zero**, with **confidence intervals crossing zero**.
- **None of the countries** show statistically significant positive sales effects.

This indicates that **formalization does not consistently benefit sales**, and in some contexts (like Kazakhstan), it may **dampen firm revenues** — possibly due to exposure to taxes, reduced flexibility, or market constraints.

---

### Key Insight

The **heterogeneous effects** of registration across countries underscore the **context-specific nature** of formalization outcomes. Structural conditions, institutional environments, and enforcement practices likely shape how formalization affects firm performance.

This analysis highlights the importance of **tailoring policy recommendations** by country — especially when promoting formalization as a pathway to growth.

