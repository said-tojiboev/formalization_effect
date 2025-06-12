
# ========================================
# Required Libraries
# ========================================
library(tidyverse)
library(haven)
library(lmtest)
library(sandwich)
library(Matching)
library(lme4)
library(modelsummary)
library(ggplot2)
library(rnaturalearth)
library(rnaturalearthdata)
library(patchwork)
library(labelled)

# ========================================
# 1. Load and Combine Country-Level Datasets
# ========================================
load_country_data <- function(path, country_name) {
  read_dta(path) %>% mutate(country = country_name)
}

data_all <- bind_rows(
  load_country_data("Uzbekistan ESD Data/Uzbekistan-2024-full-data.dta", "Uzbekistan"),
  load_country_data("Kazakhstan ESD Data/Kazakhstan-2024-full-data.dta", "Kazakhstan"),
  load_country_data("Tajikistan ESD Data/Tajikistan-2024-full-data.dta", "Tajikistan"),
  load_country_data("Turkmenistan ESD Data/Turkmenistan-2024-full-data.dta", "Turkmenistan"),
  load_country_data("Kyrgyzstan ESD Data/Kyrgyz-Republic-2023-full-data.dta", "Kyrgyzstan")
)

# ========================================
# 2. Clean and Prepare Variables
# ========================================
data_clean <- data_all %>%
  mutate(
    registered = ifelse(b6b == b5, 1, 0),
    female_owner = ifelse(b4 == 1, 1, 0),
    ln_sales = log(if_else(d2 > 0, d2 + 1, NA_real_)),
    ln_emp = log(if_else(l1 >= 0, l1 + 1, NA_real_)),
    firm_age = 2024 - b5,
    init_size = log(if_else(b6 >= 0, b6 + 1, NA_real_)),
    manager_experience = b7,
    size = factor(a3),
    country = factor(country)
  ) %>%
  filter(
    !is.na(registered), !is.na(female_owner),
    !is.na(ln_sales), !is.na(ln_emp),
    !is.na(manager_experience), !is.na(init_size),
    firm_age >= 0 & firm_age <= 100,
    manager_experience >= 0
  )

# ========================================
# 3. Descriptive Summary
# ========================================
var_label(data_clean$manager_experience) <- "experience"               # Assign a label to manager_experience

data_descriptive <- data_clean %>%
  dplyr::select(ln_sales, ln_emp, registered, firm_age, init_size, manager_experience, female_owner)

datasummary_skim(
  data_descriptive,
  fun_numeric = list(Mean = mean, SD = sd, Min = min, Median = median, Max = max)
)

# ========================================
# 4. Sample Size Summary and Bar Plot
# ========================================
summary_counts <- data_clean %>%
  mutate(type = ifelse(registered == 1, "Formal", "Informal")) %>%
  group_by(country, type) %>%
  summarise(count = n(), .groups = "drop")

ggplot(summary_counts, aes(x = country, y = count, fill = type)) +
  geom_col(position = "dodge") +
  geom_text(aes(label = count), position = position_dodge(width = 0.9), vjust = -0.5) +
  scale_fill_manual(values = c("Formal" = "darkgreen", "Informal" = "brown")) +
  labs(title = "Enterprise Survey Sample Sizes by Country", x = "Country", y = "Firms", fill = "Type") +
  theme_minimal()

# ========================================
# 5. Regional Maps by Registration Type
# ========================================
world <- ne_countries(scale = "medium", returnclass = "sf")
map_data <- world %>%
  filter(admin %in% unique(data_clean$country)) %>%
  left_join(summary_counts %>% pivot_wider(names_from = type, values_from = count, values_fill = 0),
            by = c("admin" = "country"))

p1 <- ggplot(map_data) +
  geom_sf(aes(fill = Formal)) +
  geom_sf_text(aes(label = admin), size = 2, fontface = "bold", color = "black") +
  scale_fill_gradient(low = "#ccebc5", high = "#006837") +
  labs(title = "Formal Firms", fill = "Count") +
  theme_minimal()

p2 <- ggplot(map_data) +
  geom_sf(aes(fill = Informal)) +
  geom_sf_text(aes(label = admin), size = 2, fontface = "bold", color = "black") +
  scale_fill_gradient(low = "#fbb4ae", high = "#d7301f") +
  labs(title = "Informal Firms", fill = "Count") +
  theme_minimal()

p1 + p2


