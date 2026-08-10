-- Robinhood monthly operating metrics.
-- Grain: one row per calendar month.

CREATE TABLE robinhood_monthly_metrics (
    month                           DATE NOT NULL PRIMARY KEY,
    funded_customers_millions       NUMERIC(6,2) NOT NULL,
    total_platform_assets_billions  NUMERIC(8,2) NOT NULL,
    net_deposits_billions           NUMERIC(6,2) NOT NULL
);