# Firm Formalization and Performance in Central Asia

## Research Background

This project replicates and extends the core findings of Assenova & Sorenson (2017), *"Legitimacy and the Benefits of Firm Formalization,"* using firm-level data from the **World Bank Enterprise Surveys** for five Central Asian countries: **Uzbekistan, Kazakhstan, Kyrgyzstan, Tajikistan, and Turkmenistan**.

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

## Key observations

- **High registration rate** (90%) indicates formalization is the norm among surveyed firms in these countries.
- **Wide variation in firm age and size**: Ranges from newly established startups to legacy firms over 90 years old.
- **Low female ownership** (20%) highlights a gender gap in firm leadership—an important motivation for the gender-based interaction analysis later in the study.
- **Managerial experience** shows substantial heterogeneity, supporting the use of matching and multilevel models to control for human capital factors.

These summary statistics confirm data quality and sufficient variation across key dimensions, enabling robust empirical analysis.

---

# Sample Composition and Visualization

After summarizing firm characteristics, we explored how the sample is distributed across countries and by firm registration status (formal vs. informal).

## Bar Plot: Number of Formal and Informal Firms by Country

We visualized the number of formal and informal firms in each country using a grouped bar chart.
![](https://github.com/said-tojiboev/formalization_effect/commit/927fabb7ac737f06d767bf1be1222ad94c73338e#diff-6be7311d49ea8f0b07f88a3dfce32e19824a846fe6b815de154f330d2c68ff04)

### Key observations

- **Kazakhstan** and **Uzbekistan** had the highest number of formal firms (849 and 739, respectively).
- The number of **informal firms** is much lower across all countries — the smallest being in **Tajikistan** (23 firms).
- This suggests an **imbalance in registration status**, with formal firms dominating the sample — a known issue in Enterprise Survey data.
- The imbalance needs to be accounted for when interpreting results, especially in **matching or regression models** that assume comparability across groups.

## Geographic Distribution: Choropleth Maps

We also created regional choropleth maps to visualize the distribution of formal and informal firms by country.
![](https://github.com/said-tojiboev/formalization_effect/commit/927fabb7ac737f06d767bf1be1222ad94c73338e#diff-cab46b2bd023c0b8f255f2e20c7c8fdedb5afee51569d3ae671b638bbb3bab02)

### Key Observations

- **Formal firms** are more concentrated in Kazakhstan and Uzbekistan, indicated by darker green regions.
- **Informal firms** are fewer and more spread out, with some concentration in **Uzbekistan** and **Turkmenistan**.
- Countries with fewer informal firms (e.g., **Tajikistan**) may lead to **less precise estimates** when comparing registered vs. unregistered firms.

---
