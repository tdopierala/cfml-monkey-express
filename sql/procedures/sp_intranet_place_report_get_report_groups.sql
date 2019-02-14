delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_place_report_get_report_groups`(
	in report_id int(11)
)
begin
	select 
		g.id as groupid
		,g.groupname as groupname
		,g.created as created
		,(select count(id) from place_fieldgroups fg where fg.groupid = g.id and fg.access = 1) as fieldcount
	from place_groups g
	inner join place_reportgroups rg on rg.groupid = g.id
	where rg.reportid = report_id;
		
end$$

