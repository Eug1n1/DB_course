use alconaft
go

create procedure get_user
	@user_id int
as
	select
		user_id,
		login_name,
		first_name,
		last_name,
		email_address
	from
		USERS
	where
		user_id = @user_id
go

create procedure get_product_types
as
	select
		*
	from
		PRODUCT_TYPE
go

create procedure get_product_by_id
	@product_id int
as
	select
		*
	from
		PRODUCTS
	where product_id = @product_id
go

create procedure get_product_by_name
	@product_name nvarchar(50)
as
	select
		*
	from
		PRODUCTS
	where
		product_name like concat('%', 'KFKbAxMGhCoBzGJiebQT', '%')
go

create procedure get_order
	@order_id int
as
	select
		*
	from
		ORDERS
	where order_id = @order_id
go

create procedure get_user_orders
	@user_id int
as
	select
		*
	from
		ORDERS
	where
		user_id = @user_id
	order by
		order_id
go

create procedure get_order_items
	@order_id int
as
	select
		*
	from
		ORDER_ITEMS
	where
		order_id = @order_id
	order by
		order_item_id
go

create procedure get_invoice_by_order
	@order_id int
as
	select
		*
	from
		INVOICES
	where 
		order_id = @order_id
go

create procedure get_invoice
	@invoice_id int
as
	select
		*
	from
		INVOICES
	where
		invoice_id = @invoice_id
go

create procedure get_product_types_recursive
	@product_type_id int
as
begin
	with tree (product_type_id, product_type_parent_id, level)
	as 
	(
		select 
			product_type_id, product_type_parent_id, 0
		from 
			PRODUCT_TYPE
		where 
			product_type_parent_id = @product_type_id
		union all
		select 
			PRODUCT_TYPE.product_type_id, PRODUCT_TYPE.product_type_parent_id, tree.level + 1
		from 
			PRODUCT_TYPE inner join tree 
		on tree.product_type_id = PRODUCT_TYPE.product_type_parent_id
	)
	select product_type_id, product_type_parent_id
	from tree
end
go

