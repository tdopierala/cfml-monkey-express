delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_store_get_all_attribute_types`()
begin
	select
		id as id
		,typename as typename
	from store_attributetypes;
end$$

