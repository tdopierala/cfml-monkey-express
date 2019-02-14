delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_place_get_all_collections_to_selectbox`()
begin
	select 
		c.id as id
		,c.collectionname as collectionname
	from place_collections c;
end$$

