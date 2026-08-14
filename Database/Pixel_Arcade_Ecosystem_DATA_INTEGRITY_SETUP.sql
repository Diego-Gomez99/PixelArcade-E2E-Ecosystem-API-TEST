
-- ============================
-- Proyect: Pixel Arcade Ecosystem
-- DATA INTEGRITY SETUP
-- ============================

-- Cleanning out Tables to keep the performance
DROP TABLE IF EXIST user_inventory;
DROP TABLE IF EXIST purchases;
DROP TABLE IF EXIST users;

-- WE CREATE OUR USERS TABLE
CREATE TABLE users(
	user_id INT PRIMARY KEY,
	username VARCHAR(50) NOT NULL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- CREATE OUR PURCHASES TABLE (PAYMENT GATEWAY)
CREATE TABLE purchases(
	purchase_id INT PRIMARY KEY,
	user_id INT REFERENCES users(user_id),
	item_id INT NOT NULL,
	item_name VARCHAR(100) NOT NULL,
	amount NUMERIC(10,2) NOT NULL,
	status VARCHAR(20) NOT NULL, -- 'COMPLETED' OR 'PENDING' OR 'FALIED'
	purchase_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- CREATE OUR USER INVENTORY TABLE
CREATE TABLE user_inventory(
	inventory_id SERIAL PRIMARY KEY,
	user_id INT REFERENCES users(user_id),
	item_id INT NOT NULL,
	granted_at TIMESTAMP DEAFULT CURRENT_TIMESTAMP
);

-- ===========================================================
-- WE INSERT TEST DATA WITH SIMULATION BUGS FOR TEST CASES (QA)
-- ===========================================================

INSERT INTO users(user_id, username) VALUES
(101, 'ShadowNinja'),
(102, 'PixelKing'),
(103, 'CyberValkyrie'),
(104, 'GamerGhost');

-- INSERT PURCHASES
INSERT INTO purchases (purchase_id, user_id,item_id,item_name,amount,status, purchase_date) VALUES
(5001, 101, 1, '500 Gems Pack', 4.99, 'COMPLETED', '2026-08-01 10:00:00'),
(5002, 102, 2, 'Battle Pass S1', 9.99, 'COMPLETED', '2026-08-01 10:15:00'), -- BUG: Purchased COMPLETED but NOT in the Inventory Table
(5003, 103, 1, '500 Gems Pack', 4.99, 'PENDING', '2026-08-01 11:00:00'), 
(5004, 104, 3, 'Vault Key Pack', 19.99, 'COMPLETED', '2026-08-01 12:00:00'), 
(5005, 104, 3, 'Vault Key Pack', 19.99, 'COMPLETED', '2026-08-01 12:00:00'); -- Duplicated item purchased by the same user

-- INSERT INVENTORY
INSERT INTO user_inventory (user_id, item_id, granted_at) VALUES
(101, 1, '2026-08-01 10:00:02'), -- User 101 received its 500 Gems (OK)
(104, 3, '2026-08-01 12:00:02'), -- User 104 received its Valut Key (OK)
(104, 3, '2026-08-01 12:00:03'); -- User 104 received its Valut Key AGAIN (BUG: DUPLICATED ITEM)