CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_create_blank_place_collection_privileges`()
begin

	start transaction;
	BLOCK1: begin
		declare user_id int(11);
		declare no_more_users int default false;
		declare user_cursor cursor for select id from users;
		declare continue handler for not found set no_more_users = true;
		
		open user_cursor;
		LOOP1: loop
			fetch user_cursor into user_id;
			if no_more_users then
				close user_cursor;
				leave LOOP1;
			end if;
			
			BLOCK2: begin
				
				declare collection_id int(11);
				declare no_more_collections int default false;
				declare collection_cursor cursor for select id from place_collections;
				declare continue handler for not found set no_more_collections = true;
				
				open collection_cursor;
				
				LOOP2: loop
					fetch collection_cursor into collection_id;
					if no_more_collections then
						close collection_cursor;
						leave LOOP2;
					end if;
					
					insert into place_collectionprivileges (userid, collectionid, readprivilege, writeprivilege) values (user_id, collection_id, 1, 0);
					
				end loop LOOP2;
				
			end BLOCK2;
			
		end loop LOOP1;
	end BLOCK1;
	commit;

end
