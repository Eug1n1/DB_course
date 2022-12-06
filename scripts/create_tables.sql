create database alconaft
go

use alconaft
go

create table USERS 
(
	user_id int identity(1,1) constraint CUSTOMER_PK primary key,
	first_name nvarchar(50) not null,
	last_name nvarchar(50) not null,
	email_address nvarchar(255) masked with ( function = 'Email()' ) not null unique,
	login_name nvarchar(50) masked with ( function = 'DEFAULT()' ) not null unique,
	login_password nvarchar(50) not null,
	phone_number nvarchar(13) masked with ( function = 'Partial(1, "XXX", 3)' ),
	address_line_1 nvarchar(50) masked with ( function = 'DEFAULT()' ),
	address_line_2 nvarchar(50) masked with ( function = 'DEFAULT()' ),
	town_city nvarchar(50) masked with ( function = 'DEFAULT()' ),
	county nvarchar(50) masked with ( function = 'DEFAULT()' ),
)

create table PRODUCT_TYPE
(
	product_type_id int identity(1,1) constraint PRODUCT_TYPE_PK primary key,
	product_type_parent_id int constraint PRODUCT_TYPE_PARENT_FK foreign key references PRODUCT_TYPE(product_type_id) on delete no action,
	product_type_description nvarchar(50) unique,
)

create table PRODUCTS
(
	product_id int identity(1,1) constraint PRODUCT_PK primary key,
	product_name nvarchar(50) not null unique,
	product_description nvarchar(max),
	product_type_id int constraint PRODUCT_TYPE_FK foreign key references PRODUCT_TYPE(product_type_id) on delete set null,
	product_price money not null,
	product_quantity int check( product_quantity > 0 )
)

insert into PRODUCT_TYPE (product_type_description) values ('bear'),('whiskey'),
('vodka'),('rum'),('wine'),
('absinthe'),('gin'),('tequila'),('cognac')


create table ORDER_STATUS_CODES
(
	order_status_code int identity(1,1) constraint ORDER_STATUS_CODES_PK primary key,
	order_status_code_description nvarchar(50) unique,
)

create table ORDERS
(
	order_id int identity(1,1) constraint ORDER_PK primary key,
	user_id int constraint CUSTOMER_ID_FK foreign key references USERS(user_id) on delete cascade,
	order_status_code int constraint ORDERS_ORDER_STATUS_CODE_ID_FK foreign key references ORDER_STATUS_CODES(order_status_code),
	order_details nvarchar(max)
)

create table ORDER_ITEMS
(
	order_item_id int identity(1,1) constraint ORDER_ITEM_PK primary key,
	product_id int constraint PRODUCT_ID_FK foreign key references PRODUCTS(product_id) on delete cascade,
	order_id int constraint ORDER_ITEMS_ORDER_ID_FK foreign key references ORDERS(order_id) on delete cascade,
	--order_item_status_code int constraint ORDER_ITEM_STATUS_CODE_FK foreign key references ORDER_ITEM_STATUS_CODES(order_item_status_code),
	order_item_quantity int check( order_item_quantity > 0 ),
)

create table INVOICE_STATUS_CODES
(
	invoice_status_code int identity(1,1) constraint INVOICE_STATUS_CODES_PK primary key,
	invoice_status_code_description nvarchar(50) unique,
)

insert into INVOICE_STATUS_CODES values ('issued'),('paid')

create table INVOICES
(
	invoice_id int identity(1,1) constraint INVOICES_PK primary key,
	order_id int constraint INVOICES_ORDER_ID_FK foreign key references ORDERS(order_id) on delete cascade,
	invoice_status_code int constraint INVOICE_STATUS_CODE_FK foreign key references INVOICE_STATUS_CODES(invoice_status_code) on delete set null,
	invoice_date datetime not null
)

create table PAYMENTS
(
	payment_id int identity(1,1) constraint PAYMENTS_PK primary key,
	invoice_id int constraint INVOICE_ID_FK foreign key references INVOICES(invoice_id) on delete cascade unique not null,
	payment_date datetime not null,
	payment_amount money,
)

create table SHIPMENT
(
	shipment_id int identity(1,1) constraint SHIPMENT_PK primary key,
	invoice_id int constraint SHIPMENT_INVOICE_ID_FK references INVOICES(invoice_id) on delete cascade unique not null,
	shipment_tracking_number nvarchar(20) not null,
	shipment_date datetime,
)
