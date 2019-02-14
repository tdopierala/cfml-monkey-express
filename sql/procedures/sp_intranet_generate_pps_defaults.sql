CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_generate_pps_defaults`()
begin

	BLOCK1: begin

	declare user_id int(11);
	declare no_more_users int default false;
	declare user_cursor cursor for select id from users where isstore = 1;
	declare continue handler for not found set no_more_users = true;
	
	open user_cursor;
	LOOP1: loop
		
		fetch user_cursor into user_id;
		if no_more_users then
			close user_cursor;
			leave LOOP1;
		end if;
		
		update usergroups set access = 0 where userid = user_id;
		
		update usergroups set access = 1 where userid = user_id and groupid = 24;
		update usergroups set access = 1 where userid = user_id and groupid = 25;
		
		update usermenus set usermenuaccess = 0 where userid = user_id;
		
		update usermenus set usermenuaccess = 1 where userid = user_id and menuid = 19;
		update usermenus set usermenuaccess = 1 where userid = user_id and menuid = 20;
		update usermenus set usermenuaccess = 1 where userid = user_id and menuid = 52;
		
	end loop LOOP1;
	
	end BLOCK1;

end
