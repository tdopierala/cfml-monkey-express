CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_all_place_file_types_by_step`(
 in step_id int(11))
begin

 select
   ft.id as id
	,sft.id as stepfiletypeid
   ,ft.filetypename as filetypename
   ,ft.filetypecreated as filetypecreated
	,step_id as stepid
 from place_stepfiletypes sft inner join place_filetypes ft on sft.filetypeid = ft.id
 where sft.stepid = step_id;

end
