-- Month-over-month growth for Schwab's two headline stock metrics
-- (total client assets, active brokerage accounts). Same LAG() pattern as
-- robinhood_monthly_growth: net_new_assets/core_net_new_assets/new_brokerage
-- accounts are already monthly flows, not running totals, so they're
-- carried through unchanged rather than differenced.

CREATE VIEW schwab_monthly_growth AS
SELECT
    month,
    total_client_assets_billions,
    prior_total_client_assets_billions,
    total_client_assets_billions - prior_total_client_assets_billions
        AS client_assets_mom_change,
    ROUND(
        (total_client_assets_billions - prior_total_client_assets_billions)
        / prior_total_client_assets_billions * 100,
    2) AS client_assets_mom_pct_change,
    active_brokerage_accounts_thousands,
    prior_active_brokerage_accounts_thousands,
    active_brokerage_accounts_thousands - prior_active_brokerage_accounts_thousands
        AS active_accounts_mom_change,
    ROUND(
        (active_brokerage_accounts_thousands - prior_active_brokerage_accounts_thousands)::NUMERIC
        / prior_active_brokerage_accounts_thousands * 100,
    2) AS active_accounts_mom_pct_change,
    net_new_assets_billions,
    core_net_new_assets_billions,
    new_brokerage_accounts_thousands
FROM (
    SELECT
        month,
        total_client_assets_billions,
        LAG(total_client_assets_billions) OVER (ORDER BY month)
            AS prior_total_client_assets_billions,
        active_brokerage_accounts_thousands,
        LAG(active_brokerage_accounts_thousands) OVER (ORDER BY month)
            AS prior_active_brokerage_accounts_thousands,
        net_new_assets_billions,
        core_net_new_assets_billions,
        new_brokerage_accounts_thousands
    FROM schwab_monthly_metrics
) monthly_with_lag;