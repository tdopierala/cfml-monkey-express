delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_store_get_stores_count`(
	in _location varchar(64) character set utf8,
	in _search varchar(255) character set utf8,
	in _shelf_id int(11)
)
begin
	
	if _shelf_id <> 0 then
	
		set @qry = CONCAT('select
   		count(s.id) as c
		from store_stores s
		inner join store_storeshelfs ss on s.id = ss.storeid
		where (s.loc_mall_name is null or s.loc_mall_name like "%', _location, '%") and (s.loc_mall_location like "%', _search, '%" or s.projekt like "%', _search ,'%" or s.adressklepu like "%', _search ,'%" or s.nazwaajenta like "%', _search ,'%" or s.ajent like "%', _search ,'%" or s.sklep like "%', _search ,'%") and ss.shelfid = ', _shelf_id);
	
	else
	
		set @qry = CONCAT('select
   		count(id) as c
		from store_stores
		where (loc_mall_name is null or loc_mall_name like "%', _location, '%") and (loc_mall_location like "%', _search, '%" or projekt like "%', _search ,'%" or adressklepu like "%', _search ,'%" or nazwaajenta like "%', _search ,'%" or ajent like "%', _search ,'%" or sklep like "%', _search ,'%")');
	
	end if;

	PREPARE stmt FROM @qry; 
	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt;

end$$

