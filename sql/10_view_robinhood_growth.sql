-- Month-over-month growth for Robinhood's two headline stock metrics
-- (funded customers, platform assets). net_deposits is already a monthly
-- flow, not a running total, so a "change" on it wouldn't mean anything.
--
-- LAG(x) OVER (ORDER BY month) reads x's value from the previous row in
-- month order. Computed once in the inner subquery, then reused in the
-- outer SELECT for both the absolute and percent change.

CREATE VIEW robinhood_monthly_growth AS
SELECT
    month,
    funded_customers_millions,
    prior_funded_customers_millions,
    funded_customers_millions - prior_funded_customers_millions
        AS funded_customers_mom_change,
    ROUND(
        (funded_customers_millions - prior_funded_customers_millions)
        / prior_funded_customers_millions * 100,
    2) AS funded_customers_mom_pct_change,
    total_platform_assets_billions,
    prior_total_platform_assets_billions,
    total_platform_assets_billions - prior_total_platform_assets_billions
        AS platform_assets_mom_change,
    ROUND(
        (total_platform_assets_billions - prior_total_platform_assets_billions)
        / prior_total_platform_assets_billions * 100,
    2) AS platform_assets_mom_pct_change,
    net_deposits_billions
FROM (
    SELECT
        month,
        funded_customers_millions,
        LAG(funded_customers_millions) OVER (ORDER BY month)
            AS prior_funded_customers_millions,
        total_platform_assets_billions,
        LAG(total_platform_assets_billions) OVER (ORDER BY month)
            AS prior_total_platform_assets_billions,
        net_deposits_billions
    FROM robinhood_monthly_metrics
) monthly_with_lag;