use master
go

create or alter procedure create_backup
    @dir_path nvarchar(200),
    @file_name nvarchar(100)
as
begin
    declare @path nvarchar(200) = @dir_path + '/' +  isnull(@file_name, '')

    if @file_name is null
    begin
        set @path = concat(@dir_path, '/alconaft_')
        set @path = concat(@path, replace(convert(varchar, getdate(),101),'/','') + replace(convert(varchar, getdate(),108),':',''))
        set @path = concat(@path, '_.bak')
    end

    Backup database alconaft
	    to disk = @path
end
go

create or alter procedure restore_DB
    @path nvarchar(100)
as
begin
    alter database alconaft
    set single_user
    with rollback immediate;

    RESTORE DATABASE alconaft
        FROM disk = @path
		    WITH replace;

    alter database alconaft
    set multi_user;
end
go