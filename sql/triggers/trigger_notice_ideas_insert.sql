USE `intranet`;
DELIMITER $$
CREATE DEFINER=`intranet`@`%` TRIGGER `trigger_notice_ideas_insert` AFTER INSERT ON `intranet`.`idea_ideas` FOR EACH ROW
-- Edit trigger body code below this line. Do not edit lines above this one
BEGIN
	DECLARE _uid INT;
	DECLARE _done INT DEFAULT FALSE;

	DECLARE _users CURSOR FOR 
		SELECT tgu.userid AS id FROM intranet.tree_groupusers tgu
		INNER JOIN intranet.users u ON u.id = tgu.userid
		WHERE tgu.groupid = 52 AND u.active = 1;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET _done = TRUE;

	OPEN _users;
		read_loop: LOOP
			FETCH _users INTO _uid;

			IF _done THEN LEAVE read_loop; END IF;
			
			INSERT INTO users_notices (`userid`, `message`, `date`, `url`)
			VALUES (_uid, concat('Dodano nowy pomysł "', NEW.title, '" w zakładce Good Monkey'), NOW(), concat('controller=ideas&action=view&key=', NEW.id));
		END LOOP;
	CLOSE _users;

END