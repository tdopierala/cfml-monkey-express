delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_store_get_store_planograms`(
	in _search varchar(255) character set utf8,
	in _shelf_id int(11),
	in _location varchar(255) character set utf8
)
begin
	
	if _shelf_id <> 0 then
		set @qry = CONCAT('select
			distinct 
			p.id as planogramid
			,p.note as note
			,p.created as created
		from store_stores s
		inner join store_storeshelfs ss on s.id = ss.storeid
		inner join store_storeplanograms sp on sp.storeid = s.id
		inner join store_planograms p on sp.planogramid = p.id
		where (loc_mall_name is null or loc_mall_name like "%', _location, '%") and (loc_mall_location like "%', _search, '%" or projekt like "%', _search ,'%" or adressklepu like "%', _search ,'%" or nazwaajenta like "%', _search ,'%" or ajent like "%', _search ,'%" or sklep like "%', _search ,'%") and ss.shelfid = ', _shelf_id ,' order by projekt asc');
	
	else
	
		set @qry = CONCAT('select
	    	distinct 
			p.id as planogramid
			,p.note as note
			,p.created as created
		from store_stores s
		inner join store_storeplanograms sp on sp.storeid = s.id
		inner join store_planograms p on sp.planogramid = p.id
		where (s.loc_mall_name is null or s.loc_mall_name like "%', _location, '%") and (s.loc_mall_location like "%', _search, '%" or s.projekt like "%', _search ,'%" or s.adressklepu like "%', _search ,'%" or s.nazwaajenta like "%', _search ,'%" or s.ajent like "%', _search ,'%" or s.sklep like "%', _search ,'%") order by s.projekt asc');
	
	end if;

	PREPARE stmt FROM @qry; 
	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt;

end$$

