CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_add_blank_place_attribute`(
 in attribute_id int(11))
begin

 -- start transaction;

 insert into placeattributes (attributeid, placeattributevisible) value (attribute_id, 0);

 /*BLOCK1: begin
   declare place_id int(11);
   declare no_more_places int default false;
   declare cursor_places cursor for select id from places;
   declare continue handler for not found set no_more_places = true;

   open cursor_places;

     LOOP1: loop
       fetch cursor_places into place_id;
       if no_more_places then
         close cursor_places;
         leave LOOP1;
       end if;

     insert into placeattributevalues (attributeid, placeid) value (attribute_id, place_id);

     end loop LOOP1;

 end BLOCK1;*/

 -- commit;

end
