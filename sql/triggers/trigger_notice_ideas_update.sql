USE `intranet`;
DELIMITER $$
CREATE DEFINER=`intranet`@`%` TRIGGER `intranet`.`trigger_notice_ideas_update`
AFTER UPDATE ON `intranet`.`idea_ideas`
FOR EACH ROW
-- Edit trigger body code below this line. Do not edit lines above this one

BEGIN
	DECLARE _uid INT;
	DECLARE _done INT DEFAULT FALSE;

	DECLARE _users CURSOR FOR 
		SELECT tgu.userid AS id FROM intranet.tree_groupusers tgu
		INNER JOIN intranet.users u ON u.id = tgu.userid
		WHERE tgu.groupid = 52 AND u.active = 1;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET _done = TRUE;

	SET @_status = (SELECT name FROM idea_statuses WHERE id = NEW.statusid);

	OPEN _users;
		read_loop: LOOP
			FETCH _users INTO _uid;

			IF _done THEN LEAVE read_loop; END IF;

			IF NEW.statusid <> 1 AND OLD.statusid <> NEW.statusid AND _uid <> OLD.userid THEN
			
				INSERT INTO users_notices (`userid`, `message`, `date`, `url`)
				VALUES (_uid, concat('Zmieniono status pomysłu "', OLD.title, '" na ', @_status, ' w zakładce Good Monkey'), NOW(), concat('controller=ideas&action=view&key=', OLD.id));

			END IF;
		END LOOP;
	CLOSE _users;
	
	IF NEW.statusid <> 1 AND OLD.statusid <> NEW.statusid THEN
			
		INSERT INTO users_notices (`userid`, `message`, `date`, `url`)
		VALUES (OLD.userid, concat('Zmieniono status pomysłu "', OLD.title, '" na ', @_status, ' w zakładce Good Monkey'), NOW(), concat('controller=ideas&action=view&key=', OLD.id));

	END IF;
END