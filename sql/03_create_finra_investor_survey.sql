-- FINRA NFCS Investor Survey, combined across waves.
-- Grain: one row per respondent, per survey wave.
-- Coded columns keep FINRA's raw values (including 98/99 = don't know/refused);
-- human-readable labels and cross-wave reconciliation (e.g. tenure_raw bucket
-- schemes differ between 2021 and 2024) are handled in views, not here.
-- See data/raw/finra/DATA_DICTIONARY.md for what every code means.

CREATE TABLE finra_investor_survey (
    wave_year       INTEGER NOT NULL CHECK (wave_year IN (2015, 2018, 2021, 2024)),
    nfcs_id         TEXT NOT NULL,
    s_age           SMALLINT NOT NULL CHECK (s_age IN (1, 2, 3)),
    s_education     SMALLINT NOT NULL CHECK (s_education IN (1, 2)),
    s_ethnicity     SMALLINT NOT NULL CHECK (s_ethnicity IN (1, 2)),
    s_income        SMALLINT NOT NULL CHECK (s_income IN (1, 2, 3)),
    b3_trade_freq   SMALLINT NOT NULL CHECK (b3_trade_freq IN (1, 2, 3, 4, 98, 99)),
    b2_1_owns_stock SMALLINT NOT NULL CHECK (b2_1_owns_stock IN (1, 2, 98, 99)),
    wgt1            NUMERIC(18,15) NOT NULL,
    tenure_raw      SMALLINT,
    PRIMARY KEY (wave_year, nfcs_id)
);