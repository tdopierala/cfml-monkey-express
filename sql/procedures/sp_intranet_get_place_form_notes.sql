CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_place_form_notes`(
	in form_id int(11),
	in instance_id int(11)
)
begin
	select
		u.givenname as givenname
		,u.sn as sn
		,f.formnote as formnote
		,f.created as created
	from place_forminstancenotes f inner join users u on f.userid = u.id
	where f.formid = form_id and f.instanceid = instance_id
	order by f.created desc;
end
