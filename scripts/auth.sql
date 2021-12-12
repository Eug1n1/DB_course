use alconaft
go

create procedure login_user
	@login_name nvarchar(50),
	@email_address nvarchar(50),
	@login_password nvarchar(50),
	@ret int output
as
begin
	select @ret=1 
       from USERS 
       where (login_name = isnull(@login_name,null) or email_address = isnull(@email_address,null) 
             and login_password = @login_password)
end
go

create procedure register_user
    @first_name nvarchar(50),
    @last_name nvarchar(50),
    @login_name nvarchar(50),
    @email_address nvarchar(50),
    @login_name nvarchar(50),
    @ret int output
as
begin
    select
        @ret=-1
    from
        USERS
    where
        login_name = @login_name
        or
        email_address = @email_address

    if @ret != -1
    begin
        exec insert_user
            @first_name,
            @last_name,
            @email_address,
            @login_name,
            @login_password,
            null,
            null,
            null,
            null,
            null
    end
end
go