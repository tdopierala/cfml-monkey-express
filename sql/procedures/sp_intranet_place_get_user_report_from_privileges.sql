delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_place_get_user_report_from_privileges`(
	in user_id int(11)
)
begin
	select 
		rp.id as id
		,rp.readprivilege as readprivilege
		,rp.reportid as reportid
		,r.reportname as reportname
	from place_reportprivileges rp inner join place_reports r on rp.reportid = r.id
	where rp.userid = user_id;
end$$

