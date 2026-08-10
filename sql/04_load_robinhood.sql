-- Load robinhood_monthly_raw.csv via a staging table, since the CSV's
-- "month" column ("2023-04") needs a day appended before it's a valid DATE.

CREATE TEMP TABLE robinhood_monthly_metrics_staging (
    month                           TEXT,
    funded_customers_millions       NUMERIC(6,2),
    total_platform_assets_billions  NUMERIC(8,2),
    net_deposits_billions           NUMERIC(6,2)
);

\copy robinhood_monthly_metrics_staging FROM 'data/raw/robinhood/robinhood_monthly_raw.csv' WITH (FORMAT csv, HEADER true)

INSERT INTO robinhood_monthly_metrics (month, funded_customers_millions, total_platform_assets_billions, net_deposits_billions)
SELECT (month || '-01')::date,
       funded_customers_millions,
       total_platform_assets_billions,
       net_deposits_billions
FROM robinhood_monthly_metrics_staging;

DROP TABLE robinhood_monthly_metrics_staging;