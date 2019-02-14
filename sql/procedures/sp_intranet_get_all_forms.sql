CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_all_forms`()
begin

 select
   id as formid
   ,formname as formname
   ,(select count(id) from form_formfields ff where ff.formid = f.id) as fieldcount
 from form_forms f;

end
