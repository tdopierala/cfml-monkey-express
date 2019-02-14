CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_all_user_place_instance_stats_by_week`(
	in date_start varchar(12),
	in date_stop varchar(12)
)
begin

	select
a.userid as userid,
u.givenname as givenname,
u.sn as sn,
		
makedate(Year(Now()), (week(a.instancecreated)-1)*7) as startdate,
makedate(Year(Now()), week(a.instancecreated)*7) as stopdate,

count(a.id) as totalcount,
sum(if(b.instancestatusid=2,1, 0)) as acceptedcount

from trigger_place_instances a inner join trigger_place_instances b on a.id = b.id inner join users u on a.userid = u.id
where makedate(Year(Now()), (week(a.instancecreated)-1)*7) >= date_start and
makedate(Year(Now()), week(a.instancecreated)*7) <= date_stop

group by a.userid, b.userid;

end
