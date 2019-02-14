CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_create_blank_place_attributes`(
 in newPlaceId int(11))
begin

 declare attribute_id int(11);
 declare no_more_place_attributes int default false;
 declare place_attribute_cursor cursor for select attributeid from placeattributes;
 declare continue handler for not found set no_more_place_attributes = true;

 open place_attribute_cursor;
 LOOP1: loop
   fetch place_attribute_cursor into attribute_id;
   if no_more_place_attributes then
     close place_attribute_cursor;
     leave LOOP1;
   end if;

   insert into placeattributevalues (placeid, attributeid) values (newPlaceId, attribute_id);

 end loop LOOP1;

end
