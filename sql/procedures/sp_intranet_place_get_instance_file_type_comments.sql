delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_place_get_instance_file_type_comments`(
	in instancefiletype_id int(11)
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
		place_instancefiletypecomments c
		inner join view_users u on c.userid = u.id
	where c.instancefiletypeid = instancefiletype_id
	order by c.commentcreated desc;
end$$

