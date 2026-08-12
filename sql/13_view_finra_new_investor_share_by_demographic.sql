-- Combines the four demographic breakdowns of new-investor share (formerly
-- sql/13-16, one view each for age/income/education/ethnicity) into a
-- single long/tidy view: one row per (dimension, segment, wave_year).
-- Less repetitive than four near-identical views, and a better shape for a
-- Power BI dashboard, which can filter on one "dimension" column instead
-- of switching between four separate data sources.

CREATE VIEW finra_new_investor_share_by_demographic AS

SELECT
    wave_year,
    'age' AS dimension,
    s_age::TEXT AS segment_code,
    CASE s_age
        WHEN 1 THEN '18-34'
        WHEN 2 THEN '35-54'
        WHEN 3 THEN '55+'
    END AS segment_label,
    COUNT(*) FILTER (WHERE tenure_raw IN (1, 2)) AS new_investor_count,
    COUNT(*) FILTER (WHERE tenure_raw IS NOT NULL AND tenure_raw NOT IN (98, 99)) AS valid_response_count,
    ROUND(
        COUNT(*) FILTER (WHERE tenure_raw IN (1, 2))::NUMERIC
        / COUNT(*) FILTER (WHERE tenure_raw IS NOT NULL AND tenure_raw NOT IN (98, 99)) * 100,
    2) AS new_investor_pct,
    ROUND(
        SUM(wgt1) FILTER (WHERE tenure_raw IN (1, 2))
        / SUM(wgt1) FILTER (WHERE tenure_raw IS NOT NULL AND tenure_raw NOT IN (98, 99)) * 100,
    2) AS new_investor_pct_weighted
FROM finra_investor_survey
WHERE wave_year IN (2021, 2024)
GROUP BY wave_year, s_age

UNION ALL

SELECT
    wave_year,
    'income' AS dimension,
    s_income::TEXT AS segment_code,
    CASE s_income
        WHEN 1 THEN 'Under $50K'
        WHEN 2 THEN '$50K-$100K'
        WHEN 3 THEN '$100K+'
    END AS segment_label,
    COUNT(*) FILTER (WHERE tenure_raw IN (1, 2)),
    COUNT(*) FILTER (WHERE tenure_raw IS NOT NULL AND tenure_raw NOT IN (98, 99)),
    ROUND(
        COUNT(*) FILTER (WHERE tenure_raw IN (1, 2))::NUMERIC
        / COUNT(*) FILTER (WHERE tenure_raw IS NOT NULL AND tenure_raw NOT IN (98, 99)) * 100,
    2),
    ROUND(
        SUM(wgt1) FILTER (WHERE tenure_raw IN (1, 2))
        / SUM(wgt1) FILTER (WHERE tenure_raw IS NOT NULL AND tenure_raw NOT IN (98, 99)) * 100,
    2)
FROM finra_investor_survey
WHERE wave_year IN (2021, 2024)
GROUP BY wave_year, s_income

UNION ALL

SELECT
    wave_year,
    'education' AS dimension,
    s_education::TEXT AS segment_code,
    CASE s_education
        WHEN 1 THEN 'Some college or less'
        WHEN 2 THEN 'Bachelor''s degree or higher'
    END AS segment_label,
    COUNT(*) FILTER (WHERE tenure_raw IN (1, 2)),
    COUNT(*) FILTER (WHERE tenure_raw IS NOT NULL AND tenure_raw NOT IN (98, 99)),
    ROUND(
        COUNT(*) FILTER (WHERE tenure_raw IN (1, 2))::NUMERIC
        / COUNT(*) FILTER (WHERE tenure_raw IS NOT NULL AND tenure_raw NOT IN (98, 99)) * 100,
    2),
    ROUND(
        SUM(wgt1) FILTER (WHERE tenure_raw IN (1, 2))
        / SUM(wgt1) FILTER (WHERE tenure_raw IS NOT NULL AND tenure_raw NOT IN (98, 99)) * 100,
    2)
FROM finra_investor_survey
WHERE wave_year IN (2021, 2024)
GROUP BY wave_year, s_education

UNION ALL

SELECT
    wave_year,
    'ethnicity' AS dimension,
    s_ethnicity::TEXT AS segment_code,
    CASE s_ethnicity
        WHEN 1 THEN 'White, non-Hispanic'
        WHEN 2 THEN 'Non-White'
    END AS segment_label,
    COUNT(*) FILTER (WHERE tenure_raw IN (1, 2)),
    COUNT(*) FILTER (WHERE tenure_raw IS NOT NULL AND tenure_raw NOT IN (98, 99)),
    ROUND(
        COUNT(*) FILTER (WHERE tenure_raw IN (1, 2))::NUMERIC
        / COUNT(*) FILTER (WHERE tenure_raw IS NOT NULL AND tenure_raw NOT IN (98, 99)) * 100,
    2),
    ROUND(
        SUM(wgt1) FILTER (WHERE tenure_raw IN (1, 2))
        / SUM(wgt1) FILTER (WHERE tenure_raw IS NOT NULL AND tenure_raw NOT IN (98, 99)) * 100,
    2)
FROM finra_investor_survey
WHERE wave_year IN (2021, 2024)
GROUP BY wave_year, s_ethnicity

ORDER BY dimension, segment_code, wave_year;