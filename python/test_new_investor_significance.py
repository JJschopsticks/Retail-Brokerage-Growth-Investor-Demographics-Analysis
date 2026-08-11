"""
Is the 2021 -> 2024 drop in new-investor share a real trend, or could it be
random sampling noise?

Pulls counts from finra_new_investor_share (see sql/12_view_finra_new_investor_share.sql):
- new_investor_pct_weighted: the population-level estimate (uses FINRA's wgt1
  survey weight), reported as the finding's magnitude.
- new_investor_count / valid_response_count: the actual unweighted number of
  respondents surveyed, used here for the significance test, since a test's
  confidence must be based on how much real data was collected, not on the
  population size that data is scaled to represent.
"""

import os

import psycopg2
from dotenv import load_dotenv
from statsmodels.stats.proportion import proportions_ztest

load_dotenv()

conn = psycopg2.connect(
    host=os.environ["PGHOST"],
    port=os.environ["PGPORT"],
    user=os.environ["PGUSER"],
    password=os.environ["PGPASSWORD"],
    dbname=os.environ["PGDATABASE"],
)

with conn, conn.cursor() as cur:
    cur.execute("""
        SELECT wave_year, new_investor_count, valid_response_count, new_investor_pct_weighted
        FROM finra_new_investor_share
        ORDER BY wave_year;
    """)
    rows = cur.fetchall()

conn.close()

(year_2021, count_2021, n_2021, weighted_pct_2021), (year_2024, count_2024, n_2024, weighted_pct_2024) = rows

print(f"{year_2021}: {count_2021}/{n_2021} respondents ({weighted_pct_2021}% weighted)")
print(f"{year_2024}: {count_2024}/{n_2024} respondents ({weighted_pct_2024}% weighted)")

z_stat, p_value = proportions_ztest(
    count=[count_2021, count_2024],
    nobs=[n_2021, n_2024],
)

print(f"\nz-statistic: {z_stat:.3f}")
print(f"p-value: {p_value:.10f}")

if p_value < 0.05:
    print("=> Statistically significant at the 0.05 level: the drop is unlikely to be sampling noise.")
else:
    print("=> Not statistically significant at the 0.05 level: cannot rule out sampling noise.")