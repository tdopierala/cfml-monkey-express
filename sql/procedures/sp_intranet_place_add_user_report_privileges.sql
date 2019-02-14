delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_place_add_user_report_privileges`(
	in report_id int(11))
begin

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
		
		insert into place_reportprivileges (reportid, userid, readprivilege) values (report_id, user_id, 0);
	
	end loop LOOP1;

end$$

