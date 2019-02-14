CREATE DEFINER=`intranet`@`%` PROCEDURE `p_generateusermenu`()
begin

 start transaction;

   BLOCK1: begin

     declare l_userid int(11);
     declare no_more_users int default false;
     declare user_cursor cursor for select id from users;
     declare continue handler for not found set no_more_users = true;

     open user_cursor;

       LOOP1: loop
         fetch user_cursor into l_userid;
         if no_more_users then
           close user_cursor;
           leave LOOP1;
         end if;

           BLOCK2: begin

             declare l_menuid int(11);
             declare no_more_menus int default false;
             declare menu_cursor cursor for select id from menus;
             declare continue handler for not found set no_more_menus = true;

             open menu_cursor;
             LOOP2: loop
               fetch menu_cursor into l_menuid;
               if no_more_menus then
                 close menu_cursor;
                 leave LOOP2;
               end if;

               insert into usermenus (userid, menuid, usermenuaccess) values (l_userid, l_menuid, 0);

             end loop LOOP2;

           end BLOCK2;

       end loop LOOP1;

   END BLOCK1;

 commit;

end
