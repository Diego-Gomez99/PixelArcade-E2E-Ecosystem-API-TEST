-- ==================================================================================================
-- TEST CASE 1:  Missing Fulfillment
-- Issue: A player purchased an item (Status = 'COMPLETED'), but the item never reach his inventory
-- ==================================================================================================

SELECT p.user_id, p.purchase_id, p.item_id
FROM purchases p
LEFT JOIN user_inventory i ON p.user_id = i.user_id AND p.item_id = i.item_id
WHERE p.status = 'COMPLETED' AND i.user_id IS NULL;

-- If we have a lot of affected users we can add a "COUNT(*)" in our select querie to show the impact metrics
SELECT COUNT (*) AS total_affected_purchases
FROM purchases p
LEFT JOIN user_inventory i ON p.user_id = i.user_id AND p.item_id = i.item_id
WHERE p.status = 'COMPLETED' AND i.user_id IS NULL;