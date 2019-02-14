CREATE DEFINER=`intranet`@`%` PROCEDURE `intranet_getuserholidays`(
 in t_date varchar(16) character set utf8,
 in t_page int(2),
 in t_records int(3))
begin

 declare holidaydate varchar(16) character set utf8;
 set holidaydate = concat('%', ltrim(rtrim(t_date)), '%');


 SELECT 
	trigger_holidayproposals.id,
	trigger_holidayproposals.proposalid,
	trigger_holidayproposals.proposaltypeid,
	trigger_holidayproposals.userid,
	trigger_holidayproposals.managerid,
	trigger_holidayproposals.proposalstep1status,
	trigger_holidayproposals.proposalstep2status,
	trigger_holidayproposals.usergivenname,
	trigger_holidayproposals.managergivenname,
	trigger_holidayproposals.proposaldate,
	trigger_holidayproposals.proposalhrvisible,
	trigger_holidayproposals.proposalstep1ended,
	trigger_holidayproposals.proposalstep2ended,
	trigger_holidayproposals.proposaldatefrom,
	trigger_holidayproposals.proposaldateto,
	substitutions.id AS substitutionid,
	substitutions.userid AS substitutionuserid,
	substitutions.substituteid,
	substitutions.substitutetime,
	substitutions.substitutename,
	substitutions.proposalid AS substitutionproposalid,
	substitutions.substitutephoto,
	substitutions.substituteaccess,
	u.photo
FROM 
	trigger_holidayproposals LEFT OUTER JOIN substitutions ON trigger_holidayproposals.proposalid = substitutions.proposalid
inner join users u on trigger_holidayproposals.userid = u.id
WHERE
	trigger_holidayproposals.proposalstep1status = 2 AND
	trigger_holidayproposals.proposalstep2status = 2 AND
	trigger_holidayproposals.proposaldate like holidaydate;
end
