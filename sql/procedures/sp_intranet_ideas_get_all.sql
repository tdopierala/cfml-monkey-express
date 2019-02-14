delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_ideas_get_all`(
	IN _userid INT(11),
	IN _statusid INT(2),
	IN _access INT(2),
	IN _sessionuser INT(11),
	IN _sortby VARCHAR(100),
	IN _sortset VARCHAR(4),
	IN _page INT(3),
	IN _emelents INT(3)
)
BEGIN

	set @qry = CONCAT(
		'SELECT 
			ii.id AS id, 
			ii.title AS title, 
			ii.date AS date,
			CONCAT(IFNULL(u.givenname,""), "&nbsp;", IFNULL(u.sn,"")) AS user,
			stat.name AS name,
			IFNULL(ss.projekt,"") AS store
		FROM idea_ideas AS ii
		INNER JOIN users AS u ON u.id = ii.userid
		INNER JOIN idea_statuses AS stat ON stat.id = ii.statusid
		LEFT JOIN store_stores AS ss ON ss.ajent = u.logo
		WHERE 1=1'
	);
	
	IF _userid <> 0 THEN
		set @qry = CONCAT(@qry, ' and (userid = ', _userid, ')');
	END IF;

	IF _statusid <> 0 THEN
		set @qry = CONCAT(@qry, ' and (statusid = ', _statusid, ')');
	END IF;

	/*CASE _access
		WHEN 2 THEN set @qry = CONCAT(@qry, ' and (statusid >= 2 or userid = ', _sessionuser, ')'); 
		WHEN 3 THEN set @qry = CONCAT(@qry, ' and (partner_prowadzacy_sklep = 1 or userid = ', _sessionuser, ')');
		WHEN 4 THEN set @qry = CONCAT(@qry, ' and (userid = ', _sessionuser, ')');
		ELSE set @qry = @qry;
	END CASE;*/

	IF _access > 2 THEN
		set @qry = CONCAT(@qry, ' and (userid = ', _sessionuser, ' or statusid = 4)');
	END IF;
	
	set @qry = CONCAT(@qry, ' GROUP BY ii.id ');
	set @qry = CONCAT(@qry, ' ORDER BY ', _sortby, ' ', _sortset);
	set @qry = CONCAT(@qry, ' LIMIT ', (_page-1) * _emelents, ', ', _emelents);

	PREPARE stmt FROM @qry; 
	EXECUTE stmt;

	DEALLOCATE PREPARE stmt;
END$$

