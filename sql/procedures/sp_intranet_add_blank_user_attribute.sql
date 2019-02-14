CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_add_blank_user_attribute`(
in attribute_id int(11))
begin

 -- start transaction;

 insert into userattributes (attributeid, visible) value (attribute_id, 0);

 /*BLOCK1: begin

 declare user_id int(11);
 declare no_more_users int default false;
 declare cursor_users cursor for select id from users;
 declare continue handler for not found set no_more_users = true;

 open cursor_users;
 LOOP1: loop
   fetch cursor_users into user_id;
   if no_more_users then
     close cursor_users;
     leave LOOP1;
   end if;
   insert into userattributevalues (attributeid, userid) value (attribute_id, user_id);
 end loop LOOP1;

 end BLOCK1;*/

 -- commit;

end