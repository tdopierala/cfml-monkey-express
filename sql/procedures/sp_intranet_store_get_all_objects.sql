delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_store_get_all_objects`()
begin
	select
		o.id as id
		,o.objectname as objectname
	from store_objects o;
end$$

