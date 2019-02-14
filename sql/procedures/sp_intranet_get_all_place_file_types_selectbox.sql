CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_all_place_file_types_selectbox`()
begin
 select
   ft.id as id
   ,ft.filetypename as filetypename
 from place_filetypes ft;
end
