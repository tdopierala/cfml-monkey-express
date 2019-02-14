CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_generate_default_users_protocol_number`()
begin
	declare user_id int(11);
	declare no_more_users int default false;
	declare user_cursor cursor for select id from users;
	declare continue handler for not found set no_more_users = true;
	
	open user_cursor;
	LOOP1: loop
		fetch user_cursor into user_id;
		if no_more_users then
			close user_cursor;
			leave LOOP1;
		end if;
		
		insert into protocol_numbers (userid, protocolnumber) values (user_id, 1);
		
	end loop LOOP1;
end
