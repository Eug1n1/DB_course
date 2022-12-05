use alconaft
go

go
create or alter procedure get_user
	@user_id int
as
begin

    execute as user = 'reader';
    select
		user_id,
		login_name,
		first_name,
		last_name,
		email_address,
        phone_number
	from
		USERS
	where
		user_id = @user_id
    revert
end
go

create or alter procedure get_product_types
as
	select
		*
	from
		PRODUCT_TYPE
go

create or alter procedure get_product_by_id
	@product_id int
as
	select
		*
	from
		PRODUCTS
	where product_id = @product_id
go

create or alter procedure get_products
    @top int
as
    begin
        if @top = -1
            begin
                select
                    *
                from
                    PRODUCTS
            end
        else
            begin
                select top(@top)
                    *
                from
                    PRODUCTS
            end
    end
go

create or alter procedure get_products_by_type
    @type_id int,
    @top int
as
    begin
        if @top = -1
            begin
                select
                    *
                from
                    PRODUCTS
                where product_type_id = @type_id
            end
        else
            begin
                select top(@top)
                    *
                from
                    PRODUCTS
                where product_type_id = @type_id
            end
    end

create or alter procedure get_product_by_name
	@product_name nvarchar(50)
as
	select
		*
	from
		PRODUCTS
	where
		product_name like concat('%', @product_name, '%')
go

create or alter procedure get_order
	@order_id int
as
	select
		*
	from
		ORDERS
	where order_id = @order_id
go

create or alter procedure get_user_orders
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

create or alter procedure get_order_items
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

create or alter procedure get_invoice_by_order
	@order_id int
as
	select
		*
	from
		INVOICES
	where
		order_id = @order_id
go

create or alter procedure get_invoice
	@invoice_id int
as
	select
		*
	from
		INVOICES
	where
		invoice_id = @invoice_id
go

create or alter procedure get_products
as
    select
        *
    from
        PRODUCTS
go

create or alter procedure get_products_by_price
    @min_price money,
    @max_price money
as
    select
        *
    from
        PRODUCTS
    where
        product_price between @min_price and @max_price
go

create or alter procedure get_product_types_recursive
	@product_type_id int
as
begin
	with tree (product_type_id, product_type_parent_id, product_type_description)
	as
	(
		select
			product_type_id,
			product_type_parent_id,
			product_type_description
		from
			PRODUCT_TYPE
		where
			product_type_parent_id = @product_type_id
		union all
		select
			PRODUCT_TYPE.product_type_id,
			PRODUCT_TYPE.product_type_parent_id,
			PRODUCT_TYPE.product_type_description
		from
			PRODUCT_TYPE inner join tree
		on tree.product_type_id = PRODUCT_TYPE.product_type_parent_id
	)
	select
		product_type_id,
		product_type_parent_id,
		product_type_description
	from
		tree
	order by product_type_parent_id
end
go

create or alter procedure get_done_orders
    @user_id int
as
    select
        O.order_id,
        order_details,
        I.invoice_id,
        payment_date,
        payment_amount,
        shipment_id,
        shipment_date
    from
        ORDERS O join INVOICES I
            on O.order_id = I.order_id
                 join PAYMENTS P
                     on I.invoice_id = P.invoice_id
                 left join SHIPMENT S
                     on I.invoice_id = S.invoice_id
    where O.user_id = @user_id
go

create or alter procedure get_open_order
    @user_id int,
    @order_id int output
as
    select top 1
        @order_id = O.order_id
    from
        ORDERS O left join ORDER_ITEMS OI
        on O.order_id = OI.order_id
        left join INVOICES I
        on O.order_id = I.order_id
    where
        O.user_id = @user_id and
        I.invoice_id is null
go

create or alter procedure get_open_shipments
    @user_id int
as
    select
        *
    from
        ORDERS O join INVOICES I on O.order_id = I.order_id
        join SHIPMENT S on I.invoice_id = S.invoice_id
    where
        O.user_id = @user_id and
        shipment_date is null
go

