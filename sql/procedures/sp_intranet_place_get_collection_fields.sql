delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_place_get_collection_fields`(
	in collection_id int(11)
)
begin
	select
		pif.id as collectionfieldid 
		,f.fieldname as fieldname
		,f.fieldlabel as fieldlabel
		,ft.fieldtypename as fieldtypename
		,f.id as fieldid
		,f.fieldcreated as fieldcreated
		,collection_id as collectionid
	from place_collectionfields pif
	inner join place_fields f on pif.fieldid = f.id
	inner join place_fieldtypes ft on f.fieldtypeid = ft.id
	where pif.collectionid = collection_id
	order by ord asc;
end$$

