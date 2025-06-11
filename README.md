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

## 📊 Descriptive Statistics (Cleaned Dataset)

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

## 🔍 Interpretation

- **High registration rate** (90%) indicates formalization is the norm among surveyed firms in these countries.
- **Wide variation in firm age and size**: Ranges from newly established startups to legacy firms over 90 years old.
- **Low female ownership** (20%) highlights a gender gap in firm leadership—an important motivation for the gender-based interaction analysis later in the study.
- **Managerial experience** shows substantial heterogeneity, supporting the use of matching and multilevel models to control for human capital factors.

These summary statistics confirm data quality and sufficient variation across key dimensions, enabling robust empirical analysis.

---

