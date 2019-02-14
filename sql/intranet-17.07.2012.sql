-- intranet_users_make_space_in_tree
drop procedure if exists intranet_users_make_space_in_tree$$
CREATE DEFINER=`intranet`@`%` PROCEDURE `intranet_users_make_space_in_tree`(
 in currentlft int(4),
 in currentrgt int(4),
 in parentlft int(4),
 in parentrgt int(4))
begin

 declare elementsize int(4);
 set elementsize = (currentrgt - currentlft + 1);

 update users set lft = lft+elementsize where lft >= currentlft;
 update users set rgt = rgt+elementsize where rgt >= currentlft;
 
end$$

-- intranet_users_move_element
drop procedure if exists intranet_users_move_element$$
CREATE DEFINER=`intranet`@`%` PROCEDURE `intranet_users_move_element`(
 in currentlft int(4),
 in currentrgt int(4),
 in parentlft int(4),
 in parentrgt int(4))
begin
 
 declare elementsize int(4);
 declare dist int(4);
 
 set elementsize = (currentrgt - currentlft + 1);
 set dist = (parentlft - currentlft + elementsize);

 update users set lft=lft+dist, rgt=rgt+dist where lft >= currentlft and rgt < parentrgt + elementsize; -- where lft=currentlft;
 -- update users set rgt=rgt+elementsize; -- where rgt=currentrgt;

end$$


-- intranet_users_remove_space_in_tree
drop procedure if exists intranet_users_remove_space_in_tree$$
CREATE DEFINER=`intranet`@`%` PROCEDURE `intranet_users_remove_space_in_tree`(
 in currentlft int(4),
 in currentrgt int(4))
begin
 
 declare elementsize int(4);
 set elementsize = (currentrgt - currentlft + 1);

 update users set lft=lft-elementsize where lft > currentlft;
 update users set rgt=rgt-elementsize where rgt > currentrgt;

end$$
 

drop procedure if exists intranet_users_move$$
CREATE definer = 'intranet' PROCEDURE `intranet_users_move`(IN rootuserid int(11), IN parentuserid int(11))
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
END$$



drop view if exists tmp_users;
drop view if exists view_users;
create view view_users as 
SELECT    id,    active,     login,     photo,     departmentid,     givenname,     sn,     mail,     samaccountname,     departmentname,     lft,     rgt,     parent_id,    (select count(parent.id)-1 from users as parent where node.lft between parent.lft and parent.rgt) as level,
    (select distinct userattributevaluetext from userattributevalues ua where ua.userid = node.id and ua.attributeid=123 limit 1) as position,
    (rgt - lft - 1) as size  FROM users AS node  WHERE node.lft != 0 AND node.rgt != 0  ORDER BY node.lft;


SELECT O2.member, COUNT(O1.member) AS level FROM OrgChart AS O1, OrgChart AS O2WHERE O2.lft BETWEEN O1.lft AND O1.rgt GROUP BY O2.member;