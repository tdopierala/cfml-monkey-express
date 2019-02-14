delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_place_get_users_from_collection_privileges`()
begin

select 
distinct fp.userid as userid
,u.givenname as givenname
,u.sn as sn
,u.position as position
from place_collectionprivileges fp inner join view_users u on fp.userid = u.id;

end$$

