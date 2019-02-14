delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_store_get_localizations_selectbox`(
)
begin
	select distinct loc_mall_name from store_stores;
end$$

