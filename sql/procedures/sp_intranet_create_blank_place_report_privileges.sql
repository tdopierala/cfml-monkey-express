CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_create_blank_place_report_privileges`()
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
				
				declare report_id int(11);
				declare no_more_reports int default false;
				declare report_cursor cursor for select id from place_reports;
				declare continue handler for not found set no_more_reports = true;
				
				open report_cursor;
				
				LOOP2: loop
					fetch report_cursor into report_id;
					if no_more_reports then
						close report_cursor;
						leave LOOP2;
					end if;
					
					insert into place_reportprivileges (userid, reportid, readprivilege) values (user_id, report_id, 0);
					
				end loop LOOP2;
				
			end BLOCK2;
			
		end loop LOOP1;
	end BLOCK1;
	commit;

end
