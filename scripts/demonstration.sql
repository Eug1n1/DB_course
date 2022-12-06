-- create or alter procedure register_user
--     @first_name nvarchar(50),
--     @last_name nvarchar(50),
--     @login_name nvarchar(50),
--     @login_password nvarchar(50),
--     @email_address nvarchar(50),
--     @ret int output
use alconaft
go

declare @ret int
exec register_user 
    'demo_first_name', 
    'demo_last_name', 
    'demouser', 
    '1234567890987654321', 
    'demo_email@email.com', 
    @ret output

select @ret


-- create or alter procedure login_user
-- 	@login_name nvarchar(50),
-- 	@email_address nvarchar(50), 
-- 	@login_password nvarchar(50)

exec login_user
    'demouser',
    'demo_email@email.com',
    null

exec login_user
    'demouser',
    null,
    'demouser'


-- get all products
-- create or alter procedure get_products
--     @top int
exec get_products -1

-- get top 100 products
-- create or alter procedure get_products
--     @top int
exec get_products 100

-- get products by type
-- create or alter procedure get_products_by_type
--     @type_id int,
--     @top int
exec get_products_by_type 1, 100

--get product by id
-- create or alter procedure get_product_by_id
-- 	@product_id int
exec get_product_by_id 1

-- add product to order

exec add_product_to_order 2, 34,1

-- check user orders
select
    O.user_id,
    O.order_id,
    OI.product_id,
    OI.order_item_quantity
from
    ORDERS O left join ORDER_ITEMS OI
        on O.order_id = OI.order_id
where
    user_id = 2

-- delete user orders
delete ORDERS where user_id = 2