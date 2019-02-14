delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_workflow_get_user_workflow_v2`(
	in _user_id int(11),
	in _page int(4),
	in _elements int(4),
	in _year int(4),
	in _month int(4),
	in _type_id int(11),
	in _all int(1)
)
begin
	
	set @a = (_page-1)*_elements;
	set @b = (_page*_elements);

	if _all = 1 then
	
		SET @qry = CONCAT('select 
		distinct ws.workflowid,
		w.documentid, 
		w.workflowcreated,
		w.documentname,
		w.stepdescriptionid,
		w.stepdescriptiondraft,
		w.stepcontrollingid,
		w.stepcontrollingdraft,
		w.stepapproveid,
		w.stepapproveddraft,
		w.stepaccountingid,
		w.stepaccountingdraft,
		w.stepacceptid,
		w.stepacceptdraft,
		w.stependid,
		w.endeddate,
		w.contractorname
		from workflowsteps ws inner join trigger_workflowsteplists w on ws.workflowid = w.workflowid
		where ws.userid = ',_user_id,'   
		order by w.workflowid desc'); 
	
	elseif _type_id <> 0 then
	
		SET @qry = CONCAT('select 
		distinct ws.workflowid,
		w.documentid, 
		w.workflowcreated,
		w.documentname,
		w.stepdescriptionid,
		w.stepdescriptiondraft,
		w.stepcontrollingid,
		w.stepcontrollingdraft,
		w.stepapproveid,
		w.stepapproveddraft,
		w.stepaccountingid,
		w.stepaccountingdraft,
		w.stepacceptid,
		w.stepacceptdraft,
		w.stependid,
		w.endeddate,
		w.contractorname
		from workflowsteps ws inner join trigger_workflowsteplists w on ws.workflowid = w.workflowid
		where ws.userid = ',_user_id,' and Year(w.workflowcreated) = ', _year, ' and Month(w.workflowcreated) = ', _month, ' and w.typeid = ', _type_id, '  
		order by w.workflowid desc LIMIT ', @a, ', ', _elements); 
	
	else
	
		SET @qry = CONCAT('select 
		distinct ws.workflowid,
		w.documentid, 
		w.workflowcreated,
		w.documentname,
		w.stepdescriptionid,
		w.stepdescriptiondraft,
		w.stepcontrollingid,
		w.stepcontrollingdraft,
		w.stepapproveid,
		w.stepapproveddraft,
		w.stepaccountingid,
		w.stepaccountingdraft,
		w.stepacceptid,
		w.stepacceptdraft,
		w.stependid,
		w.endeddate,
		w.contractorname
		from workflowsteps ws inner join trigger_workflowsteplists w on ws.workflowid = w.workflowid
		where ws.userid = ',_user_id,' and Year(w.workflowcreated) = ', _year, ' and Month(w.workflowcreated) = ', _month, '  
		order by w.workflowid desc LIMIT ', @a, ', ', _elements);
	
	end if;


	PREPARE stmt FROM @qry; 
	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt;
	
end$$

