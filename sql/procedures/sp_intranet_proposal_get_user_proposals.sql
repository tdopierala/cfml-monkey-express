delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_proposal_get_user_proposals`(
	in user_id int(11),
	in pge int(11),
	in cnt int(11)
)
begin

	set @a = (pge-1)*cnt;
	set @b = cnt;
	
	SET @qry = CONCAT('select
	p.proposalid as proposalid
	,p.proposalnum as proposalnum
	,p.proposaltypeid as proposaltypeid
	,p.userid as userid
	,p.managerid as managerid
	,p.usergivenname as usergivenname
	,p.managergivenname as managergivenname
	,p.proposalstep2status as proposalstep2status
	,pt.proposaltypename as proposaltypename
	,p.proposalstep1status as proposalstep1status
	,pbt.status as tripstatus
	,p.proposaldate as proposaldate
	,ps.proposalstatusname as proposalstatusname
	from trigger_holidayproposals p
	inner join proposaltypes pt on pt.id = p.proposaltypeid
	left join proposalstatuses ps on p.proposalstep2status = ps.id
	left join proposal_businesstrip pbt on pbt.id = p.proposalid
	
	where p.userid = ', user_id, ' and proposaldelete = 0
	
	order by p.proposalstep1status asc, p.proposalstep1ended desc
	
	limit ', @a, ', ', @b);
	
	PREPARE stmt FROM @qry; 
	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt;
end$$

