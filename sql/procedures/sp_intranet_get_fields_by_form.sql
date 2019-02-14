CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_fields_by_form`(
 in form_id int(11))
begin

 select
   f.id as id
   ,f.fieldname as fieldname
   ,f.fieldlabel as fieldlabel
   ,f.fieldcreated as fieldcreated
   ,ft.fieldtypename as fieldtypename
	,ff.ord as ord
	,ff.id as formfieldid
	,ff.required as required
 from place_formfields ff 
 	inner join place_fields f on ff.fieldid = f.id 
	inner join place_fieldtypes ft on f.fieldtypeid = ft.id
 where ff.formid = form_id
 order by ff.ord asc;  

end
