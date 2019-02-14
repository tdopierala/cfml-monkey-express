CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_forms_by_step`(
 in step_id int(11)
)
begin

 select 
 	sf.id as stepformid
   ,f.formname as formname
   ,f.formdescription as formdescription
   ,f.formcreated as formcreated
   ,f.id as id
   ,(select count(id) from place_formfields ff where ff.formid = f.id) as fieldcount
	,step_id as stepid
 from place_stepforms sf
 inner join place_forms f on sf.formid = f.id
 where sf.stepid = step_id;

end
