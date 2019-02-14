delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_message_get_user_unread_messages`(
	in user_id int(11),
	in pge int(11),
	in cnt int(11)
)
begin

	set @a = (pge-1)*cnt;
	set @b = cnt;

	SET @qry = CONCAT('select
	um.id as id
	,um.userid as userid
	,um.messageid as messageid
	,m.messagetitle as messagetitle
	,m.messagebody as messagebody
	,m.messagepriorityid as messagepriorityid
	,mp.priorityname as priorityname
	,mp.prioritylabel as prioritylabel
	,m.messagecreated as messagecreated
	,um.usermessagereaded as usermessagereaded
	,u.givenname as givenname
	,u.sn as sn
	
	from usermessages um 
	inner join messages m on um.messageid = m.id
	inner join messagepriorities mp on mp.id = m.messagepriorityid
	inner join users u on m.userid = u.id
	
	where um.userid = ', user_id ,' 
	and um.usermessageactive = 1
	
	order by m.messagecreated desc
	
	limit ', @a, ', ', @b);
	
	PREPARE stmt FROM @qry; 
	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt;

end$$

