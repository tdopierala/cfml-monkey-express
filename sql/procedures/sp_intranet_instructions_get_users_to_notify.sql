delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_instructions_get_users_to_notify`(
	in where_condition text character set utf8
)
begin

	set @qry = CONCAT('
		select 
			givenname as givenname, sn as sn, mail as mail
		from users 
		where', where_condition);

	PREPARE stmt FROM @qry; 
	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt;

end$$

