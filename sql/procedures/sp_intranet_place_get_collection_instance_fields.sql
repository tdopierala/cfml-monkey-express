delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_place_get_collection_instance_fields`(
in collectioninstance_id int(11)
)
begin

select 
ci.id as id
,ci.collectionid as collectionid
,ci.instanceid as instanceid
,ci.collectioninstanceid as collectioninstanceid
,ci.fieldid as fieldid
,ci.fieldvalue as fieldvalue
,ci.fieldbinarythumb as fieldbinarythumb
,ci.fieldbinarysrc as fieldbinarysrc
,f.fieldname
,f.fieldtypeid as fieldtypeid
,(select count(id) from place_collectioninstancevaluecomments ccc where ccc.collectioninstancevalueid = ci.id) as commentscount
,f.fieldmask as fieldmask
,f.fieldrate as fieldrate
,f.fieldrequired as fieldrequired
from place_collectioninstancevalues ci
inner join place_fields f on ci.fieldid = f.id
inner join place_collectionfields cf on (cf.fieldid = f.id and cf.collectionid = ci.collectionid)
where ci.collectioninstanceid = collectioninstance_id
order by cf.ord asc;

end$$

