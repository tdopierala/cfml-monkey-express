delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_place_get_user_collections_from_privileges`(
	in user_id int(11)
)
begin

	select 
		cp.id as id
		,cp.readprivilege as readprivilege
		,cp.writeprivilege as writeprivilege
		,cp.collectionid as collectionid
		,c.collectionname as collectionname
	from place_collectionprivileges cp inner join place_collections c on cp.collectionid = c.id
	where cp.userid = user_id;

end$$

