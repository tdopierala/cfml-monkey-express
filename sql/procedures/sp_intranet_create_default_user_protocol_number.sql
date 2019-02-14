CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_create_default_user_protocol_number`(
	in _user_id int(11)
)
begin
	insert into protocol_numbers (userid, protocolnumber) values (_user_id, 1);
end
