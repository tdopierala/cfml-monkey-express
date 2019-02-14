USE `intranet`;
DELIMITER $$
CREATE DEFINER=`intranet`@`%` TRIGGER `trigger_notice_material_files_insert` AFTER INSERT ON material_files FOR EACH ROW
-- Edit trigger body code below this line. Do not edit lines above this one
BEGIN
	
	DECLARE _uid INT;
	DECLARE _done INT DEFAULT FALSE;

	-- wyszukuje aktywnych uzytkownikow
	DECLARE _users CURSOR FOR 
		SELECT tgu.userid 
		FROM intranet.tree_groupusers tgu
		INNER JOIN intranet.users u ON u.id = tgu.userid
		WHERE (tgu.groupid = 11	OR tgu.groupid = 21) AND u.active = 1
		GROUP BY tgu.userid;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET _done = TRUE;

	SET @_materialname = (SELECT materialname FROM material_materials WHERE id = NEW.materialid);
	
	OPEN _users;
		read_loop: LOOP
			FETCH _users INTO _uid;

			IF _done THEN LEAVE read_loop; END IF;

			INSERT INTO users_notices (`userid`, `message`, `date`)
			VALUES (_uid, CONCAT('Dodano nowe materiały szkoleniowe w zakładce ', @_materialname), NOW());
			
		END LOOP;
	CLOSE _users;

END