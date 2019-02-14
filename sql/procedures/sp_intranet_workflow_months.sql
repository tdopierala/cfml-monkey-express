delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_workflow_months`()
begin
	select distinct Month(data_wplywu) from trigger_workflowsearch order by data_wplywu ASC;
end$$

