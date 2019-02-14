delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_store_get_object_instance`(
	in _instance_id int(11)
)
begin
	
	select
		a.attributename as attributename
		,oiv.value as value
		,oiv.objectid as objectid
		,oiv.attributeid as attributeid
		,oiv.objectinstanceid as objectinstanceid
	from store_objectinstancevalues oiv
	inner join store_attributes a on oiv.attributeid = a.id
	where oiv.objectinstanceid = _instance_id;
	
end$$

