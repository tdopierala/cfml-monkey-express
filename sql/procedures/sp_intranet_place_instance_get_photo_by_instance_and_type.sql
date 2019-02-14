delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_place_instance_get_photo_by_instance_and_type`(
	in instance_id int(11),
	in phototype_id int(11)
)
begin

	-- ipt.photobincontent as photobincontent

	select 
		ipt.id as id
		,ipt.phototypecreated as phototypecreated
		,ipt.phototypesrc as phototypesrc
		,ipt.phototypename as phototypename
		,ipt.phototypethumb as phototypethumb
		,ipt.userid as userid
		,u.givenname as givenname
		,u.sn as sn
		,u.position as position
	from place_instancephototypes ipt
	inner join users u on ipt.userid = u.id
	where ipt.instanceid = instance_id and ipt.phototypeid = phototype_id;

end$$

