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
