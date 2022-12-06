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
declare @user_id int

exec login_user
    'demouser',
    'demo_email@email.com',
    '1234567890987654321',
    @user_id output
select @user_id

declare @user_id int
exec login_user
    'demouser',
    null,
    '1234567890987654321',
    @user_id output
select @user_id

declare @user_id int
exec login_user
    null,
    null,
    '1234567890987654321',
    @user_id output
select @user_id

declare @user_id int
exec login_user
    null,
    'demo_email@email.com',
    '1234567890987654321',
    @user_id output
select @user_id



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

-- create or alter procedure add_product_to_order
--     @user_id int,
--     @product_id int,
--     @product_quantity int

exec add_product_to_order 2, 4, 1

-- delete product from order

-- create or alter procedure drop_product_from_order
--     @user_id int,
--     @product_id int,
--     @product_quantity int

exec drop_product_from_order 2, 4, 1

    -- check user opened orders
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


-- buy order

exec buy_order 2003

    -- check user closed orders
    select
        O.user_id,
        O.order_id,
        I.invoice_id,
        P.payment_date,
        P.payment_amount
    from
        ORDERS O inner join INVOICES I
            on O.order_id = I.order_id
        inner join PAYMENTS P
            on I.invoice_id = P.invoice_id
    where
        user_id = 2

-- get opened orders
declare @opened_order_id int
exec get_open_order 2, @opened_order_id output
select  @opened_order_id

exec get_done_orders 2


-- get order status

exec get_order_status 2000
exec update_order_status 2000, 'ok'

-- get history as closed orders

exec get_done_orders 2


