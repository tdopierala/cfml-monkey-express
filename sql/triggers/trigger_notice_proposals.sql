USE `intranet`;
DELIMITER $$
CREATE DEFINER=`intranet`@`%` TRIGGER `intranet`.`trigger_notice_proposals`
AFTER UPDATE ON `intranet`.`trigger_holidayproposals`
FOR EACH ROW
-- Edit trigger body code below this line. Do not edit lines above this one
BEGIN
	SET @_pnum = OLD.proposalnum;
	SET @_uid = OLD.userid;
	SET @_uname = OLD.usergivenname;
	SET @_mid = NEW.managerid;

	SET @_type = (SELECT pt.proposaltypename FROM proposaltypes pt WHERE pt.id = NEW.proposaltypeid);
	
	IF NEW.proposalhrvisible = 1 THEN
		IF NEW.proposalstep2status = 1 THEN
			
			INSERT INTO users_notices (`userid`, `message`, `date`) VALUES (@_mid, concat('Wniosek pracownika ', @_uname,' nr ', @_pnum,' oczekuje na akceptację'), NOW());
		
		ELSEIF NEW.proposalstep2status = 2 THEN
			
			INSERT INTO users_notices (`userid`, `message`, `date`) VALUES (@_uid, concat(@_type, ' nr ', @_pnum, IF(@_type=2 OR @_type=4, ' zostało zaakceptowane', ' został zaakceptowany')), NOW());
		
		ELSEIF NEW.proposalstep2status = 3 THEN
			
			INSERT INTO users_notices (`userid`, `message`, `date`) VALUES (@_uid, concat(@_type, ' nr ', @_pnum, IF(@_type=2 OR @_type=4, ' zostało zaakceptowane', ' został zaakceptowany')), NOW());
		
		END IF;
	END IF;
END