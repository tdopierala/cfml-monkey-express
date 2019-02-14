delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_store_get_shelf_stores`(
	in _shelf_id int(11)
)
begin
	select
		distinct
		s.projekt as projekt
		,s.adressklepu as adressklepu
	from store_storeshelfs ss
	inner join store_stores s on ss.storeid = s.id
	where ss.shelfid = _shelf_id;
end$$

