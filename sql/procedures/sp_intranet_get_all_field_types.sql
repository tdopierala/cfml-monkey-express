CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_all_field_types`()
begin

 select
   id as id
   ,fieldtypename as fieldtypename
 from place_fieldtypes;

end
