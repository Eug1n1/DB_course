use master

if not exists (SELECT * FROM sys.symmetric_keys WHERE name LIKE '%MS_DatabaseMasterKey%')
begin
    CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Pass-123';
end
go

BACKUP MASTER KEY TO FILE = 'C:/DB_course/masterkey.mk'
    ENCRYPTION BY PASSWORD = 'Pass-123';
go

if not exists (select * from sys.certificates where name = 'alconaft_cert')
begin
    CREATE CERTIFICATE alconaft_cert WITH SUBJECT = 'alconaft_certificate';
end
go

BACKUP CERTIFICATE alconaft_cert TO FILE = 'C:/DB_course/alconaft.cer'
   WITH PRIVATE KEY (
         FILE = 'C:/DB_course/alconaft.pvk',
         ENCRYPTION BY PASSWORD = 'Pass-123');
go

use alconaft

create database encryption key
   with algorithm = AES_256
   encryption by server certificate alconaft_cert;
go

alter database alconaft set encryption on
go

select
    DB_NAME(database_id) AS DatabaseName,
    Encryption_State AS EncryptionState,
    key_algorithm AS Algorithm,
    key_length AS KeyLength
from
    sys.dm_database_encryption_keys
go

select
    name AS DatabaseName,
    is_encrypted AS IsEncrypted
from sys.databases where name = 'alconaft'


use alconaft
create user reader without login
grant select on USERS to reader
