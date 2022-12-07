use alconaft
go

create or alter procedure login_user
	@login_name nvarchar(50),
	@email_address nvarchar(50),
	@login_password nvarchar(50),
	@user_id int output
as
begin
    begin try
        if @login_name is null and @email_address is null
        begin
            RAISERROR (15600, 16, -1, 'no_login_and_email')
        end

        if @login_password is null
        begin
            RAISERROR (15600, 16, -1, 'no_password')
        end

        select @user_id = user_id
           from USERS
           where ((login_name = isnull(@login_name,null) or email_address = isnull(@email_address,null))
                 and login_password = @login_password)

    end try
    begin catch
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        RAISERROR (@ErrorMessage, -- Message text.
                   @ErrorSeverity, -- Severity.
                   @ErrorState);
    end catch
end
go

create or alter procedure register_user
    @first_name nvarchar(50),
    @last_name nvarchar(50),
    @login_name nvarchar(50),
    @login_password nvarchar(50),
    @email_address nvarchar(50),
    @ret int output
as
begin
    begin try
        set @ret = 0

        select @ret = user_id from USERS where email_address = @email_address
        if (@ret != 0)
        begin
            RAISERROR (15600, 16, -1, 'user_already_exist')
        end

        if (@ret = 0)
        begin

            insert into USERS (first_name, last_name, email_address, login_name, login_password)
                values (@first_name, @last_name, @email_address, @login_name, @login_password)

            set @ret = 1
        end

    end try
    begin catch
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        RAISERROR (@ErrorMessage, -- Message text.
                   @ErrorSeverity, -- Severity.
                   @ErrorState);
    end catch
end
go
