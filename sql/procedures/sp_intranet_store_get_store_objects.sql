delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_store_get_store_objects`(
	in _store_id int(11)
)
begin

	select
		so.objectid as objectid
		,count(so.objectid) as c
		,o.objectname as objectname
		,_store_id as storeid
	from store_storeobjects so
	inner join store_objects o on so.objectid = o.id
	where so.storeid = _store_id
	group by so.objectid;

end$$

