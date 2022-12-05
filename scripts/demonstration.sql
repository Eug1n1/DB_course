-- create or alter procedure register_user
--     @first_name nvarchar(50),
--     @last_name nvarchar(50),
--     @login_name nvarchar(50),
--     @login_password nvarchar(50),
--     @email_address nvarchar(50),
--     @ret int output

declare @ret int
exec register_user 
    'demo_first_name', 
    'demo_last_name', 
    'demouser', 
    '1234567890987654321', 
    'demo_email@email.com', 
    @ret

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

-- product by id
-- create or alter procedure get_product_by_id
-- 	@product_id int

exec get_product_by_id 1


-- product by name
