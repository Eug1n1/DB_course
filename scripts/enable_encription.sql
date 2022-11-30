use master

if not exists (SELECT * FROM sys.symmetric_keys WHERE name LIKE '%MS_DatabaseMasterKey%')
begin
    CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Pass-123';
end
go

BACKUP MASTER KEY TO FILE = '/DB_course/master_key_backup/masterkey.mk'
    ENCRYPTION BY PASSWORD = 'Pass-123';
go

CREATE CERTIFICATE alconaft_cert WITH SUBJECT = 'alconaft_certificate';
go

BACKUP CERTIFICATE alconaft_cert TO FILE = '/DB_course/certificates/alconaft.cer'
   WITH PRIVATE KEY (
         FILE = '/DB_course/certificates/alconaft.pvk',
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
