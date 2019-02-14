delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_workflow_get_user_workflow_count_v2`(
	in _user_id int(11),
	in _year int(4),
	in _month int(4),
	in _type_id int(11),
	in _all int(1)
)
begin

	if _all = 1 then
	
		SET @qry = CONCAT('select 
			distinct count(w.workflowid) as c
			from workflowsteps ws inner join trigger_workflowsteplists w on ws.workflowid = w.workflowid
			where ws.userid = ',_user_id);
	
	elseif _type_id <> 0 then
	
		SET @qry = CONCAT('select 
			distinct count(w.workflowid) as c
			from workflowsteps ws inner join trigger_workflowsteplists w on ws.workflowid = w.workflowid
			where ws.userid = ',_user_id, ' and Year(w.workflowcreated) = ', _year, ' and Month(w.workflowcreated) = ', _month, ' and w.typeid = ', _type_id);
	
	else
	
		SET @qry = CONCAT('select 
			distinct count(w.workflowid) as c
			from workflowsteps ws inner join trigger_workflowsteplists w on ws.workflowid = w.workflowid
			where ws.userid = ',_user_id, ' and Year(w.workflowcreated) = ', _year, ' and Month(w.workflowcreated) = ', _month);
	
	end if; 

	PREPARE stmt FROM @qry; 
	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt;
end$$

