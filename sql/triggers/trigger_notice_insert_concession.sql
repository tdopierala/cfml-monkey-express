USE `intranet`;
DELIMITER $$
CREATE DEFINER=`intranet`@`%` TRIGGER `trigger_notice_insert_concession` AFTER INSERT ON `concession_concessions` FOR EACH ROW
BEGIN
	
	DECLARE _uid INT;
	DECLARE _done INT DEFAULT FALSE;

	-- wyszukuje aktywnych uzytkownikow
	DECLARE _users CURSOR FOR 
		SELECT tgu.userid 
		FROM intranet.tree_groupusers tgu
		INNER JOIN intranet.users u ON u.id = tgu.userid
		WHERE tgu.groupid = 118 AND u.active = 1
		GROUP BY tgu.userid;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET _done = TRUE;
	
	SET @storenr = (SELECT projekt FROM store_stores WHERE id = NEW.storeid);

	OPEN _users;
		read_loop: LOOP
			FETCH _users INTO _uid;

			IF _done THEN LEAVE read_loop; END IF;

			INSERT INTO users_notices (`userid`, `message`, `date`, `url`)
			VALUES (_uid, concat('Nowa koncesja dla sklepu ', @storenr, ' oczekuje na przelew.'), NOW(), concat('controller=concessions&action=view&key=', NEW.id));
			
		END LOOP;
	CLOSE _users;

END