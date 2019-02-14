USE `intranet`;
DELIMITER $$
CREATE DEFINER=`intranet`@`%` TRIGGER `trigger_notice_indexes` AFTER INSERT ON product_index FOR EACH ROW
-- Edit trigger body code below this line. Do not edit lines above this one
BEGIN
	DECLARE _uid INT;
	DECLARE _done INT DEFAULT FALSE;

	-- wyszukuje aktywnych uzytkownikow centrali
	DECLARE _users CURSOR FOR 
		SELECT tgu.userid AS id FROM intranet.tree_groupusers tgu
		INNER JOIN intranet.users u ON u.id = tgu.userid
		WHERE tgu.groupid = 68 AND u.active = 1 AND tgu.userid <> 345;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET _done = TRUE;

	SET @_num = NEW.id;

	SET @_u = (SELECT userid FROM intranet.product_steps WHERE indexid = NEW.id AND step = 1 LIMIT 1);

	OPEN _users;
		read_loop: LOOP
			FETCH _users INTO _uid;

			IF _done THEN LEAVE read_loop; END IF;

			IF _uid <> @_u THEN
			
				INSERT INTO users_notices (`userid`, `message`, `date`, `url`)
				VALUES (_uid, concat('Dodano nowy indeks o numerze ', @_num, ' w zakładce Nowe indeksy'), NOW(), concat('controller=products&action=view&key=',NEW.id));
			
			END IF;
		END LOOP;
	CLOSE _users;
END