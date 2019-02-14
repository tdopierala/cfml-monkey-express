delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_ideas_get_all_count`(
	IN _userid INT(11),
	IN _statusid INT(2),
	IN _access INT(2),
	IN _sessionuser INT(11)
)
BEGIN

	set @qry = CONCAT(
		'SELECT 
			COUNT(idea_ideas.id) AS c
		FROM idea_ideas 
		INNER JOIN users ON users.id = idea_ideas.userid
		INNER JOIN idea_statuses ON idea_statuses.id = idea_ideas.statusid
		WHERE 1=1 '
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
	
	PREPARE stmt FROM @qry; 
	EXECUTE stmt;

	DEALLOCATE PREPARE stmt;
END$$

