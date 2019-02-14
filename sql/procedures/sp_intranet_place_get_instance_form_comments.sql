delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_place_get_instance_form_comments`(
	in instanceform_id int(11)
)
begin
	select
		c.comment as comment
		,c.commentcreated as commentcreated
		,c.userid as userid
		,u.givenname as givenname
		,u.sn as sn
		,u.position as position
	from
		place_instanceformcomments c
		inner join view_users u on c.userid = u.id
	where c.instanceformid = instanceform_id
	order by c.commentcreated desc;
end$$

