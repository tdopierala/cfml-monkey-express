CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_all_place_file_types`()
begin
 select
   ft.id as id
   ,ft.filetypename as filetypename
   ,ft.filetypecreated as filetypecreated
 from place_filetypes ft;
end
