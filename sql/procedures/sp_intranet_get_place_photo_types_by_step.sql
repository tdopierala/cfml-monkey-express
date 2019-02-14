delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_place_photo_types_by_step`(
 in step_id int(11))
begin

 select
   pt.id as id
   ,pt.phototypename as phototypename
   ,pt.phototypecreated as phototypecreated
 from place_stepphototypes spt inner join place_phototypes pt on spt.phototypeid = pt.id
 where spt.stepid = step_id;

end$$

