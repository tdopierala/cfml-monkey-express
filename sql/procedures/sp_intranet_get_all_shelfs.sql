CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_all_shelfs`()
begin

 select
   s.id as shelfid
   ,s.shelftypeid as shelftypeid
   ,s.shelfcategoryid as shelfcategoryid
   ,st.shelftypename as shelftypename
   ,sc.shelfcategoryname as shelfcategoryname
 from store_shelfs s
 inner join store_shelftypes st on s.shelftypeid = st.id
 inner join store_shelfcategories sc on s.shelfcategoryid = sc.id;

end
