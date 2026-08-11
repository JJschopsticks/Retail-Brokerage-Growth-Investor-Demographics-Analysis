-- Harmonizes tenure_raw onto 2021's 5-bucket scheme, per the reconciliation
-- plan in data/raw/finra/DATA_DICTIONARY.md. 2024 codes 3+4 collapse into a
-- single "2 to <5 years" bucket; 2024 codes 5/6 relabel to match 2021's
-- "5 to <10"/"10+" (which are coded 4/5 in 2021). 2015/2018 have no
-- tenure_raw data at all, so tenure_raw is NULL and this yields NULL too.

CREATE VIEW finra_tenure_harmonized AS
SELECT
    wave_year,
    nfcs_id,
    tenure_raw,
    CASE
        WHEN wave_year = 2021 THEN
            CASE tenure_raw
                WHEN 1 THEN 'Less than 1 year'
                WHEN 2 THEN '1 to <2 years'
                WHEN 3 THEN '2 to <5 years'
                WHEN 4 THEN '5 to <10 years'
                WHEN 5 THEN '10+ years'
                WHEN 98 THEN 'Don''t know'
                WHEN 99 THEN 'Prefer not to say'
            END
        WHEN wave_year = 2024 THEN
            CASE tenure_raw
                WHEN 1 THEN 'Less than 1 year'
                WHEN 2 THEN '1 to <2 years'
                WHEN 3 THEN '2 to <5 years'
                WHEN 4 THEN '2 to <5 years'
                WHEN 5 THEN '5 to <10 years'
                WHEN 6 THEN '10+ years'
                WHEN 98 THEN 'Don''t know'
                WHEN 99 THEN 'Prefer not to say'
            END
    END AS tenure_harmonized_label
FROM finra_investor_survey;