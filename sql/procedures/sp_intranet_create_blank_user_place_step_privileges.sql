CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_create_blank_user_place_step_privileges`(
in user_id int(11)
)
begin
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
	
end
