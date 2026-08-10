-- Charles Schwab monthly operating metrics.
-- Grain: one row per calendar month.

CREATE TABLE schwab_monthly_metrics (
    month                                   DATE NOT NULL PRIMARY KEY,
    source_file                             TEXT NOT NULL,
    new_brokerage_accounts_thousands        INTEGER NOT NULL,
    total_client_assets_billions            NUMERIC(8,1) NOT NULL,
    net_new_assets_billions                 NUMERIC(6,1) NOT NULL,
    core_net_new_assets_billions            NUMERIC(6,1) NOT NULL,
    active_brokerage_accounts_thousands     INTEGER NOT NULL
);