delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_place_get_collection_instance_comments`(
	in collectioninstance_id int(11)
)
begin

	select
		c.collectioninstanceid as collectioninstanceid
		,c.instanceid as instanceid
		,c.collectionid as collectionid
		,c.comment as comment
		,c.commentcreated as commentcreated
		,c.userid as userid
		,u.givenname as givenname
		,u.sn as sn
		,u.position as position
	from place_collectioninstancecomments c
		inner join view_users u on c.userid = u.id
	where c.collectioninstanceid = collectioninstance_id
	order by c.commentcreated desc;

end$$

