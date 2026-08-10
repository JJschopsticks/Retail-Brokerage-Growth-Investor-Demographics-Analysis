-- Load finra_nfcs_combined_2015_2024.csv via a staging table.
-- The staging table mirrors the CSV's exact column order (11 columns,
-- including age_label), since \copy matches by position, not by name.
-- The transform step drops age_label (redundant with s_age) and renames
-- columns to their descriptive names.

CREATE TEMP TABLE finra_investor_survey_staging (
    wave_year       INTEGER,
    nfcs_id         TEXT,
    s_age           SMALLINT,
    s_education     SMALLINT,
    s_ethnicity     SMALLINT,
    s_income        SMALLINT,
    b3_trade_freq   SMALLINT,
    b2_1_owns_stock SMALLINT,
    wgt1            NUMERIC(18,15),
    age_label       TEXT,
    tenure_raw      SMALLINT
);

\copy finra_investor_survey_staging FROM 'data/raw/finra/finra_nfcs_combined_2015_2024.csv' WITH (FORMAT csv, HEADER true)

INSERT INTO finra_investor_survey (wave_year, nfcs_id, s_age, s_education, s_ethnicity, s_income, b3_trade_freq, b2_1_owns_stock, wgt1, tenure_raw)
SELECT wave_year, nfcs_id, s_age, s_education, s_ethnicity, s_income, b3_trade_freq, b2_1_owns_stock, wgt1, tenure_raw
FROM finra_investor_survey_staging;

DROP TABLE finra_investor_survey_staging;