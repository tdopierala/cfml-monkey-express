delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_place_get_all_collections`()
begin
	select 
		c.id as id
		,c.collectionname as collectionname
		,c.collectiondescription as collectiondescription
		,c.collectioncreated as collectioncreated
		,c.userid as userid
		,u.givenname as givenname
		,u.sn as sn
		,u.position as position
	from place_collections c 
	inner join users u on c.userid = u.id;
end$$

