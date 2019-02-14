delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_place_get_instance_users`(
	in instance_id int(11)
)
begin
	select 
		distinct
		u.givenname as givenname
		,u.sn as sn
		,u.position as position
		,u.mail as mail
		,u.tel1 as phone
		,u.mob as mob
		,u.photo as photo
		,p.userid as userid
		,p.instanceid as instanceid
	from place_participants p
	inner join view_users u on p.userid = u.id
	where p.instanceid = instance_id;
end$$

