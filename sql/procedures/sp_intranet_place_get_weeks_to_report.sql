delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_place_get_weeks_to_report`()
begin
	select makedate(Year(Now()), (week(a.instancecreated)-1)*7) as startdate from trigger_place_instances a group by week(a.instancecreated);
end$$

