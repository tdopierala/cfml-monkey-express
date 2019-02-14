delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_place_report_assign_fields_to_group`(
	in group_id int(11)
)
begin

	declare field_id int(11);
	declare no_more_fields int default false;
	declare fields_cursor cursor for select id from place_fields;
	declare continue handler for not found set no_more_fields = true;
	
	open fields_cursor;
	LOOP1: loop
	
		fetch fields_cursor into field_id;
		if no_more_fields then
			close fields_cursor;
			leave LOOP1;
		end if;
		
		insert into place_fieldgroups (fieldid, groupid, access) values (field_id, group_id, 0);
	
	end loop LOOP1;

end$$

