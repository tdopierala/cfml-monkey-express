USE `intranet`;
DELIMITER $$
CREATE DEFINER=`intranet`@`%` TRIGGER `trigger_notice_instructions_update` AFTER UPDATE ON `instruction_documents` FOR EACH ROW
BEGIN
	
	DECLARE _uid INT;
	DECLARE _done INT DEFAULT FALSE;

	-- wyszukuje aktywnych uzytkownikow
	DECLARE _users CURSOR FOR 
		SELECT tgu.userid 
		FROM intranet.tree_groupusers tgu
		INNER JOIN intranet.users u ON u.id = tgu.userid
		WHERE (
			(tgu.groupid = 9  AND NEW.centrala = 1) 
			OR (tgu.groupid = 31 AND NEW.dyrektorzy = 1)
			OR (tgu.groupid = 10 AND NEW.partner_ds_ekspansji = 1)
			OR (tgu.groupid = 11 AND NEW.partner_prowadzacy_sklep = 1)
			OR (tgu.groupid = 12 AND NEW.partner_ds_sprzedazy = 1)
		) AND u.active = 1
		GROUP BY tgu.userid;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET _done = TRUE;

	-- SET @inumber = NEW.instruction_number;
	
	OPEN _users;
		read_loop: LOOP
			FETCH _users INTO _uid;

			IF _done THEN LEAVE read_loop; END IF;

			INSERT INTO users_notices (`userid`, `message`, `date`, `url`)
			VALUES (_uid, concat('Dodano nowy dokument "', IF(NEW.instruction_number is null, '', NEW.instruction_number),'" w zakładce Akty prawne'), NOW(), concat('controller=instructions&action=preview&key=', OLD.id));
			
		END LOOP;
	CLOSE _users;

	-- INSERT INTO users_notices (`userid`, `message`, `date`, `url`)
	-- VALUES (345, concat('Nowy dokument "', IF(NEW.instruction_number is null, 'XXX', NEW.instruction_number),'" w zakładce Akty prawne'), NOW(), concat('controller=instructions&action=preview&key=', OLD.id));

END