create procedure export_BD
as
begin
    declare @path nvarchar(100) = concat('c:\DB_course\backups\alconaft_', replace(convert(varchar, getdate(),101),'/','') + replace(convert(varchar, getdate(),108),':',''), '_.bak')

    Backup database alconaft
	    to disk = @path
end
go

create procedure import_DB
    @path nvarchar(100)
as
begin
--Restore
    alter database alconaft
    set offline with rollback immediate

    RESTORE DATABASE alconaft
        FROM disk = 'C:\DB_course\backups\alconaft_12092021122919_.bak'
		    WITH replace

    alter database alconaft
    set online
end
go

use master
exec import_DB 'C:\DB_course\backups\alconaft_12092021122919_.bak'