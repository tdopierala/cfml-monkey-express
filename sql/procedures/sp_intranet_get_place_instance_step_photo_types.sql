delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_place_instance_step_photo_types`(
	in instance_id int(11),
	in step_id int(11)
)
begin

select
   sp.id as placestepphotoid
   ,step_id as step_id
   ,instance_id as instance_id
   ,p.phototypename as phototypename
   ,p.id as phototypeid
   ,(select count(id) from place_instancephototypes ipt where ipt.instanceid = instance_id and ipt.phototypeid = p.id) as photoscount
 from place_stepphototypes sp
 inner join place_phototypes p on sp.phototypeid = p.id
 where sp.stepid = step_id;

end$$

