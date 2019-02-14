CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_place_combined_group_attributes`(
  in place_id int(11),
  in where_cond varchar(255))
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
     inner join placeattributegroups pag on pag.attributeid = pav.attributeid
   where pav.placeid=place_id and pag.groupid in (where_cond)
   order by a.ord asc; 
end
