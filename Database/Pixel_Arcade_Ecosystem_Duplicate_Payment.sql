-- ====================================================================================================
-- TEST CASE 2:  Duplicate Payment Attempts
-- Issue: An user clicked many times and the app resent the request after a brief network interruption 
-- ====================================================================================================

SELECT p.user_id, p.item_id, p.item_name, p.purchase_date, COUNT(*) AS duplicated_count
FROM purchases p
WHERE p.status = 'COMPLETED'
GROUP BY user_id, item_id, item_name, purchase_date
HAVING COUNT(*) > 1;