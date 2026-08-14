
-- ===================================================================================
-- TEST CASE 3:  Orphan Inventory Detection
-- Issue: Items exist in user_inventory wothout a valid matching record in purchases
-- (Potential exploit or invalid grant)
-- ===================================================================================

SELECT i.inventory_id, i.user_id, i.item_id, i.granted_at
FROM user_inventory i
LEFT JOIN purchases p ON i.user_id = p.user_id AND i.item_id = p.item_id
WHERE p.user_id IS NULL;