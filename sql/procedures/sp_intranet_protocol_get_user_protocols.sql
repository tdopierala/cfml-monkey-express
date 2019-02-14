delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_protocol_get_user_protocols`(
	in _user_id int(11),
	in _elements int(4),
	in _page int(4)
)
begin

	set @a = (_page-1)*_elements;
	
	set @qry = CONCAT('select 
		pi.id as protocolinstanceid
		,pi.typeid as protocoltypeid
		,pi.instance_created as instance_created
		,pi.userid as userid
		,u.login as login
		,u.givenname as givenname
		,pt.typename as typename
		,pi.protocolnumber as protocolnumber
	from protocol_instances pi 
	inner join protocol_types pt on pi.typeid = pt.id
	inner join users u on pi.userid = u.id
	where pi.userid = ', _user_id, ' and u.id = ', _user_id, ' order by pi.instance_created desc limit ', @a, ', ', _elements);

	PREPARE stmt FROM @qry; 
	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt;	
	
end$$

