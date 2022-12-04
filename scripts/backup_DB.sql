use master
go

create or alter procedure export_BD
    @dir_path nvarchar(100)
as
begin

    declare @path nvarchar(100) = concat(@dir_path, '/alconaft_')
    set @path = concat(@path, replace(convert(varchar, getdate(),101),'/','') + replace(convert(varchar, getdate(),108),':',''))
    set @path = concat(@path, '_.bak')

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