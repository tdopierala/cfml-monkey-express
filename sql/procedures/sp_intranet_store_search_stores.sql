delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_store_search_stores`(
	in _search varchar(64) character set utf8
)
begin
	set @qry = CONCAT('select
   	id as id
		,projekt as projekt
		,adressklepu as adressklepu
	from store_stores
	where adressklepu like "%', _search ,'%" or nazwaajenta like "%', _search ,'%" or ajent like "%', _search ,'%" or sklep like "%', _search ,'%"');

	PREPARE stmt FROM @qry; 
	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt;
end$$

