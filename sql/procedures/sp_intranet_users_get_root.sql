delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_users_get_root`()
begin

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
   level,
   position,
   size
 from view_users
 where lft = 1;

end$$

