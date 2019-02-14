delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_place_get_collection_per_place_instances_list`(
	in instance_id int(11),
	in collection_id int(11))
begin
	select
		ci.id as id
		,ci.instancecreated as instancecreated
		,ci.userid as userid
		,u.givenname as givenname
		,u.sn as sn
		,u.position as position
	from
		place_collectioninstances ci
	inner join view_users u on ci.userid = u.id
	where ci.instanceid = instance_id and ci.collectionid = collection_id;
end$$

