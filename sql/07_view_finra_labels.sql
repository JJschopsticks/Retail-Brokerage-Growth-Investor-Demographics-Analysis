-- Human-readable labels for FINRA's coded demographic variables.
-- A VIEW, not a column: labels are computed fresh from the codes on every
-- query, so the raw table never stores redundant/derivable data.
-- See data/raw/finra/DATA_DICTIONARY.md for what each code means.

CREATE VIEW finra_investor_survey_labeled AS
SELECT
    wave_year,
    nfcs_id,
    s_age,
    CASE s_age
        WHEN 1 THEN '18-34'
        WHEN 2 THEN '35-54'
        WHEN 3 THEN '55+'
    END AS age_label,
    s_education,
    CASE s_education
        WHEN 1 THEN 'Some college or less'
        WHEN 2 THEN 'Bachelor''s degree or higher'
    END AS education_label,
    s_ethnicity,
    CASE s_ethnicity
        WHEN 1 THEN 'White, non-Hispanic'
        WHEN 2 THEN 'Non-White'
    END AS ethnicity_label,
    s_income,
    CASE s_income
        WHEN 1 THEN 'Under $50K'
        WHEN 2 THEN '$50K-$100K'
        WHEN 3 THEN '$100K+'
    END AS income_label,
    b3_trade_freq,
    b2_1_owns_stock,
    wgt1,
    tenure_raw
FROM finra_investor_survey;