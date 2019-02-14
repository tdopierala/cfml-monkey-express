delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_workflow_get_user_active_workflow`(
	in user_id int(11),
	in pge int(11),
	in cnt int(11)
)
begin

set @a = (pge-1)*cnt;
set @b = (pge*cnt);

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
where ws.workflowstatusid=1 and ws.userid = ',user_id,'
order by w.workflowcreated desc LIMIT ', @a, ', ', @b); 

PREPARE stmt FROM @qry; 
EXECUTE stmt; 

DEALLOCATE PREPARE stmt; 

end$$

