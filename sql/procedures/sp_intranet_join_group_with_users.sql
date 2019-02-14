delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_join_group_with_users`(
 in group_id int(11))
begin

 declare user_id int(11);
 declare no_more_users int default false;
 declare cursor_users cursor for select id from users;
 declare continue handler for not found set no_more_users = true;

 open cursor_users;
 LOOP1:loop
   fetch cursor_users into user_id;
   if no_more_users then
     close cursor_users;
     leave LOOP1;
   end if;

   insert into usergroups (groupid, userid) value(group_id, user_id);

 end loop LOOP1;

end$$

