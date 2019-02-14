CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_all_place_steps_selectbox`()
begin

 select
   s.id as id
   ,s.stepname as stepname
 from
   place_steps s;

end
