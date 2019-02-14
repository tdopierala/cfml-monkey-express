CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_create_blank_user_place_file_type_privileges`(
in user_id int(11)
)
begin

	declare filetype_id int(11);
	declare no_more_filetypes int default false;
	declare filetype_cursor cursor for select id from place_filetypes;
	declare continue handler for not found set no_more_filetypes = true;
				
	open filetype_cursor;
				
	LOOP2: loop
		fetch filetype_cursor into filetype_id;
		if no_more_filetypes then
			close filetype_cursor;
			leave LOOP2;
		end if;
					
		insert into place_filetypeprivileges (userid, filetypeid, readprivilege, writeprivilege) values (user_id, filetype_id, 1, 0);
					
	end loop LOOP2;

end
