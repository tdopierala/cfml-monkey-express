CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_add_blank_store_attribute`(
in attribute_id int(11)
)
begin
 insert into store_storeattributes (attributeid, storeattributevisible) values (attribute_id, 0);
end
