delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_store_get_all_attributes`()
begin
	select
		a.id as id
		,a.attributename as attributename
		,at.typename as typename
	from store_attributes a 
	inner join store_attributetypes at on a.attributetypeid = at.id;
end$$

