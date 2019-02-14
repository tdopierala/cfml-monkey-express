USE `intranet`;
DELIMITER $$
CREATE DEFINER=`intranet`@`%` TRIGGER `intranet`.`trigger_notice_index_update`
AFTER UPDATE ON `intranet`.`product_index`
FOR EACH ROW
-- Edit trigger body code below this line. Do not edit lines above this one
BEGIN
	DECLARE _uid INT;
	DECLARE _done INT DEFAULT FALSE;

	DECLARE _users_e1 CURSOR FOR 
		SELECT tgu.userid AS id FROM intranet.tree_groupusers tgu
		INNER JOIN intranet.users u ON u.id = tgu.userid
		WHERE tgu.groupid = 68 AND u.active = 1;

	DECLARE _users_e2 CURSOR FOR 
		SELECT tgu.userid AS id FROM intranet.tree_groupusers tgu
		INNER JOIN intranet.users u ON u.id = tgu.userid
		WHERE tgu.groupid = 69 AND u.active = 1;

	DECLARE _users_e3 CURSOR FOR 
		SELECT tgu.userid AS id FROM intranet.tree_groupusers tgu
		INNER JOIN intranet.users u ON u.id = tgu.userid
		WHERE tgu.groupid = 70 AND u.active = 1;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET _done = TRUE;

	SET @_num = OLD.id;
	SET @_author = (SELECT userid FROM product_steps WHERE step = 1 AND indexid = OLD.id);

	IF NEW.step = 2 THEN
		OPEN _users_e2;
			read_loop: LOOP
				FETCH _users_e2 INTO _uid;

				IF _done THEN LEAVE read_loop; END IF;
			
				INSERT INTO users_notices (`userid`, `message`, `date`, `url`)
				VALUES (_uid, concat('Zmieniono status indeksu o numerze ', @_num, ' na "zweryfikowany"'), NOW(), concat('controller=products&action=view&key=', @_num));
			END LOOP;
		CLOSE _users_e2;

		INSERT INTO users_notices (`userid`, `message`, `date`, `url`)
		VALUES (@_author, concat('Zmieniono status indeksu o numerze ', @_num, ' na "zweryfikowany"'), NOW(), concat('controller=products&action=view&key=', @_num));

	ELSEIF NEW.step = 3 THEN
		OPEN _users_e2;
			read_loop: LOOP
				FETCH _users_e2 INTO _uid;

				IF _done THEN LEAVE read_loop; END IF;
			
				INSERT INTO users_notices (`userid`, `message`, `date`, `url`)
				VALUES (_uid, concat('Zmieniono status indeksu o numerze ', @_num, ' na "odrzucony na etapie weryfikacji"'), NOW(), concat('controller=products&action=view&key=', @_num));
			END LOOP;
		CLOSE _users_e2;

		INSERT INTO users_notices (`userid`, `message`, `date`, `url`)
		VALUES (@_author, concat('Zmieniono status indeksu o numerze ', @_num, ' na "odrzucony na etapie weryfikacji"'), NOW(), concat('controller=products&action=view&key=', @_num));

	ELSEIF NEW.step = 4 THEN
		OPEN _users_e3;
			read_loop: LOOP
				FETCH _users_e3 INTO _uid;

				IF _done THEN LEAVE read_loop; END IF;
			
				INSERT INTO users_notices (`userid`, `message`, `date`, `url`)
				VALUES (_uid, concat('Zmieniono status indeksu o numerze ', @_num, ' na "zaakceptowany"'), NOW(), concat('controller=products&action=view&key=', @_num));
			END LOOP;
		CLOSE _users_e3;

		OPEN _users_e1;
			read_loop: LOOP
				FETCH _users_e1 INTO _uid;

				IF _done THEN LEAVE read_loop; END IF;
			
				INSERT INTO users_notices (`userid`, `message`, `date`, `url`)
				VALUES (_uid, concat('Zmieniono status indeksu o numerze ', @_num, ' na "zaakceptowany"'), NOW(), concat('controller=products&action=view&key=', @_num));
			END LOOP;
		CLOSE _users_e1;

	ELSEIF NEW.step = 5 THEN
		OPEN _users_e3;
			read_loop: LOOP
				FETCH _users_e3 INTO _uid;

				IF _done THEN LEAVE read_loop; END IF;
			
				INSERT INTO users_notices (`userid`, `message`, `date`, `url`)
				VALUES (_uid, concat('Zmieniono status indeksu o numerze ', @_num, ' na "brak akceptacji"'), NOW(), concat('controller=products&action=view&key=', @_num));
			END LOOP;
		CLOSE _users_e3;

	END IF;
END