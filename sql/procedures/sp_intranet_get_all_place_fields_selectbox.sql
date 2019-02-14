CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_all_place_fields_selectbox`()
begin

 select
   f.id as id
   ,f.fieldname as fieldname
 from place_fields f;

end
