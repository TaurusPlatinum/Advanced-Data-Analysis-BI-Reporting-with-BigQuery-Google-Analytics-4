WITH extracted_campaigns AS (
    SELECT
        ad_date,
        COALESCE(reach, 0) AS reach,
        -- Витягуємо назву кампанії
        regexp_replace(url_parameters, '^.*utm_campaign=([^&]+).*$','\1') AS campaign
    FROM facebook_ads_basic_daily
    UNION ALL
    SELECT
        ad_date,
        COALESCE(reach, 0) AS reach,
        regexp_replace(url_parameters, '^.*utm_campaign=([^&]+).*$','\1') AS campaign
    FROM google_ads_basic_daily
),

monthly_campaigns AS (
    SELECT
        DATE_TRUNC('month', ad_date) AS ad_month,
        campaign,
        SUM(reach) AS monthly_reach
    FROM extracted_campaigns
    GROUP BY DATE_TRUNC('month', ad_date), campaign
),

reach_with_lag AS (
    SELECT
        campaign,
        ad_month,
        monthly_reach,
        LAG(monthly_reach) OVER (PARTITION BY campaign ORDER BY ad_month) AS previous_month_reach
    FROM monthly_campaigns
),

reach_growth AS (
    SELECT
        campaign,
        ad_month,
        monthly_reach,
        previous_month_reach,
        (monthly_reach - previous_month_reach) AS reach_increase
    FROM reach_with_lag
    WHERE previous_month_reach IS NOT NULL
)

SELECT
    campaign,
    ad_month,
    reach_increase
FROM reach_growth
ORDER BY reach_increase DESC
LIMIT 1;
