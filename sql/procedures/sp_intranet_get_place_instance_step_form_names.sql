delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_place_instance_step_form_names`(
 in instance_id int(11),
 in step_id int(11)
)
begin

 select
   sf.id as placestepformid
   ,step_id as step_id
   ,instance_id as instance_id
   ,f.formname as formname
   ,f.id as formid
   ,(select count(id) from place_instanceforms pif where pif.instanceid = instance_id and pif.formid = f.id) as allfields
   ,(select count(id) from place_instanceforms pif2 where pif2.instanceid = instance_id and pif2.formid = f.id and pif2.formfieldvalue <> '') as filledfield
	,(select sum(accepted) from place_instanceforms pif3 where pif3.instanceid = instance_id and pif3.formid =f.id) as accepted
 from place_stepforms sf
 inner join place_forms f on sf.formid = f.id
 where sf.stepid = step_id;

end$$

