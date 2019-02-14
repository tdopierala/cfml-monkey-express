delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_store_get_all_stores`(
	in _location varchar(64) character set utf8,
	in _search varchar(255) character set utf8,
	in _page int(5),
	in _elements int(4),
	in _shelf_id int(11)
)
begin

	set @a = (_page-1)*_elements;
	
	if _shelf_id <> 0 then
		set @qry = CONCAT('select
			s.id as id
			,s.storecreated as storecreated
			,s.projekt as projekt
			,s.sklep as sklep
			,s.adressklepu as adressklepu
			,s.telefonkom as telefonkom
			,s.telefon as telefon
			,s.email as email
			,s.m2_sale_hall as m2_sale_hall
			,s.m2_all as m2_all
			,s.longitude as longitude
			,s.latitude as latitude
			,s.loc_mall_name as loc_mall_name
			,s.loc_mall_location as loc_mall_location
			,s.ajent as ajent
			,s.nazwaajenta as nazwaajenta
			,s.dataobowiazywaniaod as dataobowiazywaniaod
			,s.dataobowiazywaniado as dataobowiazywaniado
		from store_stores s
		inner join store_storeshelfs ss on s.id = ss.storeid
		where (loc_mall_name is null or loc_mall_name like "%', _location, '%") and (loc_mall_location like "%', _search, '%" or projekt like "%', _search ,'%" or adressklepu like "%', _search ,'%" or nazwaajenta like "%', _search ,'%" or ajent like "%', _search ,'%" or sklep like "%', _search ,'%") and ss.shelfid = ', _shelf_id ,' order by projekt asc limit ', @a, ', ', _elements);
	
	else
	
		set @qry = CONCAT('select
	    	id as id
			,storecreated as storecreated
			,projekt as projekt
			,sklep as sklep
			,adressklepu as adressklepu
			,telefonkom as telefonkom
			,telefon as telefon
			,email as email
			,m2_sale_hall as m2_sale_hall
			,m2_all as m2_all
			,longitude as longitude
			,latitude as latitude
			,loc_mall_name as loc_mall_name
			,loc_mall_location as loc_mall_location
			,ajent as ajent
			,nazwaajenta as nazwaajenta
			,dataobowiazywaniaod as dataobowiazywaniaod
			,dataobowiazywaniado as dataobowiazywaniado
		from store_stores
		where (loc_mall_name is null or loc_mall_name like "%', _location, '%") and (loc_mall_location like "%', _search, '%" or projekt like "%', _search ,'%" or adressklepu like "%', _search ,'%" or nazwaajenta like "%', _search ,'%" or ajent like "%', _search ,'%" or sklep like "%', _search ,'%") order by projekt asc limit ', @a, ', ', _elements);
	
	end if;

	PREPARE stmt FROM @qry; 
	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt;

end$$

