CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_assign_user_to_menu_item`(in t_menuid int(11))
begin
 declare t_userid int(11);
 declare no_more_users int default false;
 declare users_cursor cursor for select id from users;
 declare continue handler for not found set no_more_users = true;

 open users_cursor;
 LOOP1: loop

   fetch users_cursor into t_userid;
   if no_more_users then
     close users_cursor;
     leave LOOP1;
   end if;

   insert into usermenus (userid, menuid, usermenuaccess) values (t_userid, t_menuid, 0);

 end loop LOOP1;

end
