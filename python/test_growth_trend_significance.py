"""
Are Robinhood's funded customers and Schwab's active brokerage accounts on
a real upward trend, or could the month-to-month changes be noise around a
flat line?

Fits a linear regression of each metric against a simple month index
(0, 1, 2, ...). The slope is the average monthly change; the p-value tests
whether that slope is distinguishable from zero (no trend at all).
"""

import os

import psycopg2
from dotenv import load_dotenv
from scipy.stats import linregress

load_dotenv()

conn = psycopg2.connect(
    host=os.environ["PGHOST"],
    port=os.environ["PGPORT"],
    user=os.environ["PGUSER"],
    password=os.environ["PGPASSWORD"],
    dbname=os.environ["PGDATABASE"],
)


def test_trend(cur, table, column, label):
    cur.execute(f"SELECT {column} FROM {table} ORDER BY month;")
    values = [row[0] for row in cur.fetchall()]
    month_index = list(range(len(values)))

    result = linregress(month_index, [float(v) for v in values])

    print(f"{label}:")
    print(f"  slope: {result.slope:+.4f} per month")
    print(f"  p-value: {result.pvalue:.10f}")
    if result.pvalue < 0.05:
        direction = "upward" if result.slope > 0 else "downward"
        print(f"  => Statistically significant {direction} trend.")
    else:
        print("  => Not statistically significant: cannot rule out no trend at all.")
    print()


with conn, conn.cursor() as cur:
    test_trend(cur, "robinhood_monthly_metrics", "funded_customers_millions", "Robinhood funded customers (millions)")
    test_trend(cur, "schwab_monthly_metrics", "active_brokerage_accounts_thousands", "Schwab active brokerage accounts (thousands)")

conn.close()