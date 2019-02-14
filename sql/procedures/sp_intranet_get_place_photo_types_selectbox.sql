delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_place_photo_types_selectbox`()
begin

 select
   p.id as id
   ,p.phototypename as phototypename
 from place_phototypes p;

end$$

