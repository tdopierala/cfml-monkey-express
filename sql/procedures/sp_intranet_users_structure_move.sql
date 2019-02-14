delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_users_structure_move`(
  IN my_root INT( 11 ),
  IN new_parent INT( 11 )
)
BEGIN

	DECLARE origin_lft int(11); 
	DECLARE origin_rgt int(11); 
	DECLARE new_parent_rgt int(11);

	SELECT lft, rgt INTO origin_lft, origin_rgt FROM users_structure WHERE id = my_root;

	SET new_parent_rgt = (SELECT rgt FROM users_structure WHERE id = new_parent);

	UPDATE users_structure SET 

	lft = lft + 
		CASE
			WHEN new_parent_rgt < origin_lft 
			THEN 
				CASE
					WHEN lft BETWEEN origin_lft AND origin_rgt 
					THEN new_parent_rgt - origin_lft

					WHEN lft BETWEEN new_parent_rgt AND origin_lft - 1 
					THEN origin_rgt - origin_lft + 1

					ELSE 0 
				END

			WHEN new_parent_rgt > origin_rgt 
			THEN 
				CASE
					WHEN lft BETWEEN origin_lft AND origin_rgt 
					THEN new_parent_rgt - origin_rgt - 1

					WHEN lft BETWEEN origin_rgt + 1 AND new_parent_rgt - 1
					THEN origin_lft - origin_rgt - 1

					ELSE 0 
				END 

			ELSE 0 
		END,

	rgt = rgt + 
		CASE
			WHEN new_parent_rgt < origin_lft
			THEN 
				CASE
					WHEN rgt BETWEEN origin_lft AND origin_rgt 
					THEN new_parent_rgt - origin_lft
					
					WHEN rgt BETWEEN new_parent_rgt AND origin_lft - 1 
					THEN origin_rgt - origin_lft + 1

					ELSE 0 
				END

			WHEN new_parent_rgt > origin_rgt 
			THEN 
				CASE
					WHEN rgt BETWEEN origin_lft AND origin_rgt
					THEN new_parent_rgt - origin_rgt - 1 

					WHEN rgt BETWEEN origin_rgt + 1 AND new_parent_rgt - 1 
					THEN origin_lft - origin_rgt - 1

					ELSE 0 
				END 

			ELSE 0 
		END;

END$$

