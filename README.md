# Retail Investor Demographic Shift Analysis

Was the shift toward younger, mobile-first retail investors (Robinhood-style) a durable
structural change in the brokerage industry, or a temporary pandemic-era spike that's now
fading? What does this mean for how traditional brokerages should compete for younger
investors today?

## Data Sources

- **FINRA National Financial Capability Study (NFCS)** — Investor Survey waves 2015, 2018,
  2021, 2024. Repeated cross-sectional survey data (not a longitudinal panel).
  https://www.finrafoundation.org/nfcs-data-and-downloads
- **Robinhood Markets (HOOD)** — monthly metrics (Funded Customers, Total Platform Assets,
  Net Deposits, Gold Subscribers), mid-2024–present.
  https://investors.robinhood.com/financials/monthly-metrics
- **Charles Schwab (SCHW)** — quarterly earnings + monthly activity highlights (new brokerage
  accounts, total client accounts, core net new assets), same window.
  https://pressroom.aboutschwab.com

## Project Structure

- `data/raw/` — source files as downloaded (gitignored; see each subfolder)
- `data/processed/` — cleaned/joined data ready for SQL loading (gitignored)
- `sql/` — PostgreSQL schema and analysis queries
- `python/` — collection scripts and statistical analysis
- `docs/` — written report
