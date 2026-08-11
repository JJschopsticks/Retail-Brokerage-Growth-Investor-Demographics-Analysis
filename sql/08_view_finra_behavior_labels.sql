-- Human-readable labels for FINRA's trading-behavior codes (B3, B2_1).
-- Unlike tenure_raw, these bucket schemes are identical across all waves,
-- so no cross-wave reconciliation is needed here.

CREATE VIEW finra_investor_survey_behavior_labeled AS
SELECT
    wave_year,
    nfcs_id,
    b3_trade_freq,
    CASE b3_trade_freq
        WHEN 1 THEN 'None'
        WHEN 2 THEN '1-3 times'
        WHEN 3 THEN '4-10 times'
        WHEN 4 THEN '11+ times'
        WHEN 98 THEN 'Don''t know'
        WHEN 99 THEN 'Prefer not to say'
    END AS trade_freq_label,
    b2_1_owns_stock,
    CASE b2_1_owns_stock
        WHEN 1 THEN 'Yes'
        WHEN 2 THEN 'No'
        WHEN 98 THEN 'Don''t know'
        WHEN 99 THEN 'Prefer not to say'
    END AS owns_stock_label
FROM finra_investor_survey;