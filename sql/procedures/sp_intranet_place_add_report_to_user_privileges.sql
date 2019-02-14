delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_place_add_report_to_user_privileges`(
in user_id int(11)
)
begin
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
				
end$$

