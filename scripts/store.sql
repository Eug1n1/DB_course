use alconaft
go

create or alter procedure add_order_product
    @user_id int,
    @product_id int,
    @product_quantity int
as
begin
    declare @order_id int

    if not exists (select order_id from ORDERS where user_id = @user_id and order_status_code = 0)
    begin
        insert into ORDERS (user_id, order_status_code) values (@user_id, default)
    end

    select @order_id = order_id from ORDERS where user_id = @user_id

    if exists (select order_item_id from ORDER_ITEMS where order_id = @order_id and product_id = @product_id)
    begin
		select
		    @product_quantity = @product_quantity + order_item_quantity
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
            order_id,
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