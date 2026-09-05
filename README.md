# Retail Investor Demographic Shift Analysis

Was the pandemic-era shift toward younger, mobile-first retail investors
(Robinhood-style) a durable structural change in the brokerage industry, or a
temporary spike that's now fading? This project combines a national investor
survey with two brokerages' operating metrics to answer that question — and
finds a more precise answer than a simple yes/no.

## Key Findings

- The share of new investors (started within the past 2 years) fell from an
  estimated **21.23% in 2021 to 8.53% in 2024** (population-weighted,
  statistically significant, p < 0.001).
- That decline is concentrated in a specific demographic segment — young,
  lower-income, less-formally-educated, and disproportionately non-White
  respondents — not spread evenly across the investing population.
- **But this isn't attrition.** Overall stock ownership in that same segment
  held flat (not declining) from 2021 to 2024 across all four FINRA survey
  waves (2015-2024) — people who started investing during the pandemic
  appear to have stayed invested; they just aged out of the "new investor"
  window used to measure entry rate.
- Meanwhile, Robinhood's funded customers and Schwab's active brokerage
  accounts both kept growing at a statistically significant, steady rate
  through mid-2026 — likely driven by investors switching platforms or
  consolidating accounts, not by first-time entrants.
- **Recommendation:** shift acquisition spend away from broad first-timer
  campaigns targeting an already-converted segment, toward switcher/win-back
  campaigns and testing under-tapped demographic segments.

Full analysis, methodology, and caveats: [`docs/findings.md`](docs/findings.md).
An interactive Power BI dashboard covering all of the above is in
[`dashboard/`](dashboard/).

## Data Sources

- **FINRA National Financial Capability Study (NFCS)** — Investor Survey waves 2015, 2018,
  2021, 2024. Repeated cross-sectional survey data (not a longitudinal panel).
  https://www.finrafoundation.org/nfcs-data-and-downloads
- **Robinhood Markets (HOOD)** — monthly operating metrics (Funded Customers, Total
  Platform Assets, Net Deposits), April 2023-present.
  https://investors.robinhood.com/financials/monthly-metrics
- **Charles Schwab (SCHW)** — monthly activity metrics (new brokerage accounts, total
  client assets, net new assets, active brokerage accounts), December 2023-present.
  https://pressroom.aboutschwab.com

## Tech Stack

- **PostgreSQL** — schema, data loading, and analysis views (label reconstruction,
  cross-wave tenure reconciliation, `LAG()`-based month-over-month growth)
- **Python** (`psycopg2`, `pandas`, `scipy`, `statsmodels`) — statistical significance
  testing (two-proportion z-tests, linear regression trend tests)
- **Power BI** — interactive dashboard

## Project Structure

- `data/raw/` — source files as provided (gitignored; see each subfolder's README/data
  dictionary)
- `sql/` — schema (`01`-`03`), data loading (`04`-`06`), and analysis views (`07`+), run
  in numeric order
- `python/` — statistical significance tests, run against the loaded database
- `docs/findings.md` — full write-up: findings, business implications, recommendation,
  confidence/caveats
- `dashboard/` — Power BI file (`.pbix`)

## Reproducing this analysis

1. Copy `.env.example` to `.env` and fill in your local PostgreSQL credentials
2. Create the schema and load data by running each file in `sql/` in numeric order
   (e.g. `psql -f sql/01_create_robinhood_monthly_metrics.sql`, etc.)
3. Create a virtual environment and install dependencies: `pip install -r requirements.txt`
4. Run the significance tests: `python python/test_new_investor_significance.py`, etc.
5. Open `dashboard/retail_investor_dashboard.pbix` in Power BI Desktop and point it at
   your local database to explore the visuals