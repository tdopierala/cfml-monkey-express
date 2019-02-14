delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_place_get_users_from_report_privileges`()
begin

	select 
		distinct rp.userid as userid
		,u.givenname as givenname
		,u.sn as sn
		,u.position as position
	from place_reportprivileges rp inner join view_users u on rp.userid = u.id;

end$$

