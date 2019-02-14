CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_all_place_form_fields`()
begin

 select
   f.id as id
   ,f.fieldname as fieldname
   ,f.fieldlabel as fieldlabel
   ,f.fieldcreated as fieldcreated
   ,ft.fieldtypename as fieldtypename
 from place_fields f inner join place_fieldtypes ft on f.fieldtypeid = ft.id;

end
