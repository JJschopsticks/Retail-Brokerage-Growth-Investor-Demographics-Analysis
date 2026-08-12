"""
Is the 2021 -> 2024 drop in new-investor share statistically significant
within each age group individually, not just in aggregate?

Pulls counts from finra_new_investor_share_by_age
(see sql/13_view_finra_new_investor_share_by_age.sql) and runs a
two-proportion z-test per age group.
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

AGE_LABELS = {1: "18-34", 2: "35-54", 3: "55+"}

with conn, conn.cursor() as cur:
    cur.execute("""
        SELECT s_age, wave_year, new_investor_count, valid_response_count
        FROM finra_new_investor_share_by_age
        ORDER BY s_age, wave_year;
    """)
    rows = cur.fetchall()

conn.close()

for age_code, age_label in AGE_LABELS.items():
    age_rows = [r for r in rows if r[0] == age_code]
    (_, year_2021, count_2021, n_2021), (_, year_2024, count_2024, n_2024) = age_rows

    z_stat, p_value = proportions_ztest(
        count=[count_2021, count_2024],
        nobs=[n_2021, n_2024],
    )

    print(f"Age {age_label}:")
    print(f"  {year_2021}: {count_2021}/{n_2021}   {year_2024}: {count_2024}/{n_2024}")
    print(f"  z-statistic: {z_stat:.3f}   p-value: {p_value:.10f}")
    if p_value < 0.05:
        print("  => Statistically significant drop.")
    else:
        print("  => Not statistically significant: cannot rule out sampling noise.")
    print()