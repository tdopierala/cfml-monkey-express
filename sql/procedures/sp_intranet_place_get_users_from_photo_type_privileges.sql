delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_place_get_users_from_photo_type_privileges`()
begin

select 
distinct pp.userid as userid
,u.givenname as givenname
,u.sn as sn
,u.position as position
from place_phototypeprivileges pp inner join view_users u on pp.userid = u.id;

end$$

