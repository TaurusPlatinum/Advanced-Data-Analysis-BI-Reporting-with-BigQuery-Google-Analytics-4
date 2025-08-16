WITH all_ads_data AS (
    SELECT 
        ad_date,
        COALESCE(spend, 0) AS spend,
        COALESCE(value, 0) AS value,
        'Facebook' AS ad_source
    FROM facebook_ads_basic_daily

    UNION ALL

    SELECT 
        ad_date,
        COALESCE(spend, 0) AS spend,
        COALESCE(value, 0) AS value,
        'Google' AS ad_source
    FROM google_ads_basic_daily
)

SELECT 
    ad_date,
    ROUND(
        CASE 
            WHEN SUM(spend) = 0 THEN 0
            ELSE (SUM(value) - SUM(spend)) / SUM(spend)::NUMERIC
        END, 
        2
    ) AS romi
FROM all_ads_data
GROUP BY ad_date
HAVING SUM(spend) > 0
ORDER BY romi DESC
LIMIT 5;
