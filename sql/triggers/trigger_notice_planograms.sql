USE `intranet`;
DELIMITER $$
CREATE DEFINER=`intranet`@`%` TRIGGER `intranet`.`trigger_notice_planograms`
AFTER INSERT ON `intranet`.`store_planograms`
FOR EACH ROW
-- Edit trigger body code below this line. Do not edit lines above this one

BEGIN

	DECLARE _uid INT;
	DECLARE _done INT DEFAULT FALSE;

	-- wyszukuje aktywnych uzytkownikow
	DECLARE _users CURSOR FOR 
		SELECT DISTINCT u.id
		FROM store_shelfs s
		INNER JOIN store_storeshelfs ss ON ss.shelfid = s.id
		INNER JOIN store_stores st ON st.id = ss.storeid
		INNER JOIN users u ON (st.projekt = u.login AND st.ajent = u.logo AND st.is_active AND u.active = 1 /*OR u.id IN(2,3,345)*/)
		WHERE (s.shelfcategoryid = NEW.shelfcategoryid AND s.shelftypeid = NEW.shelftypeid AND s.storetypeid = NEW.storetypeid);

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET _done = TRUE;
	
	SET @_category = (SELECT shelfcategoryname FROM store_shelfcategories WHERE id = NEW.shelfcategoryid);
	SET @_type = (SELECT shelftypename FROM store_shelftypes WHERE id = NEW.shelftypeid);
	
	OPEN _users;
		read_loop: LOOP
			FETCH _users INTO _uid;

			IF _done THEN LEAVE read_loop; END IF;
			
			INSERT INTO users_notices (`userid`, `message`, `date`, `url`)
			VALUES (_uid, CONCAT('Dodano nowy nowy planogram w kategorii: "', @_category, '", ', @_type), Now(), 'controller=store_storeplanograms&action=index');
			
		END LOOP;
	CLOSE _users;
	
	-- INSERT INTO users_notices (`userid`, `message`, `date`)
	-- VALUES (345, CONCAT('Dodano nowy nowy planogram w kategorii ', @category, ' ', @_type), Now());

	-- INSERT INTO users_notices (`userid`, `message`, `date`)
	-- VALUES (2, CONCAT('Dodano nowy nowy planogram w kategorii ', @category, ' ', @_type), Now());

END