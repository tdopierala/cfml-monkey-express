delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_store_get_store_object_instances`(
	in _object_id int(11),
	in _store_id int(11)
)
begin
	select
		so.objectinstanceid as objectinstanceid
		,so.userid as userid
		,_object_id as objectid
		,_store_id as storeid
		,o.objectname as objectname
		,u.givenname as givenname
		,u.sn as sn
		,so.created as created
	from store_storeobjects so
	inner join store_objects o on so.objectid = o.id
	inner join users u on so.userid = u.id
	where so.objectid = _object_id and so.storeid = _store_id;
end$$

