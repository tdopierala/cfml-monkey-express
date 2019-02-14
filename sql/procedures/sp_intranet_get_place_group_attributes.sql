delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_place_group_attributes`(
  in place_id int(11),
  in group_id int(11))
begin
   select
     a.attributetypeid as attributetypeid
     ,a.attributename as attributename
     ,a.id as attributeid
     ,a.attributerequired as attributerequired
     ,pav.id as placeattributevalueid
     ,pav.placeid as placeid
     ,pav.placeattributevaluetext as placeattributevaluetext
     ,pav.placeattributevaluebinary as placeattributevaluebinary
     ,pag.groupid as groupid
   from
     placeattributevalues pav inner join attributes a on pav.attributeid=a.id
     inner join placeattributegroups pag on pag.groupid = group_id
   where pav.placeid=place_id and pag.attributeid=a.id
   order by pag.ord asc; 
end$$

