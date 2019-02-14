CREATE DEFINER=`intranet`@`%` PROCEDURE `intranet_users_move`(IN rootuserid int(11), IN parentuserid int(11))
BEGIN
-- Need two parameters: (1) CurrentRoot, and (2) NewParent.
DECLARE Origin_Lft int(4);
DECLARE Origin_Rgt int(4);
DECLARE NewParent_Rgt int(4);

SELECT `lft`, `rgt`
	INTO Origin_Lft, Origin_Rgt
	FROM `users`
	WHERE `id` = rootuserid;
SET NewParent_Rgt = (SELECT `rgt` FROM `users`
	WHERE `id` = parentuserid);
UPDATE `users` 
	SET `lft` = `lft` + 
	CASE
		WHEN NewParent_Rgt < Origin_Lft
			THEN CASE
				WHEN lft BETWEEN Origin_Lft AND Origin_Rgt
					THEN NewParent_Rgt - Origin_Lft
				WHEN lft BETWEEN NewParent_Rgt	AND Origin_Lft - 1
					THEN Origin_Rgt - Origin_Lft + 1
				ELSE 0 END
		WHEN NewParent_Rgt > Origin_Rgt
			THEN CASE
				WHEN lft BETWEEN Origin_Lft	AND Origin_Rgt
					THEN NewParent_Rgt - Origin_Rgt - 1
				WHEN lft BETWEEN Origin_Rgt + 1 AND NewParent_Rgt - 1
					THEN Origin_Lft - Origin_Rgt - 1
				ELSE 0 END
			ELSE 0 END,
	rgt = rgt + 
	CASE
		WHEN NewParent_Rgt < Origin_Lft
			THEN CASE
		WHEN rgt BETWEEN Origin_Lft AND Origin_Rgt
			THEN NewParent_Rgt - Origin_Lft
		WHEN rgt BETWEEN NewParent_Rgt AND Origin_Lft - 1
			THEN Origin_Rgt - Origin_Lft + 1
		ELSE 0 END
		WHEN NewParent_Rgt > Origin_Rgt
			THEN CASE
				WHEN rgt BETWEEN Origin_Lft AND Origin_Rgt
					THEN NewParent_Rgt - Origin_Rgt - 1
				WHEN rgt BETWEEN Origin_Rgt + 1	AND NewParent_Rgt - 1
					THEN Origin_Lft - Origin_Rgt - 1
				ELSE 0 END
			ELSE 0 END;
END