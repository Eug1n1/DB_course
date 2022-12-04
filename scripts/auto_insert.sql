use alconaft
go

create or alter procedure autoinsert_users
	@limit int
as 
begin
	declare @i int = 0,
			@size int = 10,
			@first_name nvarchar(10),
			@last_name nvarchar(10),
			@login_name nvarchar(10),
			@login_password nvarchar(10),
			@email_address nvarchar(20),
			@phone_number nvarchar(7),
			@login_charPool nvarchar(max) = 'abcdefghijkmnopqrstuvwxyzABCDEFGHIJKLMNPQRSTUVWXYZ1234567890-_'

	while @i < @limit
	begin
		exec RandomString @size, null, @first_name output
		exec RandomString @size, null, @last_name output
		exec RandomString @size, @login_charPool, @login_name output
		exec RandomString @size, @login_charPool, @login_password output
		exec RandomString 7, '1234567890', @phone_number out

		declare @email_domain char(10) = (
			select
				top (1) letter 
			from
			( 
				values
					('@gmail.com'),('@mail.ru'),('@yahoo.com'),('@yandex.ru'),('@bk.ru'),('@tut.by')
			) as letters(letter)
			order by abs(checksum(newid()))
		)

		set @email_address = concat(@login_name, @email_domain)
		

		insert into USERS(first_name, last_name, email_address, login_name, login_password, phone_number) values (@first_name, @last_name, @email_address, @login_name, @login_password, concat('+37529', @phone_number))

		set @i += 1
		print @i
	end
end

go

create or alter procedure autoinsert_products
	@limit int
as
begin
	declare @product_name nvarchar(20),
			@product_description nvarchar(max),
			@product_type_id int, 
			@product_price money,
			@product_quantity int,
			@i int = 0

	while @i < @limit
	begin

		exec RandomString 20, null, @product_name output
		exec RandomString 250, 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM -:1234567890', @product_description output

		set @product_type_id = 
		(
			select
				top (1) product_type_id
			from PRODUCT_TYPE
			order by abs(checksum(newid()))
		)

		set @product_price = round(RAND() * 500 + 1, 2)
		set @product_quantity = floor(RAND() * 500 + 1)

		insert into PRODUCTS(product_name, product_description, product_type_id, product_price, product_quantity) values (@product_name, @product_description, @product_type_id, @product_price, @product_quantity)

		print @i
		set @i = @i + 1
	end
end
go

create or alter procedure autoinsert_orders
	@limit int
as
begin
	declare @i int = 0,
			@user_id int,
			@order_status_code int,
			@order_data_placed date,
			@order_datails nvarchar(max)

	while @i < @limit
	begin

	exec RandomString 200, 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM:() -1234567890', @order_datails output

	set @user_id =
	(
		select top 1
			user_id 
		from 
			USERS
		order by abs(checksum(newid()))
	)

	set @order_status_code =
	(
		select top 1
			ORDER_STATUS_CODES.order_status_code
		from
			ORDER_STATUS_CODES
		order by abs(checksum(newid()))
	)

	insert into ORDERS (user_id, order_details, order_status_code) values (@user_id, @order_datails, @order_status_code)
	
	print @i
	set @i = @i + 1
	end
end
go

create or alter procedure autoinsert_product_type
	@limit int
as 
begin
	declare @i int = 0,
			@product_type_parent_id int,
			@product_type_description nvarchar(20)

	declare product_type_cursor cursor for
	select * 
	from 
	(
		values
			('bear'),('whiskey'), ('vodka'),('rum'),('wine'),
			('absinthe'),('gin'),('tequila'),('cognac')
	) alc(descr)
	where descr not in (select product_type_description from PRODUCT_TYPE)

	open product_type_cursor  
	fetch next from product_type_cursor into @product_type_description  

	while @@FETCH_STATUS = 0  
	begin  
		  exec add_product_type @product_type_description, null, null
		  fetch next from product_type_cursor into @product_type_description 
	end 

	close product_type_cursor  
	deallocate product_type_cursor

	select * 
	from 
	(
		values
			('bear'),('whiskey'), ('vodka'),('rum'),('wine'),
			('absinthe'),('gin'),('tequila'),('cognac')
	) alc(descr)
	where descr not in (select product_type_description from PRODUCT_TYPE)

	while @i < @limit
	begin
		set @product_type_parent_id = 
		(
			select top 1 product_type_id
			from PRODUCT_TYPE
			order by abs(checksum(newid()))
		)

		exec RandomString 20, null, @product_type_description output

		insert into PRODUCT_TYPE (product_type_parent_id, product_type_description) values (@product_type_parent_id, @product_type_description)
		
		set @i = @i + 1 
	end
end
go

create or alter procedure autoinsert_order_status_codes
	@limit int
