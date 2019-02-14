delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_place_field_get_selectbox_type_values`(
	in field_id int(11)
)
begin
	select fieldvalue as id, fieldvalue as val from place_fieldvalues where fieldid = field_id; 
end$$

