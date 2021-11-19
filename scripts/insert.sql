create procedure insert_user
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
	insert into USERS(first_name, last_name, email_address, login_name, login_password, 
							phone_number, address_line_1, address_line_2, town_city, county)
	values (@first_name, @last_name, @email_address, @login_name, @login_password, 
			@phone_number, @address_line_1, @address_line_2, @town_city, @county)
end
go

create procedure insert_product
	@product_name nvarchar(50),
	@product_description nvarchar(max),
	@product_type_id int,
	@product_price money,
	@product_quantity int
as
begin
	insert into PRODUCTS(product_name, product_description, product_type_id, product_price, product_quantity)
	values (@product_name, @product_description, @product_type_id, @product_price, @product_quantity)
end
go

create procedure insert_order
	@user_id int,
	@order_status_code int,
	@order_date_placed datetime,
	@order_details nvarchar(max)
as
begin
	insert into ORDERS (user_id, order_status_code, order_date_placed, order_details)
	values (@user_id, @order_status_code, @order_date_placed, @order_details)
end
go

create procedure insert_order_item
	@order_id int,
	@product_id int,
	@order_item_quantity int
as
begin
	insert into ORDER_ITEMS (order_id, product_id, order_item_quantity)
	values (@order_id, @product_id, @order_item_quantity)
end
go

create procedure insert_invoice
	@order_id int,
	@invoice_status_code int,
	@invoice_date datetime
as
begin
	insert into INVOICES(order_id, invoice_status_code, invoice_date)
	values (@order_id, @invoice_status_code, @invoice_date)
end
go

create procedure insert_payment
	@invoice_id int,
	@payment_date datetime,
	@payment_amount money
as
begin
	insert into PAYMENTS (invoice_id, payment_date, payment_amount)
	values (@invoice_id, @payment_date, @payment_amount)
end
go

create procedure insert_shipment
	@invoice_id int,
	@shipment_tracking_number nvarchar(20),
	@shipment_date datetime
as
begin
	insert into SHIPMENT (invoice_id, shipment_tracking_number, shipment_date)
	values (@invoice_id, @shipment_tracking_number, @shipment_date)
end
go

create procedure insert_invoice_status_code
	@invoice_status_code_description nvarchar(50)
as
begin
	insert into INVOICE_STATUS_CODES (invoice_status_code_description)
	values (@invoice_status_code_description)
end
go

create procedure insert_order_status_code
	@order_status_code nvarchar(50)
as
begin
	insert into ORDER_STATUS_CODES (order_status_code_description)
	values (@order_status_code)
end
go

create procedure insert_product_type
	@product_type_parent_id int,
	@product_type_description nvarchar(50)
as
begin
	insert into PRODUCT_TYPE (product_type_parent_id, product_type_description)
	values (@product_type_parent_id, @product_type_description)
end
go