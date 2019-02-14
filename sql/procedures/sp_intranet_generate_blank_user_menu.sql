CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_generate_blank_user_menu`(in t_userid int(11))
begin
declare t_menuid int(11);
declare no_more_menus int default false;
declare menus_cursor cursor for select id from menus;
declare continue handler for not found set no_more_menus = true;

open menus_cursor;
LOOP1: loop

  fetch menus_cursor into t_menuid;
  if no_more_menus then
    close menus_cursor;
    leave LOOP1;
  end if;

  insert into usermenus (userid, menuid, usermenuaccess) values (t_userid, t_menuid, 0);

  end loop LOOP1;

end
