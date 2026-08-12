-- Same logic as finra_new_investor_share (sql/12), but segmented by
-- s_income, to check whether the 2021->2024 decline in new-investor share
-- is uniform across income brackets or concentrated in one of them.

CREATE VIEW finra_new_investor_share_by_income AS
SELECT
    wave_year,
    s_income,
    COUNT(*) FILTER (WHERE tenure_raw IN (1, 2))
        AS new_investor_count,
    COUNT(*) FILTER (WHERE tenure_raw IS NOT NULL AND tenure_raw NOT IN (98, 99))
        AS valid_response_count,
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
GROUP BY wave_year, s_income
ORDER BY wave_year, s_income;