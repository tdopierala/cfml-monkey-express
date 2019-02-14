CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_all_user_place_instance_stats`(
in user_id int(11)
)
begin

	select
		makedate(Year(Now()), (week(a.instancecreated)-1)*7) as startdate,
		makedate(Year(Now()), week(a.instancecreated)*7) as stopdate,
		count(a.id) as totalcount,
		sum(if(b.instancestatusid=2,1, 0)) as acceptedcount
	from trigger_place_instances a inner join trigger_place_instances b on a.id = b.id
	where a.userid = user_id and a.userid = b.userid
	group by week(a.instancecreated), week(b.instancecreated);
	
end
