delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_place_instance_step_reports`(
	in instance_id int(11),
	in step_id int(11)
)
begin

select
   r.id as reportid
   ,step_id as step_id
   ,instance_id as instance_id
   ,r.reportname as reportname
 from place_stepreports sr
 inner join place_reports r on sr.reportid = r.id
 where sr.stepid = step_id;

end$$

