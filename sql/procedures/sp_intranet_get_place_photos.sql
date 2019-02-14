delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_place_photos`(
 in place_id int(11))
begin
  select
   pf.id as id
   ,f.id as fileid
   ,f.filename as filename
   ,f.filesrc as filesrc
   -- ,f.filebinary as filebinary
   ,pfc.placefilecategoryname as placefilecategoryname
   ,pf.toexport as toexport
 from placefiles pf 
 inner join files f on pf.fileid = f.id 
 inner join placefilecategories pfc on pf.placefilecategoryid = pfc.id
 where pf.placeid = place_id and pfc.isimage = 1;
end$$

