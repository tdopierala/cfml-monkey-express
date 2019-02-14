CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_generate_blank_first_place_step`(
 in instance_id int(11),
 in user_id int(11)
)
begin
 insert into place_workflows (instanceid, stepid, statusid, start, userid) values (instance_id, 1, 1, NOW(), user_id);
end
