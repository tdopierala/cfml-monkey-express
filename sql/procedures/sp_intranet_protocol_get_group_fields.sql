delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_protocol_get_group_fields`(
	in group_id int(11),
	in whr varchar(255) character set utf8
)
begin

	SET @qry = CONCAT('select
		fg.id as fieldgroupid
		,f.id as fieldid
		,f.fieldname as fieldname
		,ft.fieldtypename as fieldtypename
		,fg.access as access
		from protocol_fieldgroups fg 
		inner join protocol_fields f on fg.fieldid = f.id
		inner join place_fieldtypes ft on f.fieldtypeid = ft.id
		where fg.groupid = ', group_id, ' and ', whr);
		
	PREPARE stmt FROM @qry; 
	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt;

end$$

