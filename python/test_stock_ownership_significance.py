"""
Falsification test for the "retention, not attrition" theory: did overall
stock ownership (b2_1_owns_stock) actually decline from 2021 to 2024, or
did it hold steady / keep rising? A decline would support "people left
investing." A flat or rising trend refutes that and supports "people
stayed invested, they just aged out of the tenure_raw 'new' window."

Pulls counts from finra_stock_ownership_share_by_age
(see sql/14_view_finra_stock_ownership_share_by_age.sql) and runs a
two-proportion z-test comparing 2021 to 2024 for each segment.
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
        SELECT segment_code, segment_label, wave_year, owns_stock_count, valid_response_count
        FROM finra_stock_ownership_share_by_age
        WHERE wave_year IN (2021, 2024)
        ORDER BY segment_code, wave_year;
    """)
    rows = cur.fetchall()

conn.close()

for i in range(0, len(rows), 2):
    (_, segment_label, year_2021, count_2021, n_2021), (_, _, year_2024, count_2024, n_2024) = rows[i], rows[i + 1]

    z_stat, p_value = proportions_ztest(
        count=[count_2021, count_2024],
        nobs=[n_2021, n_2024],
    )
    direction = "increase" if count_2024 / n_2024 > count_2021 / n_2021 else "decrease"

    print(f"{segment_label}:")
    print(f"  {year_2021}: {count_2021}/{n_2021} ({count_2021/n_2021*100:.2f}%)   {year_2024}: {count_2024}/{n_2024} ({count_2024/n_2024*100:.2f}%)")
    print(f"  z-statistic: {z_stat:.3f}   p-value: {p_value:.6f}   direction: {direction}")
    if p_value < 0.05:
        print(f"  => Statistically significant {direction}.")
    else:
        print("  => Not statistically significant: flat, no evidence of decline.")
    print()