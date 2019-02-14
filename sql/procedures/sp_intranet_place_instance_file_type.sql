delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_place_instance_file_type`(
	in instance_id int(11),
	in filetype_id int(11)
)
begin 
select
	ift.id as id 
	,ift.instanceid as instanceid
	,ift.fileid as fileid
	,ift.filetypeid as filetypeid
	,ft.filetypename as filetypename
	,ift.filesrc as filesrc
	,ift.filename as filename
	,ift.userid as userid
	,ift.filetypedescription as filetypedescription
	,u.givenname as givenname
	,u.sn as sn
	,u.position as position
	,ift.filecreated as filecreated
	,ift.filetypethumb as filetypethumb
	,(select count(id) from place_instancefiletypecomments a where a.instancefiletypeid = ift.id) as commentscount
from place_instancefiletypes ift
inner join place_filetypes ft on ift.filetypeid = ft.id
inner join view_users u on ift.userid = u.id
where ift.filetypeid = filetype_id and ift.instanceid = instance_id;
end$$

