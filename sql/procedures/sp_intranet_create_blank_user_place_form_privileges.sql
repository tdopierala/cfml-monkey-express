CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_create_blank_user_place_form_privileges`(
in user_id int(11)
)
begin
	declare form_id int(11);
	declare no_more_forms int default false;
	declare form_cursor cursor for select id from place_forms;
	declare continue handler for not found set no_more_forms = true;
				
	open form_cursor;
				
	LOOP2: loop
		fetch form_cursor into form_id;
		if no_more_forms then
			close form_cursor;
			leave LOOP2;
		end if;
					
		insert into place_formprivileges (userid, formid, readprivilege, writeprivilege) values (user_id, form_id, 1, 0);
					
	end loop LOOP2;
end
