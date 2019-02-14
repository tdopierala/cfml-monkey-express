delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_store_get_defined_shelfs`()
begin
	select
		ss.id as id
		,ss.shelftypeid as shelftypeid
		,ss.shelfcategoryid as shelfcategoryid
		,c.shelfcategoryname as shelfcategoryname
		,t.shelftypename as shelftypename
	from store_shelfs ss
	inner join store_shelftypes t on ss.shelftypeid = t.id
	inner join store_shelfcategories c on ss.shelfcategoryid = c.id;
end$$

