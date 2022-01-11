use alconaft
go

create or alter procedure export_products
as
Begin
	exec master.dbo.sp_configure 'show advanced options', 1
		RECONFIGURE WITH OVERRIDE
	exec master.dbo.sp_configure 'xp_cmdshell', 1
		RECONFIGURE WITH OVERRIDE;

	declare @fileName varchar(100)
	declare @sqlStr varchar(1000)
	declare @sqlCmd varchar(1000)
	set @fileName = 'c:\DB_course\alconaft_products_2.xml'
	set @sqlStr = 'use alconaft; declare @text varchar(max) = (select top 100 * from products for xml path(''PRODUCT''), ' +
	              'ROOT(''PRODUCTS'')); select replace(@text, ''</PRODUCT>'', ''</PRODUCT>'' + char(13))'
	set @sqlCmd = 'bcp "' + @sqlStr + '" queryout ' + @fileName + ' -w -T -S DESKTOP-FT44TPL\SQLEXPRESS'
	exec xp_cmdshell @sqlCmd;
end
go

create or alter procedure import_products
    @path nvarchar(100)
as
begin
    set identity_insert PRODUCTS on;
    insert into PRODUCTS (product_id, product_name, product_description, product_type_id, product_price, product_quantity)
    select
       MY_XML.PRODUCT.query('product_id').value('.', 'int'),
       MY_XML.PRODUCT.query('product_name').value('.', 'nvarchar(50)'),
       MY_XML.PRODUCT.query('product_description').value('.', 'nvarchar(max)'),
       MY_XML.PRODUCT.query('product_type_id').value('.', 'int'),
       MY_XML.PRODUCT.query('product_price').value('.', 'money'),
       MY_XML.PRODUCT.query('product_quantity').value('.', 'int')

    from (select CAST(MY_XML as xml)
          from OPENROWSET(bulk @path, single_blob ) as T(MY_XML)) as T(MY_XML)
          cross apply MY_XML.nodes('PRODUCTS/PRODUCT') as MY_XML (PRODUCT);
    set identity_insert PRODUCTS off;
end
go

delete from PRODUCTS
exec export_products
exec import_products