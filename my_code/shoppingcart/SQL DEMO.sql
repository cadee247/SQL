-- ============================================
-- 1) DROP TABLES IF EXIST (reset demo)
-- ============================================
DROP TABLE IF EXISTS OrderDetails;
DROP TABLE IF EXISTS OrderHeader;
DROP TABLE IF EXISTS Cart;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS ProductsMenu;

-- ============================================
-- 2) CREATE TABLES
-- ============================================
CREATE TABLE ProductsMenu (
    Id INT PRIMARY KEY,               -- Unique product ID
    Name VARCHAR(50),                 -- Product name
    Price DECIMAL(10,2)               -- Product price
);

CREATE TABLE Users (
    User_ID INT PRIMARY KEY,          -- Unique user ID
    Username VARCHAR(50)              -- Name of the user
);

CREATE TABLE Cart (
    ProductId INT PRIMARY KEY,        -- Product ID in the cart
    Qty INT,                          -- Quantity of that product
    FOREIGN KEY (ProductId) REFERENCES ProductsMenu(Id)
);

CREATE TABLE OrderHeader (
    OrderID INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,  -- Unique auto-increment order ID
    User_ID INT,                   -- User who placed the order
    OrderDate TIMESTAMP,           -- Date and time of order
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID)
);

CREATE TABLE OrderDetails (
    OrderHeader INT,               -- References the order
    ProdID INT,                    -- References the product
    Qty INT,                        -- Quantity ordered
    FOREIGN KEY (OrderHeader) REFERENCES OrderHeader(OrderID),
    FOREIGN KEY (ProdID) REFERENCES ProductsMenu(Id)
);

-- ============================================
-- 3) INSERT INITIAL DATA
-- ============================================
INSERT INTO ProductsMenu VALUES
(1, 'Coke', 10.00),
(2, 'Chips', 5.00);

INSERT INTO Users VALUES
(1, 'Arnold'),
(2, 'Sheryl');

-- Check initial data
SELECT * FROM ProductsMenu;
SELECT * FROM Users;

-- ============================================
-- 4) ADD ITEMS TO CART
-- ============================================
-- Step 1: Add Coke for the first time
INSERT INTO Cart (ProductId, Qty) VALUES (1, 1);
SELECT * FROM Cart;

-- Step 2: Add Coke again (increase quantity)
UPDATE Cart SET Qty = Qty + 1 WHERE ProductId = 1;
SELECT * FROM Cart;

-- Step 3: Add Chips for the first time
INSERT INTO Cart (ProductId, Qty) VALUES (2, 1);
SELECT * FROM Cart;

-- ============================================
-- 5) REMOVE ITEMS FROM CART
-- ============================================
-- Step 1: Remove one Coke if more than 1 in cart
UPDATE Cart SET Qty = Qty - 1 WHERE ProductId = 1 AND Qty > 1;
SELECT * FROM Cart;

-- Step 2: Remove Chips completely (qty = 1)
DELETE FROM Cart WHERE ProductId = 2;
SELECT * FROM Cart;

-- ============================================
-- 6) CHECKOUT PROCESS
-- ============================================
-- Step 1: Make sure cart has items
SELECT * FROM Cart;

-- Step 2: Create a new order and capture OrderID
WITH new_order AS (
    INSERT INTO OrderHeader (User_ID, OrderDate)
    VALUES (1, NOW())
    RETURNING OrderID
)
-- Step 3: Move cart items to OrderDetails
INSERT INTO OrderDetails (OrderHeader, ProdID, Qty)
SELECT new_order.OrderID, Cart.ProductId, Cart.Qty
FROM Cart
JOIN new_order ON TRUE;

-- Step 4: Empty cart after checkout
DELETE FROM Cart;
SELECT * FROM Cart;

-- ============================================
-- 7) FUNCTIONS TO AUTOMATE ADD/REMOVE
-- ============================================
CREATE OR REPLACE FUNCTION AddItem(p_productId INT)
RETURNS TEXT AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM Cart WHERE ProductId = p_productId) THEN
        UPDATE Cart SET Qty = Qty + 1 WHERE ProductId = p_productId;
        RETURN 'Quantity updated';
    ELSE
        INSERT INTO Cart (ProductId, Qty) VALUES (p_productId, 1);
        RETURN 'Item added';
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION RemoveItem(p_productId INT)
RETURNS TEXT AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM Cart WHERE ProductId = p_productId AND Qty > 1) THEN
        UPDATE Cart SET Qty = Qty - 1 WHERE ProductId = p_productId;
        RETURN 'Quantity reduced';
    ELSE
        DELETE FROM Cart WHERE ProductId = p_productId;
        RETURN 'Item removed';
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Test functions
SELECT AddItem(1); -- Add Coke
SELECT AddItem(2); -- Add Chips
SELECT * FROM Cart;

SELECT RemoveItem(1); -- Remove one Coke
SELECT RemoveItem(2); -- Remove Chips completely
SELECT * FROM Cart;

-- ============================================
-- 8) SELECT EXAMPLES (view orders)
-- ============================================
SELECT * FROM OrderHeader;
SELECT * FROM OrderDetails;

-- View a single order (OrderID = 1)
SELECT oh.OrderID, u.Username, pm.Name, od.Qty, pm.Price
FROM OrderHeader oh
JOIN Users u ON oh.User_ID = u.User_ID
JOIN OrderDetails od ON oh.OrderID = od.OrderHeader
JOIN ProductsMenu pm ON od.ProdID = pm.Id
WHERE oh.OrderID = 1;

-- View all orders placed today
SELECT oh.OrderID, u.Username, pm.Name, od.Qty, pm.Price, oh.OrderDate
FROM OrderHeader oh
JOIN Users u ON oh.User_ID = u.User_ID
JOIN OrderDetails od ON oh.OrderID = od.OrderHeader
JOIN ProductsMenu pm ON od.ProdID = pm.Id
WHERE oh.OrderDate::date = CURRENT_DATE;

-- ============================================
-- 9) CLEANUP SCRIPT (optional)
-- ============================================
DELETE FROM OrderDetails;
DELETE FROM OrderHeader;
DELETE FROM Cart;
DELETE FROM Users;
DELETE FROM ProductsMenu;
