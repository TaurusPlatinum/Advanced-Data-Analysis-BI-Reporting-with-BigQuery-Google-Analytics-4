WITH all_ads_data AS (
    SELECT 
        ad_date,
        spend,
        'Facebook' AS ad_source
    FROM facebook_ads_basic_daily

    UNION ALL

    SELECT 
        ad_date,
        spend,
        'Google' AS ad_source
    FROM google_ads_basic_daily
)

SELECT 
    ad_date,
    ad_source,
    ROUND(AVG(spend)::NUMERIC, 2) AS avg_spend,
    MAX(spend) AS max_spend,
    MIN(spend) AS min_spend
FROM all_ads_data
GROUP BY ad_date, ad_source
ORDER BY ad_date, ad_source;
