CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_create_blank_user_place_photo_type_privileges`(
in user_id int(11)
)
begin

	declare phototype_id int(11);
	declare no_more_phototypes int default false;
	declare phototype_cursor cursor for select id from place_phototypes;
	declare continue handler for not found set no_more_phototypes = true;
				
	open phototype_cursor;
		
	LOOP2: loop
		fetch phototype_cursor into phototype_id;
		if no_more_phototypes then
			close phototype_cursor;
			leave LOOP2;
		end if;
					
		insert into place_phototypeprivileges (userid, phototypeid, readprivilege, writeprivilege) values (user_id, phototype_id, 1, 0);
					
	end loop LOOP2;

end
