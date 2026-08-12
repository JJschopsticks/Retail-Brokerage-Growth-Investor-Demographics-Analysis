"""
Is the 2021 -> 2024 drop in new-investor share statistically significant
within each demographic segment individually, not just in aggregate?

Pulls counts from finra_new_investor_share_by_demographic
(see sql/13_view_finra_new_investor_share_by_demographic.sql) and runs a
two-proportion z-test per segment, across all four dimensions
(age, income, education, ethnicity).
"""

import os
from itertools import groupby

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
        SELECT dimension, segment_code, segment_label, wave_year, new_investor_count, valid_response_count
        FROM finra_new_investor_share_by_demographic
        ORDER BY dimension, segment_code, wave_year;
    """)
    rows = cur.fetchall()

conn.close()

current_dimension = None
for (dimension, _segment_code, segment_label), segment_rows in groupby(rows, key=lambda r: (r[0], r[1], r[2])):
    (_, _, _, year_2021, count_2021, n_2021), (_, _, _, year_2024, count_2024, n_2024) = list(segment_rows)

    if dimension != current_dimension:
        print(f"=== {dimension.title()} ===")
        current_dimension = dimension

    z_stat, p_value = proportions_ztest(
        count=[count_2021, count_2024],
        nobs=[n_2021, n_2024],
    )

    print(f"{segment_label}:")
    print(f"  {year_2021}: {count_2021}/{n_2021}   {year_2024}: {count_2024}/{n_2024}")
    print(f"  z-statistic: {z_stat:.3f}   p-value: {p_value:.10f}")
    if p_value < 0.05:
        print("  => Statistically significant drop.")
    else:
        print("  => Not statistically significant: cannot rule out sampling noise.")
    print()