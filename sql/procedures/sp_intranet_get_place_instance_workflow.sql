delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_place_instance_workflow`(
 in instance_id int(11)
)
begin
 select
   w.id as id
   ,w.stepid as stepid
   ,s.stepname as stepname
   ,w.statusid as statusid
   ,st.statusname as statusname
   ,w.start as start
   ,w.stop as stop
   ,w.userid as userid
   ,u.givenname as givenname
   ,u.sn as sn
	,u.position as position
   ,w.instanceid as instanceid
	,u2.givenname as givenname2
	,u2.sn as sn2
	,w.workflownote as workflownote
 from place_workflows w 
 inner join users u on w.userid = u.id
 left outer join users u2 on w.user2 = u2.id
 inner join place_steps s on w.stepid = s.id
 inner join place_statuses st on w.statusid = st.id
 where w.instanceid = instance_id
 order by w.start desc;
end$$

