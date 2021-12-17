use alconaft
go

create procedure delete_user
	@user_id int
as
begin
	delete from USERS where user_id = @user_id
end
go

create procedure delete_product
	@product_id int
as
begin
	delete from PRODUCTS where product_id = @product_id
end
go

create procedure delete_order
	@order_id int
as
begin
	delete from ORDERS where order_id = @order_id
end
go

create procedure delete_order_item
	@order_item_id int
as
begin
	delete from ORDER_ITEMS where order_item_id = @order_item_id
end
go

create procedure delete_invoice
	@invoice_id int
as
begin
	delete from INVOICES where invoice_id = @invoice_id
end
go

create procedure delete_payment
	@payment_id int
as
begin
	delete from PAYMENTS where payment_id = @payment_id
end
go

create procedure delete_shipment
	@shipment_id int
as
begin
	delete from SHIPMENT where shipment_id = @shipment_id
end
go

create procedure delete_product_type
	@product_type_id int
as
begin
	delete from PRODUCT_TYPE where product_type_id = @product_type_id
end
go

create procedure delete_invoice_status_code
	@invoice_status_code int
as
begin
	delete from INVOICE_STATUS_CODES where invoice_status_code = @invoice_status_code
end
go