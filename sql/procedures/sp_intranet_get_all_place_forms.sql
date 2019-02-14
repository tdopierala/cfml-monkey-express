CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_all_place_forms`()
begin

 select 
   f.id as id
   ,f.formname as formname
   ,f.formdescription as formdescription
   ,(select count(id) from place_formfields where formid = f.id) as fieldcount
   ,f.formcreated as formcreated
	,f.def as def
 from place_forms f;

end
