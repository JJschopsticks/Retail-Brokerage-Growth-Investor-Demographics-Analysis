# Robinhood Monthly Metrics — files to download

Source: https://investors.robinhood.com/financials/monthly-metrics

Automated fetching of this data isn't possible right now — the IR site times out on
every automated request (bot protection) and the SEC EDGAR mirror returns 403s without
a browser. Grab these by hand.

For each month from **June 2024 through the most recently published month**, download the
"Monthly Metrics" file (prefer the Excel version if offered; otherwise the PDF dashboard),
and save it here as:

```
YYYY-MM_robinhood_monthly_metrics.xlsx   (or .pdf)
```

Metrics we care about from each file: Funded Customers, Total Platform Assets, Net Deposits,
Gold Subscribers.

Once the files are in place, let's move to the next step together (parsing them into a
clean CSV in `data/processed/`).
