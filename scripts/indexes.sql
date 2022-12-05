use alconaft

-- USERS
create unique nonclustered index indx_login_name on USERS(login_name);
create unique nonclustered index indx_email_address on USERS(email_address);

-- PRODUCTS
create unique nonclustered index indx_product_name on PRODUCTS(product_name);
create unique nonclustered index indx_product_name_desc on PRODUCTS(product_name desc);
create nonclustered index indx_product_type on PRODUCTS(product_type_id);
create nonclustered index indx_product_price on PRODUCTS(product_price);
create nonclustered index indx_product_price_desc on PRODUCTS(product_price desc);
create nonclustered index indx_product_quantity on PRODUCTS(product_quantity);
create nonclustered index indx_product_quantity_desc on PRODUCTS(product_quantity desc);

-- PRODUCT_TYPE
create nonclustered index indx_product_type_parent on PRODUCT_TYPE(product_type_parent_id);

-- ORDERS
create nonclustered index indx_user_id on ORDERS(user_id);

-- ORDER_ITEMS
create nonclustered index indx_order_items_order_id on ORDER_ITEMS(order_id);
-- create unique nonclustered index indx_order_products on ORDER_ITEMS(order_id)

-- INVOICES
create nonclustered index indx_invoices_order_id on INVOICES(order_id);
create nonclustered index indx_invoice_status_code on INVOICES(invoice_status_code);

-- SHIPMENT
create nonclustered index indx_shipment_invoice_id on SHIPMENT(invoice_id);
create nonclustered index indx_shipment_tracking_number on SHIPMENT(shipment_tracking_number)

-- PAYMENTS
create nonclustered index indx_payments_invoice_id on PAYMENTS(invoice_id);