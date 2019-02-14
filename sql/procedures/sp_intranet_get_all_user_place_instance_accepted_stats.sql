CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_all_user_place_instance_accepted_stats`(
in user_id int(11)
)
begin

	select 
		count(id) as count, 
		makedate(2012, (week(instancecreated)-1)*7) as startdate,
		makedate(2012, week(instancecreated)*7) as stopdate
	from trigger_place_instances
	where userid = user_id and instancestatusid = 2
	group by week(instancecreated);
	
end
