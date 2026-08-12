# Findings: Retail Investor Demographic Shift Analysis

**Audience:** Growth and acquisition marketing leadership at a retail
brokerage platform (e.g., Robinhood, Schwab, or a comparable competitor).

**Throughline:** The original question behind this project was where retail
brokerage growth is coming from, and whether the pandemic-era surge of
new, younger investors was a durable shift or a temporary spike. The
answer turned out to be more precise than a simple "temporary" or
"durable" verdict: the investors who joined during the pandemic largely
**stayed** invested (durable), but the *rate of finding new people to
convert* in that same segment has dropped off — most likely because the
pool of previously-uninvested people in that segment was substantially
drained by the surge itself, not because people gave up on investing.
Both recommendations below are built around that more precise finding.

## Finding 1: The pandemic-era surge converted a specific demographic segment — durably. What's declined since is the rate of finding *new* people left to convert in that same segment.

The share of FINRA NFCS survey respondents who started investing within
the past 2 years fell from an estimated **21.23% in 2021 to 8.53% in
2024** (population-weighted using FINRA's `wgt1` survey weight; z = 9.73,
p < 0.001 on the underlying respondent counts — not sampling noise).
Breaking that decline out by demographic segment shows it was never a
broad-based shift: the groups with the highest 2021 new-investor share
also had by far the largest absolute drop by 2024, in all four dimensions
tested.

| Dimension | Segment | 2021 (weighted) | 2024 (weighted) | Absolute drop |
|---|---|---|---|---|
| Age | 18-34 | 49.43% | 22.51% | -26.92 pts |
| Age | 35-54 | 20.58% | 8.48% | -12.10 pts |
| Age | 55+ | 3.86% | 1.93% | -1.93 pts |
| Income | Under $50K | 40.01% | 15.55% | -24.46 pts |
| Income | $50K-$100K | 15.28% | 8.51% | -6.77 pts |
| Income | $100K+ | 13.51% | 5.04% | -8.47 pts |
| Education | Some college or less | 27.53% | 12.46% | -15.07 pts |
| Education | Bachelor's+ | 14.05% | 5.02% | -9.03 pts |
| Ethnicity | Non-White | 36.17% | 14.21% | -21.96 pts |
| Ethnicity | White, non-Hispanic | 16.52% | 6.33% | -10.19 pts |

Every one of these 10 segment-level drops is individually statistically
significant (per-segment two-proportion z-tests, all p < 0.05, most
p < 0.001), and the consistency across four independent demographic cuts
indicates one underlying story rather than four coincidences.

**Taken at face value, this looks like a reversal — but it isn't one.**
`tenure_raw` ("started investing in the past 2 years") is a *flow*
metric: it measures the rate of new entries, not how many people are
currently invested. A short, sharp surge of new entrants will always
produce exactly this shape — high, then low — even if every single person
who entered during the surge is still investing today; they simply age
out of the "past 2 years" window. To tell these two scenarios apart, we
tested `b2_1_owns_stock` ("do you currently own individual stocks"), a
*stock* metric of current participation that — unlike `tenure_raw` — is
populated in all four waves (2015, 2018, 2021, 2024), not just 2021/2024.

For 18-34 year olds specifically, stock ownership went **76.69% (2015) →
78.36% (2018) → 83.79% (2021) → 84.79% (2024)** — a jump during the
pandemic that has *held, not reverted*. A 2021-vs-2024 significance test
confirms this across every age group: no statistically significant change
in any segment (p = 0.55-0.87, all far above the 0.05 threshold), and
where there's any movement at all, it's a slight increase, never a
decrease.

**This does not prove individual-level retention** — FINRA's data is
repeated cross-sectional, so we cannot literally track the same people
from 2021 to 2024 — but it is strong population-level evidence against an
attrition story. If the pandemic-era cohort had broadly abandoned
investing, overall participation should have fallen back toward the
2015/2018 baseline by 2024. It didn't, in any age group.

