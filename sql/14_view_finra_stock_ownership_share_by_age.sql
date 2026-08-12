-- Falsification test for the "retention, not attrition" theory: if the
-- 2020-2021 new-investor surge just aged out of tenure_raw's "started in
-- the past 2 years" window while staying invested, overall stock
-- ownership (a STOCK metric: are you currently invested) should stay
-- elevated through 2024, not revert toward 2015/2018 levels. tenure_raw
-- can't test this (only populated 2021/2024); b2_1_owns_stock can, since
-- it's populated in all four waves.

CREATE VIEW finra_stock_ownership_share_by_age AS

SELECT
    wave_year,
    'all' AS segment_code,
    'All ages' AS segment_label,
    COUNT(*) FILTER (WHERE b2_1_owns_stock = 1) AS owns_stock_count,
    COUNT(*) FILTER (WHERE b2_1_owns_stock IN (1, 2)) AS valid_response_count,
    ROUND(
        COUNT(*) FILTER (WHERE b2_1_owns_stock = 1)::NUMERIC
        / COUNT(*) FILTER (WHERE b2_1_owns_stock IN (1, 2)) * 100,
    2) AS owns_stock_pct,
    ROUND(
        SUM(wgt1) FILTER (WHERE b2_1_owns_stock = 1)
        / SUM(wgt1) FILTER (WHERE b2_1_owns_stock IN (1, 2)) * 100,
    2) AS owns_stock_pct_weighted
FROM finra_investor_survey
GROUP BY wave_year

UNION ALL

SELECT
    wave_year,
    s_age::TEXT AS segment_code,
    CASE s_age
        WHEN 1 THEN '18-34'
        WHEN 2 THEN '35-54'
        WHEN 3 THEN '55+'
    END AS segment_label,
    COUNT(*) FILTER (WHERE b2_1_owns_stock = 1),
    COUNT(*) FILTER (WHERE b2_1_owns_stock IN (1, 2)),
    ROUND(
        COUNT(*) FILTER (WHERE b2_1_owns_stock = 1)::NUMERIC
        / COUNT(*) FILTER (WHERE b2_1_owns_stock IN (1, 2)) * 100,
    2),
    ROUND(
        SUM(wgt1) FILTER (WHERE b2_1_owns_stock = 1)
        / SUM(wgt1) FILTER (WHERE b2_1_owns_stock IN (1, 2)) * 100,
    2)
FROM finra_investor_survey
GROUP BY wave_year, s_age

ORDER BY segment_code, wave_year;