delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_store_get_stores_to_planograms`(
	in _search varchar(255) character set utf8,
	in _shelf_id int(11),
	in _location varchar(255) character set utf8
)
begin
	
	if _shelf_id <> 0 then
		set @qry = CONCAT('select
			s.id as id
			,s.projekt as projekt
			,s.sklep as sklep
			,s.adressklepu as adressklepu
		from store_stores s
		inner join store_storeshelfs ss on s.id = ss.storeid
		where (loc_mall_name is null or loc_mall_name like "%', _location, '%") and (loc_mall_location like "%', _search, '%" or projekt like "%', _search ,'%" or adressklepu like "%', _search ,'%" or nazwaajenta like "%', _search ,'%" or ajent like "%', _search ,'%" or sklep like "%', _search ,'%") and ss.shelfid = ', _shelf_id ,' order by projekt asc');
	
	else
	
		set @qry = CONCAT('select
	    	id as id
			,projekt as projekt
			,sklep as sklep
			,adressklepu as adressklepu
		from store_stores
		where (loc_mall_name is null or loc_mall_name like "%', _location, '%") and (loc_mall_location like "%', _search, '%" or projekt like "%', _search ,'%" or adressklepu like "%', _search ,'%" or nazwaajenta like "%', _search ,'%" or ajent like "%', _search ,'%" or sklep like "%', _search ,'%") order by projekt asc');
	
	end if;

	PREPARE stmt FROM @qry; 
	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt;

end$$

