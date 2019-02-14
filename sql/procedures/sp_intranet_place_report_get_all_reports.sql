delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_place_report_get_all_reports`()
begin

	select
		r.id as reportid
		,r.reportname as reportname
		,r.reportcreated as reportcreated
		,(select count(id) from place_reportgroups rfg where rfg.groupid = r.id) as groupcount
	from place_reports r;
	
end$$

