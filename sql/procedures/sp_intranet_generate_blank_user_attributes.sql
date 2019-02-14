CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_generate_blank_user_attributes`(
	in user_id int(11)
)
begin
	declare attribute_id int(11);
	declare no_more_attributes int default false;
	declare attribute_cursor cursor for select attributeid from userattributes;
	declare continue handler for not found set no_more_attributes = true;
				
	open attribute_cursor;
				
	LOOP2: loop
		fetch attribute_cursor into attribute_id;
		if no_more_attributes then
			close attribute_cursor;
			leave LOOP2;
		end if;
					
		insert into userattributevalues (userid, attributeid) values (user_id, attribute_id);
					
	end loop LOOP2;
end
