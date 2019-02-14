delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_place_get_collection_instance_field_value_comments`(
	in collectioninstancevalue_id int(11)
)
begin
	select
		civc.comment as comment
		,civc.commentcreated as commentcreated
		,civc.id as id
		,civc.userid as userid
		,u.givenname as givenname
		,u.sn as sn
		,u.position as position
	from place_collectioninstancevaluecomments civc
		inner join view_users u on civc.userid = u.id
	where civc.collectioninstancevalueid = collectioninstancevalue_id
	order by civc.commentcreated desc;
end$$

