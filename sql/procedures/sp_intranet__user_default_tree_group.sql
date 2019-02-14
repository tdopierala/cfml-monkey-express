CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet__user_default_tree_group`(
	in t_groupid int(11)
)
begin
 declare t_userid int(11);
 declare no_more_users int default false;
 declare users_cursor cursor for select id from users where partner_prowadzacy_sklep = 1;
 declare continue handler for not found set no_more_users = true;
	
 delete from tree_groupusers where groupid = t_groupid;

 open users_cursor;
 LOOP1: loop

   fetch users_cursor into t_userid;
   if no_more_users then
     close users_cursor;
     leave LOOP1;
   end if;

   insert into tree_groupusers (groupid, userid) values (t_groupid, t_userid);

 end loop LOOP1;

end
