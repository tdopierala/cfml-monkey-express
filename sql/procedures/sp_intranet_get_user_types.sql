delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_user_types`(
 in user_id int(11))
begin

 select id, typename from types where groupid in (select groupid from usergroups where userid = user_id and access = 1) order by ord asc;

end$$

