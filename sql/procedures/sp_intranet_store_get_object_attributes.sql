delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_store_get_object_attributes`(
	in _object_id int(11)
)
begin
	select
		_object_id as objectid
		,a.attributename as attributename
		,o.attributeid as attributeid
	from store_objectattributes o
	inner join store_attributes a on o.attributeid = a.id
	where o.objectid = _object_id;
end$$

