use master
go

create procedure export_BD
as
begin

    declare @path nvarchar(100) = concat('c:\DB_course\backups\alconaft_',
        replace(convert(varchar, getdate(),101),'/','') + replace(convert(varchar, getdate(),108),':',''), '_.bak')
    Backup database alconaft
	    to disk = @path
end
go


create or alter procedure import_DB
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