delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_protocol_get_value_rows`(
	col varchar(255) character set utf8,
	cond varchar(255) character set utf8
)
begin

	SET @qry = CONCAT('select ', col, ' from protocol_instancevalues inner join protocol_fields on protocol_instancevalues.fieldid = protocol_fields.id where ', cond);
		
	PREPARE stmt FROM @qry; 
	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt;  
end$$

