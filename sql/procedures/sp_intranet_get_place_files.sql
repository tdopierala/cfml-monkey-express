CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_place_files`(
 in place_id int(11))
begin

select 
 u.id as userid
, u.givenname as givenname
, u.sn as sn
, u.mail as mail
, f.filename as filename
, f.id as fileid
, f.filecreated as filecreated
, pfc.placefilecategoryname as placefilecategoryname
from placefiles as pf
inner join files f on pf.fileid = f.id
inner join placefilecategories pfc on pfc.id = pf.placefilecategoryid
inner join users u on u.id = f.userid
where pf.placeid = place_id;

end

