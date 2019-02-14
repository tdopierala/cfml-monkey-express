delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_users_structure`()
BEGIN

SELECT 
	s.id as sid, 
	s.keyid as uid, 
	IF(u.givenname IS NULL, d.department_name, CONCAT(u.givenname, ' ', u.sn)) as name,
	u.mail,
	-- u.position as position,
	IF(ua.userattributevaluetext IS NULL, u.position, ua.userattributevaluetext) as position,
	u.photo,
	s.lft, 
	s.rgt, 
	IF(u.departmentname IS NULL,d.department_name,u.departmentname) as departmentname,
	s.type,
	(select count(p.id)-1 from users_structure as p where s.lft between p.lft and p.rgt) as depth
	
FROM users_structure AS s 
 LEFT JOIN users AS u ON u.id = s.keyid AND s.type = 1
 LEFT JOIN departments AS d ON d.id = s.keyid AND (s.type = 0 or s.type = 2 or s.type = 3)
 LEFT JOIN userattributevalues AS ua ON ua.userid = s.keyid AND attributeid = 123

-- WHERE s.lft >= 128

ORDER BY lft; 

END$$

