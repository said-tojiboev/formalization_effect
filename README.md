Dataset Background and Variable Construction
This replication study uses firm-level data from five Central Asian countries—Uzbekistan, Kazakhstan, Kyrgyzstan, Tajikistan, and Turkmenistan—collected through the Enterprise Surveys. These surveys are structured to capture key indicators of firm performance, demographics, and regulatory compliance.

Data Cleaning and Construction
The raw data files were imported from .dta format and harmonized across countries. The following variables were constructed to replicate the analysis framework of Assenova & Sorenson (2017):

registered: Indicator for whether the firm was officially registered at founding (1 = registered at the time of founding, 0 = not).
ln_sales: Natural log of total annual sales, adjusted to avoid log(0).
ln_emp: Natural log of total full-time employment.
firm_age: Age of the firm in years, calculated as 2024 minus the reported founding year.
init_size: Log of number of employees at founding.
manager_experience: Years of experience of the top manager.
female_owner: Binary variable indicating whether the firm has a female top owner.
size: Factor variable representing firm size category as per survey coding.
country: Country identifier added during data loading.

Firms with missing or invalid values for these core variables, as well as firms with negative manager experience or unreasonable firm ages (>100 years), were excluded.

🧾 Summary Statistics
The first analytic step provides descriptive statistics for the cleaned sample. This step helps validate the distributions of key variables and informs later model interpretation.
