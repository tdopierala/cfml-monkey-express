delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_place_report_get_all_groups`(
	in columns varchar(255) character set utf8
)
begin

	if Length(columns) = 0 then
	
		select 
			g.id as groupid
			,g.groupname as groupname
			,g.created as created
			,(select count(id) from place_fieldgroups fg where fg.groupid = g.id and fg.access = 1) as fieldcount
		from place_groups g;
		
	else
	
		SET @qry = CONCAT('select ', columns, '
		 from place_groups');
	
		PREPARE stmt FROM @qry; 
		EXECUTE stmt; 

		DEALLOCATE PREPARE stmt;
	
	end if;
	
end$$

