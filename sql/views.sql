-- Summarizes sessions, purchases, and conversions by device type.
-- Cihaz türüne göre oturum, satın alma ve dönüşüm oranlarını özetler.
CREATE VIEW vw_TrafficByDevice AS
SELECT
    device,
    COUNT(DISTINCT user_id) AS total_users,
    COUNT(*) AS total_events,
    SUM(CASE WHEN type = 'purchase' THEN 1 ELSE 0 END) AS total_purchases,
    ROUND(
        100.0 * SUM(CASE WHEN type = 'purchase' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS conversion_rate
FROM clean_events
GROUP BY device;
GO


-- Shows geographic performance: users, purchases, and conversion by country.
-- Ülkelere göre kullanıcı sayısı, satın alma sayısı ve dönüşüm oranlarını gösterir.
CREATE VIEW vw_TrafficByCountry AS
SELECT
    country,
    COUNT(DISTINCT user_id) AS total_users,
    COUNT(*) AS total_events,
    SUM(CASE WHEN type = 'purchase' THEN 1 ELSE 0 END) AS total_purchases,
    ROUND(
        100.0 * SUM(CASE WHEN type = 'purchase' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS conversion_rate
FROM clean_events
GROUP BY country;
GO


-- Analyzes conversion funnel: view, add_to_cart, purchase.
-- Dönüşüm hunisini analiz eder: görüntüleme, sepete ekleme, satın alma.
CREATE VIEW vw_FunnelAnalysis AS
SELECT
    COUNT(DISTINCT CASE WHEN type = 'view' THEN user_id END) AS viewed_users,
    COUNT(DISTINCT CASE WHEN type = 'add_to_cart' THEN user_id END) AS cart_users,
    COUNT(DISTINCT CASE WHEN type = 'purchase' THEN user_id END) AS purchased_users,
    ROUND(
        100.0 * COUNT(DISTINCT CASE WHEN type = 'add_to_cart' THEN user_id END)
        / NULLIF(COUNT(DISTINCT CASE WHEN type = 'view' THEN user_id END), 0),
        2
    ) AS view_to_cart_rate,
    ROUND(
        100.0 * COUNT(DISTINCT CASE WHEN type = 'purchase' THEN user_id END)
        / NULLIF(COUNT(DISTINCT CASE WHEN type = 'add_to_cart' THEN user_id END), 0),
        2
    ) AS cart_to_purchase_rate
FROM clean_events;
GO


-- Displays daily trends for users, events, and purchases.
-- Günlük kullanıcı, etkinlik ve satın alma eğilimlerini gösterir.
CREATE VIEW vw_TrafficByDate AS
SELECT
    date,
    COUNT(DISTINCT user_id) AS daily_users,
    COUNT(*) AS daily_events,
    SUM(CASE WHEN type = 'purchase' THEN 1 ELSE 0 END) AS daily_purchases
FROM clean_events
GROUP BY date;
GO


-- Measures engagement by event count per user.
-- Kullanıcı başına ortalama etkinlik sayısını ölçerek etkileşimi değerlendirir.
CREATE VIEW vw_UserEngagement AS
SELECT
    user_id,
    COUNT(*) AS total_events,
    COUNT(DISTINCT date) AS active_days,
    ROUND(COUNT(*) * 1.0 / COUNT(DISTINCT date), 2) AS avg_events_per_day
FROM clean_events
GROUP BY user_id;
GO


-- Evaluates product-level funnel performance and popularity.
-- Ürün bazında funnel performansını ve popülerliğini değerlendirir.
CREATE VIEW vw_ProductPerformance AS
SELECT
    item_id,
    COUNT(*) AS total_interactions,
    SUM(CASE WHEN type = 'add_to_cart' THEN 1 ELSE 0 END) AS times_added_to_cart,
    SUM(CASE WHEN type = 'purchase' THEN 1 ELSE 0 END) AS times_purchased,
    ROUND(
        100.0 * SUM(CASE WHEN type = 'purchase' THEN 1 ELSE 0 END)
        / NULLIF(SUM(CASE WHEN type = 'add_to_cart' THEN 1 ELSE 0 END), 0),
        2
    ) AS product_conversion_rate
FROM clean_events
GROUP BY item_id;
