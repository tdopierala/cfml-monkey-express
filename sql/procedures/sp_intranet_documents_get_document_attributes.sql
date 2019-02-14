CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_documents_get_document_attributes`(
	in document_id int(1)
)
begin

	select 
		a.attributename as attributename
		,a.attributetypeid as attributetypeid
		,at.typename as typename
		,dav.id as documentattributevalueid
		,dav.documentid as documentid
		,dav.attributeid as attributeid
		,dav.documentattributetextvalue
	from documentattributes d
	inner join documentattributevalues dav on d.attributeid = dav.attributeid
	inner join attributes a on d.attributeid = a.id
	inner join attributetypes at on a.attributetypeid = at.id
	where dav.documentid = document_id and documentattributevisible=1;

end
