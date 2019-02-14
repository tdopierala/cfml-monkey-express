delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_workflow_get_all_documents_in_workflow_v2`(
	in _year int(4),
	in _month int(4),
	in _step int(4),
	in _page int(4),
	in _elements int(4)
)
begin

	set @a = (_page-1)*_elements;
	
	set @qry = CONCAT('select 
		t.workflowid as workflowid
		,t.workflowcreated as workflowcreated
		,t.documentname as documentname
		,t.stepdescriptionid as stepdescriptionid
		,t.stepdescriptiondraft as stepdescriptiondraft
		,t.stepcontrollingid as stepcontrollingid
		,t.stepcontrollingdraft as stepcontrollingdraft
		,t.stepapproveid as stepapproveid
		,t.stepapproveddraft as stepapproveddraft
		,t.stepaccountingid as stepaccountingid
		,t.stepaccountingdraft as stepaccountingdraft
		,t.stepacceptid as stepacceptid
		,t.stepacceptdraft as stepacceptdraft
		,t.endeddate as endeddate
		,t.contractorname as contractorname
		,t.typeid as typeid
	from trigger_workflowsteplists t 
	where Year(t.workflowcreated) = ', _year, ' and Month(t.workflowcreated) = ', _month, ' order by t.workflowcreated desc limit ', @a, ', ', _elements);

	PREPARE stmt FROM @qry; 
	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt;
	
end$$

