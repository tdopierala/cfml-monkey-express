delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_place_report_get_step_reports`(
	in step_id int(11)
)
begin
	select
		r.id as reportid
		,r.reportname as reportname
		,r.reportcreated as reportcreated
	from place_stepreports sr
	inner join place_reports r on sr.reportid = r.id;
end$$

