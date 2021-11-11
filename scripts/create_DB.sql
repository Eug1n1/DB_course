create database alconaft
use alconaft

create table CUSTOMERS 
(
	customer_id int identity(1,1) constraint CUSTOMER_PK primary key,
	first_name nvarchar(50) not null,
	last_name nvarchar(50) not null,
	email_address nvarchar(255) not null,
	login_name nvarchar(50) not null,
	login_password nvarchar(50) not null,
	phone_number nvarchar(13),
	address_line_1 nvarchar(50),
	address_line_2 nvarchar(50),
	town_city nvarchar(50),
	county nvarchar(50),
)

create table PRODUCT_TYPE
(
	product_type_id int identity(1,1) constraint PRODUCT_TYPE_PK primary key,
	product_type_parent_id int constraint PRODUCT_TYPE_PARENT_FK foreign key references PRODUCT_TYPE(product_type_id),
	product_type_description nvarchar(50),
)

create table PRODUCTS
(
	product_id int identity(1,1) constraint PRODUCT_PK primary key,
	product_name nvarchar(50) not null,
	product_description nvarchar(max),
	product_type_id int constraint PRODUCT_TYPE_FK foreign key references PRODUCT_TYPE(product_type_id),
	product_price money not null,
	product_quantity int not null
)

create table ORDER_STATUS_CODES
(
	order_status_code int identity(1,1) constraint ORDER_STATUS_CODES_PK primary key,
	order_status_code_description nvarchar(50),
)

create table ORDERS
(
	order_id int identity(1,1) constraint ORDER_PK primary key,
	customer_id int constraint CUSTOMER_ID_FK foreign key references CUSTOMERS(customer_id),
	order_status_code int constraint ORDER_STATUS_CODE_FK foreign key references ORDER_STATUS_CODES(order_status_code),
	order_date_placed date,
	order_details nvarchar(max)
)

create table ORDER_ITEM_STATUS_CODES
(
	order_item_status_code int identity(1,1) constraint ORDER_ITEM_STATUS_CODES_PK primary key,
	order_item_status_code_description nvarchar(50),
)

create table ORDER_ITEMS
(
	order_item_id int identity(1,1) constraint ORDER_ITEM_PK primary key,
	product_id int constraint PRODUCT_ID_FK foreign key references PRODUCTS(product_id),
	order_id int constraint ORDER_ITEMS_ORDER_ID_FK foreign key references ORDERS(order_id),
	order_item_status_code int constraint ORDER_ITEM_STATUS_CODE_FK foreign key references ORDER_ITEM_STATUS_CODES(order_item_status_code),
	order_item_quantity int check( order_item_quantity > 0 ),
-- вопросик с прайсом нужен ли он в этой таблице
)

create table INVOICE_STATUS_CODES
(
	invoice_status_code int identity(1,1) constraint INVOICE_STATUS_CODES_PK primary key,
	invoice_status_code_description nvarchar(50),
)

create table INVOICES
(
	invoice_id int identity(1,1) constraint INVOICES_PK primary key,
	order_id int constraint INVOICES_ORDER_ID_FK foreign key references ORDERS(order_id),
	invoice_status_code int constraint INVOICE_STATUS_CODE_FK foreign key references INVOICE_STATUS_CODES(invoice_status_code),
	invoice_date date not null
)

create table PAYMENTS
(
	payment_id int identity(1,1) constraint PAYMENTS_PK primary key,
	invoice_id int constraint INVOICE_ID_FK foreign key references INVOICES(invoice_id),
	payment_date date not null,
	payment_amount money check( payment_amount > 0 ),
)

create table SHIPMENT
(
	shipment_id int identity(1,1) constraint SHIPMENT_PK primary key,
	invoice_id int constraint SHIPMENT_INVOICE_ID_FK references INVOICES(invoice_id),
	oreder_id int constraint SHIPMENT_ORDER_ID_FK references ORDERS(order_id),
	shipment_tracking_number nvarchar(20) not null,
	shipment_date date,
)