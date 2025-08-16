WITH all_ads_data AS (
    SELECT 
        fb.ad_date,
        'Facebook Ads' AS media_source,
        fc.campaign_name,
        fa.adset_name,
        fb.spend,
        fb.impressions,
        fb.reach,
        fb.clicks,
        fb.leads,
        fb.value
    FROM
        facebook_ads_basic_daily fb
    LEFT JOIN facebook_adset fa ON fb.adset_id = fa.adset_id
    LEFT JOIN facebook_campaign fc ON fb.campaign_id = fc.campaign_id

    UNION ALL

    SELECT 
        ad_date,
        'Google Ads' AS media_source,
        campaign_name,
        adset_name,
        spend,
        impressions,
        reach,
        clicks,
        leads,
        value
    FROM
        google_ads_basic_daily
)

SELECT 
    DATE_TRUNC('week', ad_date)::DATE AS week_start,
    campaign_name,
    SUM(COALESCE(value, 0)) AS weekly_value
FROM all_ads_data
GROUP BY week_start, campaign_name
HAVING SUM(COALESCE(value, 0)) > 0
ORDER BY weekly_value DESC
LIMIT 1;
