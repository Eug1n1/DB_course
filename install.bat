mkdir C:\DB_course
SQLCMD.EXE -E -S localhost -i .\scripts\create_tables.sql .\scripts\indexes.sql .\scripts\insert.sql .\scripts\select.sql .\scripts\update.sql .\scripts\delete.sql .\scripts\other_procedures.sql .\scripts\export_import.sql .\scripts\store.sql .\scripts\auth.sql .\scripts\backup_DB.sql .\scripts\enable_encription.sql .\scripts\auto_insert.sql
