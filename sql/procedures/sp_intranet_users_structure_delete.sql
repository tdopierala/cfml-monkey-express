delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_users_structure_delete`(
	IN _id INT( 11 )
)
BEGIN

	DECLARE _rgt INT( 11 );
	DECLARE _lft INT( 11 );

	SELECT lft, rgt INTO _lft, _rgt FROM users_structure WHERE id = _id;

	DELETE FROM users_structure WHERE lft >= _lft AND rgt <= _rgt;

	UPDATE users_structure SET lft = lft - ( _rgt - _lft + 1 ) WHERE lft > _rgt;
	UPDATE users_structure SET rgt = rgt - ( _rgt - _lft + 1 ) WHERE rgt > _rgt;
		
END$$

