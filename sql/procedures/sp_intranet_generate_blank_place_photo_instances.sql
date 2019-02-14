CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_generate_blank_place_photo_instances`(
 in instance_id int(11),
 in step_id int(11)
)
begin
 declare phototype_id int(11);
 declare no_more_photos int default false;
 declare photo_cursor cursor for select distinct id from place_phototypes;
 declare continue handler for not found set no_more_photos = true;
 open photo_cursor;
 LOOP1: loop
 fetch photo_cursor into phototype_id;
 if no_more_photos then
   close photo_cursor;
   leave LOOP1;
   end if;
 insert into place_instancephototypes (instanceid, phototypeid) values (instance_id, phototype_id); 
 end loop LOOP1;
end
