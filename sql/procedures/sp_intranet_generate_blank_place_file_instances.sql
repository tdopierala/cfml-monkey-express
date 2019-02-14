CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_generate_blank_place_file_instances`(
 in instance_id int(11),
 in step_id int(11)
)
begin
 declare filetype_id int(11);
 declare no_more_files int default false;
 declare file_cursor cursor for select distinct id from place_filetypes;
 declare continue handler for not found set no_more_files = true;
 open file_cursor;
 LOOP1: loop
   fetch file_cursor into filetype_id;
   if no_more_files then
     close file_cursor;
     leave LOOP1;
   end if;
   insert into place_instancefiletypes (instanceid, filetypeid) values (instance_id, filetype_id);
 end loop LOOP1;
end
