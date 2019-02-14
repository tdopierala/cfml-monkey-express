CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_join_group_with_rules`(
 in group_id int(11))
begin

 declare rule_id int(11);
 declare no_more_rules int default false;
 declare cursor_rules cursor for select id from rules;
 declare continue handler for not found set no_more_rules = true;

 open cursor_rules;
 LOOP1:loop
   fetch cursor_rules into rule_id;
   if no_more_rules then
     close cursor_rules;
     leave LOOP1;
   end if;

   insert into grouprules (groupid, ruleid) value (group_id, rule_id);

 end loop LOOP1;

end
