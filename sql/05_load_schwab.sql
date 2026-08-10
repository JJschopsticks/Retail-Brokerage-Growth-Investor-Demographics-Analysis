-- Load schwab_monthly_raw.csv via a staging table, for the same reason as
-- Robinhood: the CSV's "month" column needs a day appended before it's a
-- valid DATE. Column order here matches the CSV exactly.

CREATE TEMP TABLE schwab_monthly_metrics_staging (
    source_file                             TEXT,
    month                                   TEXT,
    new_brokerage_accounts_thousands        INTEGER,
    total_client_assets_billions            NUMERIC(8,1),
    net_new_assets_billions                 NUMERIC(6,1),
    core_net_new_assets_billions            NUMERIC(6,1),
    active_brokerage_accounts_thousands     INTEGER
);

\copy schwab_monthly_metrics_staging FROM 'data/raw/schwab/schwab_monthly_raw.csv' WITH (FORMAT csv, HEADER true)

INSERT INTO schwab_monthly_metrics (month, source_file, new_brokerage_accounts_thousands, total_client_assets_billions, net_new_assets_billions, core_net_new_assets_billions, active_brokerage_accounts_thousands)
SELECT (month || '-01')::date,
       source_file,
       new_brokerage_accounts_thousands,
       total_client_assets_billions,
       net_new_assets_billions,
       core_net_new_assets_billions,
       active_brokerage_accounts_thousands
FROM schwab_monthly_metrics_staging;

DROP TABLE schwab_monthly_metrics_staging;