**Business implication:** 2021-era acquisition spend converted a specific
demographic segment, and those conversions look durable, not wasted. What
has changed since is that the segment's pool of previously-uninvested,
easily-convertible people has been substantially drawn down by that same
surge — so campaigns still built on the 2020-2021 "start investing"
playbook, aimed at the same profile, are increasingly targeting a pool
that's already been converted rather than one that's giving up.

## Finding 2: Overall brokerage account growth is still climbing steadily — likely driven by switchers, not first-timers

Despite the drop in new-investor starts, both Robinhood's funded customers
and Schwab's active brokerage accounts grew at a statistically significant,
steady rate from mid-2023 through mid-2026 (linear regression: Robinhood
+0.14M funded customers/month, Schwab +162K active accounts/month; p < 0.001
for both).

**Business implication:** Read together with Finding 1, this is the more
important half of the story: account growth hasn't stalled even as the
first-time-investor pipeline has shrunk. The most direct explanation
consistent with both datasets is that current growth is increasingly
coming from investors who already have accounts elsewhere and are
switching or consolidating, not from people investing for the first time.

## Recommendation

Reallocate acquisition budget away from broad, demographically
untargeted "start investing" campaigns built on the 2021 playbook. That
playbook specifically over-indexed on young, lower-income, less-formally-
educated, and non-White first-time investors, and — per Finding 1 —
those conversions were durable, not wasted. That's exactly why continuing
to chase the same profile with the same first-timer message is now a
weaker return: the segment's pool of not-yet-invested, easily-convertible
people has already been substantially drawn down by that same successful
campaign.

Two concrete moves follow directly from the two findings:

1. **Shift spend toward switcher/win-back campaigns** (e.g., matching
   competitors' ACAT transfer bonuses, streamlining the transfer process)
   targeting people who already invest on another platform. Finding 2
   shows total accounts are still growing even as new-investor supply
   shrinks — switchers, not first-timers, are where the active growth is
   happening right now, so acquisition spend should follow that channel
   rather than the shrinking one.
2. **Test acquisition campaigns aimed at segments that never had a 2021
   surge to draw down their pool of convertible non-investors** — 55+,
   $100K+ income, Bachelor's+. Their 2021 share and subsequent drop were
   both far smaller, meaning their pool of not-yet-invested people is
   less depleted than the segment the original campaign already
   converted — so they may still have room to convert efficiently.

This is defensible directly from the data collected here — it doesn't
require inferring product usage, churn, or deal economics we didn't
measure, and it's a direct answer to the project's original question
about where growth is (and isn't) coming from.

## Confidence / caveats

- FINRA NFCS is repeated cross-sectional survey data, not a longitudinal
  panel — every comparison above is cohort-level (different people
  surveyed each wave), not evidence about what any specific individual did.
- `tenure_raw` (investing tenure) has zero coverage in the 2015/2018 waves,
  so this trend can only be measured from 2021 to 2024 — we cannot confirm
  whether 2021's 21.23% was itself already elevated relative to a longer
  pre-pandemic baseline.
- The retention evidence (stable `b2_1_owns_stock` share 2021→2024) is a
  population-level, not individual-level, observation — cross-sectional
  data can't confirm that the *specific people* who joined in 2021 are the
  same ones still invested in 2024. It's possible some of that cohort left
  and were offset by other new entrants, netting out to a flat overall
  rate. The population-level trend still argues against a broad attrition
  story, but it isn't direct proof at the individual level.
- The weighted estimates depend on the accuracy of FINRA's published
  survey weights; we did not independently verify FINRA's weighting
  methodology.
- Robinhood/Schwab data is company-level operating metrics, not
  demographic survey data — it cannot directly confirm *who* is opening
  new accounts. The "switchers are driving growth" conclusion is a
  reasonable inference from combining the two datasets' timing, not a
  directly observed fact.
- The data window for Robinhood/Schwab (April 2023 / December 2023 onward)
  doesn't reach back to the 2020-2021 surge itself, so today's growth rate
  can't be directly compared to the pandemic-era peak using this dataset
  alone.
