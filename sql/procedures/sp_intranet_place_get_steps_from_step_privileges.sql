delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_place_get_steps_from_step_privileges`(
	in user_id int(11)
)
begin
	select 
		sp.id as id
		,sp.readprivilege as readprivilege
		,sp.writeprivilege as writeprivilege
		,sp.acceptprivilege as acceptprivilege
		,sp.refuseprivilege as refuseprivilege
		,sp.archiveprivilege as archiveprivilege
		,sp.deleteprivilege as deleteprivilege
		,sp.moveprivilege as moveprivilege
		,sp.stepid as stepid
		,s.stepname as stepname
	from place_stepprivileges sp inner join place_steps s on sp.stepid = s.id
	where sp.userid = user_id;
end$$

