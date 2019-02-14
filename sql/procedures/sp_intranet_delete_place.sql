CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_delete_place`(
 in place_id int(11))
begin

 delete from places where id = place_id;
 delete from placeworkflows where placeid = place_id;
 delete from placefiles where placeid = place_id;
 delete from placeattributevalues where placeid = place_id;

end
