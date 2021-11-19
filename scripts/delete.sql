create procedure delete_customer
	@customer_id int
as
begin
	delete from CUSTOMERS where customer_id = @customer_id
end
go

select * from ORDERS order by customer_id
select * from ORDER_ITEMS
select * from ORDERS where customer_id = 129
select * from ORDER_ITEMS where order_id = 896

exec delete_customer 237