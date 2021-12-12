use alconaft
go

alter procedure add_order_product
    @user_id int,
    @product_id int,
    @product_quantity int
as
begin
    declare @order_id int

    if not exists (select order_id from ORDERS where user_id = @user_id)
    begin
        insert into ORDERS (user_id, order_status_code) values (@user_id, default)
    end

    select @order_id=order_id from ORDERS where user_id = @user_id

    if exists (select order_item_id from ORDER_ITEMS where order_id = @order_id and product_id = @product_id)
    begin
		select
		    @product_quantity=@product_quantity + order_item_quantity
		from
		    ORDER_ITEMS
		where
		    order_id = @order_id and product_id = @product_id

		update
			ORDER_ITEMS 
		set
			order_item_quantity = @product_quantity
		where
			order_id = @order_id and product_id = @product_id
    end
    else
        exec insert_order_item
            @order_id,
            @product_id,
            @product_quantity
end
go

create procedure buy_order
    @order_id int
as
begin
    if exists (select * from INVOICES where order_id = @order_id)
    begin
        select -1
    end

    insert into INVOICES (order_id, invoice_status_code, invoice_date) values (@order_id, 0, getdate())

    select 1
end
go