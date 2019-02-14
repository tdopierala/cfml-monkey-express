delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_place_report_get_group_fields`(
	in group_id int(11)
)
begin
	select
		f.id as fieldid
		,f.fieldname as fieldname
		,f.fieldlabel as fieldlabel
		,fg.id as fieldgroupid
		,fg.groupid as groupid
		,fg.access as access
		,fg.formid as formid
	from place_fieldgroups fg
	inner join place_fields f on fg.fieldid = f.id
	where fg.groupid = group_id;
end$$

