CREATE DEFINER=`intranet`@`%` PROCEDURE `intranet_users_getfulltree`()
begin

 start transaction;

 select 
   id,
   active, 
   login, 
   photo, 
   departmentid, 
   givenname, 
   sn, 
   mail, 
   samaccountname, 
   departmentname, 
   lft, 
   rgt, 
   parent_id,
   position,
   (select count(parent.id)-1 from view_users as parent where node.lft between parent.lft and parent.rgt) as depth
 from view_users as node
 where node.lft != 0 and node.rgt != 0
 order by node.lft;

 commit;
end