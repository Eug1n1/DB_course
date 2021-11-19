create procedure update_user
	@user_id int,
	@first_name nvarchar(50),
	@last_name nvarchar(50),
	@email_address nvarchar(255),
	@login_name nvarchar(50),
	@login_password nvarchar(50),
	@phone_number nvarchar(13),
	@address_line_1 nvarchar(50),
	@address_line_2 nvarchar(50),
	@town_city nvarchar(50),
	@county nvarchar(50)
as
begin
	update USERS
	set 
		first_name = @first_name, 
		last_name = @last_name, 
		email_address = @email_address,
		login_name = @login_name, 
		login_password = @login_password, 
		phone_number = @phone_number, 
		address_line_1 = @address_line_1, 
		address_line_2 = @address_line_2, 
		town_city = @town_city, 
		county = @county
	where 
		user_id = @user_id
end
go

create procedure update_product
	@product_id int,
	@product_name nvarchar(50),
	@product_description nvarchar(max),
	@product_type_id int,
	@product_price money,
	@product_quantity int
as
begin
	update PRODUCTS
	set 
		product_name = @product_name, 
		product_description = @product_description,
		product_type_id = @product_type_id, 
		product_price = @product_price,
		product_quantity = @product_quantity
	where 
		product_id = @product_id
end
go

create procedure update_order
	@order_id int,
	@user_id int,
	@order_status_code int,
	@order_date_placed datetime,
	@order_details nvarchar(max)
as
begin
	update ORDERS
	set 
		user_id = @user_id,
		order_status_code = @order_status_code,
		order_date_placed = @order_date_placed,
		order_details = @order_details
	where 
		order_id = @order_id
end
go

create procedure update_order_item
	@order_item_id int,
	@order_id int,
	@product_id int,
	@order_item_quantity int
as
begin
	update ORDER_ITEMS
	set		
		order_id = @order_id, 
		product_id = @product_id, 
		order_item_quantity = @order_item_quantity
	where
		order_item_id = @order_item_id
end
go

create procedure update_invoice
	@invoice_id int,
	@order_id int,
	@invoice_status_code int,
	@invoice_date datetime
as
begin
	update INVOICES
	set 
		order_id = @order_id, 
		invoice_status_code = @invoice_status_code, 
		invoice_date = @invoice_date
	where
		invoice_id = @invoice_id
end
go

create procedure update_payment
	@payment_id int,
	@invoice_id int,
	@payment_date datetime,
	@payment_amount money
as
begin
	update PAYMENTS 
	set 
		invoice_id = @invoice_id, 
		payment_date = @payment_date, 
		payment_amount = @payment_amount
	where 
		payment_id = @payment_id
end
go

create procedure update_shipment
	@shipment_id int,
	@invoice_id int,
	@shipment_tracking_number nvarchar(20),
	@shipment_date datetime
as
begin
	update SHIPMENT
	set 
		invoice_id = @invoice_id, 
		shipment_tracking_number = @shipment_tracking_number, 
		shipment_date = @shipment_date
	where
		shipment_id = @shipment_id 
end
go

create procedure update_invoice_status_code
	@invoice_status_code int,
	@invoice_status_code_description nvarchar(50)
as
begin
	update INVOICE_STATUS_CODES
	set 
		invoice_status_code_description = @invoice_status_code_description
	where
		invoice_status_code = @invoice_status_code
end
go

create procedure update_order_status_code
	@order_status_code int,
	@order_status_code nvarchar(50)
as
begin
	update ORDER_STATUS_CODES
	set 
		order_status_code = @order_status_code
	where
		order_status_code = @order_status_code
end
go

create procedure update_product_type
	@product_type_id int,
	@product_type_parent_id int,
	@product_type_description nvarchar(50)
as
begin
	update PRODUCT_TYPE
	set 
		product_type_parent_id = @product_type_parent_id, 
		product_type_description = @product_type_description
	where
		product_type_id = @product_type_id
end
go