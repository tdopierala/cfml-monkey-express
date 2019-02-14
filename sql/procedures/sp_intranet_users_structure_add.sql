delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_users_structure_add`(
  IN _keyid INT( 11 ),
  IN _type INT( 11 ),
  IN _name VARCHAR( 255 ) character set utf8
)
BEGIN

	IF (_type > 1) THEN
		INSERT INTO departments ( department_name ) VALUES ( _name );
		SET _keyid = LAST_INSERT_ID();
	END IF;
	
	UPDATE users_structure SET lft = lft + 2, rgt = rgt + 2 WHERE lft >= 1;
	INSERT INTO users_structure (keyid, type, lft, rgt) VALUES (_keyid, _type, 1, 2);

END$$