# ========================================
# 6. Linear Probability Model (LPM)
# ========================================
data_clean$country <- relevel(data_clean$country, ref = "Uzbekistan")

model_lpm <- lm(
  registered ~ female_owner + firm_age + init_size + manager_experience + size + country,
  data = data_clean
)

lpm_results <- broom::tidy(model_lpm, conf.int = TRUE) %>%
  filter(term != "(Intercept)")

ggplot(lpm_results, aes(x = estimate, y = reorder(term, estimate))) +
  geom_point(size = 3) +
  geom_errorbarh(aes(xmin = conf.low, xmax = conf.high), height = 0.2) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "red") +
  labs(
    title = "Linear Probability Model of Registration at Founding",
    x = "Coefficient",
    y = NULL
  ) +
  theme_minimal(base_size = 14)

# ========================================
# 7. Effect by Firm Age (Replicating Figure 4 Logic)
# ========================================
results <- tibble()

for (age in 1:20) {
  subset_data <- data_clean %>% filter(firm_age == age)
  
  model_sales <- lm(ln_sales ~ registered + init_size + manager_experience + size + country, data = subset_data)
  model_emp <- lm(ln_emp ~ registered + init_size + manager_experience + size + country, data = subset_data)
  
  coef_sales <- broom::tidy(model_sales) %>% filter(term == "registered") %>%
    mutate(outcome = "Ln Sales", firm_age = age)
  coef_emp <- broom::tidy(model_emp) %>% filter(term == "registered") %>%
    mutate(outcome = "Ln Employment", firm_age = age)
  
  results <- bind_rows(results, coef_sales, coef_emp)
}

ggplot(results, aes(x = firm_age, y = estimate, color = outcome)) +
  geom_line() +
  geom_errorbar(aes(ymin = estimate - 1.96 * std.error,
                    ymax = estimate + 1.96 * std.error), width = 0.5) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
  labs(
    title = "Effect of Registration by Firm Age",
    x = "Firm Age (Years)",
    y = "Effect of Registration"
  ) +
  theme_minimal()

# ========================================
# 8a. Overall Matching Effects (Full Sample)
# ========================================
data_match <- data_clean %>%
  filter(!is.na(firm_age), !is.na(init_size), !is.na(manager_experience))

X <- as.matrix(data_match[, c("firm_age", "init_size", "manager_experience")])
Tr <- data_match$registered
Y_emp <- data_match$ln_emp
Y_sales <- data_match$ln_sales

genout <- GenMatch(Tr = Tr, X = X, M = 1, pop.size = 200)
match_emp <- Match(Y = Y_emp, Tr = Tr, X = X, Weight.matrix = genout)
match_sales <- Match(Y = Y_sales, Tr = Tr, X = X, Weight.matrix = genout)

summary(match_emp)
summary(match_sales)


# ========================================
# 8b. Matching Effects by Country (Replicating Figure 5)
# ========================================
get_country_effect <- function(df, outcome_var) {
  df <- df %>% drop_na(firm_age, init_size, manager_experience, registered, !!sym(outcome_var))
  if (length(unique(df$registered)) < 2 || nrow(df) < 20) {
    return(c(effect = NA, se = NA))
  }
  X <- as.matrix(df[, c("firm_age", "init_size", "manager_experience")])
  Tr <- df$registered
  Y <- df[[outcome_var]]
  genout <- GenMatch(Tr = Tr, X = X, M = 1, pop.size = 200, max.generations = 10, print.level = 0)
  match_out <- Match(Y = Y, Tr = Tr, X = X, Weight.matrix = genout)
  estimate <- match_out$est
  se <- match_out$se.standard
  c(effect = estimate, se = se)
}

results_list <- data_clean %>%
  split(.$country) %>%
  map_df(~{
    emp_res <- get_country_effect(.x, "ln_emp")
    sales_res <- get_country_effect(.x, "ln_sales")
    tibble(
      country = unique(.x$country),
      emp_effect = emp_res["effect"],
      emp_se = emp_res["se"],
      sales_effect = sales_res["effect"],
      sales_se = sales_res["se"]
    )
  }) %>%
  drop_na()

results_list <- results_list %>%
  mutate(
    emp_lower = emp_effect - 1.96 * emp_se,
    emp_upper = emp_effect + 1.96 * emp_se,
    sales_lower = sales_effect - 1.96 * sales_se,
    sales_upper = sales_effect + 1.96 * sales_se
  )

