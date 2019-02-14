CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_all_place_instance_stats`(
)
begin
	select
		s.statusname as statusname
		,count(i.id) as statuscount
	from trigger_place_instances i
	inner join place_statuses s on i.instancestatusid = s.id
	group by i.instancestatusid; 
end
