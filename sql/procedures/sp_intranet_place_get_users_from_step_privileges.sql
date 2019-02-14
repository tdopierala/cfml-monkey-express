delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_place_get_users_from_step_privileges`()
begin

select 
distinct sp.userid as userid
,u.givenname as givenname
,u.sn as sn
,u.position as position
from place_stepprivileges sp inner join view_users u on sp.userid = u.id;

end$$

