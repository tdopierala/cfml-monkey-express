CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_all_place_instances_count`(
	in status_id int(11),
	in user_id int(11),
	in step_id int(11),
	in instancereason_id int(11),
	in placesearch varchar(255) character set utf8
)
begin
	set @qry = CONCAT('select 
		count(id) as c
	from trigger_place_instances i where ');
	
	if user_id <> 0 then
		set @qry = CONCAT(@qry, ' (userid = ', user_id, ') and ');
	end if;
	
	if step_id <> 0 then
		set @qry = CONCAT(@qry, ' (i.stepid = ', step_id, ') and ');
	end if;
	
	if instancereason_id <> 0 then
		set @qry = CONCAT(@qry, ' (i.instancereasonid = ', instancereason_id, ') and ');
	end if;
	
	if LENGTH(placesearch) <> 0 then
		set @qry = CONCAT(@qry, ' (LOWER(i.givenname) like "%', LOWER(TRIM(placesearch)), '%" or 
									LOWER(i.rejectnote) like "%', LOWER(TRIM(placesearch)), '%" or
									LOWER(i.street) like "%', LOWER(TRIM(placesearch)) ,'%" or
									LOWER(i.postalcode) like "%', LOWER(TRIM(placesearch)) ,'%" or
									LOWER(i.city) like "%', LOWER(TRIM(placesearch)) ,'%" or
									LOWER(i.streetnumber) like "%', LOWER(TRIM(placesearch)) ,'%") and ');
	end if;
	
	set @qry = CONCAT(@qry, ' instancestatusid = ', status_id);
	
	
	PREPARE stmt FROM @qry; 
	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt;
end
