delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_store_get_store_by_logo`(
	in sklep_logo varchar(12) character set utf8
)
begin
	select 
		id
		,storecreated
		,projekt
		,sklep
		,adressklepu
		,telefonkom
		,telefon
		,email
		,m2_sale_hall
		,m2_all
		,longitude
		,latitude
		,loc_mall_name
		,loc_mall_location
		,ajent
		,nazwaajenta
		,dataobowiazywaniaod
		,dataobowiazywaniado
	from store_stores
	where sklep = sklep_logo
	limit 1; 
end$$

