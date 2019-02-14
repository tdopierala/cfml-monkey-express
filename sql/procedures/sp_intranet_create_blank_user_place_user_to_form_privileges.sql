CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_create_blank_user_place_user_to_form_privileges`(
in form_id int(11)
)
begin
	declare user_id int(11);
	declare no_more_users int default false;
	declare user_cursor cursor for select id from users;
	declare continue handler for not found set no_more_users = true;
				
	open user_cursor;
				
	LOOP2: loop
		fetch user_cursor into user_id;
		if no_more_users then
			close user_cursor;
			leave LOOP2;
		end if;
					
		insert into place_formprivileges (userid, formid, readprivilege, writeprivilege) values (user_id, form_id, 1, 0);
					
	end loop LOOP2;
end
