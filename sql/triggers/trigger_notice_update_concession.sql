USE `intranet`;
DELIMITER $$
CREATE DEFINER=`intranet`@`%` TRIGGER `trigger_notice_update_concession` AFTER UPDATE ON `concession_concessions` FOR EACH ROW
BEGIN
	
	SET @storenr = (SELECT projekt FROM store_stores WHERE id = OLD.storeid);
	
	IF NEW.statusid = 2 THEN
		
		INSERT INTO users_notices (`userid`, `message`, `date`, `url`)
		VALUES (OLD.userid, concat('Potwierdzenie płatności za koncesję dla sklepu ', @storenr, ' zostało zamieszczone.'), NOW(), concat('controller=concessions&action=view&key=', OLD.id));
	
	END IF;
	
END