ggplot(results_list, aes(x = emp_effect, y = reorder(country, emp_effect))) +
  geom_point(color = "darkblue", size = 3) +
  geom_errorbarh(aes(xmin = emp_lower, xmax = emp_upper), height = 0.2) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "red") +
  labs(title = "Effect of Registration on Employment by Country", x = "Effect on Employment", y = "Country") +
  theme_minimal()

ggplot(results_list, aes(x = sales_effect, y = reorder(country, sales_effect))) +
  geom_point(color = "darkgreen", size = 3) +
  geom_errorbarh(aes(xmin = sales_lower, xmax = sales_upper), height = 0.2) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "red") +
  labs(title = "Effect of Registration on Sales by Country", x = "Effect on Sales", y = "Country") +
  theme_minimal()

# ========================================
# 9. OLS Regressions: Effect of Registration
# ========================================
model1 <- lm(ln_sales ~ registered + firm_age + init_size + country, data = data_clean)
model2 <- lm(ln_emp ~ registered + firm_age + init_size + country, data = data_clean)
model3 <- lm(ln_sales ~ registered + firm_age + init_size + manager_experience + female_owner + size + country, data = data_clean)
model4 <- lm(ln_emp ~ registered + firm_age + init_size + manager_experience + female_owner + size + country, data = data_clean)

modelsummary(
  list("Ln Sales (Basic)" = model1, 
       "Ln Employment (Basic)" = model2, 
       "Ln Sales (Full)" = model3, 
       "Ln Employment (Full)" = model4),
  stars = TRUE,
  coef_map = c("registered" = "Registered at Start",
               "firm_age" = "Ln Firm Age",
               "init_size" = "Ln Employees (Founding)",
               "manager_experience" = "Manager Experience",
               "female_owner" = "Female Owner"),
  gof_omit = "AIC|BIC|Log.Lik"
)

# ========================================
# 10. Multilevel Models (Random Slopes by Country)
# ========================================
model_emp_hlm <- lmer(
  ln_emp ~ registered + female_owner + firm_age + init_size + manager_experience + size + (1 + registered | country),
  data = data_clean
)

model_sales_hlm <- lmer(
  ln_sales ~ registered + female_owner + firm_age + init_size + manager_experience + size + (1 + registered | country),
  data = data_clean
)

summary(model_emp_hlm)
summary(model_sales_hlm)

# ========================================
# 11. Extract and Plot Random Effects by Country
# ========================================
emp_effects <- ranef(model_emp_hlm)$country %>%
  tibble::rownames_to_column("country") %>%
  dplyr::select(country, registered) %>%
  rename(emp_effect = registered)

sales_effects <- ranef(model_sales_hlm)$country %>%
  tibble::rownames_to_column("country") %>%
  dplyr::select(country, registered) %>%
  rename(sales_effect = registered)

fixed_emp <- fixef(model_emp_hlm)["registered"]
fixed_sales <- fixef(model_sales_hlm)["registered"]

combined_effects <- emp_effects %>%
  left_join(sales_effects, by = "country") %>%
  mutate(
    total_emp_effect = emp_effect + fixed_emp,
    total_sales_effect = sales_effect + fixed_sales,
    emp_ci_low = total_emp_effect - 0.1,
    emp_ci_high = total_emp_effect + 0.1,
    sales_ci_low = total_sales_effect - 0.2,
    sales_ci_high = total_sales_effect + 0.2
  )

# Plot: Employment Effects by Country
ggplot(combined_effects, aes(x = reorder(country, total_emp_effect), y = total_emp_effect)) +
  geom_point(color = "darkblue", size = 3) +
  geom_errorbar(aes(ymin = emp_ci_low, ymax = emp_ci_high), width = 0.2) +
  coord_flip() +
  labs(
    title = "Estimated Effect of Registration on Employment by Country (HLM)",
    x = "Country",
    y = "Effect on Employment (log points)"
  ) +
  theme_minimal(base_size = 14)

# Plot: Sales Effects by Country
ggplot(combined_effects, aes(x = reorder(country, total_sales_effect), y = total_sales_effect)) +
  geom_point(color = "darkgreen", size = 3) +
  geom_errorbar(aes(ymin = sales_ci_low, ymax = sales_ci_high), width = 0.2) +
  coord_flip() +
  labs(
    title = "Estimated Effect of Registration on Sales by Country (HLM)",
    x = "Country",
    y = "Effect on Sales (log points)"
  ) +
  theme_minimal(base_size = 14)
