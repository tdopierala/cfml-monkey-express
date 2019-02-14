delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_place_report`(
	in instance_id int(11),
	in group_id int(11)
)
begin
	select
		f.fieldname as fieldname
		,pif.formfieldvalue as fieldvalue
	from place_fieldgroups pfg
	inner join place_fields f on pfg.fieldid = f.id
	inner join place_instanceforms pif on pif.formfieldid = f.id
	where pif.instanceid = instance_id and pfg.groupid = group_id and pfg.access = 1 and pif.formid = pfg.formid;
end$$

