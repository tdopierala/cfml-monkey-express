CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_all_place_instances`(
 in page int(4),
 in elements int(2),
 in offset int(3),
 in status_id int(11),
 in instancereason_id int(11),
 in user_id int(11),
 in step_id int(11),
 in placesearch varchar(255) character set utf8
)
begin

	set @a = (page-1)*elements;
	
	set @qry = CONCAT('select 
		i.instanceid as id
	    ,i.instancecreated as instancecreated
	    ,i.city as instanceplace
	    ,i.postalcode as instancepostalcode
	    ,i.street as instancestreet
		,i.streetnumber as streetnumber
	    ,i.userid as userid
		,i.givenname as givenname
		,i.sn as sn
		,i.position as position
		,i.instancereasonid as instancereasonid
		,i.rejectnote as rejectnote
		,i.rejectuserid as rejectuserid
		,i.rejectdatetime as rejectdatetime
		,i.instancestatusid as instancestatusid
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
	
	set @qry = CONCAT(@qry, ' instancestatusid = ', status_id, ' order by i.instancecreated desc limit ', @a, ', ', elements);
	
	
	PREPARE stmt FROM @qry; 
	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt;
	
end
