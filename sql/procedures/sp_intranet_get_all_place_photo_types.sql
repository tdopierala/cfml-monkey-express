CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_all_place_photo_types`()
begin

 select
   p.id as id
   ,p.phototypename as phototypename
   ,p.phototypecreated as phototypecreated
 from place_phototypes p;

end
