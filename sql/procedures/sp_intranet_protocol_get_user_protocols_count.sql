delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_protocol_get_user_protocols_count`(
	in _user_id int(11)
)
begin
	select count(id) as c from protocol_instances where userid = _user_id; 
end$$

