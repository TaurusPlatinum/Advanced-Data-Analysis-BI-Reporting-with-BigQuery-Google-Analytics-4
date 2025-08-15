WITH all_ads_data AS (
    SELECT 
        ad_date,
        regexp_replace(url_parameters, '^.*utm_campaign=([^&]+).*$', '\1') AS campaign,
        'Facebook' AS ad_source
    FROM facebook_ads_basic_daily
    WHERE url_parameters ILIKE '%utm_campaign=%'

    UNION ALL

    SELECT 
        ad_date,
        regexp_replace(url_parameters, '^.*utm_campaign=([^&]+).*$', '\1') AS campaign,
        'Google' AS ad_source
    FROM google_ads_basic_daily
    WHERE url_parameters ILIKE '%utm_campaign=%'
),

ad_set_days AS (
    SELECT 
        campaign,
        ad_date
    FROM all_ads_data
    GROUP BY campaign, ad_date
),

ranked_ad_set_days AS (
    SELECT 
        campaign,
        ad_date,
        ROW_NUMBER() OVER (PARTITION BY campaign ORDER BY ad_date) AS rn
    FROM ad_set_days
),

grouped_data AS (
    SELECT 
        campaign,
        ad_date,
        ad_date - (rn || ' days')::interval AS grp
    FROM ranked_ad_set_days
),

all_streaks AS (
    SELECT 
        campaign,
        MIN(ad_date) AS start_date,
        MAX(ad_date) AS end_date,
        COUNT(*) AS duration_days
    FROM grouped_data
    GROUP BY campaign, grp
)

SELECT *
FROM all_streaks
ORDER BY duration_days DESC
LIMIT 1;
