use alconaft
go

create or alter procedure add_product_to_order
    @user_id int,
    @product_id int,
    @product_quantity_order int
as
begin
    declare @order_id int;
    exec get_open_order @user_id, @order_id output

    if @order_id is null
    begin
        insert into ORDERS (user_id) values (@user_id)
        exec get_open_order @user_id, @order_id output
    end

    if exists (select order_item_id from ORDER_ITEMS where order_id = @order_id and product_id = @product_id)
    begin
        declare @product_quantity_product int

        select @product_quantity_product = product_quantity from PRODUCTS where product_id = @product_id

		if (@product_quantity_product < @product_quantity_order)
        begin
            rollback transaction
        end

        update
		    PRODUCTS
		set
		    product_quantity = product_quantity - @product_quantity_order
		where
		      product_id = @product_id

		select
		    @product_quantity_order = @product_quantity_order + order_item_quantity
		from
		    ORDER_ITEMS
		where
		    order_id = @order_id and product_id = @product_id

		update
			ORDER_ITEMS 
		set
			order_item_quantity = @product_quantity_order
		where
			order_id = @order_id and product_id = @product_id
    end
    else
        exec insert_order_item
            @order_id,
            @product_id,
            @product_quantity_order
end
go

create or alter procedure buy_order
    @order_id int
as
begin
    if exists (select * from INVOICES where order_id = @order_id)
    begin
        select -1
    end

    insert into INVOICES (order_id, invoice_status_code, invoice_date) values (@order_id, 0, getdate())

    declare @invoice_id int = (select invoice_id from INVOICES where order_id = @order_id)

    declare @payment_amount money = (
        select
            sum(p.product_price * oi.order_item_quantity) as "order_price"
        from
            ORDER_ITEMS oi join PRODUCTS p
            on oi.product_id = p.product_id
        where
            oi.order_id = @order_id
        group by
            order_id
    )

    insert into PAYMENTS (invoice_id, payment_date, payment_amount) values (@invoice_id, getdate(), @payment_amount)

    select 1
end
go

create or alter procedure open_shipment
    @invoice_id int
as
begin
    declare @shipment_tracking_number nvarchar(20)
    exec RandomString 20, '1234567890qwertyuiopasdfghjklzxcvbnm-', @shipment_tracking_number output

    insert into SHIPMENT (invoice_id, shipment_tracking_number, shipment_date) values (@invoice_id, @shipment_tracking_number, null)
end
go

create or alter procedure close_shipment
    @shipment_id int
as
begin
    update SHIPMENT set shipment_date = getdate() where shipment_id = @shipment_id
end
go