delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_store_get_store_shelfs`(
	in _store_id int(11)
)
begin
	select 
		sc.shelfcategoryname as shelfcategoryname
		,st.shelftypename as shelftypename
		,count(ss.shelfid) as c
		,ss.shelfid as shelfid
	from store_storeshelfs ss
	inner join store_shelfs s on ss.shelfid = s.id
	inner join store_shelfcategories sc on s.shelfcategoryid = sc.id
	inner join store_shelftypes st on s.shelftypeid = st.id
	where ss.storeid = _store_id
	group by ss.shelfid;
end$$

