CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_create_blank_place_photo_type_privileges`()
begin

	start transaction;
	BLOCK1: begin
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
			
			BLOCK2: begin
				
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
				
			end BLOCK2;
			
		end loop LOOP1;
	end BLOCK1;
	commit;

end
