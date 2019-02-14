delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_workflow_get_user_active_workflow_count_v2`(
	in _user_id int(11),
	in _year int(4),
	in _month int(4),
	in _category_id int(11),
	in _all int(4)
)
begin
	
	declare select_string text;
	declare where_string text;
	declare type_string varchar(255);
	declare all_string varchar(255);
	
	set select_string = concat('select 
		distinct count(ws.workflowid) as c
	from workflowsteps ws inner join trigger_workflowsteplists w on ws.workflowid = w.workflowid');
	
	/* SET @qry = CONCAT('select 
		distinct count(ws.workflowid) as c
	from workflowsteps ws inner join trigger_workflowsteplists w on ws.workflowid = w.workflowid
	where ws.workflowstatusid=1 and ws.userid = ',_user_id,' and Year(w.workflowcreated) = ', _year,' and Month(w.workflowcreated) = ', _month); 
	*/
	
	
	
	if _category_id <> 0 then 
		
		set type_string = concat(' and w.categoryid = ', _category_id, ' order by w.workflowcreated desc ');
			
	else 
		
		set type_string = concat(' order by w.workflowcreated desc ');
		
	end if;
	
	if _all = 1 then

		set where_string = concat(' where ws.workflowstatusid=1 and ws.userid = ',_user_id);

	else

		set where_string = concat(' where ws.workflowstatusid=1 and ws.userid = ',_user_id,' and Year(w.workflowcreated) = ', _year,' and Month(w.workflowcreated) = ', _month);
	
	end if;
	
	
	-- 	@qry = concat(@qry, ' order by w.workflowcreated desc');	
		
	/*	SET @qry = CONCAT('select 
		distinct count(ws.workflowid) as c
	from workflowsteps ws inner join trigger_workflowsteplists w on ws.workflowid = w.workflowid
	where ws.workflowstatusid=1 and ws.userid = ',_user_id,' and Year(w.workflowcreated) = ', _year,' and Month(w.workflowcreated) = ', _month, '
	order by w.workflowcreated desc'); */
			
	set @qry = concat(select_string, where_string, type_string);

	PREPARE stmt FROM @qry; 
	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt;
end$$

