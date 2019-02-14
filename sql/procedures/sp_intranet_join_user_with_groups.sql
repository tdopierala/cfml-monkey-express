delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_join_user_with_groups`(
 in user_id int(11))
begin

 declare group_id int(11);
 declare no_more_groups int default false;
 declare cursor_groups cursor for select id from groups;
 declare continue handler for not found set no_more_groups = true;

 open cursor_groups;
 LOOP1:loop
   fetch cursor_groups into group_id;
   if no_more_groups then
     close cursor_groups;
     leave LOOP1;
   end if;

   insert into usergroups (groupid, userid) value(group_id, user_id);

 end loop LOOP1;

end$$

