delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_workflow_get_all_documents_in_workflow_count_v2`(
	in _year int(4),
	in _month int(4),
	in _step int(4)
)
begin
	
	set @qry = CONCAT('select 
		count(id) as c
	from trigger_workflowsteplists t 
	where Year(t.workflowcreated) = ', _year, ' and Month(t.workflowcreated) = ', _month);

	PREPARE stmt FROM @qry; 
	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt;
	
end$$

