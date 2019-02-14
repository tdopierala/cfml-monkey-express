CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_create_blank_place_step_privileges`()
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
				
				declare step_id int(11);
				declare no_more_steps int default false;
				declare step_cursor cursor for select id from place_steps;
				declare continue handler for not found set no_more_steps = true;
				
				open step_cursor;
				
				LOOP2: loop
					fetch step_cursor into step_id;
					if no_more_steps then
						close step_cursor;
						leave LOOP2;
					end if;
					
					insert into place_stepprivileges (userid, stepid, readprivilege, writeprivilege, acceptprivilege, refuseprivilege, archiveprivilege) values (user_id, step_id, 1, 0, 0, 0, 0);
					
				end loop LOOP2;
				
			end BLOCK2;
			
		end loop LOOP1;
	end BLOCK1;
	commit;

end
