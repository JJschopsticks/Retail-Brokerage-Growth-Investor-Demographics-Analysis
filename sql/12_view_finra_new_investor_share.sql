-- Headline stat: share of investors who started investing in the past
-- 2 years (tenure_raw codes 1+2), by wave. This cutoff is identical in
-- both the 2021 and 2024 bucket schemes, so no reconciliation is needed
-- (unlike finra_tenure_harmonized, which handles the buckets beyond it).
-- Only 2021/2024 have tenure_raw data at all (see DATA_DICTIONARY.md).
--
-- FILTER (WHERE ...) on an aggregate counts only the matching rows,
-- without needing a CASE WHEN ... THEN 1 END wrapped inside COUNT().
--
-- wgt1 is FINRA's survey sampling weight: each respondent represents a
-- different number of real people, since the raw sample over/undersamples
-- some groups relative to the true population. COUNT(*) treats every
-- respondent as 1 vote (unweighted); SUM(wgt1) adds up how many people
-- each respondent actually represents (weighted, population-correct).
-- Both are kept here to compare.

CREATE OR REPLACE VIEW finra_new_investor_share AS
SELECT
    wave_year,
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
GROUP BY wave_year
ORDER BY wave_year;