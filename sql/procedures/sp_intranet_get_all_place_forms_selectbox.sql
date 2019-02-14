CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_all_place_forms_selectbox`()
begin

 select
   f.id as id
   ,f.formname as formname
 from place_forms f;

end
