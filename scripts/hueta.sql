CREATE USER reader WITHOUT LOGIN
GRANT SELECT ON USERS TO reader

CREATE USER reader_unmasked WITHOUT LOGIN
GRANT SELECT ON USERS TO reader_unmasked
GRANT UNMASK TO reader_unmasked

use alconaft
ALTER Table USERS
ALTER COLUMN email_address
 ADD MASKED WITH (FUNCTION='Email()')

use alconaft
ALTER Table USERS
ALTER COLUMN login_name
 ADD MASKED WITH (FUNCTION='DEFAULT()')

ALTER Table USERS
ALTER COLUMN phone_number
    ADD MASKED WITH( function = 'Partial(1, "XXXXXXXXX", 3)' )

EXECUTE AS USER = 'reader'
SELECT * FROM USERS
REVERT

exec insert_user
    'admin',
    'admin',
    'admin@gmail.com',
    'admin',
    'admin',
    '+375222222222',
    null,
    null,
    null,
    null

EXECUTE AS USER = 'reader_unmasked'
SELECT * FROM USERS
WHERE email_address = 'admin@gmail.com'
REVERT

SELECT * FROM USERS

EXECUTE AS USER = 'reader'
SELECT * FROM USERS
WHERE email_address = 'admin@gmail.com'
REVERT


EXECUTE AS USER = 'reader'
SELECT * FROM USERS
WHERE login_name = 'RqENkZ8Hfi'
REVERT


EXECUTE AS USER = 'reader_unmasked'
SELECT * FROM USERS
WHERE login_name = 'RqENkZ8Hfi'
REVERT







use master

SELECT * FROM sys.symmetric_keys WHERE name LIKE '%MS_DatabaseMasterKey%'
go
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'strongpassword';
go
BACKUP MASTER KEY TO FILE = 'C:\DB_course\master_key_backup\masterkey1.mk'
    ENCRYPTION BY PASSWORD = 'strongpassword';
go
CREATE CERTIFICATE alconaft_cert WITH SUBJECT = 'alconaft_certificate';
go
BACKUP CERTIFICATE alconaft_cert TO FILE = 'C:\DB_course\certificate\alconaft1.cer'
   WITH PRIVATE KEY (
         FILE = 'C:\DB_course\certificate\alconaft1.pvk',
         ENCRYPTION BY PASSWORD = 'strongpassword');
go

use alconaft
create database encryption key
   with algorithm = AES_256
   encryption by server certificate alconaft_cert;
go

SELECT SERVERPROPERTY('productversion'), SERVERPROPERTY ('productlevel'), SERVERPROPERTY ('edition')

alter database alconaft set encryption on
go

SELECT
DB_NAME(database_id) AS DatabaseName
,Encryption_State AS EncryptionState
,key_algorithm AS Algorithm
,key_length AS KeyLength
FROM sys.dm_database_encryption_keys
GO
SELECT
    NAME AS DatabaseName,
    IS_ENCRYPTED AS IsEncrypted
from sys.databases where name = 'alconaft'
