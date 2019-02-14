delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_place_instance_step_file_types`(
	in instance_id int(11),
	in step_id int(11)
)
begin

select
   sf.id as placestepfileid
   ,step_id as step_id
   ,instance_id as instance_id
   ,f.filetypename as filetypename
   ,f.id as filetypeid
   ,(select count(id) from place_instancefiletypes ift where ift.instanceid = instance_id and ift.filetypeid = f.id) as filescount
 from place_stepfiletypes sf
 inner join place_filetypes f on sf.filetypeid = f.id
 where sf.stepid = step_id;

end$$