as
begin
	declare @i int = 0,
			@status_code_description nvarchar(20),
			@table_name nvarchar(20)

	while @i < @limit
	begin

		exec RandomString 20, null, @status_code_description output
		insert into ORDER_STATUS_CODES values (@status_code_description)

		set @i = @i + 1
	end
end
go

create or alter procedure autoinsert_invoice_status_codes
	@limit int
as
begin
	declare @i int = 0,
			@status_code_description nvarchar(20),
			@table_name nvarchar(20)

	while @i < @limit
	begin

		exec RandomString 20, null, @status_code_description output
		insert into INVOICE_STATUS_CODES values (@status_code_description)

		set @i = @i + 1
	end
end
go

create or alter procedure autoinsert_order_items
as
begin
	declare @product_id int,
			@order_id int,
			@order_item_quantity int,
			@product_qunatity int,
			@i int = 0,
			@limit int = (select count(*) from ORDERS as ord where ord.order_id not in (select order_id from ORDER_ITEMS where order_id = ord.order_id)),
			@limit_for_order int,
			@i_for_order int = 0

	while @i < @limit
	begin

		set @order_id = 
		(
			select top 1
				ord.order_id
			from 
				ORDERS as ord
			where 
				ord.order_id not in (select order_id from ORDER_ITEMS where order_id = ord.order_id)
			order by abs(checksum(newid()))
		)

		set @limit_for_order = rand() * 10 + 1
		set @i_for_order = 0

		while @i_for_order < @limit_for_order
		begin
			set @product_id = 
			(
				select top 1 
					product_id
				from 
					PRODUCTS
				where product_id not in (select product_id from ORDER_ITEMS where order_id = @order_id)
				order by abs(checksum(newid()))
			)
		
			set @order_item_quantity = floor(rand() * 20 + 1)
			
			set @i_for_order = @i_for_order + 1
			
			insert into ORDER_ITEMS(product_id, order_id, order_item_quantity) values (@product_id, @order_id, @order_item_quantity)
		end
		

		print @i
		set @i = @i + 1
	end
end
go

create or alter procedure autoinsert_invoices
as
begin
	declare @i int = 0,
			@order_id int,
			@invoice_status_code int,
			@limit int

	set @limit = floor(rand() * (select count(*) from ORDERS) * 0.5)
	print @limit

	while @i < @limit
	begin

		set @order_id = 
		(
			select top 1
				order_id
			from 
				ORDERS
			where not order_id = any(select order_id from INVOICES) 
			order by abs(checksum(newid()))
		)

		set @invoice_status_code = 
		(
			select top 1 
				invoice_status_code
			from 
				INVOICE_STATUS_CODES
			order by abs(checksum(newid()))
		)


		insert into INVOICES(order_id, invoice_status_code, invoice_date) values (@order_id, @invoice_status_code, GETDATE())

		set @i = @i + 1
	end
end
go

create or alter procedure autoinsert_shipment
as
begin
	declare @invoice_id int,
			@order_id int,
			@shipment_tracking_number nvarchar(20),
			@shipment_date datetime,
			@i int = 0,
			@limit int
	
	set @limit = floor(rand() * ((select count(*) from INVOICES) - 50) + 50)
	print @limit
	while @i < @limit
	begin
		set @invoice_id = 
		(
			select top 1
				invoice_id
			from
				INVOICES
			order by abs(checksum(newid()))
		)

		exec RandomString 20, '1234567890qwertyuiopasdfghjklzxcvbnm-', @shipment_tracking_number output

		set @shipment_date = GETDATE()

		insert into SHIPMENT(invoice_id, shipment_tracking_number, shipment_date) values (@invoice_id, @shipment_tracking_number, @shipment_date)
		print @i
		set @i = @i + 1
	end
end
go

create or alter procedure autoinsert_payment
as
begin
	declare @i int = 0,
			@limit int = (select count(*) from INVOICES),
			@invoice_id int,
			@payment_date datetime,
			@payment_amount money

	while @i < @limit
	begin
		
		set @invoice_id =
		(
			select top 1
				invoice_id
			from
				INVOICES
			where invoice_id not in (select invoice_id from PAYMENTS)
			order by abs(checksum(newid()))
		)

		declare @order_id int =
		(
			select
				order_id
			from
				INVOICES
			where invoice_id = @invoice_id
		)

		set @payment_amount =
		(
			select
				sum(product_price)
			from
				PRODUCTS
			where product_id in (select product_id from ORDER_ITEMS where order_id = @order_id)
		)

		insert into PAYMENTS(invoice_id, payment_amount, payment_date) values (@invoice_id, @payment_amount, GETDATE())		

		print @i
		set @i = @i + 1
	end
end
go


exec autoinsert_users 100000
exec autoinsert_product_type 100
exec autoinsert_invoice_status_codes 5
exec autoinsert_order_status_codes 5
exec autoinsert_products 100000
exec autoinsert_orders 2000
exec autoinsert_order_items
exec autoinsert_invoices
exec autoinsert_shipment
exec autoinsert_payment
go