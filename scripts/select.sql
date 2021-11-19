create procedure get_users
	@page_number int,
	@page_size int
as 
begin
	
	declare @start_index int = (@page_number - 1) * @page_size + 1,
			@end_index int = @page_number * @page_size;

	WITH num_row
	AS
	(
		SELECT 
			row_number() OVER (ORDER BY customer_id) as nom, 		
			customer_id,
			login_name,
			first_name,
			last_name
		from 
			CUSTOMERS
	) 
	SELECT customer_id, login_name, first_name, last_name FROM num_row
	WHERE nom BETWEEN @start_index AND @end_index;
end
go

create procedure get_user
	@user_id int
as
	select
		customer_id,
		login_name,
		first_name,
		last_name
	from
		USERS
	where
		user_id = @user_id