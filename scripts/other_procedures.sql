create proc add_product_type
	@description nvarchar(30),
	@parent_description nvarchar(30),
	@parent_id int
as
begin

	declare @product_parent_id int

	if @parent_id is null
	begin
		set @product_parent_id = 
		(
			select product_type_id from PRODUCT_TYPE where product_type_description = @parent_description
		)
	end
	else if @parent_description is null
	begin
		set @product_parent_id = 
		(
			select product_type_id from PRODUCT_TYPE where product_type_id = @parent_id
		)
	end
	else
	begin
		set @product_parent_id = null
	end

	insert into PRODUCT_TYPE (product_type_description, product_type_parent_id) 
		values 
		(
			@description,
			@product_parent_id
		)
end
go

alter procedure RandomString
	@length int,
	@char_pool nvarchar(max),
	@random_string nvarchar(max) output
as
begin
	declare @pool_length int,
			@i int

	if @char_pool is null
	begin
		set @char_pool = 'abcdefghijkmnopqrstuvwxyzABCDEFGHIJKLMNPQRSTUVWXYZ'
	end

	set @pool_length = Len(@char_pool)
	
	set @random_string = ''

	set @i = 0
	while (@i < @length) 
	begin
	    set @random_string = @random_string + substring(@char_pool, convert(int, rand() * @pool_length) + 1, 1)
	    set @i = @i + 1
	end
end
go