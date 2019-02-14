DELIMITER $$
drop trigger if exists trigger_insert_attribute$$
CREATE DEFINER=`intranet` trigger trigger_insert_attribute after insert on attributes for each row
begin
 call sp_intranet_add_blank_user_attribute(NEW.id);
 call sp_intranet_add_blank_document_attribute(NEW.id);
 call sp_intranet_add_blank_place_attribute(NEW.id);
 call sp_intranet_add_blank_store_attribute(NEW.id);
end$$

drop trigger if exists t_documentattributevalue$$
CREATE DEFINER=`intranet` trigger t_documentattributevalue after insert on documentattributevalues for each row
begin
 if new.attributeid = 100 then
   update cron_invoicereports set numer_faktury = new.documentattributetextvalue where documentid = new.documentid;
   update trigger_workflowsearch set numer_faktury = new.documentattributetextvalue where documentid = new.documentid;
 end if;

 if new.attributeid = 101 then
   update cron_invoicereports set netto = new.documentattributetextvalue where documentid = new.documentid;
   update trigger_workflowsearch set netto = new.documentattributetextvalue where documentid = new.documentid;
 end if;

 if new.attributeid = 102 then
   update cron_invoicereports set brutto = new.documentattributetextvalue where documentid = new.documentid;
   update trigger_workflowsearch set brutto = new.documentattributetextvalue where documentid = new.documentid;
   update trigger_workflowsteplists set brutto = new.documentattributetextvalue where documentid = new.documentid;
 end if;

 if new.attributeid = 103 then
   update cron_invoicereports set data_wystawienia = new.documentattributetextvalue where documentid = new.documentid;
   update trigger_workflowsearch set data_wystawienia = new.documentattributetextvalue where documentid = new.documentid;
 end if;

 if new.attributeid = 104 then
   update cron_invoicereports set data_sprzedazy = new.documentattributetextvalue where documentid = new.documentid;
   update trigger_workflowsearch set data_sprzedazy = new.documentattributetextvalue where documentid = new.documentid;
 end if;

 if new.attributeid = 105 then
   update cron_invoicereports set data_platnosci = new.documentattributetextvalue where documentid = new.documentid;
   update trigger_workflowsearch set data_platnosci = new.documentattributetextvalue where documentid = new.documentid;
 end if;

 if new.attributeid = 106 then
   update cron_invoicereports set data_wplywu = new.documentattributetextvalue where documentid = new.documentid;
   update trigger_workflowsearch set data_wplywu = new.documentattributetextvalue where documentid = new.documentid;
 end if;

 if new.attributeid = 108 then
   update cron_invoicereports set numer_faktury_zewnetrzny = new.documentattributetextvalue where documentid = new.documentid;
   update trigger_workflowsearch set numer_faktury_zewnetrzny = new.documentattributetextvalue where documentid = new.documentid;
 end if;
end$$

drop trigger if exists trigger_update_documentattributevalues$$
CREATE DEFINER=`intranet` trigger trigger_update_documentattributevalues after update on documentattributevalues for each row
begin
 if new.attributeid = 100 then
   update cron_invoicereports set numer_faktury = new.documentattributetextvalue where documentid = new.documentid;
   update trigger_workflowsearch set numer_faktury = new.documentattributetextvalue where documentid = new.documentid;
 end if;

 if new.attributeid = 101 then
   update cron_invoicereports set netto = new.documentattributetextvalue where documentid = new.documentid;
   update trigger_workflowsearch set netto = new.documentattributetextvalue where documentid = new.documentid;
 end if;

 if new.attributeid = 102 then
   update cron_invoicereports set brutto = new.documentattributetextvalue where documentid = new.documentid;
   update trigger_workflowsearch set brutto = new.documentattributetextvalue where documentid = new.documentid;
   update trigger_workflowsteplists set brutto = new.documentattributetextvalue where documentid = new.documentid;
 end if;

 if new.attributeid = 103 then
   update cron_invoicereports set data_wystawienia = new.documentattributetextvalue where documentid = new.documentid;
   update trigger_workflowsearch set data_wystawienia = new.documentattributetextvalue where documentid = new.documentid;
 end if;

 if new.attributeid = 104 then
   update cron_invoicereports set data_sprzedazy = new.documentattributetextvalue where documentid = new.documentid;
   update trigger_workflowsearch set data_sprzedazy = new.documentattributetextvalue where documentid = new.documentid;
 end if;

 if new.attributeid = 105 then
   update cron_invoicereports set data_platnosci = new.documentattributetextvalue where documentid = new.documentid;
   update trigger_workflowsearch set data_platnosci = new.documentattributetextvalue where documentid = new.documentid;
 end if;

 if new.attributeid = 106 then
   update cron_invoicereports set data_wplywu = new.documentattributetextvalue where documentid = new.documentid;
   update trigger_workflowsearch set data_wplywu = new.documentattributetextvalue where documentid = new.documentid;
 end if;

 if new.attributeid = 108 then
   update cron_invoicereports set numer_faktury_zewnetrzny = new.documentattributetextvalue where documentid = new.documentid;
   update trigger_workflowsearch set numer_faktury_zewnetrzny = new.documentattributetextvalue where documentid = new.documentid;
 end if;
end$$

drop trigger if exists trigger_insert_documents$$
CREATE DEFINER=`intranet` trigger trigger_insert_documents after insert on documents for each row
begin
 declare l_nazwa1 text character set utf8;
 declare l_nazwa2 text character set utf8;
 declare l_nip varchar(16) character set utf8;

 set l_nazwa1 = (select nazwa1 from contractors where id = new.contractorid);
 set l_nazwa2 = (select nazwa2 from contractors where id = new.contractorid);
 set l_nip = (select nip from contractors where id = new.contractorid);
 insert into cron_invoicereports (documentid, contractorid, nazwa1, nazwa2, nip) values (new.id, new.contractorid, l_nazwa1, l_nazwa2, l_nip);

 -- Zapisanie podstawowych danych do wyszukiwania faktur w intranecie
 insert into trigger_workflowsearch (documentid, nazwa1, nazwa2, nip, contractorid) values (new.id, l_nazwa1, l_nazwa2, l_nip, new.contractorid);

 insert into trigger_workflowsteplists (documentid, contractorname, delegation, hr_documentvisible) values (new.id, l_nazwa1, new.delegation, 1);
end$$

drop trigger if exists trigger_update_documents$$
CREATE DEFINER=`intranet`  trigger trigger_update_documents after update on documents for each row
begin

 if new.typeid != 0 then
   update trigger_workflowsteplists set typeid=new.typeid where documentid = new.id;
 end if;

end$$

drop trigger if exists triggers_insert_group$$
CREATE DEFINER=`intranet` trigger triggers_insert_group after insert on groups for each row
begin
 call sp_intranet_join_group_with_rules(NEW.id);
 call sp_intranet_join_group_with_users(NEW.id);
end$$

drop trigger if exists trigger_intranet_place_collection_instance_comments_add$$
CREATE DEFINER=`intranet`  trigger trigger_intranet_place_collection_instance_comments_add after insert on place_collectioninstancecomments for each row
begin
	insert into place_participants (instanceid, userid) values (NEW.instanceid, NEW.userid);
end$$

drop trigger if exists trigger_intranet_place_generate_blank_collection_fields$$
CREATE DEFINER=`intranet`  trigger trigger_intranet_place_generate_blank_collection_fields after insert on place_collectioninstances for each row
begin

	call sp_intranet_place_generate_blank_collection_instance(NEW.instanceid, NEW.collectionid, NEW.id, NEW.userid);
	insert into place_participants (instanceid, userid) values (NEW.instanceid, NEW.userid); 
	
end$$


drop trigger if exists trigger_intranet_place_collection_instance_value_comment_add$$
CREATE DEFINER=`intranet`  trigger trigger_intranet_place_collection_instance_value_comment_add after insert on place_collectioninstancevaluecomments for each row
begin
	insert into place_participants (instanceid, userid) values (NEW.instanceid, NEW.userid);
end$$


drop trigger if exists trigger_intranet_place_update_collection_instance$$
CREATE DEFINER=`intranet`  trigger trigger_intranet_place_update_collection_instance after update on place_collectioninstancevalues for each row
begin
	if NEW.collectionid = 1 and NEW.fieldid = 49 then
		update trigger_rivals set rivalname = NEW.fieldvalue where collectioninstanceid = NEW.collectioninstanceid;
	end if;
	
	if NEW.collectionid = 1 and NEW.fieldid = 10 then
		update trigger_rivals set rivalprovince = NEW.fieldvalue where collectioninstanceid = NEW.collectioninstanceid; 
	end if;
	
	if NEW.collectionid = 1 and NEW.fieldid = 7 then
		update trigger_rivals set rivalcity = NEW.fieldvalue where collectioninstanceid = NEW.collectioninstanceid;
	end if;
	
	if NEW.collectionid = 1 and NEW.fieldid = 9 then
		update trigger_rivals set rivalstreet = NEW.fieldvalue where collectioninstanceid = NEW.collectioninstanceid;
	end if;
	
	if NEW.collectionid = 1 and NEW.fieldid = 11 then
		update trigger_rivals set rivalstreetnumber = NEW.fieldvalue where collectioninstanceid = NEW.collectioninstanceid;
	end if;
	
	if NEW.collectionid = 1 and NEW.fieldid = 12 then
		update trigger_rivals set rivalhomenumber = NEW.fieldvalue where collectioninstanceid = NEW.collectioninstanceid;
	end if;
	
	if NEW.collectionid = 1 and NEW.fieldid = 60 then
		update trigger_rivals set rivalbinaryphoto = NEW.fieldbinaryvalue where collectioninstanceid = NEW.collectioninstanceid;
	end if;
	
	if NEW.collectionid = 1 and NEW.fieldid = 53 then
		update trigger_rivals set otwarte_od = NEW.fieldvalue where collectioninstanceid = NEW.collectioninstanceid;
	end if;
	
	if NEW.collectionid = 1 and NEW.fieldid=58 then
		update trigger_rivals set otwarte_do = NEW.fieldvalue where collectioninstanceid = NEW.collectioninstanceid;
	end if;
	
	if NEW.collectionid = 1 and NEW.fieldid=52 then
		update trigger_rivals set liczba_klientow = NEW.fieldvalue where collectioninstanceid = NEW.collectioninstanceid;
	end if;
	
	if NEW.collectionid = 1 and NEW.fieldid=51 then
		update trigger_rivals set szacowany_obrot = NEW.fieldvalue where collectioninstanceid = NEW.collectioninstanceid;
	end if;
	
	
end$$

drop trigger if exists trigger_intranet_add_collection$$
CREATE DEFINER=`intranet`  trigger trigger_intranet_add_collection after insert on place_collections for each row
begin
	call sp_intranet_place_add_user_collection_privileges(NEW.id);
end$$


drop trigger if exists trigger_intranet_add_place_file_type$$
CREATE DEFINER=`intranet`  trigger trigger_intranet_add_place_file_type after insert on place_filetypes for each row
begin
	call sp_intranet_create_blank_place_file_type_privileges(NEW.id);
end$$


drop trigger if exists trigger_intranet_add_place_form$$
CREATE DEFINER=`intranet`  trigger trigger_intranet_add_place_form after insert on place_forms for each row
begin
	call sp_intranet_create_blank_user_place_user_to_form_privileges(NEW.id);
end$$


drop trigger if exists trigger_intranet_add_place_group$$
CREATE DEFINER=`intranet`  trigger trigger_intranet_add_place_group after insert on place_groups for each row
begin
	call sp_intranet_place_report_assign_fields_to_group(NEW.id);
end$$


drop trigger if exists trigger_intranet_place_instance_file_type_comment_add$$
CREATE DEFINER=`intranet`  trigger trigger_intranet_place_instance_file_type_comment_add after insert on place_instancefiletypecomments for each row
begin
	insert into place_participants (instanceid, userid) values (NEW.instanceid, NEW.userid);
end$$


drop trigger if exists trigger_intranet_place_instance_file_type_add$$
CREATE DEFINER=`intranet`  trigger trigger_intranet_place_instance_file_type_add after insert on place_instancefiletypes for each row
begin
	insert into place_participants (instanceid, userid) values (NEW.instanceid, NEW.userid);
end$$


drop trigger if exists trigger_intranet_place_instance_form_comment_add$$
CREATE DEFINER=`intranet`  trigger trigger_intranet_place_instance_form_comment_add after insert on place_instanceformcomments for each row
begin
	insert into place_participants (instanceid, userid) values (NEW.instanceid, NEW.userid);
end$$


drop trigger if exists trigger_place_instance_forms_update$$
CREATE DEFINER=`intranet`  trigger trigger_place_instance_forms_update after update on place_instanceforms for each row
begin
	-- Zapisanie miejscowości
	if NEW.formfieldid = 7 then
		update trigger_place_instances set city = NEW.formfieldvalue where instanceid = NEW.instanceid;
	end if;
	
	-- Zapisanie ulicy
	if NEW.formfieldid = 9 then
		update trigger_place_instances set street = NEW.formfieldvalue where instanceid = NEW.instanceid;
	end if;
	
	-- Numer ulicy/domu 
	if NEW.formfieldid = 11 then
		update trigger_place_instances set streetnumber = NEW.formfieldvalue where instanceid = NEW.instanceid;
	end if; 
	
	-- Numer mieszkania
	if NEW.formfieldid = 12 then
		update trigger_place_instances set homenumber = NEW.formfieldvalue where instanceid = NEW.instanceid;
	end if;
	
	-- Kod pocztowy
	if NEW.formfieldid = 54 then
		update trigger_place_instances set postalcode = NEW.formfieldvalue where instanceid = NEW.instanceid;
	end if;
	
end$$


drop trigger if exists trigger_intranet_place_add_photo_to_place_instance$$
CREATE DEFINER=`intranet`  trigger trigger_intranet_place_add_photo_to_place_instance after insert on place_instancephototypes for each row 
begin
	insert into place_participants (instanceid, userid) values (NEW.instanceid, NEW.userid);
end$$


drop trigger if exists trigger_intranet_place_create_blank_elements$$
CREATE DEFINER=`intranet`  trigger trigger_intranet_place_create_blank_elements after insert on place_instances for each row
begin

	declare t_givenname varchar(64) character set utf8;
	declare t_sn varchar(64) character set utf8;
	declare t_position varchar(128) character set utf8;
	
	set t_givenname = (select givenname from view_users where id = NEW.userid);
	set t_sn = (select sn from view_users where id = NEW.userid);
	set t_position = (select position from view_users where id = NEW.userid);
	
	insert into trigger_place_instances (instanceid, instancecreated, userid, givenname, sn, position) values (NEW.id, NEW.instancecreated, NEW.userid, t_givenname, t_sn, t_position);

 call sp_intranet_generate_blank_first_place_step(NEW.id, NEW.userid);
 call sp_intranet_generate_blank_place_step_form_instances(NEW.id, -1);
 -- call sp_intranet_generate_blank_place_file_instances(NEW.id, -1);
 -- call sp_intranet_generate_blank_place_photo_instances(NEW.id, -1);

 -- Zapisanie użytkownika, k†óry bierze udział w tej nieruchomości
 insert into place_participants (instanceid, userid) values (NEW.id, NEW.userid);

end$$


drop trigger if exists trigger_intranet_add_report$$
CREATE DEFINER=`intranet`  trigger trigger_intranet_add_report after insert on place_reports for each row
begin
	call sp_intranet_place_add_user_report_privileges(NEW.id);
end$$


drop trigger if exists trigger_intranet_place_workflow_add_step_status$$
CREATE DEFINER=`intranet`  trigger trigger_intranet_place_workflow_add_step_status after insert on place_workflows for each row
begin
	update trigger_place_instances t set stepid = NEW.stepid, instancestatusid = NEW.statusid, instancereasonid = NEW.instancereasonid where t.instanceid = NEW.instanceid;
end$$


drop trigger if exists trigger_intranet_place_workflow_change_step_status$$
CREATE DEFINER=`intranet`  trigger trigger_intranet_place_workflow_change_step_status after update on place_workflows for each row
begin

	update trigger_place_instances set
	stepid = 
	case
		when NEW.stepid = 8
			then stepid=-1
			else stepid = stepid
	end 
	
	,instancestatusid = NEW.statusid, instancereasonid = NEW.instancereasonid
	

	,rejectreasonid = NEW.instancereasonid, rejectnote = NEW.workflownote, rejectuserid = NEW.user2, rejectdatetime = Now() 
	
	where 
		instanceid = NEW.instanceid;
		
	insert into place_participants (instanceid, userid) values (NEW.instanceid, NEW.user2);
	
end$$


drop trigger if exists trigger_insert_places$$
CREATE DEFINER=`intranet`  trigger trigger_insert_places after insert on places for each row
begin
 -- Tworzę pierwszy krok obiegu nieruchomości
 insert into placeworkflows (placeid, userid, placestatusid, placestepid, placeworkflowstart) 
 values (NEW.id, NEW.userid, 1, 1, Now());

 -- update places set placestepid = 1, placestatusid=1 where id=NEW.id;

 -- Tworze puste atrybuty dla nieruchomości
 call sp_intranet_create_blank_place_attributes(NEW.id);

 -- Tworzę pierwszy wpis do tabeli raportów obiegu nieruchomości
 -- insert into trigger_placesteplists (placeid, step1, step1datetime, step1status) values (NEW.id, 1, Now(), 1);
end$$


drop trigger if exists trigger_insert_placeworkflows$$
CREATE DEFINER=`intranet`  trigger trigger_insert_placeworkflows after insert on placeworkflows for each row
begin

 -- update places set placestepid = NEW.placestepid, placestatusid=NEW.placestatusid where id=NEW.placeid;

 if NEW.placestepid = 1 then
   insert into trigger_placesteplists (placeid, step1, step1datetime, step1status) values (NEW.placeid, NEW.placestepid, NEW.placeworkflowstart, NEW.placestatusid);
   -- update places set placestepid = NEW.placestepid, placestatusid=NEW.placestatusid where id=NEW.placeid;
 end if;

 if NEW.placestepid = 2 then
   update trigger_placesteplists set step2=NEW.placestepid, step2datetime=NEW.placeworkflowstart, step2status=NEW.placestatusid where placeid=NEW.placeid;
   -- update places set placestepid = NEW.placestepid, placestatusid=NEW.placestatusid where id=NEW.placeid;
 end if;

 if NEW.placestepid = 3 then
   update trigger_placesteplists set step3=NEW.placestepid, step3datetime=NEW.placeworkflowstart, step3status=NEW.placestatusid where placeid=NEW.placeid;
   -- update places set placestepid = NEW.placestepid, placestatusid=NEW.placestatusid where id=NEW.placeid;
 end if;

 if NEW.placestepid = 4 then
   update trigger_placesteplists set step4=NEW.placestepid, step4datetime=NEW.placeworkflowstart, step4status=NEW.placestatusid where placeid=NEW.placeid;
   -- update places set placestepid = NEW.placestepid, placestatusid=NEW.placestatusid where id=NEW.placeid;
 end if;

 if NEW.placestepid = 5 then
   update trigger_placesteplists set step5=NEW.placestepid, step5datetime=NEW.placeworkflowstart, step5status=NEW.placestatusid where placeid=NEW.placeid;
   -- update places set placestepid = NEW.placestepid, placestatusid=NEW.placestatusid where id=NEW.placeid;
 end if;
end$$


drop trigger if exists trigger_update_placeworkflows$$
CREATE DEFINER=`intranet`  trigger trigger_update_placeworkflows after update on placeworkflows for each row
begin

 -- update places set placestepid = NEW.placestepid, placestatusid=NEW.newplacestatusid where id=NEW.placeid;

 if NEW.placestepid = 1 and NEW.newplacestatusid != 1 then
   update trigger_placesteplists set step1=NEW.placestepid, step1datetime=NEW.placeworkflowstop, step1status=NEW.newplacestatusid where placeid=NEW.placeid;
 end if;

 if NEW.placestepid = 2 and NEW.newplacestatusid != 1 then
   update trigger_placesteplists set step2=NEW.placestepid, step2datetime=NEW.placeworkflowstop, step2status=NEW.newplacestatusid where placeid=NEW.placeid;
 end if;

 if NEW.placestepid = 3 and NEW.newplacestatusid != 1 then
   update trigger_placesteplists set step3=NEW.placestepid, step3datetime=NEW.placeworkflowstop, step3status=NEW.newplacestatusid where placeid=NEW.placeid;
 end if;

 if NEW.placestepid = 4 and NEW.newplacestatusid != 1 then
   update trigger_placesteplists set step4=NEW.placestepid, step4datetime=NEW.placeworkflowstop, step4status=NEW.newplacestatusid where placeid=NEW.placeid;
 end if;

 if NEW.placestepid = 5 and NEW.newplacestatusid != 1 then
   update trigger_placesteplists set step5=NEW.placestepid, step5datetime=NEW.placeworkflowstop, step5status=NEW.newplacestatusid where placeid=NEW.placeid;
 end if;

end$$


drop trigger if exists t_insertproposalattributevalue$$
CREATE DEFINER=`intranet`  trigger t_insertproposalattributevalue after insert on proposalattributevalues for each row
begin
 if new.attributeid = 132 then
   update trigger_userholidayproposals set proposaluser = new.proposalattributevaluetext where proposalid = new.proposalid;
 end if;

end$$


drop trigger if exists t_updateproposalattributevalue$$
CREATE DEFINER=`intranet`  trigger t_updateproposalattributevalue after update on proposalattributevalues for each row
begin
 if new.attributeid = 134 then
   update trigger_holidayproposals set proposaldate = new.proposalattributevaluetext where proposalid = new.proposalid;
 end if;

 if new.attributeid = 127 then
   update trigger_holidayproposals set proposaldatefrom = new.proposalattributevaluetext where proposalid = new.proposalid;
 end if;

 if new.attributeid = 128 then
   update trigger_holidayproposals set proposaldateto = new.proposalattributevaluetext where proposalid = new.proposalid;
 end if;
end$$


drop trigger if exists t_proposal$$
CREATE DEFINER=`intranet` trigger t_proposal after insert on proposals for each row
begin
 declare t_givenname varchar(64) character set utf8;
 declare t_sn varchar(64) character set utf8;
 set t_givenname = (select givenname from users where id=new.userid);
 set t_sn = (select sn from users where id=new.userid);

 insert into trigger_holidayproposals (proposalid, proposalnum, proposaltypeid, userid, usergivenname) values (new.id, new.proposalnum, new.proposaltypeid, new.userid, concat(t_givenname, " ", t_sn));

end$$


drop trigger if exists t_updateproposal$$
CREATE DEFINER=`intranet`  trigger t_updateproposal after update on proposals for each row
begin
 update trigger_holidayproposals set proposalhrvisible = new.proposalvisible where proposalid = new.id;
end$$ 


drop trigger if exists t_proposalstep$$
CREATE DEFINER=`intranet`  trigger t_proposalstep after insert on proposalsteps for each row
begin

 declare t_givenname varchar(64) character set utf8;
 declare t_sn varchar(64) character set utf8;

 if new.proposalstepstatusid = 1 then
   update trigger_holidayproposals set proposalstep1status = new.proposalstatusid where proposalid = new.proposalid;
 end if;

 if new.proposalstepstatusid = 2 then
   set t_givenname = (select givenname from users where id = new.userid);
   set t_sn = (select sn from users where id = new.userid);
   update trigger_holidayproposals set proposalstep2status = new.proposalstatusid, managerid = new.userid, managergivenname = concat(t_givenname, " ", t_sn) where proposalid = new.proposalid;
 end if;
end$$


drop trigger if exists t_updateproposalstep$$
CREATE DEFINER=`intranet`  trigger t_updateproposalstep after update on proposalsteps for each row
begin
 if new.proposalstepstatusid = 1 then
   update trigger_holidayproposals set proposalstep1status = new.proposalstatusid, proposalstep1ended = new.proposalstepended where proposalid = new.proposalid;
 end if;

 if new.proposalstepstatusid = 2 then
   update trigger_holidayproposals set proposalstep2status = new.proposalstatusid, proposalstep2ended = new.proposalstepended where proposalid = new.proposalid;
 end if;
end$$


drop trigger if exists trigger_intranet_add_protocol_field$$
CREATE DEFINER=`intranet`  TRIGGER `trigger_intranet_add_protocol_field` AFTER INSERT ON `protocol_fields`
FOR EACH ROW begin
	call sp_intranet_protocol_assign_field_with_groups(NEW.id);
end$$


drop trigger if exists trigger_intranet_protocol_add_group$$
CREATE DEFINER=`intranet`  TRIGGER `trigger_intranet_protocol_add_group` AFTER INSERT ON `protocol_groups`
FOR EACH ROW begin
	call sp_intranet_protocol_assign_group_with_fields(NEW.id);
	call sp_intranet_protocol_assign_group_with_types(NEW.id);
end$$


drop trigger if exists trigger_intranet_protocol_add_instance$$
CREATE DEFINER=`intranet`  trigger trigger_intranet_protocol_add_instance after insert on protocol_instances for each row
begin
	call sp_intranet_protocol_create_blank_protocol(NEW.id, NEW.typeid);
end$$


drop trigger if exists trigger_intranet_protocol_add_type$$
CREATE DEFINER=`intranet`  TRIGGER `trigger_intranet_protocol_add_type` AFTER INSERT ON `protocol_types`
FOR EACH ROW begin
	call sp_intranet_protocol_assign_type_with_groups(NEW.id);
end$$


drop trigger if exists trigger_intranet_add_new_rule$$
CREATE DEFINER=`intranet`  trigger trigger_intranet_add_new_rule after insert on rules for each row
begin

 declare group_id int(11);
 declare no_more_groups int default false;
 declare groups_cursor cursor for select id from groups;
 declare continue handler for not found set no_more_groups = true;

 open groups_cursor;
 LOOP1: loop
   fetch groups_cursor into group_id;
   if no_more_groups then
     close groups_cursor;
     leave LOOP1;
   end if;

   insert into grouprules (ruleid, groupid, access) values (NEW.id, group_id, 0);

 end loop LOOP1;

end$$


drop trigger if exists trigger_insert_ssg_questionaire$$
CREATE DEFINER=`intranet`  trigger trigger_insert_ssg_questionaire after insert on ssg_questionnaires for each row
begin

 declare question_id int(11);
 declare no_more_questions int default false;
 declare questions_cursor cursor for select id from ssg_questions;
 declare continue handler for not found set no_more_questions = true;

 open questions_cursor;
 LOOP1: loop
   fetch questions_cursor into question_id;
   if no_more_questions then
     close questions_cursor;
     leave LOOP1;
   end if;

   insert into ssg_answers (questionid, questionaryid) values (question_id, NEW.id);

 end loop LOOP1;

end$$


drop trigger if exists trigger_intranet_add_user_groups$$
CREATE DEFINER=`intranet`  trigger trigger_intranet_add_user_groups after insert on users for each row
begin
  call sp_intranet_join_user_with_groups(NEW.id);
  call sp_intranet_create_blank_user_place_form_privileges(NEW.id);
  call sp_intranet_create_blank_user_place_collection_privileges(NEW.id);
  call sp_intranet_create_blank_user_place_file_type_privileges(NEW.id);
  call sp_intranet_create_blank_user_place_photo_type_privileges(NEW.id);
  call sp_intranet_create_blank_user_place_step_privileges(NEW.id);
  call sp_intranet_place_add_report_to_user_privileges(NEW.id);
  call sp_intranet_generate_blank_user_menu(NEW.id);
  call sp_intranet_create_default_user_protocol_number(NEW.id);
end$$


drop trigger if exists t_workflow$$
CREATE DEFINER=`intranet`  trigger t_workflow after insert on workflows for each row
begin

 declare l_nazwa1 text character set utf8;
 declare l_contractorid int(11);
 declare l_documentname text character set utf8;

 set l_contractorid = (select contractorid from documents where id = new.documentid);
 set l_documentname = (select documentattributetextvalue from documentattributevalues where documentid = new.documentid and attributeid = 100);

 -- Aktualizacja danych o obiegu dokumentów w tabeli z raportami faktur
 update cron_invoicereports set workflowid = new.id where documentid = new.documentid;

 set l_nazwa1 = (select nazwa1 from contractors where id = l_contractorid);

 -- Zaktualizowanie wpisu z tabelą kroków.
 -- Wpis został dodany przez trigger t_document
 update trigger_workflowsteplists set workflowid = new.id, workflowcreated = new.workflowcreated, documentname = l_documentname where documentid = new.documentid;
 -- insert into trigger_workflowsteplists (workflowid, documentid, contractorname, workflowcreated, documentname) values (new.id, new.documentid, l_nazwa1, new.workflowcreated, l_documentname);

 update trigger_workflowsearch set workflowid = new.id where documentid = new.documentid;
end$$


drop trigger if exists trigger_insert_workflowsteps$$
CREATE DEFINER=`intranet`  trigger trigger_insert_workflowsteps after insert on workflowsteps for each row
begin

 if new.workflowstepstatusid = 1 then
   update trigger_workflowsteplists set stepdescriptionid = new.workflowstatusid where workflowid = new.workflowid;
   -- Dodanie informacji o departamencie, który wygenerował fakturę
   update cron_invoicereports set departmentname = (select departmentname from users where id = new.userid limit 1) where workflowid = new.workflowid;
 end if;

 if new.workflowstepstatusid = 2 then
   update trigger_workflowsteplists set stepcontrollingid = new.workflowstatusid where workflowid = new.workflowid;
 end if;

 if new.workflowstepstatusid = 3 then
   update trigger_workflowsteplists set stepapproveid = new.workflowstatusid where workflowid = new.workflowid;
 end if;

 if new.workflowstepstatusid = 4 then
   update trigger_workflowsteplists set stepaccountingid = new.workflowstatusid where workflowid = new.workflowid;
 end if;

 if new.workflowstepstatusid = 5 then
   update trigger_workflowsteplists set stepacceptid = new.workflowstatusid where workflowid = new.workflowid;
 end if;

end$$

drop trigger if exists trigger_update_workflowteps$$
CREATE DEFINER=`intranet`  trigger trigger_update_workflowteps after update on workflowsteps for each row
begin

 -- Aktualizacja pierwszego kroku obiegu dokumentów
 if new.workflowstepstatusid = 1 then
   update trigger_workflowsteplists set stepdescriptionid = new.workflowstatusid, workflowstepnote = new.workflowstepnote where workflowid = new.workflowid;
   update trigger_workflowsearch set workflowstepnote = new.workflowstepnote where workflowid = new.workflowid;
   -- Dodanie informacji o departamencie, który wygenerował fakturę
   update cron_invoicereports set departmentname = (select departmentname from users where id = new.userid limit 1) where workflowid = new.workflowid;
 end if;

 -- Controlling
 if new.workflowstepstatusid = 2 then
   update trigger_workflowsteplists set stepcontrollingid = new.workflowstatusid where workflowid = new.workflowid;
 end if;

 -- Dyrektor
 if new.workflowstepstatusid = 3 then
   update trigger_workflowsteplists set stepapproveid = new.workflowstatusid where workflowid = new.workflowid;
 end if;

 -- Księgowość
 if new.workflowstepstatusid = 4 then
   update trigger_workflowsteplists set stepaccountingid = new.workflowstatusid where workflowid = new.workflowid;
 end if;

 -- Prezes
 if new.workflowstepstatusid = 5 then
   update trigger_workflowsteplists set stepacceptid = new.workflowstatusid where workflowid = new.workflowid;
 end if;

 -- Aktualizacja informacji o statusie draftu
 if new.isdraft = 1 and new.workflowstepstatusid = 1 then
   update trigger_workflowsteplists set stepdescriptiondraft = new.isdraft where workflowid = new.workflowid;
 end if;

 if new.isdraft = 1 and new.workflowstepstatusid = 2 then
   update trigger_workflowsteplists set stepcontrollingdraft = new.isdraft where workflowid = new.workflowid;
 end if;

 if new.isdraft = 1 and new.workflowstepstatusid = 3 then
   update trigger_workflowsteplists set stepapproveddraft = new.isdraft where workflowid = new.workflowid;
 end if;

 if new.isdraft = 1 and new.workflowstepstatusid = 4 then
   update trigger_workflowsteplists set stepaccountingdraft = new.isdraft where workflowid = new.workflowid;
 end if;

 if new.isdraft = 1 and new.workflowstepstatusid = 5 then
   update trigger_workflowsteplists set stepacceptdraft = new.isdraft where workflowid = new.workflowid;
 end if;

 if new.isdraft = 0 and new.workflowstepstatusid = 1 then
   update trigger_workflowsteplists set stepdescriptiondraft = new.isdraft where workflowid = new.workflowid;
 end if;

 if new.isdraft = 0 and new.workflowstepstatusid = 2 then
   update trigger_workflowsteplists set stepcontrollingdraft = new.isdraft where workflowid = new.workflowid;
 end if;

 if new.isdraft = 0 and new.workflowstepstatusid = 3 then
   update trigger_workflowsteplists set stepapproveddraft = new.isdraft where workflowid = new.workflowid;
 end if;

 if new.isdraft = 0 and new.workflowstepstatusid = 4 then
   update trigger_workflowsteplists set stepaccountingdraft = new.isdraft where workflowid = new.workflowid;
 end if;

 if new.isdraft = 0 and new.workflowstepstatusid = 5 then
   update trigger_workflowsteplists set stepacceptdraft = new.isdraft where workflowid = new.workflowid;
 end if;

 if new.workflowstepstatusid = 5 and new.workflowstatusid = 2 then
   update trigger_workflowsteplists set endeddate = new.workflowstepended where workflowid = new.workflowid;
 end if;

end$$

drop procedure if exists delete_workflow$$
CREATE DEFINER=`intranet` PROCEDURE `delete_workflow`(
 in workflow_id int(11), -- identyfikator obiegu dokumentów
 in user_id int(11), -- identyfikator użytkownika
 in ip varchar(16))
begin

 declare document_id int(11);
 set document_id = (select documentid from workflows where id = workflow_id);

 set autocommit = 0;

 start transaction;

 /* Kopiuje wpisy z tabeli documents */
 insert into del_documents select * from documents where id = document_id;
 delete from documents where id = document_id;
 insert into del_history (
   del_historydate, 
   del_historytable, 
   del_historytablefield, 
   del_historytablekey, 
   del_historyuserid, 
   del_historyip) 
 values (NOW(), 'documents', 'id', document_id, user_id, ip);

 /* Kopiuje wpisy z tabeli workflows */
 insert into del_workflows select * from workflows where id = workflow_id;
 delete from workflows where id = workflow_id;
 insert into del_history (
   del_historydate, 
   del_historytable, 
   del_historytablefield, 
   del_historytablekey, 
   del_historyuserid, 
   del_historyip) 
 values (NOW(), 'workflows', 'id', workflow_id, user_id, ip);

 /* Kopiuje wpisy z tabeli workflowstepdescriptions */
 insert into del_workflowstepdescriptions select * from workflowstepdescriptions where workflowid = workflow_id;
 delete from workflowstepdescriptions where workflowid = workflow_id;
 insert into del_history (
   del_historydate, 
   del_historytable, 
   del_historytablefield, 
   del_historytablekey, 
   del_historyuserid, 
   del_historyip) 
 values (NOW(), 'workflowstepdescriptions', 'workflowid', workflow_id, user_id, ip);

 /* Kopiuje wpisy z tabeli workflowsteps */
 insert into del_workflowsteps select * from workflowsteps where workflowid = workflow_id;
 delete from workflowsteps where workflowid = workflow_id;
 insert into del_history (
   del_historydate, 
   del_historytable, 
   del_historytablefield, 
   del_historytablekey, 
   del_historyuserid, 
   del_historyip) 
 values (NOW(), 'workflowsteps', 'workflowid', workflow_id, user_id, ip);

 /* Kopiuje wpisy z talebi workflowtosendmails */
 insert into del_workflowtosendmails select * from workflowtosendmails where workflowid = workflow_id;
 delete from workflowtosendmails where workflowid = workflow_id;
 insert into del_history (
   del_historydate, 
   del_historytable, 
   del_historytablefield, 
   del_historytablekey, 
   del_historyuserid, 
   del_historyip) 
 values (NOW(), 'workflowtosendmails', 'workflowid', workflow_id, user_id, ip);

 /* Kopiuje wpisy z tabeli cron_invoicereports */
 insert into del_cron_invoicereports select * from cron_invoicereports where workflowid = workflow_id;
 delete from cron_invoicereports where workflowid = workflow_id;
 insert into del_history (
   del_historydate, 
   del_historytable, 
   del_historytablefield, 
   del_historytablekey, 
   del_historyuserid, 
   del_historyip) 
 values (NOW(), 'cron_invoicereports', 'workflowid', workflow_id, user_id, ip);

 /* Kopiuje dane z tabeli trigger_workflowsearch */
 insert into del_trigger_workflowsearch select * from trigger_workflowsearch where workflowid = workflow_id;
 delete from trigger_workflowsearch where workflowid = workflow_id;
 insert into del_history (
   del_historydate, 
   del_historytable, 
   del_historytablefield, 
   del_historytablekey, 
   del_historyuserid, 
   del_historyip) 
 values (NOW(), 'trigger_workflowsearch', 'workflowid', workflow_id, user_id, ip);

 /* Kopiuje dane z tabeli trigger_workflowsteplists */
 insert into del_trigger_workflowsteplists select * from trigger_workflowsteplists where workflowid = workflow_id;
 delete from trigger_workflowsteplists where workflowid = workflow_id;
 insert into del_history (
   del_historydate, 
   del_historytable, 
   del_historytablefield, 
   del_historytablekey, 
   del_historyuserid, 
   del_historyip) 
 values (NOW(), 'trigger_workflowsteplists', 'workflowid', workflow_id, user_id, ip);

 /* Kopiuje dane z tabeli documentinstances */
 insert into del_documentinstances select * from documentinstances where documentid = document_id;
 delete from documentinstances where documentid = document_id;
 insert into del_history (
   del_historydate, 
   del_historytable, 
   del_historytablefield, 
   del_historytablekey, 
   del_historyuserid, 
   del_historyip) 
 values (NOW(), 'documentinstances', 'documentid', document_id, user_id, ip);

 /* Kopiuje dane z tabeli documentattributevalues */
 insert into del_documentattributevalues select * from documentattributevalues where documentid = document_id;
 delete from documentattributevalues where documentid = document_id;
 insert into del_history (
   del_historydate, 
   del_historytable, 
   del_historytablefield, 
   del_historytablekey, 
   del_historyuserid, 
   del_historyip) 
 values (NOW(), 'documentattributevalues', 'documentid', document_id, user_id, ip);

 commit;
end$$

drop procedure if exists delete_workflowstepdescription$$
CREATE DEFINER=`intranet` PROCEDURE `delete_workflowstepdescription`(
 in workflowstepdescription_id int(11),
 in user_id int(11),
 in ip varchar(16))
begin

 set autocommit = 0;

 start transaction;

   /* Kopiuje wpisy z tabeli workflowstepdescriptions */
   insert into del_workflowstepdescriptions select * from workflowstepdescriptions where id = workflowstepdescription_id;
   delete from workflowstepdescriptions where id = workflowstepdescription_id;
   insert into del_history (
     del_historydate, 
     del_historytable, 
     del_historytablefield, 
     del_historytablekey, 
     del_historyuserid, 
     del_historyip) 
   values (NOW(), 'workflowstepdescriptions', 'id', workflowstepdescription_id, user_id, ip);

 commit;
end$$

drop procedure if exists intranet_getuserholidays$$
CREATE DEFINER=`intranet` PROCEDURE `intranet_getuserholidays`(
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
end$$

drop procedure if exists intranet_users_getfulltree$$
CREATE DEFINER=`intranet` PROCEDURE `intranet_users_getfulltree`()
begin

 start transaction;

 select 
   id,
   active, 
   login, 
   photo, 
   departmentid, 
   givenname, 
   sn, 
   mail, 
   samaccountname, 
   departmentname, 
   lft, 
   rgt, 
   parent_id,
   position,
   (select count(parent.id)-1 from view_users as parent where node.lft between parent.lft and parent.rgt) as depth
 from view_users as node
 where node.lft != 0 and node.rgt != 0
 order by node.lft;

 commit;
end$$

drop procedure if exists intranet_users_move$$
CREATE DEFINER=`intranet` PROCEDURE `intranet_users_move`(IN rootuserid int(11), IN parentuserid int(11))
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

CREATE DEFINER=`intranet` PROCEDURE `p_adduserattributevalues`(in t_userid int(11))
begin
 declare t_userattributeid int(11);
 declare no_more_userattributeid int default false;
 declare userattribute_cursor cursor for select attributeid from userattributes;
 declare continue handler for not found set no_more_userattributeid = true;

 open userattribute_cursor;
 LOOP1: loop
   fetch userattribute_cursor into t_userattributeid;
   if no_more_userattributeid then
     close userattribute_cursor;
     leave LOOP1;
   end if;
   insert into userattributevalues (userid, attributeid) values (t_userid, t_userattributeid);
 end loop LOOP1;
end$$

CREATE DEFINER=`intranet` PROCEDURE `p_generateusermenu`()
begin

 start transaction;

   BLOCK1: begin

     declare l_userid int(11);
     declare no_more_users int default false;
     declare user_cursor cursor for select id from users;
     declare continue handler for not found set no_more_users = true;

     open user_cursor;

       LOOP1: loop
         fetch user_cursor into l_userid;
         if no_more_users then
           close user_cursor;
           leave LOOP1;
         end if;

           BLOCK2: begin

             declare l_menuid int(11);
             declare no_more_menus int default false;
             declare menu_cursor cursor for select id from menus;
             declare continue handler for not found set no_more_menus = true;

             open menu_cursor;
             LOOP2: loop
               fetch menu_cursor into l_menuid;
               if no_more_menus then
                 close menu_cursor;
                 leave LOOP2;
               end if;

               insert into usermenus (userid, menuid, usermenuaccess) values (l_userid, l_menuid, 0);

             end loop LOOP2;

           end BLOCK2;

       end loop LOOP1;

   END BLOCK1;

 commit;

end$$

CREATE DEFINER=`intranet` PROCEDURE `p_rebuilduserattributes`()
begin

 start transaction;

 delete from userattributes where 1 = 1;

         BLOCK2: begin

           declare attributeid int(11);
           declare no_more_attributes int default false;
           declare attributescursor cursor for select id from attributes;
           declare continue handler for not found set no_more_attributes = true;

           open attributescursor;
           LOOP2: loop
             fetch attributescursor into attributeid;
             if no_more_attributes then
               close attributescursor;
               leave LOOP2;
             end if;

             insert into userattributes (attributeid, visible) values (attributeid, 0);

           end loop LOOP2;

         end BLOCK2;

commit;

end$$

CREATE DEFINER=`intranet` PROCEDURE `p_rebuilduserattributevalues`()
begin

 start transaction;

 delete from userattributevalues where 1 = 1;

 BLOCK1: begin

   declare userid int(11);
   declare no_more_users int default false;
   declare userscursor cursor for select id from users;
   declare continue handler for not found set no_more_users = true;

   open userscursor;

     LOOP1: loop

       fetch userscursor into userid;
        if no_more_users then
           close userscursor;
           leave LOOP1;
        end if;

         BLOCK2: begin

           declare attributeid int(11);
           declare no_more_attributes int default false;
           declare attributescursor cursor for select id from attributes;
           declare continue handler for not found set no_more_attributes = true;

           open attributescursor;
           LOOP2: loop
             fetch attributescursor into attributeid;
             if no_more_attributes then
               close attributescursor;
               leave LOOP2;
             end if;

             insert into userattributevalues (userid, attributeid) values (userid, attributeid);

           end loop LOOP2;

         end BLOCK2;

     end loop LOOP1;

 end BLOCK1;

commit;

end$$

CREATE DEFINER=`intranet` PROCEDURE `p_updatecron_invoicereports`()
begin

 declare l_contractorid int(11);
 declare l_nip text character set utf8;
 declare no_more_cron_invoice_reports int default false;
 declare croninvoicereportscursor cursor for select contractorid from cron_invoicereports;
 declare continue handler for not found set no_more_cron_invoice_reports = true;

 open croninvoicereportscursor;
   LOOP2: loop
     fetch croninvoicereportscursor into l_contractorid;
       if no_more_cron_invoice_reports then
         close croninvoicereportscursor;
         leave LOOP2;
       end if;
     set l_nip = (select nip from contractors where id = l_contractorid);
     update cron_invoicereports set nip = l_nip where contractorid = l_contractorid;

   end loop LOOP2;

end$$

CREATE DEFINER=`intranet` PROCEDURE `p_update_contractors_in_trigger_workflowsteplists`()
begin
 start transaction;

 BLOCK1: begin

   declare tmp_documentid int(11);
   declare no_more_documents int default false;
   declare documents_cursor cursor for select id from documents;
   declare continue handler for not found set no_more_documents = true;

   open documents_cursor;
     LOOP1: loop
       fetch documents_cursor into tmp_documentid;
       if no_more_documents then
         close documents_cursor;
         leave LOOP1;
        end if;

        BLOCK2: begin
           declare tmp_nazwa1 text character set utf8;
           declare no_more_contractors int default false;
           declare contractors_cursor cursor for select nazwa1 from contractors c inner join documents d on c.id = d.contractorid where d.id = tmp_documentid;
           declare continue handler for not found set no_more_contractors = true;

           open contractors_cursor;
           LOOP2: loop
             fetch contractors_cursor into tmp_nazwa1;
             if no_more_contractors then
               close contractors_cursor;
               leave LOOP2;
              end if;

              update trigger_workflowsteplists set contractorname = tmp_nazwa1 where documentid = tmp_documentid;

           end loop LOOP2;

        end BLOCK2;

     end loop LOOP1;

 end BLOCK1;

 commit;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_get_ssg_statistics_by_questionary`(
 in questionary_id int(11)
)
begin

 select
   IFNULL((select count(*) from ssg_answers a1 where a1.questionaryid = questionary_id and answervalue = 1), 0) as yescount,
   IFNULL((select count(*) from ssg_answers a2 where a2.questionaryid = questionary_id and answervalue = -1), 0) as nocount,
   IFNULL((select count(*) from ssg_answers a3 where a3.questionaryid = questionary_id), 0) as totalcount,
   IFNULL((select sum(q2.questionfactor) from ssg_answers a4 inner join ssg_questions q2 on a4.questionid = q2.id where a4.answervalue = 1 and a4.questionaryid = questionary_id), 0) as sumpoints,
   IFNULL((select sum(q3.questionfactor) from ssg_answers a5 inner join ssg_questions q3 on a5.questionid = q3.id where a5.questionaryid = questionary_id), 0) as totalpoints
 from ssg_questionnaires q where q.id = questionary_id;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_add_blank_document_attribute`(
 in attribute_id int(11))
begin

 -- start transaction;
   insert into documentattributes (attributeid, documentattributevisible) value (attribute_id, 0);

   /*BLOCK1: begin

     declare document_attribute_id int(11);
     declare document_instance_id int(11);

     declare document_id int(11);
     declare no_more_documents int default false;
     declare cursor_documents cursor for select id from documents;
     declare continue handler for not found set no_more_documents = true;

     set document_attribute_id = (select id from documentattributes where attributeid = attribute_id and documentattributevisible = 0);

     open cursor_documents;
     LOOP1: loop
       fetch cursor_documents into document_id;
       if no_more_documents then
         close cursor_documents;
         leave LOOP1;
       end if;
       set document_instance_id = (select id from documentinstances where documentid = document_id);

       insert into documentattributevalues (documentattributeid, documentid, attributeid, documentinstanceid) 
       values (document_attribute_id, document_id, attribute_id, document_instance_id);

     end loop LOOP1;

   end BLOCK1;*/

 -- commit;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_add_blank_place_attribute`(
 in attribute_id int(11))
begin

 -- start transaction;

 insert into placeattributes (attributeid, placeattributevisible) value (attribute_id, 0);

 /*BLOCK1: begin
   declare place_id int(11);
   declare no_more_places int default false;
   declare cursor_places cursor for select id from places;
   declare continue handler for not found set no_more_places = true;

   open cursor_places;

     LOOP1: loop
       fetch cursor_places into place_id;
       if no_more_places then
         close cursor_places;
         leave LOOP1;
       end if;

     insert into placeattributevalues (attributeid, placeid) value (attribute_id, place_id);

     end loop LOOP1;

 end BLOCK1;*/

 -- commit;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_add_blank_store_attribute`(
in attribute_id int(11)
)
begin
 insert into store_storeattributes (attributeid, storeattributevisible) values (attribute_id, 0);
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_add_blank_user_attribute`(
in attribute_id int(11))
begin

 -- start transaction;

 insert into userattributes (attributeid, visible) value (attribute_id, 0);

 /*BLOCK1: begin

 declare user_id int(11);
 declare no_more_users int default false;
 declare cursor_users cursor for select id from users;
 declare continue handler for not found set no_more_users = true;

 open cursor_users;
 LOOP1: loop
   fetch cursor_users into user_id;
   if no_more_users then
     close cursor_users;
     leave LOOP1;
   end if;
   insert into userattributevalues (attributeid, userid) value (attribute_id, user_id);
 end loop LOOP1;

 end BLOCK1;*/

 -- commit;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_add_blank_user_attribute_value`(
 in attribute_id int(11))
begin
 start transaction;
 BLOCK1: begin

 declare user_id int(11);
 declare no_more_users int default false;
 declare cursor_users cursor for select id from users;
 declare continue handler for not found set no_more_users = true;

 open cursor_users;
 LOOP1: loop
   fetch cursor_users into user_id;
   if no_more_users then
     close cursor_users;
     leave LOOP1;
   end if;
   insert into userattributevalues (attributeid, userid) value (attribute_id, user_id);
 end loop LOOP1;

 end BLOCK1;
 commit;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_assign_user_to_menu_item`(in t_menuid int(11))
begin
 declare t_userid int(11);
 declare no_more_users int default false;
 declare users_cursor cursor for select id from users;
 declare continue handler for not found set no_more_users = true;

 open users_cursor;
 LOOP1: loop

   fetch users_cursor into t_userid;
   if no_more_users then
     close users_cursor;
     leave LOOP1;
   end if;

   insert into usermenus (userid, menuid, usermenuaccess) values (t_userid, t_menuid, 0);

 end loop LOOP1;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_create_blank_place_attributes`(
 in newPlaceId int(11))
begin

 declare attribute_id int(11);
 declare no_more_place_attributes int default false;
 declare place_attribute_cursor cursor for select attributeid from placeattributes;
 declare continue handler for not found set no_more_place_attributes = true;

 open place_attribute_cursor;
 LOOP1: loop
   fetch place_attribute_cursor into attribute_id;
   if no_more_place_attributes then
     close place_attribute_cursor;
     leave LOOP1;
   end if;

   insert into placeattributevalues (placeid, attributeid) values (newPlaceId, attribute_id);

 end loop LOOP1;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_create_blank_place_collection_privileges`()
begin

	start transaction;
	BLOCK1: begin
		declare user_id int(11);
		declare no_more_users int default false;
		declare user_cursor cursor for select id from users;
		declare continue handler for not found set no_more_users = true;
		
		open user_cursor;
		LOOP1: loop
			fetch user_cursor into user_id;
			if no_more_users then
				close user_cursor;
				leave LOOP1;
			end if;
			
			BLOCK2: begin
				
				declare collection_id int(11);
				declare no_more_collections int default false;
				declare collection_cursor cursor for select id from place_collections;
				declare continue handler for not found set no_more_collections = true;
				
				open collection_cursor;
				
				LOOP2: loop
					fetch collection_cursor into collection_id;
					if no_more_collections then
						close collection_cursor;
						leave LOOP2;
					end if;
					
					insert into place_collectionprivileges (userid, collectionid, readprivilege, writeprivilege) values (user_id, collection_id, 1, 0);
					
				end loop LOOP2;
				
			end BLOCK2;
			
		end loop LOOP1;
	end BLOCK1;
	commit;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_create_blank_place_file_type_privileges`(
	in _file_type_id int(11))
begin

	start transaction;
	BLOCK1: begin
		declare user_id int(11);
		declare no_more_users int default false;
		declare user_cursor cursor for select id from users;
		declare continue handler for not found set no_more_users = true;
		
		open user_cursor;
		LOOP1: loop
			fetch user_cursor into user_id;
			if no_more_users then
				close user_cursor;
				leave LOOP1;
			end if;
			
		insert into place_filetypeprivileges (userid, filetypeid, readprivilege, writeprivilege) 
			values (user_id, _file_type_id, 0, 0);
			
		end loop LOOP1;
	end BLOCK1;
	commit;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_create_blank_place_form_privileges`()
begin

	start transaction;
	BLOCK1: begin
		declare user_id int(11);
		declare no_more_users int default false;
		declare user_cursor cursor for select id from users;
		declare continue handler for not found set no_more_users = true;
		
		open user_cursor;
		LOOP1: loop
			fetch user_cursor into user_id;
			if no_more_users then
				close user_cursor;
				leave LOOP1;
			end if;
			
			BLOCK2: begin
				
				declare form_id int(11);
				declare no_more_forms int default false;
				declare form_cursor cursor for select id from place_forms;
				declare continue handler for not found set no_more_forms = true;
				
				open form_cursor;
				
				LOOP2: loop
					fetch form_cursor into form_id;
					if no_more_forms then
						close form_cursor;
						leave LOOP2;
					end if;
					
					insert into place_formprivileges (userid, formid, readprivilege, writeprivilege) values (user_id, form_id, 1, 0);
					
				end loop LOOP2;
				
			end BLOCK2;
			
		end loop LOOP1;
	end BLOCK1;
	commit;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_create_blank_place_photo_type_privileges`()
begin

	start transaction;
	BLOCK1: begin
		declare user_id int(11);
		declare no_more_users int default false;
		declare user_cursor cursor for select id from users;
		declare continue handler for not found set no_more_users = true;
		
		open user_cursor;
		LOOP1: loop
			fetch user_cursor into user_id;
			if no_more_users then
				close user_cursor;
				leave LOOP1;
			end if;
			
			BLOCK2: begin
				
				declare phototype_id int(11);
				declare no_more_phototypes int default false;
				declare phototype_cursor cursor for select id from place_phototypes;
				declare continue handler for not found set no_more_phototypes = true;
				
				open phototype_cursor;
				
				LOOP2: loop
					fetch phototype_cursor into phototype_id;
					if no_more_phototypes then
						close phototype_cursor;
						leave LOOP2;
					end if;
					
					insert into place_phototypeprivileges (userid, phototypeid, readprivilege, writeprivilege) values (user_id, phototype_id, 1, 0);
					
				end loop LOOP2;
				
			end BLOCK2;
			
		end loop LOOP1;
	end BLOCK1;
	commit;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_create_blank_place_report_privileges`()
begin

	start transaction;
	BLOCK1: begin
		declare user_id int(11);
		declare no_more_users int default false;
		declare user_cursor cursor for select id from users;
		declare continue handler for not found set no_more_users = true;
		
		open user_cursor;
		LOOP1: loop
			fetch user_cursor into user_id;
			if no_more_users then
				close user_cursor;
				leave LOOP1;
			end if;
			
			BLOCK2: begin
				
				declare report_id int(11);
				declare no_more_reports int default false;
				declare report_cursor cursor for select id from place_reports;
				declare continue handler for not found set no_more_reports = true;
				
				open report_cursor;
				
				LOOP2: loop
					fetch report_cursor into report_id;
					if no_more_reports then
						close report_cursor;
						leave LOOP2;
					end if;
					
					insert into place_reportprivileges (userid, reportid, readprivilege) values (user_id, report_id, 0);
					
				end loop LOOP2;
				
			end BLOCK2;
			
		end loop LOOP1;
	end BLOCK1;
	commit;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_create_blank_place_step_privileges`()
begin

	start transaction;
	BLOCK1: begin
		declare user_id int(11);
		declare no_more_users int default false;
		declare user_cursor cursor for select id from users;
		declare continue handler for not found set no_more_users = true;
		
		open user_cursor;
		LOOP1: loop
			fetch user_cursor into user_id;
			if no_more_users then
				close user_cursor;
				leave LOOP1;
			end if;
			
			BLOCK2: begin
				
				declare step_id int(11);
				declare no_more_steps int default false;
				declare step_cursor cursor for select id from place_steps;
				declare continue handler for not found set no_more_steps = true;
				
				open step_cursor;
				
				LOOP2: loop
					fetch step_cursor into step_id;
					if no_more_steps then
						close step_cursor;
						leave LOOP2;
					end if;
					
					insert into place_stepprivileges (userid, stepid, readprivilege, writeprivilege, acceptprivilege, refuseprivilege, archiveprivilege) values (user_id, step_id, 1, 0, 0, 0, 0);
					
				end loop LOOP2;
				
			end BLOCK2;
			
		end loop LOOP1;
	end BLOCK1;
	commit;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_create_blank_user_place_collection_privileges`(
in user_id int(11)
)
begin
	declare collection_id int(11);
	declare no_more_collections int default false;
	declare collection_cursor cursor for select id from place_collections;
	declare continue handler for not found set no_more_collections = true;
				
	open collection_cursor;
				
	LOOP2: loop
		fetch collection_cursor into collection_id;
		if no_more_collections then
			close collection_cursor;
			leave LOOP2;
		end if;
					
		insert into place_collectionprivileges (userid, collectionid, readprivilege, writeprivilege) values (user_id, collection_id, 1, 0);
					
	end loop LOOP2;
				
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_create_blank_user_place_file_type_privileges`(
in user_id int(11)
)
begin

	declare filetype_id int(11);
	declare no_more_filetypes int default false;
	declare filetype_cursor cursor for select id from place_filetypes;
	declare continue handler for not found set no_more_filetypes = true;
				
	open filetype_cursor;
				
	LOOP2: loop
		fetch filetype_cursor into filetype_id;
		if no_more_filetypes then
			close filetype_cursor;
			leave LOOP2;
		end if;
					
		insert into place_filetypeprivileges (userid, filetypeid, readprivilege, writeprivilege) values (user_id, filetype_id, 1, 0);
					
	end loop LOOP2;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_create_blank_user_place_form_privileges`(
in user_id int(11)
)
begin
	declare form_id int(11);
	declare no_more_forms int default false;
	declare form_cursor cursor for select id from place_forms;
	declare continue handler for not found set no_more_forms = true;
				
	open form_cursor;
				
	LOOP2: loop
		fetch form_cursor into form_id;
		if no_more_forms then
			close form_cursor;
			leave LOOP2;
		end if;
					
		insert into place_formprivileges (userid, formid, readprivilege, writeprivilege) values (user_id, form_id, 1, 0);
					
	end loop LOOP2;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_create_blank_user_place_photo_type_privileges`(
in user_id int(11)
)
begin

	declare phototype_id int(11);
	declare no_more_phototypes int default false;
	declare phototype_cursor cursor for select id from place_phototypes;
	declare continue handler for not found set no_more_phototypes = true;
				
	open phototype_cursor;
		
	LOOP2: loop
		fetch phototype_cursor into phototype_id;
		if no_more_phototypes then
			close phototype_cursor;
			leave LOOP2;
		end if;
					
		insert into place_phototypeprivileges (userid, phototypeid, readprivilege, writeprivilege) values (user_id, phototype_id, 1, 0);
					
	end loop LOOP2;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_create_blank_user_place_step_privileges`(
in user_id int(11)
)
begin
	declare step_id int(11);
	declare no_more_steps int default false;
	declare step_cursor cursor for select id from place_steps;
	declare continue handler for not found set no_more_steps = true;
				
	open step_cursor;
				
	LOOP2: loop
		fetch step_cursor into step_id;
		if no_more_steps then
			close step_cursor;
			leave LOOP2;
		end if;
					
		insert into place_stepprivileges (userid, stepid, readprivilege, writeprivilege, acceptprivilege, refuseprivilege, archiveprivilege) values (user_id, step_id, 1, 0, 0, 0, 0);
			
	end loop LOOP2;
	
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_create_blank_user_place_user_to_form_privileges`(
in form_id int(11)
)
begin
	declare user_id int(11);
	declare no_more_users int default false;
	declare user_cursor cursor for select id from users;
	declare continue handler for not found set no_more_users = true;
				
	open user_cursor;
				
	LOOP2: loop
		fetch user_cursor into user_id;
		if no_more_users then
			close user_cursor;
			leave LOOP2;
		end if;
					
		insert into place_formprivileges (userid, formid, readprivilege, writeprivilege) values (user_id, form_id, 1, 0);
					
	end loop LOOP2;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_create_default_user_protocol_number`(
	in _user_id int(11)
)
begin
	insert into protocol_numbers (userid, protocolnumber) values (_user_id, 1);
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_create_user_to_instruction_assignment`(
 in bound VARCHAR(255),
 in where_cond varchar(255),
 in instruction_id int(11)
)
BEGIN
 -- Część procedury odpowiedzialna za parsowanie ciągu znaków
 DECLARE occurance INT DEFAULT 0;
 DECLARE i INT DEFAULT 0;
 DECLARE splitted_value INT;

 -- Tablica tymczasowa zawierająca id grupy
 DROP TEMPORARY TABLE IF EXISTS _groups;
 CREATE TEMPORARY TABLE _groups(
   id INT NOT NULL
  ) ENGINE=Memory;

 SET occurance = (SELECT LENGTH(where_cond) - LENGTH(REPLACE(where_cond, bound, '')) +1);
 SET i=1;
 WHILE i <= occurance DO
   SET splitted_value = (SELECT REPLACE(SUBSTRING(SUBSTRING_INDEX(where_cond, bound, i), LENGTH(SUBSTRING_INDEX(where_cond, bound, i - 1)) + 1), ',', ''));
   INSERT INTO _groups VALUES (splitted_value);
   SET i = i + 1;
 END WHILE;
 -- Koniec części procedury odpowiedzialnej za parsowanie ciągu znaków
 --

 -- Kursor przechodzący przez wszystkie grupy i dodający powiązanie z użytkownikiem
 begin

 declare user_id int(11);
 declare no_more_users int default false;
 declare user_cursor cursor for select distinct userid from usergroups where groupid in (select id from _groups) and access = 1;
 declare continue handler for not found set no_more_users = true;

 open user_cursor;

 LOOP1: loop
   fetch user_cursor into user_id;
   if no_more_users then
     close user_cursor;
     leave LOOP1;
   end if;

   insert into instruction_userinstructions (userid, instructionid, userinstructionread) values (user_id, instruction_id, 0);

 end loop LOOP1;

 end;
 -- Koniec kursora

END$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_dashboard_user_available_dashboards`(
	in _user_id int(11)
)
begin
SELECT 
				d.id as id
				,d.dashboardname as dashboardname
				,d.dashboarddisplayname as dashboarddisplayname
			FROM
				dashboard_dashboards d
			WHERE d.id NOT IN (
				SELECT
					ud.dashboardid
				FROM
					dashboard_userdashboards ud
				WHERE ud.userid = _user_id);
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_dashboard_user_dashboards`(
	in _user_id int(11)
)
begin

	SELECT
			ud.id as id
				,ud.dashboardid as dashboardid
				,d.dashboardname as dashboardname
				,d.dashboarddisplayname as dashboarddisplayname
				,ud.userid as userid
				,ud.display_in as display_in
			FROM
				dashboard_userdashboards ud
			INNER JOIN dashboard_dashboards d on ud.dashboardid = d.id
			WHERE ud.userid = _user_id;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_delete_collection`(
	in collectioninstance_id int(11)
)
begin

	insert into del_place_collectioninstances select * from place_collectioninstances where  id = collectioninstance_id;
	delete from place_collectioninstances where id = collectioninstance_id;
	
	insert into del_place_collectioninstancevalues select * from place_collectioninstancevalues where collectioninstanceid = collectioninstance_id;
	delete from place_collectioninstancevalues where collectioninstanceid = collectioninstance_id;
	
	insert into del_place_collectioninstancevaluecomments select * from place_collectioninstancevaluecomments where collectioninstanceid = collectioninstance_id;
	delete from place_collectioninstancevaluecomments where collectioninstanceid = collectioninstance_id;
	
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_delete_place`(
 in place_id int(11))
begin

 delete from places where id = place_id;
 delete from placeworkflows where placeid = place_id;
 delete from placefiles where placeid = place_id;
 delete from placeattributevalues where placeid = place_id;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_delete_place_instance`(
in instance_id int(11)
)
begin

	insert into del_place_instancephototypecomments select * from place_instancephototypecomments where instanceid = instance_id;
	delete from place_instancephototypecomments where instanceid = instance_id;
	
	insert into del_place_instancephototypes select * from place_instancephototypes where instanceid = instance_id;
	delete from place_instancephototypes where instanceid = instance_id;
	
	insert into del_place_instances select * from place_instances where id = instance_id;
	delete from place_instances where id = instance_id;
	
	insert into del_place_participants select * from place_participants where instanceid = instance_id;
	delete from place_participants where instanceid = instance_id;
	
	insert into del_place_workflows select * from place_workflows where instanceid = instance_id;
	delete from place_workflows where instanceid = instance_id;
	
	insert into del_trigger_place_instances select * from trigger_place_instances where instanceid = instance_id;
	delete from trigger_place_instances where instanceid = instance_id;
	
	insert into del_place_collectioninstancecomments select * from place_collectioninstancecomments where instanceid = instance_id;
	delete from place_collectioninstancecomments where instanceid = instance_id;
	
	insert into del_place_collectioninstances select * from place_collectioninstances where instanceid = instance_id;
	delete from place_collectioninstances where instanceid = instance_id;
	
	insert into del_place_collectioninstancevaluecomments select * from place_collectioninstancevaluecomments where instanceid = instance_id;
	delete from place_collectioninstancevaluecomments where instanceid = instance_id;
	
	insert into del_place_collectioninstancevalues select * from place_collectioninstancevalues where instanceid = instance_id;
	delete from place_collectioninstancevalues where instanceid = instance_id;
	
	insert into del_place_instancefiletypecomments select * from place_instancefiletypecomments where instanceid = instance_id;
	delete from place_instancefiletypecomments where instanceid = instance_id;
	
	insert into del_place_instancefiletypes select * from place_instancefiletypes where instanceid = instance_id;
	delete from place_instancefiletypes where instanceid = instance_id;
	
	insert into del_place_instanceformcomments select * from place_instanceformcomments where instanceid = instance_id;
	delete from place_instanceformcomments where instanceid = instance_id;
	
	insert into del_place_instanceforms select * from place_instanceforms where instanceid = instance_id;
	delete from place_instanceforms where instanceid = instance_id;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_documents_get_document_attributes`(
	in document_id int(1)
)
begin

	select 
		a.attributename as attributename
		,a.attributetypeid as attributetypeid
		,at.typename as typename
		,dav.id as documentattributevalueid
		,dav.documentid as documentid
		,dav.attributeid as attributeid
		,dav.documentattributetextvalue
	from documentattributes d
	inner join documentattributevalues dav on d.attributeid = dav.attributeid
	inner join attributes a on d.attributeid = a.id
	inner join attributetypes at on a.attributetypeid = at.id
	where dav.documentid = document_id and documentattributevisible=1;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_generate_blank_first_place_step`(
 in instance_id int(11),
 in user_id int(11)
)
begin
 insert into place_workflows (instanceid, stepid, statusid, start, userid) values (instance_id, 1, 1, NOW(), user_id);
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_generate_blank_place_file_instances`(
 in instance_id int(11),
 in step_id int(11)
)
begin
 declare filetype_id int(11);
 declare no_more_files int default false;
 declare file_cursor cursor for select distinct id from place_filetypes;
 declare continue handler for not found set no_more_files = true;
 open file_cursor;
 LOOP1: loop
   fetch file_cursor into filetype_id;
   if no_more_files then
     close file_cursor;
     leave LOOP1;
   end if;
   insert into place_instancefiletypes (instanceid, filetypeid) values (instance_id, filetype_id);
 end loop LOOP1;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_generate_blank_place_photo_instances`(
 in instance_id int(11),
 in step_id int(11)
)
begin
 declare phototype_id int(11);
 declare no_more_photos int default false;
 declare photo_cursor cursor for select distinct id from place_phototypes;
 declare continue handler for not found set no_more_photos = true;
 open photo_cursor;
 LOOP1: loop
 fetch photo_cursor into phototype_id;
 if no_more_photos then
   close photo_cursor;
   leave LOOP1;
   end if;
 insert into place_instancephototypes (instanceid, phototypeid) values (instance_id, phototype_id); 
 end loop LOOP1;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_generate_blank_place_step_form_instances`(
 in instance_id int(11),
 in step_id int(11)
)
begin
 BLOCK1: begin

 declare form_id int(11);
 declare no_more_forms int default false;
 declare form_cursor cursor for select distinct id from place_forms;
 declare continue handler for not found set no_more_forms = true;
 open form_cursor;
 LOOP1: loop

   fetch form_cursor into form_id;
   if no_more_forms then
     close form_cursor;
     leave LOOP1;
   end if;

   BLOCK2: begin

   declare formfield_id int(11);
   declare no_more_fields int default false;
   declare field_cursor cursor for select fieldid from place_formfields where formid = form_id;
   declare continue handler for not found set no_more_fields = true;

   open field_cursor;
   LOOP2: loop

     fetch field_cursor into formfield_id;
     if no_more_fields then
       close field_cursor;
       leave LOOP2;
     end if;

     insert into place_instanceforms (formid, instanceid, formfieldid) values (form_id, instance_id, formfield_id);

   end loop LOOP2;

   end BLOCK2;

 end loop LOOP1;

 end BLOCK1;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_generate_blank_place_step_instances`(
 in instance_id int(11),
 in step_id int(11)
)
begin
 BLOCK1: begin

 declare form_id int(11);
 declare no_more_forms int default false;
 declare form_cursor cursor for select formid from place_stepforms where stepid = step_id;
 declare continue handler for not found set no_more_forms = true;
 open form_cursor;
 LOOP1: loop

   fetch form_cursor into form_id;
   if no_more_forms then
     close form_cursor;
     leave LOOP1;
   end if;

   BLOCK2: begin

   declare formfield_id int(11);
   declare no_more_fields int default false;
   declare field_cursor cursor for select fieldid from place_formfields where formid = form_id;
   declare continue handler for not found set no_more_fields = true;

   open field_cursor;
   LOOP2: loop

     fetch field_cursor into formfield_id;
     if no_more_fields then
       close field_cursor;
       leave LOOP2;
     end if;

     insert into place_instanceforms (formid, instanceid, stepid, formfieldid) values (form_id, instance_id, step_id, formfield_id);

   end loop LOOP2;

   end BLOCK2;

 end loop LOOP1;

 end BLOCK1;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_generate_blank_user_attributes`(
	in user_id int(11)
)
begin
	declare attribute_id int(11);
	declare no_more_attributes int default false;
	declare attribute_cursor cursor for select attributeid from userattributes;
	declare continue handler for not found set no_more_attributes = true;
				
	open attribute_cursor;
				
	LOOP2: loop
		fetch attribute_cursor into attribute_id;
		if no_more_attributes then
			close attribute_cursor;
			leave LOOP2;
		end if;
					
		insert into userattributevalues (userid, attributeid) values (user_id, attribute_id);
					
	end loop LOOP2;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_generate_blank_user_menu`(in t_userid int(11))
begin
declare t_menuid int(11);
declare no_more_menus int default false;
declare menus_cursor cursor for select id from menus;
declare continue handler for not found set no_more_menus = true;

open menus_cursor;
LOOP1: loop

  fetch menus_cursor into t_menuid;
  if no_more_menus then
    close menus_cursor;
    leave LOOP1;
  end if;

  insert into usermenus (userid, menuid, usermenuaccess) values (t_userid, t_menuid, 0);

  end loop LOOP1;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_generate_default_users_protocol_number`()
begin
	declare user_id int(11);
	declare no_more_users int default false;
	declare user_cursor cursor for select id from users;
	declare continue handler for not found set no_more_users = true;
	
	open user_cursor;
	LOOP1: loop
		fetch user_cursor into user_id;
		if no_more_users then
			close user_cursor;
			leave LOOP1;
		end if;
		
		insert into protocol_numbers (userid, protocolnumber) values (user_id, 1);
		
	end loop LOOP1;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_generate_pps_defaults`()
begin

	BLOCK1: begin

	declare user_id int(11);
	declare no_more_users int default false;
	declare user_cursor cursor for select id from users where isstore = 1;
	declare continue handler for not found set no_more_users = true;
	
	open user_cursor;
	LOOP1: loop
		
		fetch user_cursor into user_id;
		if no_more_users then
			close user_cursor;
			leave LOOP1;
		end if;
		
		update usergroups set access = 0 where userid = user_id;
		
		update usergroups set access = 1 where userid = user_id and groupid = 24;
		update usergroups set access = 1 where userid = user_id and groupid = 25;
		
		update usermenus set usermenuaccess = 0 where userid = user_id;
		
		update usermenus set usermenuaccess = 1 where userid = user_id and menuid = 19;
		update usermenus set usermenuaccess = 1 where userid = user_id and menuid = 20;
		update usermenus set usermenuaccess = 1 where userid = user_id and menuid = 52;
		
	end loop LOOP1;
	
	end BLOCK1;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_all_field_types`()
begin

 select
   id as id
   ,fieldtypename as fieldtypename
 from place_fieldtypes;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_all_forms`()
begin

 select
   id as formid
   ,formname as formname
   ,(select count(id) from form_formfields ff where ff.formid = f.id) as fieldcount
 from form_forms f;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_all_instructions`(
 in instruction_category_id int(11),
 in date_from datetime,
 in date_to datetime
)
begin

 select 
   i.id as instruction_id
   ,i.instructionname as instructionname
   ,ic.id as instructioncatgoryid
   ,ic.instructioncategoryname as instructioncategoryname
   ,u.givenname as authorgivenname
   ,u.sn as authorsn
   ,f.fileoriginalname as fileoriginalname
   ,f.filename as filename
   ,i.instructionnumber as instructionnumber
 from instruction_instructions i
 inner join instruction_instructioncategories ic on i.instructioncategoryid=ic.id
 inner join users u on i.userid = u.id
 inner join files f on i.fileid = f.id;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_all_place_fields_selectbox`()
begin

 select
   f.id as id
   ,f.fieldname as fieldname
 from place_fields f;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_all_place_file_types`()
begin
 select
   ft.id as id
   ,ft.filetypename as filetypename
   ,ft.filetypecreated as filetypecreated
 from place_filetypes ft;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_all_place_file_types_by_step`(
 in step_id int(11))
begin

 select
   ft.id as id
	,sft.id as stepfiletypeid
   ,ft.filetypename as filetypename
   ,ft.filetypecreated as filetypecreated
	,step_id as stepid
 from place_stepfiletypes sft inner join place_filetypes ft on sft.filetypeid = ft.id
 where sft.stepid = step_id;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_all_place_file_types_selectbox`()
begin
 select
   ft.id as id
   ,ft.filetypename as filetypename
 from place_filetypes ft;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_all_place_forms`()
begin

 select 
   f.id as id
   ,f.formname as formname
   ,f.formdescription as formdescription
   ,(select count(id) from place_formfields where formid = f.id) as fieldcount
   ,f.formcreated as formcreated
	,f.def as def
 from place_forms f;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_all_place_forms_selectbox`()
begin

 select
   f.id as id
   ,f.formname as formname
 from place_forms f;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_all_place_form_fields`()
begin

 select
   f.id as id
   ,f.fieldname as fieldname
   ,f.fieldlabel as fieldlabel
   ,f.fieldcreated as fieldcreated
   ,ft.fieldtypename as fieldtypename
 from place_fields f inner join place_fieldtypes ft on f.fieldtypeid = ft.id;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_all_place_instances`(
 in page int(4),
 in elements int(2),
 in offset int(3),
 in status_id int(11),
 in instancereason_id int(11),
 in user_id int(11),
 in step_id int(11),
 in placesearch varchar(255) character set utf8
)
begin

	set @a = (page-1)*elements;
	
	set @qry = CONCAT('select 
		i.instanceid as id
	    ,i.instancecreated as instancecreated
	    ,i.city as instanceplace
	    ,i.postalcode as instancepostalcode
	    ,i.street as instancestreet
		,i.streetnumber as streetnumber
	    ,i.userid as userid
		,i.givenname as givenname
		,i.sn as sn
		,i.position as position
		,i.instancereasonid as instancereasonid
		,i.rejectnote as rejectnote
		,i.rejectuserid as rejectuserid
		,i.rejectdatetime as rejectdatetime
		,i.instancestatusid as instancestatusid
	from trigger_place_instances i where ');
	
	if user_id <> 0 then
		set @qry = CONCAT(@qry, ' (userid = ', user_id, ') and ');
	end if;
	
	if step_id <> 0 then
		set @qry = CONCAT(@qry, ' (i.stepid = ', step_id, ') and ');
	end if;
	
	if instancereason_id <> 0 then
		set @qry = CONCAT(@qry, ' (i.instancereasonid = ', instancereason_id, ') and ');
	end if;
	
	if LENGTH(placesearch) <> 0 then
		set @qry = CONCAT(@qry, ' (LOWER(i.givenname) like "%', LOWER(TRIM(placesearch)), '%" or 
									LOWER(i.rejectnote) like "%', LOWER(TRIM(placesearch)), '%" or
									LOWER(i.street) like "%', LOWER(TRIM(placesearch)) ,'%" or
									LOWER(i.postalcode) like "%', LOWER(TRIM(placesearch)) ,'%" or
									LOWER(i.city) like "%', LOWER(TRIM(placesearch)) ,'%" or
									LOWER(i.streetnumber) like "%', LOWER(TRIM(placesearch)) ,'%") and ');
	end if;
	
	set @qry = CONCAT(@qry, ' instancestatusid = ', status_id, ' order by i.instancecreated desc limit ', @a, ', ', elements);
	
	
	PREPARE stmt FROM @qry; 
	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt;
	
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_all_place_instances_count`(
	in status_id int(11),
	in user_id int(11),
	in step_id int(11),
	in instancereason_id int(11),
	in placesearch varchar(255) character set utf8
)
begin
	set @qry = CONCAT('select 
		count(id) as c
	from trigger_place_instances i where ');
	
	if user_id <> 0 then
		set @qry = CONCAT(@qry, ' (userid = ', user_id, ') and ');
	end if;
	
	if step_id <> 0 then
		set @qry = CONCAT(@qry, ' (i.stepid = ', step_id, ') and ');
	end if;
	
	if instancereason_id <> 0 then
		set @qry = CONCAT(@qry, ' (i.instancereasonid = ', instancereason_id, ') and ');
	end if;
	
	if LENGTH(placesearch) <> 0 then
		set @qry = CONCAT(@qry, ' (LOWER(i.givenname) like "%', LOWER(TRIM(placesearch)), '%" or 
									LOWER(i.rejectnote) like "%', LOWER(TRIM(placesearch)), '%" or
									LOWER(i.street) like "%', LOWER(TRIM(placesearch)) ,'%" or
									LOWER(i.postalcode) like "%', LOWER(TRIM(placesearch)) ,'%" or
									LOWER(i.city) like "%', LOWER(TRIM(placesearch)) ,'%" or
									LOWER(i.streetnumber) like "%', LOWER(TRIM(placesearch)) ,'%") and ');
	end if;
	
	set @qry = CONCAT(@qry, ' instancestatusid = ', status_id);
	
	
	PREPARE stmt FROM @qry; 
	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_all_place_instance_stats`(
)
begin
	select
		s.statusname as statusname
		,count(i.id) as statuscount
	from trigger_place_instances i
	inner join place_statuses s on i.instancestatusid = s.id
	group by i.instancestatusid; 
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_all_place_photo_types`()
begin

 select
   p.id as id
   ,p.phototypename as phototypename
   ,p.phototypecreated as phototypecreated
 from place_phototypes p;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_all_place_steps`()
begin

 select
   s.id as id
   ,s.stepname as stepname
   ,s.prev as prev
   ,s.next as next
   ,(select count(id) from place_stepforms sf where sf.stepid = s.id) as formcount
   ,(select count(id) from place_stepphototypes spt where spt.stepid = s.id) as photocount
   ,(select count(id) from place_stepfiletypes sft where sft.stepid = s.id) as filecount
	,(select count(id) from place_stepcollections psc where psc.stepid = s.id) as collectioncount
	,(select count(id) from place_stepreports psr where psr.stepid = s.id) as reportcount
 from place_steps s;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_all_place_steps_selectbox`()
begin

 select
   s.id as id
   ,s.stepname as stepname
 from
   place_steps s;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_all_shelfs`()
begin

 select
   s.id as shelfid
   ,s.shelftypeid as shelftypeid
   ,s.shelfcategoryid as shelfcategoryid
   ,st.shelftypename as shelftypename
   ,sc.shelfcategoryname as shelfcategoryname
 from store_shelfs s
 inner join store_shelftypes st on s.shelftypeid = st.id
 inner join store_shelfcategories sc on s.shelfcategoryid = sc.id;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_all_user_place_instance_accepted_stats`(
in user_id int(11)
)
begin

	select 
		count(id) as count, 
		makedate(2012, (week(instancecreated)-1)*7) as startdate,
		makedate(2012, week(instancecreated)*7) as stopdate
	from trigger_place_instances
	where userid = user_id and instancestatusid = 2
	group by week(instancecreated);
	
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_all_user_place_instance_stats`(
in user_id int(11)
)
begin

	select
		makedate(Year(Now()), (week(a.instancecreated)-1)*7) as startdate,
		makedate(Year(Now()), week(a.instancecreated)*7) as stopdate,
		count(a.id) as totalcount,
		sum(if(b.instancestatusid=2,1, 0)) as acceptedcount
	from trigger_place_instances a inner join trigger_place_instances b on a.id = b.id
	where a.userid = user_id and a.userid = b.userid
	group by week(a.instancecreated), week(b.instancecreated);
	
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_all_user_place_instance_statsby_by_week`(
	in date_start varchar(12),
	in date_stop varchar(12)
)
begin

	select
a.userid as userid,
u.givenname as givenname,
u.sn as sn,
		
makedate(Year(Now()), (week(a.instancecreated)-1)*7) as startdate,
makedate(Year(Now()), week(a.instancecreated)*7) as stopdate,

count(a.id) as totalcount,
sum(if(b.instancestatusid=2,1, 0)) as acceptedcount

from trigger_place_instances a inner join trigger_place_instances b on a.id = b.id inner join users u on a.userid = u.id
where makedate(Year(Now()), (week(a.instancecreated)-1)*7) >= date_start and
makedate(Year(Now()), week(a.instancecreated)*7) <= date_stop

group by a.userid, b.userid;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_all_user_place_instance_statsby_week`(
	in date_start varchar(12),
	in date_stop varchar(12)
)
begin

	select
a.userid as userid,
u.givenname as givenname,
u.sn as sn,
		
makedate(Year(Now()), (week(a.instancecreated)-1)*7) as startdate,
makedate(Year(Now()), week(a.instancecreated)*7) as stopdate,

count(a.id) as totalcount,
sum(if(b.instancestatusid=2,1, 0)) as acceptedcount

from trigger_place_instances a inner join trigger_place_instances b on a.id = b.id inner join users u on a.userid = u.id
where makedate(Year(Now()), (week(a.instancecreated)-1)*7) >= date_start and
makedate(Year(Now()), week(a.instancecreated)*7) <= date_stop

group by a.userid, b.userid;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_all_user_place_instance_stats_by_week`(
	in date_start varchar(12),
	in date_stop varchar(12)
)
begin

	select
a.userid as userid,
u.givenname as givenname,
u.sn as sn,
		
makedate(Year(Now()), (week(a.instancecreated)-1)*7) as startdate,
makedate(Year(Now()), week(a.instancecreated)*7) as stopdate,

count(a.id) as totalcount,
sum(if(b.instancestatusid=2,1, 0)) as acceptedcount

from trigger_place_instances a inner join trigger_place_instances b on a.id = b.id inner join users u on a.userid = u.id
where makedate(Year(Now()), (week(a.instancecreated)-1)*7) >= date_start and
makedate(Year(Now()), week(a.instancecreated)*7) <= date_stop

group by a.userid, b.userid;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_collections_by_step`(
 in step_id int(11)
)
begin

 select 
   c.collectionname as collectionname
   ,c.collectiondescription as collectiondescription
   ,c.collectioncreated as collectioncreated
   ,c.id as id
	,u.givenname as givenname
	,u.sn as sn
	,u.position as position
   ,(select count(id) from place_collectionfields cf where  f.collectionid = c.id) as collectioncount
 from place_stepcollections cf
 inner join place_collections c on cf.collectionid = c.id
 inner join view_users u on u.userid = c.userid
 where cf.stepid = step_id;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_fields_by_form`(
 in form_id int(11))
begin

 select
   f.id as id
   ,f.fieldname as fieldname
   ,f.fieldlabel as fieldlabel
   ,f.fieldcreated as fieldcreated
   ,ft.fieldtypename as fieldtypename
	,ff.ord as ord
	,ff.id as formfieldid
	,ff.required as required
 from place_formfields ff 
 	inner join place_fields f on ff.fieldid = f.id 
	inner join place_fieldtypes ft on f.fieldtypeid = ft.id
 where ff.formid = form_id
 order by ff.ord asc;  

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_file_comments`(
 in fileId int(11))
begin

 select
   u.givenname as givenname
,   u.sn as sn
,   u.samaccountname as samacountname
,   u.mail as mail
,   fc.fileid as fileid
,   fc.filecommentdate as filecommentdate
,   fc.filecommenttext
 from
   filecomments fc
 inner join users u on fc.userid = u.id
 where
   fc.fileid = fileId
 order by fc.filecommentdate desc;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_forms_by_step`(
 in step_id int(11)
)
begin

 select 
 	sf.id as stepformid
   ,f.formname as formname
   ,f.formdescription as formdescription
   ,f.formcreated as formcreated
   ,f.id as id
   ,(select count(id) from place_formfields ff where ff.formid = f.id) as fieldcount
	,step_id as stepid
 from place_stepforms sf
 inner join place_forms f on sf.formid = f.id
 where sf.stepid = step_id;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_instructions_by_user`(
 in category_id int(11),
 in date_from varchar(255),
 in date_to varchar(255),
 in user_id int(11)
)
begin

 select
   i.id as instructionid
   ,u.givenname as authorgivenname
   ,u.sn as authorsn
   ,i.instructionname as instructionname
   ,i.instructiondescription as instructiondescription
   ,i.fileid as fileid
   ,i.userid as userid
   ,i.instructioncreated as instructioncreated
   ,ii.instructioncategoryname as instructioncategoryname
   ,ui.id as userinstructionid
   ,ui.userinstructionread as userinstructionread
   ,i.instructionnumber as instructionnumber
 from
   instruction_userinstructions ui
 inner join instruction_instructions i on ui.instructionid = i.id
 inner join users u on i.userid = u.id
 inner join instruction_instructioncategories ii on i.instructioncategoryid = ii.id
 where ui.userid = user_id and i.instructioncategoryid = category_id;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_my_places`(
in user_id int(11)
)
begin

select p.id as id
 ,p.address as address
 ,p.provinceid as provinceid
 ,p.cityname as cityname
 ,p.provincename as provincename
 ,p.districtname as districtname
 ,p.lat as lat
 ,p.lng as lng
 ,p.userid as userid
 ,p.priority as priority
 ,p.archive as archive
 ,u.givenname as givenname
 ,u.sn as sn
 ,p.id as placeid
 ,p.placecreated as placecreated
 from places p inner join users u on p.userid=u.id
where p.id in (select distinct placeid from placeworkflows where p.userid = user_id);

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_place_collections_by_step`(
 in step_id int(11)
)
begin

 select 
   c.collectionname as collectionname
   ,c.collectiondescription as collectiondescription
   ,c.collectioncreated as collectioncreated
   ,c.id as id
	,u.givenname as givenname
	,u.sn as sn
	,u.position as position
   ,(select count(id) from place_collectionfields cf where  cf.collectionid = c.id) as collectioncount
 from place_stepcollections cf
 inner join place_collections c on cf.collectionid = c.id
 inner join users u on u.id = c.userid
 where cf.stepid = step_id;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_place_combined_group_attributes`(
  in place_id int(11),
  in where_cond varchar(255))
begin
   select
     a.attributetypeid as attributetypeid
     ,a.attributename as attributename
     ,a.id as attributeid
     ,a.attributerequired as attributerequired
     ,pav.id as placeattributevalueid
     ,pav.placeid as placeid
     ,pav.placeattributevaluetext as placeattributevaluetext
     ,pav.placeattributevaluebinary as placeattributevaluebinary
     ,pag.groupid as groupid
   from
     placeattributevalues pav inner join attributes a on pav.attributeid=a.id
     inner join placeattributegroups pag on pag.attributeid = pav.attributeid
   where pav.placeid=place_id and pag.groupid in (where_cond)
   order by a.ord asc; 
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_place_files`(
 in place_id int(11))
begin

select 
 u.id as userid
, u.givenname as givenname
, u.sn as sn
, u.mail as mail
, f.filename as filename
, f.id as fileid
, f.filecreated as filecreated
, pfc.placefilecategoryname as placefilecategoryname
from placefiles as pf
inner join files f on pf.fileid = f.id
inner join placefilecategories pfc on pfc.id = pf.placefilecategoryid
inner join users u on u.id = f.userid
where pf.placeid = place_id;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_place_form_notes`(
	in form_id int(11),
	in instance_id int(11)
)
begin
	select
		u.givenname as givenname
		,u.sn as sn
		,f.formnote as formnote
		,f.created as created
	from place_forminstancenotes f inner join users u on f.userid = u.id
	where f.formid = form_id and f.instanceid = instance_id
	order by f.created desc;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_place_group_attributes`(
  in place_id int(11),
  in group_id int(11))
begin
   select
     a.attributetypeid as attributetypeid
     ,a.attributename as attributename
     ,a.id as attributeid
     ,a.attributerequired as attributerequired
     ,pav.id as placeattributevalueid
     ,pav.placeid as placeid
     ,pav.placeattributevaluetext as placeattributevaluetext
     ,pav.placeattributevaluebinary as placeattributevaluebinary
     ,pag.groupid as groupid
   from
     placeattributevalues pav inner join attributes a on pav.attributeid=a.id
     inner join placeattributegroups pag on pag.groupid = group_id
   where pav.placeid=place_id and pag.attributeid=a.id
   order by pag.ord asc; 
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_place_instance_by_id`(
 in instance_id int(11)
)
begin
 select 
   i.instanceid as id
   ,i.instancecreated as instancecreated
   -- ,i.instancenumber as instancenumber
   ,i.city as instanceplace
   ,i.postalcode as instancepostalcode
   ,i.street as instancestreet
   ,i.userid as userid
	,i.givenname as givenname
	,i.sn as sn
	,i.position as position
	,i.streetnumber as streetnumber
	,i.homenumber as homenumber
 from trigger_place_instances i
 -- inner join view_users u on i.userid = u.id
 where i.instanceid = instance_id;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_place_instance_get_form_fields`(
 in form_id int(11),
 in instance_id int(11)
)
begin

 select
 pif.id as id
 ,pif.formfieldvalue as formfieldvalue
 ,pfrm.formname as formname
 ,pfrm.id as formid
 ,pf.fieldname as fieldname
 ,pf.fieldtypeid as fieldtypeid
 ,pf.fieldlabel as fieldlabel
 ,pif.formfieldid as fieldid
 ,pif.instanceid as instanceid 
 ,(select count(id) from place_instanceformcomments ifc where ifc.instanceformid = pif.id) as commentscount
 ,pf.fieldmask as fieldmask
 ,pf.fieldrate as fieldrate
 ,pf.fieldrequired as fieldrequired
 ,iff.required as required
 ,pf.class as class
 ,(select sum(accepted) from place_instanceforms pif2 where pif2.instanceid = instance_id and pif2.formid = form_id) as accepted
 from place_instanceforms pif 
 	inner join place_fields pf on pif.formfieldid = pf.id
 	inner join place_forms pfrm on pif.formid = pfrm.id
	inner join place_formfields iff on (iff.formid = form_id and iff.fieldid = pf.id)
 where pif.instanceid = instance_id and pif.formid = form_id
 order by iff.ord asc;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_place_instance_step_collection_names`(
 in instance_id int(11),
 in step_id int(11)
)
begin

 select
   sc.id as placestepcollectionid
   ,step_id as step_id
   ,instance_id as instance_id
   ,c.collectionname as collectionname
   ,c.id as collectionid
   ,(select count(id) from place_collectioninstances pci where pci.instanceid = instance_id and pci.collectionid = c.id) as collectioncount
 from place_stepcollections sc
 inner join place_collections c on sc.collectionid = c.id
 where sc.stepid = step_id;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_place_instance_step_file_types`(
	in instance_id int(11),
	in step_id int(11)
)
begin

select
   sf.id as placestepfileid
   ,step_id as step_id
   ,instance_id as instance_id
   ,f.filetypename as filetypename
   ,f.id as filetypeid
   ,(select count(id) from place_instancefiletypes ift where ift.instanceid = instance_id and ift.filetypeid = f.id) as filescount
 from place_stepfiletypes sf
 inner join place_filetypes f on sf.filetypeid = f.id
 where sf.stepid = step_id;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_place_instance_step_form_names`(
 in instance_id int(11),
 in step_id int(11)
)
begin

 select
   sf.id as placestepformid
   ,step_id as step_id
   ,instance_id as instance_id
   ,f.formname as formname
   ,f.id as formid
   ,(select count(id) from place_instanceforms pif where pif.instanceid = instance_id and pif.formid = f.id) as allfields
   ,(select count(id) from place_instanceforms pif2 where pif2.instanceid = instance_id and pif2.formid = f.id and pif2.formfieldvalue <> '') as filledfield
	,(select sum(accepted) from place_instanceforms pif3 where pif3.instanceid = instance_id and pif3.formid =f.id) as accepted
 from place_stepforms sf
 inner join place_forms f on sf.formid = f.id
 where sf.stepid = step_id;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_place_instance_step_photo_types`(
	in instance_id int(11),
	in step_id int(11)
)
begin

select
   sp.id as placestepphotoid
   ,step_id as step_id
   ,instance_id as instance_id
   ,p.phototypename as phototypename
   ,p.id as phototypeid
   ,(select count(id) from place_instancephototypes ipt where ipt.instanceid = instance_id and ipt.phototypeid = p.id) as photoscount
 from place_stepphototypes sp
 inner join place_phototypes p on sp.phototypeid = p.id
 where sp.stepid = step_id;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_place_instance_step_reports`(
	in instance_id int(11),
	in step_id int(11)
)
begin

select
   r.id as reportid
   ,step_id as step_id
   ,instance_id as instance_id
   ,r.reportname as reportname
 from place_stepreports sr
 inner join place_reports r on sr.reportid = r.id
 where sr.stepid = step_id;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_place_instance_workflow`(
 in instance_id int(11)
)
begin
 select
   w.id as id
   ,w.stepid as stepid
   ,s.stepname as stepname
   ,w.statusid as statusid
   ,st.statusname as statusname
   ,w.start as start
   ,w.stop as stop
   ,w.userid as userid
   ,u.givenname as givenname
   ,u.sn as sn
	,u.position as position
   ,w.instanceid as instanceid
	,u2.givenname as givenname2
	,u2.sn as sn2
	,w.workflownote as workflownote
 from place_workflows w 
 inner join users u on w.userid = u.id
 left outer join users u2 on w.user2 = u2.id
 inner join place_steps s on w.stepid = s.id
 inner join place_statuses st on w.statusid = st.id
 where w.instanceid = instance_id
 order by w.start desc;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_place_photos`(
 in place_id int(11))
begin
  select
   pf.id as id
   ,f.id as fileid
   ,f.filename as filename
   ,f.filesrc as filesrc
   -- ,f.filebinary as filebinary
   ,pfc.placefilecategoryname as placefilecategoryname
   ,pf.toexport as toexport
 from placefiles pf 
 inner join files f on pf.fileid = f.id 
 inner join placefilecategories pfc on pf.placefilecategoryid = pfc.id
 where pf.placeid = place_id and pfc.isimage = 1;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_place_photo_types_by_step`(
 in step_id int(11))
begin

 select
   pt.id as id
   ,pt.phototypename as phototypename
   ,pt.phototypecreated as phototypecreated
 from place_stepphototypes spt inner join place_phototypes pt on spt.phototypeid = pt.id
 where spt.stepid = step_id;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_place_photo_types_selectbox`()
begin

 select
   p.id as id
   ,p.phototypename as phototypename
 from place_phototypes p;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_place_report`(
	in instance_id int(11),
	in group_id int(11)
)
begin
	select
		f.fieldname as fieldname
		,pif.formfieldvalue as fieldvalue
	from place_fieldgroups pfg
	inner join place_fields f on pfg.fieldid = f.id
	inner join place_instanceforms pif on pif.formfieldid = f.id
	where pif.instanceid = instance_id and pfg.groupid = group_id and pfg.access = 1 and pif.formid = pfg.formid;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_place_workflow`(
 in place_id int(11))
begin

 select 
   p.placeid as placeid
 , p.userid as userid
 , p.placestepid as placestepid
 , p.placestatusid as placestatusid
 , p.placestepstatusreasonid as placestepstatusreasonid
 , p.placeworkflowstart as placeworkflowstart
 , p.placeworkflowstop as placeworkflowstop
 , p.newuserid as newuserid
 , p.placeworkflownote as placeworkflownote
 , p.newplacestatusid as newplacestatusid
 , pstatus.placestatusname as placestatusname
 , pstatus2.placestatusname as newplacestatusname
 , pstep.placestepname as placestepname
 , u.givenname as givenname
 , u.sn as sn
 , u2.givenname as newgivenname
 , u2.sn as newsn
 from placeworkflows p
 left join placesteps pstep on p.placestepid = pstep.id
 left join placestatuses pstatus on p.placestatusid = pstatus.id
 left join placestatuses pstatus2 on p.newplacestatusid = pstatus2.id
 left join users u on p.userid = u.id
 left join users u2 on p.newuserid = u2.id
 where 
   p.placeid = place_id;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_posts_list`(
	in pge int(11),
	in cnt int(11)
)
begin

	set @a = (pge-1)*cnt;
	set @b = cnt;
	
 SET @qry = CONCAT('select
   p.id as postid
   ,p.posttitle as posttitle
   ,p.postcontent as postcontent
   ,p.postcreated as postcreated
	,p.filename as filename
   ,p.userid as userid
   ,p.filename as filename
   ,u.givenname as givenname
   ,u.sn as sn
 from posts p 
 inner join users u on p.userid = u.id
 order by p.postcreated DESC
 limit ', @a, ', ', @b);

	PREPARE stmt FROM @qry; 
	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_questions_by_questionaryid`(
 in questionary_id int(11)
)
begin

 select
   a.id as answerid
   ,q.id as questionid
   ,q.questionname as questionname
   ,q.questionfactor as questionfactor
   ,q.classificationid as classificationid
   ,c.classificationname as classificationname
   ,a.answervalue as answervalue
   ,a.questionaryid as questionaryid
   ,a.fileid as fileid
   ,a.filesrc as filesrc
	,q.questiontypeid as questiontypeid
	,a.answertext as answertext
 from
   ssg_answers a
 inner join ssg_questions q on a.questionid = q.id
 inner join ssg_classifications c on q.classificationid = c.id
 where a.questionaryid = questionary_id;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_get_user_types`(
 in user_id int(11))
begin

 select id, typename from types where groupid in (select groupid from usergroups where userid = user_id and access = 1) order by ord asc;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_ideas_get_all`(
	IN _userid INT(11),
	IN _statusid INT(2),
	IN _access INT(2),
	IN _sessionuser INT(11),
	IN _sortby VARCHAR(100),
	IN _sortset VARCHAR(4),
	IN _page INT(3),
	IN _emelents INT(3)
)
BEGIN

	set @qry = CONCAT(
		'SELECT 
			idea_ideas.id AS id, 
			idea_ideas.title AS title, 
			idea_ideas.date AS date,
			CONCAT(IFNULL(users.givenname,''), "&nbsp;", IFNULL(users.sn,'')) AS user,
			idea_statuses.name AS name
		FROM idea_ideas 
		INNER JOIN users ON users.id = idea_ideas.userid
		INNER JOIN idea_statuses ON idea_statuses.id = idea_ideas.statusid
		WHERE 1=1 '
	);

	IF _userid <> 0 THEN
		set @qry = CONCAT(@qry, ' and (userid = ', _userid, ')');
	END IF;

	IF _statusid <> 0 THEN
		set @qry = CONCAT(@qry, ' and (statusid = ', _statusid, ')');
	END IF;

	CASE _access
		WHEN 2 THEN set @qry = CONCAT(@qry, ' and (statusid >= 2 or userid = ', _sessionuser, ')'); 
		WHEN 3 THEN set @qry = CONCAT(@qry, ' and (partner_prowadzacy_sklep = 1 or userid = ', _sessionuser, ')');
		WHEN 4 THEN set @qry = CONCAT(@qry, ' and (userid = ', _sessionuser, ')');
		ELSE set @qry = @qry;
	END CASE;

	set @qry = CONCAT(@qry, ' ORDER BY ', _sortby, ' ', _sortset);
	set @qry = CONCAT(@qry, ' LIMIT ', (_page-1) * _emelents, ', ', _emelents);
	
	PREPARE stmt FROM @qry; 
	EXECUTE stmt;

	DEALLOCATE PREPARE stmt;
END$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_ideas_get_all_count`(
	IN _userid INT(11),
	IN _statusid INT(2),
	IN _access INT(2),
	IN _sessionuser INT(11)
)
BEGIN

	set @qry = CONCAT(
		'SELECT 
			COUNT(idea_ideas.id) AS c
		FROM idea_ideas 
		INNER JOIN users ON users.id = idea_ideas.userid
		INNER JOIN idea_statuses ON idea_statuses.id = idea_ideas.statusid
		WHERE 1=1 '
	);

	IF _userid <> 0 THEN
		set @qry = CONCAT(@qry, ' and (userid = ', _userid, ')');
	END IF;

	IF _statusid <> 0 THEN
		set @qry = CONCAT(@qry, ' and (statusid = ', _statusid, ')');
	END IF;

	CASE _access
		WHEN 2 THEN set @qry = CONCAT(@qry, ' and (statusid >= 2 or userid = ', _sessionuser, ')'); 
		WHEN 3 THEN set @qry = CONCAT(@qry, ' and (partner_prowadzacy_sklep = 1 or userid = ', _sessionuser, ')');
		WHEN 4 THEN set @qry = CONCAT(@qry, ' and (userid = ', _sessionuser, ')');
		ELSE set @qry = @qry;
	END CASE;
	
	PREPARE stmt FROM @qry; 
	EXECUTE stmt;

	DEALLOCATE PREPARE stmt;
END$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_instructions_get_users_to_notify`(
	in where_condition text character set utf8
)
begin

	set @qry = CONCAT('
		select 
			givenname as givenname, sn as sn, mail as mail
		from users 
		where', where_condition);

	PREPARE stmt FROM @qry; 
	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_instruction_get_all_instructions`(
	in documenttype_id int(11),
	in status_id int(11),
	in user_id int(11),
	in where_condition text character set utf8,
	in _limit int(4)
)
begin

	SET @qry = CONCAT('select 
		id.id as id
		,id.documenttypeid as documenttypeid
		,id.statusid as statusid
		,id.department_name as department_name
		,id.instruction_number as instruction_number
		,id.instruction_created as instruction_created
		,id.instruction_for as instruction_for
		,id.instruction_about as instruction_about
		,id.instruction_date_from as instruction_date_from
		,id.instruction_date_to as instruction_date_to
		,id.instruction_summary as instruction_summary
		,id.thumb_src as thumb_src
		,id.filesrc as filesrc
		,idt.documenttypename as documenttypename
		,id.filename as filename
		from instruction_documents id
		inner join instruction_documenttypes idt on idt.id = id.documenttypeid where ', where_condition, ' order by instruction_created DESC');
	
	if _limit <> 0 then
		set @qry = concat(@qry, ' limit ', _limit);
	end if;
	
	PREPARE stmt FROM @qry; 
	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt;
		
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_instruction_get_instructions`(
	in where_condition varchar(255) character set utf8,
	in limit_condition varchar(255) character set utf8
)
begin
	SET @qry = CONCAT('select 
		id.id as id
		,id.documenttypeid as documenttypeid
		,id.statusid as statusid
		,id.department_name as department_name
		,id.instruction_number as instruction_number
		,id.instruction_created as instruction_created
		,id.instruction_for as instruction_for
		,id.instruction_about as instruction_about
		,id.instruction_date_from as instruction_date_from
		,id.instruction_date_to as instruction_date_to
		,id.instruction_summary as instruction_summary
		,id.thumb_src as thumb_src
		,id.filesrc as filesrc
		,idt.documenttypename as documenttypename
		,id.filename as filename
		from instruction_documents id
		inner join instruction_documenttypes idt on idt.id = id.documenttypeid where ', where_condition, ' ', limit_condition);
		
	PREPARE stmt FROM @qry; 
	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt;		  
		  
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_invoice_get_user_invoice_templates`(
	in user_id int(11)
)
begin

	select
		id as id
		,invoice_template_name as invoicetemplatename
		,invoice_template_description as invoicetemplatedescription
	from invoice_templates
	where userid = user_id;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_join_group_with_rules`(
 in group_id int(11))
begin

 declare rule_id int(11);
 declare no_more_rules int default false;
 declare cursor_rules cursor for select id from rules;
 declare continue handler for not found set no_more_rules = true;

 open cursor_rules;
 LOOP1:loop
   fetch cursor_rules into rule_id;
   if no_more_rules then
     close cursor_rules;
     leave LOOP1;
   end if;

   insert into grouprules (groupid, ruleid) value (group_id, rule_id);

 end loop LOOP1;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_join_group_with_users`(
 in group_id int(11))
begin

 declare user_id int(11);
 declare no_more_users int default false;
 declare cursor_users cursor for select id from users;
 declare continue handler for not found set no_more_users = true;

 open cursor_users;
 LOOP1:loop
   fetch cursor_users into user_id;
   if no_more_users then
     close cursor_users;
     leave LOOP1;
   end if;

   insert into usergroups (groupid, userid) value(group_id, user_id);

 end loop LOOP1;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_join_user_with_groups`(
 in user_id int(11))
begin

 declare group_id int(11);
 declare no_more_groups int default false;
 declare cursor_groups cursor for select id from groups;
 declare continue handler for not found set no_more_groups = true;

 open cursor_groups;
 LOOP1:loop
   fetch cursor_groups into group_id;
   if no_more_groups then
     close cursor_groups;
     leave LOOP1;
   end if;

   insert into usergroups (groupid, userid) value(group_id, user_id);

 end loop LOOP1;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_message_get_user_unread_messages`(
	in user_id int(11),
	in pge int(11),
	in cnt int(11)
)
begin

	set @a = (pge-1)*cnt;
	set @b = cnt;

	SET @qry = CONCAT('select
	um.id as id
	,um.userid as userid
	,um.messageid as messageid
	,m.messagetitle as messagetitle
	,m.messagebody as messagebody
	,m.messagepriorityid as messagepriorityid
	,mp.priorityname as priorityname
	,mp.prioritylabel as prioritylabel
	,m.messagecreated as messagecreated
	,um.usermessagereaded as usermessagereaded
	,u.givenname as givenname
	,u.sn as sn
	
	from usermessages um 
	inner join messages m on um.messageid = m.id
	inner join messagepriorities mp on mp.id = m.messagepriorityid
	inner join users u on m.userid = u.id
	
	where um.userid = ', user_id ,' 
	and um.usermessageactive = 1
	
	order by m.messagecreated desc
	
	limit ', @a, ', ', @b);
	
	PREPARE stmt FROM @qry; 
	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_place_add_report_to_user_privileges`(
in user_id int(11)
)
begin
	declare report_id int(11);
	declare no_more_reports int default false;
	declare report_cursor cursor for select id from place_reports;
	declare continue handler for not found set no_more_reports = true;
				
	open report_cursor;
				
	LOOP2: loop
		fetch report_cursor into report_id;
		if no_more_reports then
			close report_cursor;
			leave LOOP2;
		end if;
					
		insert into place_reportprivileges (userid, reportid, readprivilege) values (user_id, report_id, 0);
					
	end loop LOOP2;
				
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_place_add_user_collection_privileges`(
	in collection_id int(11))
begin

	declare user_id int(11);
	declare no_more_users int default false;
	declare user_cursor cursor for select id from users;
	declare continue handler for not found set no_more_users = true;
	
	open user_cursor;
	LOOP1: loop
	
		fetch user_cursor into user_id;
		if no_more_users then
			close user_cursor;
			leave LOOP1;
		end if;
		
		insert into place_collectionprivileges (collectionid, userid, readprivilege, writeprivilege) values (collection_id, user_id, 0, 0);
	
	end loop LOOP1;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_place_add_user_report_privileges`(
	in report_id int(11))
begin

	declare user_id int(11);
	declare no_more_users int default false;
	declare user_cursor cursor for select id from users;
	declare continue handler for not found set no_more_users = true;
	
	open user_cursor;
	LOOP1: loop
	
		fetch user_cursor into user_id;
		if no_more_users then
			close user_cursor;
			leave LOOP1;
		end if;
		
		insert into place_reportprivileges (reportid, userid, readprivilege) values (report_id, user_id, 0);
	
	end loop LOOP1;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_place_check`(
 in city_name varchar(255) character set utf8,
 in t_address varchar(255) character set utf8,
 in province_name varchar(255) character set utf8)
begin

 declare find_city_name varchar(255) character set utf8 default '';
 declare find_t_address varchar(255) character set utf8 default '';
 declare find_province_name varchar(255) character set utf8 default '';

 set find_city_name = CONCAT('%', LOWER(TRIM(city_name)), '%');
 set find_t_address = CONCAT('%', LOWER(TRIM(t_address)), '%');
 set find_province_name = CONCAT('%', LOWER(TRIM(province_name)), '%');

 select id
 from places p
 where 
   p.address like find_t_address and
   p.cityname like find_city_name and
   p.provincename like find_province_name;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_place_collection_per_place_instances_list`(
	in instance_id int(11),
	in collection_id int(11))
begin
	select
		ci.id as id
		,ci.instancecreated as instancecreated
		,ci.userid as userid
		,u.givenname as givenname
		,u.sn as sn
		,u.position as position
		,instanceid as instanceid
		,collectionid as collectionid
		,(select count(id) from place_collectioninstancecomments cic where cic.collectioninstanceid = ci.id ) as commentscount
	from
		place_collectioninstances ci
	inner join view_users u on ci.userid = u.id
	where ci.instanceid = instance_id and ci.collectionid = collection_id;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_place_field_get_selectbox_type_values`(
	in field_id int(11)
)
begin
	select fieldvalue as id, fieldvalue as val from place_fieldvalues where fieldid = field_id; 
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_place_generate_blank_collection_instance`(
in instance_id int(11),
in collection_id int(11),
in collectioninstance_id int(11),
in user_id int(11)
)
begin

declare field_id int(11);
declare no_more_fields int default false;
declare field_cursor cursor for select fieldid from place_collectionfields where collectionid = collection_id;
declare continue handler for not found set no_more_fields = true;

open field_cursor;
LOOP1:loop
fetch field_cursor into field_id;
if no_more_fields then
close field_cursor;
leave LOOP1;
end if;

insert into place_collectioninstancevalues (collectionid, instanceid, collectioninstanceid, fieldid) values (collection_id, instance_id, collectioninstance_id, field_id);

end loop LOOP1;

insert into trigger_rivals (collectionid, instanceid, collectioninstanceid, userid) values (collection_id, instance_id, collectioninstance_id, user_id);

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_place_get_all_collections`()
begin
	select 
		c.id as id
		,c.collectionname as collectionname
		,c.collectiondescription as collectiondescription
		,c.collectioncreated as collectioncreated
		,c.userid as userid
		,u.givenname as givenname
		,u.sn as sn
		,u.position as position
	from place_collections c 
	inner join users u on c.userid = u.id;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_place_get_all_collections_to_selectbox`()
begin
	select 
		c.id as id
		,c.collectionname as collectionname
	from place_collections c;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_place_get_collection_fields`(
	in collection_id int(11)
)
begin
	select
		pif.id as collectionfieldid 
		,f.fieldname as fieldname
		,f.fieldlabel as fieldlabel
		,ft.fieldtypename as fieldtypename
		,f.id as fieldid
		,f.fieldcreated as fieldcreated
		,collection_id as collectionid
	from place_collectionfields pif
	inner join place_fields f on pif.fieldid = f.id
	inner join place_fieldtypes ft on f.fieldtypeid = ft.id
	where pif.collectionid = collection_id
	order by ord asc;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_place_get_collection_instance_comments`(
	in collectioninstance_id int(11)
)
begin

	select
		c.collectioninstanceid as collectioninstanceid
		,c.instanceid as instanceid
		,c.collectionid as collectionid
		,c.comment as comment
		,c.commentcreated as commentcreated
		,c.userid as userid
		,u.givenname as givenname
		,u.sn as sn
		,u.position as position
	from place_collectioninstancecomments c
		inner join view_users u on c.userid = u.id
	where c.collectioninstanceid = collectioninstance_id
	order by c.commentcreated desc;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_place_get_collection_instance_fields`(
in collectioninstance_id int(11)
)
begin

select 
ci.id as id
,ci.collectionid as collectionid
,ci.instanceid as instanceid
,ci.collectioninstanceid as collectioninstanceid
,ci.fieldid as fieldid
,ci.fieldvalue as fieldvalue
,ci.fieldbinarythumb as fieldbinarythumb
,ci.fieldbinarysrc as fieldbinarysrc
,f.fieldname
,f.fieldtypeid as fieldtypeid
,(select count(id) from place_collectioninstancevaluecomments ccc where ccc.collectioninstancevalueid = ci.id) as commentscount
,f.fieldmask as fieldmask
,f.fieldrate as fieldrate
,f.fieldrequired as fieldrequired
from place_collectioninstancevalues ci
inner join place_fields f on ci.fieldid = f.id
inner join place_collectionfields cf on (cf.fieldid = f.id and cf.collectionid = ci.collectionid)
where ci.collectioninstanceid = collectioninstance_id
order by cf.ord asc;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_place_get_collection_instance_field_value_comments`(
	in collectioninstancevalue_id int(11)
)
begin
	select
		civc.comment as comment
		,civc.commentcreated as commentcreated
		,civc.id as id
		,civc.userid as userid
		,u.givenname as givenname
		,u.sn as sn
		,u.position as position
	from place_collectioninstancevaluecomments civc
		inner join view_users u on civc.userid = u.id
	where civc.collectioninstancevalueid = collectioninstancevalue_id
	order by civc.commentcreated desc;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_place_get_collection_per_place_instances_list`(
	in instance_id int(11),
	in collection_id int(11))
begin
	select
		ci.id as id
		,ci.instancecreated as instancecreated
		,ci.userid as userid
		,u.givenname as givenname
		,u.sn as sn
		,u.position as position
	from
		place_collectioninstances ci
	inner join view_users u on ci.userid = u.id
	where ci.instanceid = instance_id and ci.collectionid = collection_id;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_place_get_instance_collections_from_trigger_table`(
	in instance_id int(11),
	in collection_id int(11)
)
begin
	select 
		t.rivalname as rivalname
		,t.rivalprovince as rivalprovince
		,t.rivalcity as rivalcity
		,t.rivalstreet as rivalstreet
		,t.rivalstreetnumber as rivalstreetnumber
		,t.rivalhomenumber as rivalhomenumber
		,t.rivalbinaryphoto as rivalbinaryphoto
		,t.otwarte_od as otwarte_od
		,t.otwarte_do as otwarte_do
		,t.liczba_klientow as liczba_klientow
		,t.szacowany_obrot as szacowany_obrot
		,u.givenname as givenname
		,u.sn as sn
		,u.position as position
		,t.collectioninstanceid as collectioninstanceid
	from trigger_rivals t
		inner join view_users u on t.userid = u.id
	where t.instanceid = instance_id and t.collectionid = collection_id;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_place_get_instance_file_type_comments`(
	in instancefiletype_id int(11)
)
begin
	select
		c.comment as comment
		,c.commentcreated as commentcreated
		,c.userid as userid
		,u.givenname as givenname
		,u.sn as sn
		,u.position as position
	from
		place_instancefiletypecomments c
		inner join view_users u on c.userid = u.id
	where c.instancefiletypeid = instancefiletype_id
	order by c.commentcreated desc;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_place_get_instance_form_comments`(
	in instanceform_id int(11)
)
begin
	select
		c.comment as comment
		,c.commentcreated as commentcreated
		,c.userid as userid
		,u.givenname as givenname
		,u.sn as sn
		,u.position as position
	from
		place_instanceformcomments c
		inner join view_users u on c.userid = u.id
	where c.instanceformid = instanceform_id
	order by c.commentcreated desc;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_place_get_instance_users`(
	in instance_id int(11)
)
begin
	select 
		distinct
		u.givenname as givenname
		,u.sn as sn
		,u.position as position
		,u.mail as mail
		,u.tel1 as phone
		,u.mob as mob
		,u.photo as photo
		,p.userid as userid
		,p.instanceid as instanceid
	from place_participants p
	inner join view_users u on p.userid = u.id
	where p.instanceid = instance_id;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_place_get_steps_from_step_privileges`(
	in user_id int(11)
)
begin
	select 
		sp.id as id
		,sp.readprivilege as readprivilege
		,sp.writeprivilege as writeprivilege
		,sp.acceptprivilege as acceptprivilege
		,sp.refuseprivilege as refuseprivilege
		,sp.archiveprivilege as archiveprivilege
		,sp.deleteprivilege as deleteprivilege
		,sp.moveprivilege as moveprivilege
		,sp.stepid as stepid
		,s.stepname as stepname
	from place_stepprivileges sp inner join place_steps s on sp.stepid = s.id
	where sp.userid = user_id;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_place_get_users_from_collection_privileges`()
begin

select 
distinct fp.userid as userid
,u.givenname as givenname
,u.sn as sn
,u.position as position
from place_collectionprivileges fp inner join view_users u on fp.userid = u.id;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_place_get_users_from_file_type_privileges`()
begin

select 
distinct fp.userid as userid
,u.givenname as givenname
,u.sn as sn
,u.position as position
from place_filetypeprivileges fp inner join view_users u on fp.userid = u.id;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_place_get_users_from_form_privileges`()
begin

select 
distinct fp.userid as userid
,u.givenname as givenname
,u.sn as sn
,u.position as position
from place_formprivileges fp inner join view_users u on fp.userid = u.id;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_place_get_users_from_photo_type_privileges`()
begin

select 
distinct pp.userid as userid
,u.givenname as givenname
,u.sn as sn
,u.position as position
from place_phototypeprivileges pp inner join view_users u on pp.userid = u.id;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_place_get_users_from_report_privileges`()
begin

	select 
		distinct rp.userid as userid
		,u.givenname as givenname
		,u.sn as sn
		,u.position as position
	from place_reportprivileges rp inner join view_users u on rp.userid = u.id;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_place_get_users_from_step_privileges`()
begin

select 
distinct sp.userid as userid
,u.givenname as givenname
,u.sn as sn
,u.position as position
from place_stepprivileges sp inner join view_users u on sp.userid = u.id;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_place_get_user_collections_from_privileges`(
	in user_id int(11)
)
begin

	select 
		cp.id as id
		,cp.readprivilege as readprivilege
		,cp.writeprivilege as writeprivilege
		,cp.collectionid as collectionid
		,c.collectionname as collectionname
	from place_collectionprivileges cp inner join place_collections c on cp.collectionid = c.id
	where cp.userid = user_id;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_place_get_user_file_types_privileges`(
	in user_id int(11)
)
begin

	select 
		ftp.id as id
		,ftp.readprivilege as readprivilege
		,ftp.writeprivilege as writeprivilege
		,ftp.filetypeid as filetypeid
		,ft.filetypename as filetypename
	from place_filetypeprivileges ftp inner join place_filetypes ft on ftp.filetypeid = ft.id
	where ftp.userid = user_id;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_place_get_user_forms_from_privileges`(
	in user_id int(11)
)
begin
	
	select 
		fp.id as id
		,fp.readprivilege as readprivilege
		,fp.writeprivilege as writeprivilege
		,fp.acceptprivilege as acceptprivilege
		,fp.formid as formid
		,f.formname as formname
	from place_formprivileges fp inner join place_forms f on fp.formid = f.id
	where fp.userid = user_id;
	
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_place_get_user_photo_type_privileges`(
	in user_id int(11)
)
begin
	select 
		pp.id as id
		,pp.readprivilege as readprivilege
		,pp.writeprivilege as writeprivilege
		,pp.phototypeid as phototypeid
		,pt.phototypename as phototypename
	from place_phototypeprivileges pp inner join place_phototypes pt on pp.phototypeid = pt.id
	where pp.userid = user_id;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_place_get_user_report_from_privileges`(
	in user_id int(11)
)
begin
	select 
		rp.id as id
		,rp.readprivilege as readprivilege
		,rp.reportid as reportid
		,r.reportname as reportname
	from place_reportprivileges rp inner join place_reports r on rp.reportid = r.id
	where rp.userid = user_id;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_place_get_weeks`()
begin
	select makedate(Year(Now()), (week(a.instancecreated)-1)*7) as startdate from trigger_place_instances a group by week(a.instancecreated);
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_place_get_weeks_to_report`()
begin
	select makedate(Year(Now()), (week(a.instancecreated)-1)*7) as startdate from trigger_place_instances a group by week(a.instancecreated);
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_place_instance_file_type`(
	in instance_id int(11),
	in filetype_id int(11)
)
begin 
select
	ift.id as id 
	,ift.instanceid as instanceid
	,ift.fileid as fileid
	,ift.filetypeid as filetypeid
	,ft.filetypename as filetypename
	,ift.filesrc as filesrc
	,ift.filename as filename
	,ift.userid as userid
	,ift.filetypedescription as filetypedescription
	,u.givenname as givenname
	,u.sn as sn
	,u.position as position
	,ift.filecreated as filecreated
	,ift.filetypethumb as filetypethumb
	,(select count(id) from place_instancefiletypecomments a where a.instancefiletypeid = ift.id) as commentscount
from place_instancefiletypes ift
inner join place_filetypes ft on ift.filetypeid = ft.id
inner join view_users u on ift.userid = u.id
where ift.filetypeid = filetype_id and ift.instanceid = instance_id;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_place_instance_get_photo_by_instance_and_type`(
	in instance_id int(11),
	in phototype_id int(11)
)
begin

	-- ipt.photobincontent as photobincontent

	select 
		ipt.id as id
		,ipt.phototypecreated as phototypecreated
		,ipt.phototypesrc as phototypesrc
		,ipt.phototypename as phototypename
		,ipt.phototypethumb as phototypethumb
		,ipt.userid as userid
		,u.givenname as givenname
		,u.sn as sn
		,u.position as position
	from place_instancephototypes ipt
	inner join users u on ipt.userid = u.id
	where ipt.instanceid = instance_id and ipt.phototypeid = phototype_id;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_place_partner_search`(
 in user_id int(11),
 in province_id int(11),
 in city_name varchar(255) character set utf8,
 in street_name varchar(255) character set utf8,
 in partner_name varchar(255) character set utf8)
begin

 declare find_city_name varchar(255) character set utf8 default '';
 declare find_street_name varchar(255) character set utf8 default '';
 declare find_partner_name varchar(255) character set utf8 default '';

 set find_city_name = CONCAT('%', LOWER(TRIM(city_name)), '%');
 set find_street_name = CONCAT('%', LOWER(TRIM(street_name)), '%');
 set find_partner_name = CONCAT('%', LOWER(TRIM(partner_name)), '%');

 if province_id = 0 then

 select
 p.id as id
 ,p.address as address
 ,p.provinceid as provinceid
 ,p.cityname as cityname
 ,p.provincename as provincename
 ,p.districtname as districtname
 ,p.lat as lat
 ,p.lng as lng
 ,p.userid as userid
 ,p.priority as priority
 ,p.archive as archive
 ,u.givenname as givenname
 ,u.sn as sn
 ,p.id as placeid
 ,p.placecreated as placecreated
 ,p.placestepid as placestepid
 ,p.placestatusid as placestatusid
 ,tpsl.step1status as step1status
 ,tpsl.step2status as step2status
 ,tpsl.step3status as step3status
 ,tpsl.step4status as step4status
 ,tpsl.step5status as step5status
 from places p inner join users u on p.userid=u.id
 inner join trigger_placesteplists tpsl on tpsl.placeid=p.id
 where 
   p.userid = user_id and
   LOWER(p.cityname) like find_city_name and
   LOWER(p.address) like find_street_name and
   (LOWER(u.givenname) like find_partner_name or LOWER(u.sn) like find_partner_name);

 else

 select
 p.id as id
 ,p.address as address
 ,p.provinceid as provinceid
 ,p.cityname as cityname
 ,p.provincename as provincename
 ,p.districtname as districtname
 ,p.lat as lat
 ,p.lng as lng
 ,p.userid as userid
 ,p.priority as priority
 ,p.archive as archive
 ,u.givenname as givenname
 ,u.sn as sn
 ,p.id as placeid
 ,p.placecreated as placecreated
 ,p.placestepid as placestepid
 ,p.placestatusid as placestatusid
 ,tpsl.step1status as step1status
 ,tpsl.step2status as step2status
 ,tpsl.step3status as step3status
 ,tpsl.step4status as step4status
 ,tpsl.step5status as step5status
 from places p inner join users u on p.userid=u.id
 inner join trigger_placesteplists tpsl on tpsl.placeid=p.id
 where 
   p.userid = user_id and
   LOWER(p.cityname) like find_city_name and
   LOWER(p.address) like find_street_name and
   (LOWER(u.givenname) like find_partner_name or LOWER(u.sn) like find_partner_name) and
   p.provinceid=province_id;

 end if;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_place_report_assign_fields_to_group`(
	in group_id int(11)
)
begin

	declare field_id int(11);
	declare no_more_fields int default false;
	declare fields_cursor cursor for select id from place_fields;
	declare continue handler for not found set no_more_fields = true;
	
	open fields_cursor;
	LOOP1: loop
	
		fetch fields_cursor into field_id;
		if no_more_fields then
			close fields_cursor;
			leave LOOP1;
		end if;
		
		insert into place_fieldgroups (fieldid, groupid, access) values (field_id, group_id, 0);
	
	end loop LOOP1;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_place_report_get_all_groups`(
	in columns varchar(255) character set utf8
)
begin

	if Length(columns) = 0 then
	
		select 
			g.id as groupid
			,g.groupname as groupname
			,g.created as created
			,(select count(id) from place_fieldgroups fg where fg.groupid = g.id and fg.access = 1) as fieldcount
		from place_groups g;
		
	else
	
		SET @qry = CONCAT('select ', columns, '
		 from place_groups');
	
		PREPARE stmt FROM @qry; 
		EXECUTE stmt; 

		DEALLOCATE PREPARE stmt;
	
	end if;
	
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_place_report_get_all_reports`()
begin

	select
		r.id as reportid
		,r.reportname as reportname
		,r.reportcreated as reportcreated
		,(select count(id) from place_reportgroups rfg where rfg.groupid = r.id) as groupcount
	from place_reports r;
	
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_place_report_get_group_fields`(
	in group_id int(11)
)
begin
	select
		f.id as fieldid
		,f.fieldname as fieldname
		,f.fieldlabel as fieldlabel
		,fg.id as fieldgroupid
		,fg.groupid as groupid
		,fg.access as access
		,fg.formid as formid
	from place_fieldgroups fg
	inner join place_fields f on fg.fieldid = f.id
	where fg.groupid = group_id;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_place_report_get_report_groups`(
	in report_id int(11)
)
begin
	select 
		g.id as groupid
		,g.groupname as groupname
		,g.created as created
		,(select count(id) from place_fieldgroups fg where fg.groupid = g.id and fg.access = 1) as fieldcount
	from place_groups g
	inner join place_reportgroups rg on rg.groupid = g.id
	where rg.reportid = report_id;
		
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_place_report_get_step_reports`(
	in step_id int(11)
)
begin
	select
		r.id as reportid
		,r.reportname as reportname
		,r.reportcreated as reportcreated
	from place_stepreports sr
	inner join place_reports r on sr.reportid = r.id;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_place_search`(
 in province_id int(11),
 in city_name varchar(255) character set utf8,
 in street_name varchar(255) character set utf8,
 in partner_name varchar(255) character set utf8)
begin

 declare find_city_name varchar(255) character set utf8 default '';
 declare find_street_name varchar(255) character set utf8 default '';
 declare find_partner_name varchar(255) character set utf8 default '';

 set find_city_name = CONCAT('%', LOWER(TRIM(city_name)), '%');

 set find_street_name = CONCAT('%', LOWER(TRIM(street_name)), '%');

 set find_partner_name = CONCAT('%', LOWER(TRIM(partner_name)), '%');

 if province_id = 0 then

 select
 p.id as id
 ,p.address as address
 ,p.provinceid as provinceid
 ,p.cityname as cityname
 ,p.provincename as provincename
 ,p.districtname as districtname
 ,p.lat as lat
 ,p.lng as lng
 ,p.userid as userid
 ,p.priority as priority
 ,p.archive as archive
 ,u.givenname as givenname
 ,u.sn as sn
 ,p.id as placeid
 ,p.placecreated as placecreated
 ,p.placestepid as placestepid
 ,p.placestatusid as placestatusid
 ,tpsl.step1status as step1status
 ,tpsl.step2status as step2status
 ,tpsl.step3status as step3status
 ,tpsl.step4status as step4status
 ,tpsl.step5status as step5status
 from places p inner join users u on p.userid=u.id
 inner join trigger_placesteplists tpsl on tpsl.placeid=p.id
 where 
   LOWER(p.cityname) like find_city_name and
   LOWER(p.address) like find_street_name and
   (LOWER(u.givenname) like find_partner_name or LOWER(u.sn) like find_partner_name);

 else

   select
 p.id as id
 ,p.address as address
 ,p.provinceid as provinceid
 ,p.cityname as cityname
 ,p.provincename as provincename
 ,p.districtname as districtname
 ,p.lat as lat
 ,p.lng as lng
 ,p.userid as userid
 ,p.priority as priority
 ,p.archive as archive
 ,u.givenname as givenname
 ,u.sn as sn
 ,p.id as placeid
 ,p.placecreated as placecreated
 ,p.placestepid as placestepid
 ,p.placestatusid as placestatusid
 ,tpsl.step1status as step1status
 ,tpsl.step2status as step2status
 ,tpsl.step3status as step3status
 ,tpsl.step4status as step4status
 ,tpsl.step5status as step5status
 from places p inner join users u on p.userid=u.id
 inner join trigger_placesteplists tpsl on tpsl.placeid=p.id
 where 
   LOWER(p.cityname) like find_city_name and
   LOWER(p.address) like find_street_name and
   (LOWER(u.givenname) like find_partner_name or LOWER(u.sn) like find_partner_name) and
   p.provinceid=province_id;

 end if;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_proposal_get_user_proposals`(
	in user_id int(11),
	in pge int(11),
	in cnt int(11)
)
begin

	set @a = (pge-1)*cnt;
	set @b = cnt;
	
	SET @qry = CONCAT('select
	p.proposalid as proposalid
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
	inner join proposalstatuses ps on p.proposalstep2status = ps.id
	left join proposal_businesstrip pbt on pbt.id = p.proposalid
	
	where p.userid = ', user_id, '
	
	order by p.proposalstep1ended desc
	
	limit ', @a, ', ', @b);
	
	PREPARE stmt FROM @qry; 
	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_protocol_add_protocol_instance_row`(
	in _type_id int(11),
	in _instance_id int(11),
	in _group_id int(11)
)
begin

	-- Pierwszym etapem jest pobranie numeru wiersza
	set @my_row = (select max(row) from protocol_instancevalues where instanceid = _instance_id and typeid = _type_id and groupid = _group_id);

	-- Teraz mając numer wiersza tworzę kursor, który
	-- przechodzi przez wszystkie pola grupy i dodaje wartości.
	BLOCK1: begin
		declare field_id int(11);
		declare no_more_fields int default false;
		declare field_cursor cursor for select fieldid from protocol_fieldgroups where groupid = _group_id and access = 1;
		declare continue handler for not found set no_more_fields = true;
		
		open field_cursor;
		LOOP1: loop
			fetch field_cursor into field_id;
			if no_more_fields then
				close field_cursor;
				leave LOOP1;
			end if;
			
			insert into protocol_instancevalues (instanceid, typeid, fieldid, groupid, row) values 
				(_instance_id, _type_id, field_id, _group_id, IFNULL(@my_row, -1)+1);
			
		end loop LOOP1;
		
	end BLOCK1;
	
select 
	protocol_instancevalues.id,fieldname,fieldid,fieldvalue,fieldclass,readonly,fieldtypeid 
from protocol_instancevalues 
	inner join protocol_fields on protocol_instancevalues.fieldid = protocol_fields.id 
where instanceid=_instance_id and typeid=_type_id and groupid=_group_id and row=@my_row+1;
	
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_protocol_assign_field_with_groups`(
	in field_id int(11)
)
begin
	declare group_id int(11);
	declare no_more_groups int default false;
	declare group_cursor cursor for select id from protocol_groups;
	declare continue handler for not found set no_more_groups = true;
				
	open group_cursor;
				
	LOOP2: loop
		fetch group_cursor into group_id;
		if no_more_groups then
			close group_cursor;
			leave LOOP2;
		end if;
					
		insert into protocol_fieldgroups (fieldid, groupid) values (field_id, group_id);
					
	end loop LOOP2;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_protocol_assign_group_with_fields`(
	in group_id int(11)
)
begin
	declare field_id int(11);
	declare no_more_fields int default false;
	declare field_cursor cursor for select id from protocol_fields;
	declare continue handler for not found set no_more_fields = true;
	
	open field_cursor;
	
	LOOP1: loop
		fetch field_cursor into field_id;
		if no_more_fields then
			close field_cursor;
			leave LOOP1;
		end if;
		insert into protocol_fieldgroups (fieldid, groupid) values (field_id, group_id);
	end loop LOOP1;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_protocol_assign_group_with_types`(
	in group_id int(11)
)
begin
	declare type_id int(11);
	declare no_more_types int default false;
	declare type_cursor cursor for select id from protocol_types;
	declare continue handler for not found set no_more_types = true;
	
	open type_cursor;
	
	LOOP1: loop
		fetch type_cursor into type_id;
		if no_more_types then
			close type_cursor;
			leave LOOP1;
		end if;
		insert into protocol_typegroups (typeid, groupid) values (type_id, group_id);
	end loop LOOP1;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_protocol_assign_type_with_groups`(
	in type_id int(11)
)
begin
	
	declare group_id int(11);
	declare no_more_groups int default false;
	declare group_cursor cursor for select id from protocol_groups;
	declare continue handler for not found set no_more_groups = true;
	
	open group_cursor;
	LOOP1: loop
		fetch group_cursor into group_id;
		if no_more_groups then
			close group_cursor;
			leave LOOP1;
		end if;
		insert into protocol_typegroups (typeid, groupid) values (type_id, group_id);
	end loop LOOP1;
	
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_protocol_create_blank_protocol`(
	in instance_id int(11),
	in type_id int(11)
)
begin
	
	BLOCK1: begin
	
	declare group_id int(11);
	declare no_more_groups int default false;
	declare group_cursor cursor for select distinct groupid from protocol_typegroups where typeid = type_id and access = 1;
	declare continue handler for not found set no_more_groups = true;
	
	open group_cursor;
	LOOP1: loop
		fetch group_cursor into group_id;
		if no_more_groups then
			close group_cursor;
			leave LOOP1;
		end if;
		
		BLOCK2: begin
		
		declare field_id int(11);
		declare no_more_fields int default false;
		declare field_cursor cursor for select fieldid from protocol_fieldgroups where access = 1 and groupid = group_id;
		declare continue handler for not found set no_more_fields = true;
		
		open field_cursor;
		LOOP2: loop
			fetch field_cursor into field_id;
			if no_more_fields then
				close field_cursor;
				leave LOOP2;
			end if;
		
		insert into protocol_instancevalues (instanceid, typeid, fieldid, groupid) values (instance_id, type_id, field_id, group_id);
		end loop LOOP2;
		
		end BLOCK2;
		
		
	end loop LOOP1;
	
	end BLOCK1;
	
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_protocol_get_day_protocols`(
	in _day int(2),
	in _month int(2),
	in _year int(4)
)
begin
	select 
		pi.userid as userid
		,u.login as login
		,u.givenname as givenname
		,pi.instance_created as date
		,pi.id as protocolid
		,pi.typeid as typeid
		,pt.typename as typename
	from
		protocol_instances pi
	inner join users u on pi.userid = u.id
	inner join protocol_types pt on pi.typeid = pt.id
	where day(pi.instance_created) = _day and month(pi.instance_created) = _month and year(pi.instance_created) = _year;
	
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_protocol_get_groups`()
begin
	select 
		g.id as groupid
		,g.groupname as groupname
		,(select count(id) from protocol_fieldgroups fg where fg.groupid = g.id and fg.access = 1 ) as fieldscount
	from protocol_groups g;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_protocol_get_group_fields`(
	in group_id int(11),
	in whr varchar(255) character set utf8
)
begin

	SET @qry = CONCAT('select
		fg.id as fieldgroupid
		,f.id as fieldid
		,f.fieldname as fieldname
		,ft.fieldtypename as fieldtypename
		,fg.access as access
		from protocol_fieldgroups fg 
		inner join protocol_fields f on fg.fieldid = f.id
		inner join place_fieldtypes ft on f.fieldtypeid = ft.id
		where fg.groupid = ', group_id, ' and ', whr);
		
	PREPARE stmt FROM @qry; 
	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_protocol_get_summary_dates`()
begin

	SELECT 
		distinct DATE(pi.instance_created) as date, 
		count(*) as c 
	from protocol_instances pi 
	group by date(pi.instance_created) 
	order by pi.instance_created desc 
	limit 7;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_protocol_get_types`()
begin
	select
		t.id as typeid
		,t.typename as typename
		,(select count(id) from protocol_typegroups tg where tg.typeid = t.id and tg.access = 1) as groupscount
	from protocol_types t;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_protocol_get_type_groups`(
	in type_id int(11)
)
begin
	select
		tg.id as typegroupid
		,g.id as groupid
		,g.groupname as groupname
		,g.grouprepeat as grouprepeat
		,(select count(id) from protocol_fieldgroups fg where fg.groupid = g.id and fg.access = 1) as fieldscount
		,tg.access as access
	from protocol_typegroups tg
	inner join protocol_groups g on tg.groupid = g.id
	where tg.typeid = type_id;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_protocol_get_user_protocols`(
	in _user_id int(11),
	in _elements int(4),
	in _page int(4)
)
begin

	set @a = (_page-1)*_elements;
	
	set @qry = CONCAT('select 
		pi.id as protocolinstanceid
		,pi.typeid as protocoltypeid
		,pi.instance_created as instance_created
		,pi.userid as userid
		,u.login as login
		,u.givenname as givenname
		,pt.typename as typename
		,pi.protocolnumber as protocolnumber
	from protocol_instances pi 
	inner join protocol_types pt on pi.typeid = pt.id
	inner join users u on pi.userid = u.id
	where pi.userid = ', _user_id, ' and u.id = ', _user_id, ' order by pi.instance_created desc limit ', @a, ', ', _elements);

	PREPARE stmt FROM @qry; 
	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt;	
	
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_protocol_get_user_protocols_count`(
	in _user_id int(11)
)
begin
	select count(id) as c from protocol_instances where userid = _user_id; 
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_protocol_get_value_rows`(
	col varchar(255) character set utf8,
	cond varchar(255) character set utf8
)
begin

	SET @qry = CONCAT('select ', col, ' from protocol_instancevalues inner join protocol_fields on protocol_instancevalues.fieldid = protocol_fields.id where ', cond);
		
	PREPARE stmt FROM @qry; 
	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt;  
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_restore_workflow`(
 in workflow_id int(11),
 in user_id int(11),
 in ip varchar(16)
)
begin

 declare document_id int(11);
 set document_id = (select documentid from del_workflows where id = workflow_id);

 set autocommit = 0;

 start transaction;

 insert into documents select * from del_documents where id = document_id;
 delete from del_documents where id = document_id;
 insert into del_history (
   del_historydate, 
   del_historytable, 
   del_historytablefield, 
   del_historytablekey, 
   del_historyuserid, 
   del_historyip) 
 values (NOW(), 'del_documents', 'id', document_id, user_id, ip);

 insert into workflows select * from del_workflows where id = workflow_id;
 delete from del_workflows where id = workflow_id;
 insert into del_history (
   del_historydate, 
   del_historytable, 
   del_historytablefield, 
   del_historytablekey, 
   del_historyuserid, 
   del_historyip) 
 values (NOW(), 'del_workflows', 'id', workflow_id, user_id, ip);

 insert into workflowstepdescriptions select * from del_workflowstepdescriptions where workflowid = workflow_id;
 delete from del_workflowstepdescriptions where workflowid = workflow_id;
 insert into del_history (
   del_historydate, 
   del_historytable, 
   del_historytablefield, 
   del_historytablekey, 
   del_historyuserid, 
   del_historyip) 
 values (NOW(), 'del_workflowstepdescriptions', 'workflowid', workflow_id, user_id, ip);

 insert into workflowsteps select * from del_workflowsteps where workflowid = workflow_id;
 delete from del_workflowsteps where workflowid = workflow_id;
 insert into del_history (
   del_historydate, 
   del_historytable, 
   del_historytablefield, 
   del_historytablekey, 
   del_historyuserid, 
   del_historyip) 
 values (NOW(), 'del_workflowsteps', 'workflowid', workflow_id, user_id, ip);

 insert into documentinstances select * from del_documentinstances where documentid = document_id;
 delete from del_documentinstances where documentid = document_id;
 insert into del_history (
   del_historydate, 
   del_historytable, 
   del_historytablefield, 
   del_historytablekey, 
   del_historyuserid, 
   del_historyip) 
 values (NOW(), 'del_documentinstances', 'documentid', document_id, user_id, ip);

 insert into documentattributevalues select * from del_documentattributevalues where documentid = document_id;
 delete from del_documentattributevalues where documentid = document_id;
 insert into del_history (
   del_historydate, 
   del_historytable, 
   del_historytablefield, 
   del_historytablekey, 
   del_historyuserid, 
   del_historyip) 
 values (NOW(), 'del_documentattributevalues', 'documentid', document_id, user_id, ip);

 insert into workflowtosendmails select * from del_workflowtosendmails where workflowid = workflow_id;
 delete from del_workflowtosendmails where workflowid = workflow_id;
 insert into del_history(
   del_historydate, 
   del_historytable, 
   del_historytablefield, 
   del_historytablekey, 
   del_historyuserid, 
   del_historyip) 
 values (NOW(), 'del_workflowtosendmails', 'workflowid', workflow_id, user_id, ip);

 delete from trigger_workflowsearch where workflowid = workflow_id;
 delete from trigger_workflowsteplists where workflowid = workflow_id;
 delete from cron_invoicereports where workflowid = workflow_id;

 insert into trigger_workflowsearch select * from del_trigger_workflowsearch where workflowid = workflow_id;
 delete from del_trigger_workflowsearch where workflowid = workflow_id;
 insert into del_history(
   del_historydate, 
   del_historytable, 
   del_historytablefield, 
   del_historytablekey, 
   del_historyuserid, 
   del_historyip) 
 values (NOW(), 'del_trigger_workflowsearch', 'workflowid', workflow_id, user_id, ip);

 insert into trigger_workflowsteplists select * from del_trigger_workflowsteplists where workflowid = workflow_id;
 delete from del_trigger_workflowsteplists where workflowid = workflow_id;
 insert into del_history(
   del_historydate, 
   del_historytable, 
   del_historytablefield, 
   del_historytablekey, 
   del_historyuserid, 
   del_historyip) 
 values (NOW(), 'del_trigger_workflowsteplists', 'workflowid', workflow_id, user_id, ip);

 insert into cron_invoicereports select * from del_cron_invoicereports where workflowid = workflow_id;
 delete from del_cron_invoicereports where workflowid = workflow_id;
 insert into del_history(
   del_historydate, 
   del_historytable, 
   del_historytablefield, 
   del_historytablekey, 
   del_historyuserid, 
   del_historyip) 
 values (NOW(), 'del_cron_invoicereports', 'workflowid', workflow_id, user_id, ip);

 commit;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_search`(in search varchar(128) character set utf8)
begin

 declare tofind varchar(255) character set utf8 default '';
 set tofind = CONCAT('%', LOWER(TRIM(search)), '%');

 select
   workflowid
 , documentid
 , numer_faktury
 , nazwa1
 , workflowstepnote
 from
   trigger_workflowsearch
 where
   LOWER(workflowstepnote) like tofind OR
   LOWER(numer_faktury) like tofind OR
   LOWER(netto) like tofind OR
   LOWER(brutto) like tofind OR
   LOWER(nazwa1) like tofind OR
   LOWER(nazwa2) like tofind OR
   LOWER(nip) like tofind OR
   LOWER(numer_faktury_zewnetrzny) like tofind;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_search_instructions`(
 in search varchar(255) character set utf8
)
begin

 declare tosearch varchar(255) character set utf8 default '';
 set tosearch = CONCAT('%', LOWER(TRIM(search)), '%');

 select distinct
   i.id as instruction_id
   ,i.instructionname as instructionname
   ,ic.id as instructioncatgoryid
   ,ic.instructioncategoryname as instructioncategoryname
   ,u.givenname as authorgivenname
   ,u.sn as authorsn
   ,f.fileoriginalname as fileoriginalname
   ,f.filename as filename
   ,i.instructionnumber as instructionnumber
   ,i.instructiondescription as instructiondescription
   ,i.instructioncreated as instructioncreated
   ,f.id as fileid
 from instruction_instructions i
 inner join instruction_instructioncategories ic on i.instructioncategoryid=ic.id
 inner join users u on i.userid = u.id
 inner join files f on i.fileid = f.id
 where 
   LOWER(i.instructionname) like tosearch or
   LOWER(ic.instructioncategoryname) like tosearch or
   LOWER(u.givenname) like tosearch or
   LOWER(u.sn) like tosearch or
   LOWER(f.fileoriginalname) like tosearch or
   LOWER(f.filename) like tosearch or
   LOWER(i.instructionnumber) like tosearch or
   LOWER(i.instructiondescription) like tosearch;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_search_users`(
 in search varchar(128) character set utf8
)
begin
 declare tosearch varchar(255) character set utf8 default '';
 set tosearch = CONCAT('%', LOWER(TRIM(search)), '%');

 select 
   id
   ,login	
   ,photo	
   ,departmentid	
   ,givenname	
   ,sn	
   ,mail	
   ,samaccountname	
   ,departmentname	
   ,lft	
   ,rgt	
   ,parent_id	
   ,level	
   ,position	
   ,tel1	
   ,tel2	
   ,mob	
   ,ldapdepartmentname	
   ,description	
   ,size
 from view_users
 where 
   (LOWER(login) like tosearch or
   LOWER(photo) like tosearch or
   LOWER(givenname) like tosearch or
   LOWER(sn) like tosearch or
   LOWER(mail) like tosearch or
   LOWER(samaccountname) like tosearch or
   LOWER(departmentname) like tosearch or
   LOWER(position) like tosearch or
   LOWER(tel1) like tosearch or
   LOWER(tel2) like tosearch or
   LOWER(mob) like tosearch or
   LOWER(ldapdepartmentname) like tosearch or
   LOWER(description) like tosearch)
	and
	active=1;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_ssg_get_ssg_by_userid`(
 in user_id int(11),
 in _month int(4),
 in _year int(4)
)
begin

 if user_id <> 0 then

 	select 
   q.id as questionaryid
   ,u.givenname as givenname
   ,u.sn as sn
   ,q.questionnairestart as questionnairestart
   ,q.questionnairestop as questionnairestop
   ,s.projekt as projekt
   ,s.adressklepu as adressklepu
   ,IFNULL((select sum(qq.questionfactor) from ssg_answers a inner join ssg_questions qq on a.questionid = qq.id where a.questionaryid = q.id and a.answervalue=1), 0) as answersum
   ,IFNULL((select sum(qq.questionfactor) from ssg_answers a inner join ssg_questions qq on a.questionid = qq.id where a.questionaryid = q.id), 0) as answertotalsum
  from 
     ssg_questionnaires q
   inner join users u on q.userid = u.id
   inner join store_stores s on q.storeid = s.id
   where q.userid = user_id and q.visible = 1 and Month(q.questionnairestart) = _month and Year(q.questionnairestart) = _year;

 else

 	select 
   q.id as questionaryid
   ,u.givenname as givenname
   ,u.sn as sn
   ,q.questionnairestart as questionnairestart
   ,q.questionnairestop as questionnairestop
   ,s.projekt as projekt
   ,s.adressklepu as adressklepu
   ,IFNULL((select sum(qq.questionfactor) from ssg_answers a inner join ssg_questions qq on a.questionid = qq.id where a.questionaryid = q.id and a.answervalue=1), 0) as answersum
   ,IFNULL((select sum(qq.questionfactor) from ssg_answers a inner join ssg_questions qq on a.questionid = qq.id where a.questionaryid = q.id), 0) as answertotalsum
  from 
     ssg_questionnaires q
   inner join users u on q.userid = u.id
   inner join store_stores s on q.storeid = s.id
	where q.visible = 1 and Month(q.questionnairestart) = _month and Year(q.questionnairestart) = _year;

 end if;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_store_get_all_attributes`()
begin
	select
		a.id as id
		,a.attributename as attributename
		,at.typename as typename
	from store_attributes a 
	inner join store_attributetypes at on a.attributetypeid = at.id;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_store_get_all_attribute_types`()
begin
	select
		id as id
		,typename as typename
	from store_attributetypes;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_store_get_all_objects`()
begin
	select
		o.id as id
		,o.objectname as objectname
	from store_objects o;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_store_get_all_stores`(
	in _location varchar(64) character set utf8,
	in _search varchar(255) character set utf8,
	in _page int(5),
	in _elements int(4),
	in _shelf_id int(11)
)
begin

	set @a = (_page-1)*_elements;
	
	if _shelf_id <> 0 then
		set @qry = CONCAT('select
			s.id as id
			,s.storecreated as storecreated
			,s.projekt as projekt
			,s.sklep as sklep
			,s.adressklepu as adressklepu
			,s.telefonkom as telefonkom
			,s.telefon as telefon
			,s.email as email
			,s.m2_sale_hall as m2_sale_hall
			,s.m2_all as m2_all
			,s.longitude as longitude
			,s.latitude as latitude
			,s.loc_mall_name as loc_mall_name
			,s.loc_mall_location as loc_mall_location
			,s.ajent as ajent
			,s.nazwaajenta as nazwaajenta
			,s.dataobowiazywaniaod as dataobowiazywaniaod
			,s.dataobowiazywaniado as dataobowiazywaniado
		from store_stores s
		inner join store_storeshelfs ss on s.id = ss.storeid
		where (loc_mall_name is null or loc_mall_name like "%', _location, '%") and (loc_mall_location like "%', _search, '%" or projekt like "%', _search ,'%" or adressklepu like "%', _search ,'%" or nazwaajenta like "%', _search ,'%" or ajent like "%', _search ,'%" or sklep like "%', _search ,'%") and ss.shelfid = ', _shelf_id ,' order by projekt asc limit ', @a, ', ', _elements);
	
	else
	
		set @qry = CONCAT('select
	    	id as id
			,storecreated as storecreated
			,projekt as projekt
			,sklep as sklep
			,adressklepu as adressklepu
			,telefonkom as telefonkom
			,telefon as telefon
			,email as email
			,m2_sale_hall as m2_sale_hall
			,m2_all as m2_all
			,longitude as longitude
			,latitude as latitude
			,loc_mall_name as loc_mall_name
			,loc_mall_location as loc_mall_location
			,ajent as ajent
			,nazwaajenta as nazwaajenta
			,dataobowiazywaniaod as dataobowiazywaniaod
			,dataobowiazywaniado as dataobowiazywaniado
		from store_stores
		where (loc_mall_name is null or loc_mall_name like "%', _location, '%") and (loc_mall_location like "%', _search, '%" or projekt like "%', _search ,'%" or adressklepu like "%', _search ,'%" or nazwaajenta like "%', _search ,'%" or ajent like "%', _search ,'%" or sklep like "%', _search ,'%") order by projekt asc limit ', @a, ', ', _elements);
	
	end if;

	PREPARE stmt FROM @qry; 
	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_store_get_defined_shelfs`()
begin
	select
		ss.id as id
		,ss.shelftypeid as shelftypeid
		,ss.shelfcategoryid as shelfcategoryid
		,c.shelfcategoryname as shelfcategoryname
		,t.shelftypename as shelftypename
	from store_shelfs ss
	inner join store_shelftypes t on ss.shelftypeid = t.id
	inner join store_shelfcategories c on ss.shelfcategoryid = c.id;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_store_get_localizations_selectbox`(
)
begin
	select distinct loc_mall_name from store_stores;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_store_get_object_attributes`(
	in _object_id int(11)
)
begin
	select
		_object_id as objectid
		,a.attributename as attributename
		,o.attributeid as attributeid
	from store_objectattributes o
	inner join store_attributes a on o.attributeid = a.id
	where o.objectid = _object_id;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_store_get_object_instance`(
	in _instance_id int(11)
)
begin
	
	select
		a.attributename as attributename
		,oiv.value as value
		,oiv.objectid as objectid
		,oiv.attributeid as attributeid
		,oiv.objectinstanceid as objectinstanceid
	from store_objectinstancevalues oiv
	inner join store_attributes a on oiv.attributeid = a.id
	where oiv.objectinstanceid = _instance_id;
	
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_store_get_planogram_files`(
	in _planogram_id int(11)
)
begin
	
	select
		pf.id as id
		,pf.filename as filename
		,pf.filesrc as filesrc
	from store_planogramfiles pf
	where pf.planogramid = _planogram_id;
	
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_store_get_shelf_stores`(
	in _shelf_id int(11)
)
begin
	select
		distinct
		s.projekt as projekt
		,s.adressklepu as adressklepu
	from store_storeshelfs ss
	inner join store_stores s on ss.storeid = s.id
	where ss.shelfid = _shelf_id;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_store_get_stores_count`(
	in _location varchar(64) character set utf8,
	in _search varchar(255) character set utf8,
	in _shelf_id int(11)
)
begin
	
	if _shelf_id <> 0 then
	
		set @qry = CONCAT('select
   		count(s.id) as c
		from store_stores s
		inner join store_storeshelfs ss on s.id = ss.storeid
		where (s.loc_mall_name is null or s.loc_mall_name like "%', _location, '%") and (s.loc_mall_location like "%', _search, '%" or s.projekt like "%', _search ,'%" or s.adressklepu like "%', _search ,'%" or s.nazwaajenta like "%', _search ,'%" or s.ajent like "%', _search ,'%" or s.sklep like "%', _search ,'%") and ss.shelfid = ', _shelf_id);
	
	else
	
		set @qry = CONCAT('select
   		count(id) as c
		from store_stores
		where (loc_mall_name is null or loc_mall_name like "%', _location, '%") and (loc_mall_location like "%', _search, '%" or projekt like "%', _search ,'%" or adressklepu like "%', _search ,'%" or nazwaajenta like "%', _search ,'%" or ajent like "%', _search ,'%" or sklep like "%', _search ,'%")');
	
	end if;

	PREPARE stmt FROM @qry; 
	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_store_get_stores_to_planograms`(
	in _search varchar(255) character set utf8,
	in _shelf_id int(11),
	in _location varchar(255) character set utf8
)
begin
	
	if _shelf_id <> 0 then
		set @qry = CONCAT('select
			s.id as id
			,s.projekt as projekt
			,s.sklep as sklep
			,s.adressklepu as adressklepu
		from store_stores s
		inner join store_storeshelfs ss on s.id = ss.storeid
		where (loc_mall_name is null or loc_mall_name like "%', _location, '%") and (loc_mall_location like "%', _search, '%" or projekt like "%', _search ,'%" or adressklepu like "%', _search ,'%" or nazwaajenta like "%', _search ,'%" or ajent like "%', _search ,'%" or sklep like "%', _search ,'%") and ss.shelfid = ', _shelf_id ,' order by projekt asc');
	
	else
	
		set @qry = CONCAT('select
	    	id as id
			,projekt as projekt
			,sklep as sklep
			,adressklepu as adressklepu
		from store_stores
		where (loc_mall_name is null or loc_mall_name like "%', _location, '%") and (loc_mall_location like "%', _search, '%" or projekt like "%', _search ,'%" or adressklepu like "%', _search ,'%" or nazwaajenta like "%', _search ,'%" or ajent like "%', _search ,'%" or sklep like "%', _search ,'%") order by projekt asc');
	
	end if;

	PREPARE stmt FROM @qry; 
	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_store_get_store_by_logo`(
	in sklep_logo varchar(12) character set utf8
)
begin
	select 
		id
		,storecreated
		,projekt
		,sklep
		,adressklepu
		,telefonkom
		,telefon
		,email
		,m2_sale_hall
		,m2_all
		,longitude
		,latitude
		,loc_mall_name
		,loc_mall_location
		,ajent
		,nazwaajenta
		,dataobowiazywaniaod
		,dataobowiazywaniado
	from store_stores
	where sklep = sklep_logo
	limit 1; 
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_store_get_store_objects`(
	in _store_id int(11)
)
begin

	select
		so.objectid as objectid
		,count(so.objectid) as c
		,o.objectname as objectname
		,_store_id as storeid
	from store_storeobjects so
	inner join store_objects o on so.objectid = o.id
	where so.storeid = _store_id
	group by so.objectid;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_store_get_store_object_instances`(
	in _object_id int(11),
	in _store_id int(11)
)
begin
	select
		so.objectinstanceid as objectinstanceid
		,so.userid as userid
		,_object_id as objectid
		,_store_id as storeid
		,o.objectname as objectname
		,u.givenname as givenname
		,u.sn as sn
		,so.created as created
	from store_storeobjects so
	inner join store_objects o on so.objectid = o.id
	inner join users u on so.userid = u.id
	where so.objectid = _object_id and so.storeid = _store_id;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_store_get_store_planograms`(
	in _search varchar(255) character set utf8,
	in _shelf_id int(11),
	in _location varchar(255) character set utf8
)
begin
	
	if _shelf_id <> 0 then
		set @qry = CONCAT('select
			distinct 
			p.id as planogramid
			,p.note as note
			,p.created as created
		from store_stores s
		inner join store_storeshelfs ss on s.id = ss.storeid
		inner join store_storeplanograms sp on sp.storeid = s.id
		inner join store_planograms p on sp.planogramid = p.id
		where (loc_mall_name is null or loc_mall_name like "%', _location, '%") and (loc_mall_location like "%', _search, '%" or projekt like "%', _search ,'%" or adressklepu like "%', _search ,'%" or nazwaajenta like "%', _search ,'%" or ajent like "%', _search ,'%" or sklep like "%', _search ,'%") and ss.shelfid = ', _shelf_id ,' order by projekt asc');
	
	else
	
		set @qry = CONCAT('select
	    	distinct 
			p.id as planogramid
			,p.note as note
			,p.created as created
		from store_stores s
		inner join store_storeplanograms sp on sp.storeid = s.id
		inner join store_planograms p on sp.planogramid = p.id
		where (s.loc_mall_name is null or s.loc_mall_name like "%', _location, '%") and (s.loc_mall_location like "%', _search, '%" or s.projekt like "%', _search ,'%" or s.adressklepu like "%', _search ,'%" or s.nazwaajenta like "%', _search ,'%" or s.ajent like "%', _search ,'%" or s.sklep like "%', _search ,'%") order by s.projekt asc');
	
	end if;

	PREPARE stmt FROM @qry; 
	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_store_get_store_protocols_count`(
	in _logo varchar(16) character set utf8
)
begin
	declare user_id int(11);
	set user_id = (select id from users where logo = _logo limit 1);
	
	select 
		count(pi.typeid) as c
		,pt.typename as typename
		,user_id as userid
		,pi.typeid as typeid
	from protocol_instances pi
	inner join protocol_types pt on pi.typeid = pt.id
	where pi.userid =  user_id
	group by pi.typeid;
	
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_store_get_store_shelfs`(
	in _store_id int(11)
)
begin
	select 
		sc.shelfcategoryname as shelfcategoryname
		,st.shelftypename as shelftypename
		,count(ss.shelfid) as c
		,ss.shelfid as shelfid
	from store_storeshelfs ss
	inner join store_shelfs s on ss.shelfid = s.id
	inner join store_shelfcategories sc on s.shelfcategoryid = sc.id
	inner join store_shelftypes st on s.shelftypeid = st.id
	where ss.storeid = _store_id
	group by ss.shelfid;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_store_search_stores`(
	in _search varchar(64) character set utf8
)
begin
	set @qry = CONCAT('select
   	id as id
		,projekt as projekt
		,adressklepu as adressklepu
	from store_stores
	where adressklepu like "%', _search ,'%" or nazwaajenta like "%', _search ,'%" or ajent like "%', _search ,'%" or sklep like "%', _search ,'%"');

	PREPARE stmt FROM @qry; 
	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_users_get_root`()
begin

 select
   id,
   active,
   login,
   photo,
   departmentid,
   givenname,
   sn,
   mail,
   samaccountname,
   departmentname,
   lft,
   rgt,
   parent_id,
   level,
   position,
   size
 from view_users
 where lft = 1;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_users_get_root_branch`(
 in t_lft int(4),
 in t_rgt int(4))
begin

 select 
   id,
   active,
   login,
   photo,
   departmentid,
   givenname,
   sn,
   mail,
   samaccountname,
   departmentname,
   lft,
   rgt,
   parent_id,
   level,
   position,
   size
 from view_users as node
 where node.lft between t_lft and t_rgt
 order by node.lft;

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_users_structure`()
BEGIN

SELECT 
	-- s.id, 
	s.keyid as id, 
	IF(u.givenname IS NULL, d.department_name, CONCAT(u.givenname, ' ', u.sn)) as name,
	u.mail,
	u.position,
	u.photo,
	s.lft, 
	s.rgt, 
	IF(u.departmentname IS NULL,d.department_name,u.departmentname) as departmentname,
	s.type,
	(select count(p.id)-1 from users_structure as p where s.lft between p.lft and p.rgt) as depth
	
FROM users_structure AS s 
LEFT JOIN users AS u ON u.id = s.keyid AND s.type = 1
LEFT JOIN departments AS d ON d.id = s.keyid AND (s.type = 0 or s.type = 2 or s.type = 3)

-- WHERE s.lft >= 128

ORDER BY lft;

END$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_user_login_history`()
begin
	select
		u.givenname as givenname
		,u.sn as sn
		,u.login as login
		,u.samaccountname as samaccountname
		,u.id as id
		,u.photo as photo
		,u.last_login as last_login
		,u.logo as logo
		,u.mail as mail
		,p.nazwa1 as nazwa1
		,p.nazwa2 as nazwa2
		,p.email as partneremail
		,u.departmentname as departmentname
		,p.rolakontrahenta as rolahontrahenta
	from users u
	left join partners p on u.logo=p.logo
	where Year(u.last_login) = Year(Now()) and Month(u.last_login) = Month(Now()) and Day(u.last_login) = Day(Now())
	order by u.last_login desc;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_workflow_get_all_documents_in_workflow_count_v2`(
	in _year int(4),
	in _month int(4),
	in _step int(4)
)
begin
	
	set @qry = CONCAT('select 
		count(id) as c
	from trigger_workflowsteplists t 
	where Year(t.workflowcreated) = ', _year, ' and Month(t.workflowcreated) = ', _month);

	PREPARE stmt FROM @qry; 
	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt;
	
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_workflow_get_all_documents_in_workflow_v2`(
	in _year int(4),
	in _month int(4),
	in _step int(4),
	in _page int(4),
	in _elements int(4)
)
begin

	set @a = (_page-1)*_elements;
	
	set @qry = CONCAT('select 
		t.workflowid as workflowid
		,t.workflowcreated as workflowcreated
		,t.documentname as documentname
		,t.stepdescriptionid as stepdescriptionid
		,t.stepdescriptiondraft as stepdescriptiondraft
		,t.stepcontrollingid as stepcontrollingid
		,t.stepcontrollingdraft as stepcontrollingdraft
		,t.stepapproveid as stepapproveid
		,t.stepapproveddraft as stepapproveddraft
		,t.stepaccountingid as stepaccountingid
		,t.stepaccountingdraft as stepaccountingdraft
		,t.stepacceptid as stepacceptid
		,t.stepacceptdraft as stepacceptdraft
		,t.endeddate as endeddate
		,t.contractorname as contractorname
		,t.typeid as typeid
	from trigger_workflowsteplists t 
	where Year(t.workflowcreated) = ', _year, ' and Month(t.workflowcreated) = ', _month, ' order by t.workflowcreated desc limit ', @a, ', ', _elements);

	PREPARE stmt FROM @qry; 
	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt;
	
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_workflow_get_user_active_workflow`(
	in user_id int(11),
	in pge int(11),
	in cnt int(11)
)
begin

set @a = (pge-1)*cnt;
set @b = (pge*cnt);

SET @qry = CONCAT('select 
distinct ws.workflowid,
w.documentid, 
w.workflowcreated,
w.documentname,
w.stepdescriptionid,
w.stepdescriptiondraft,
w.stepcontrollingid,
w.stepcontrollingdraft,
w.stepapproveid,
w.stepapproveddraft,
w.stepaccountingid,
w.stepaccountingdraft,
w.stepacceptid,
w.stepacceptdraft,
w.stependid,
w.endeddate,
w.contractorname
from workflowsteps ws inner join trigger_workflowsteplists w on ws.workflowid = w.workflowid
where ws.workflowstatusid=1 and ws.userid = ',user_id,'
order by w.workflowcreated desc LIMIT ', @a, ', ', @b); 

PREPARE stmt FROM @qry; 
EXECUTE stmt; 

DEALLOCATE PREPARE stmt; 

end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_workflow_get_user_active_workflow_count_v2`(
	in _user_id int(11),
	in _year int(4),
	in _month int(4),
	in _type_id int(11),
	in _all int(4)
)
begin
	
	declare select_string text;
	declare where_string text;
	declare type_string varchar(255);
	declare all_string varchar(255);
	
	set select_string = concat('select 
		distinct count(ws.workflowid) as c
	from workflowsteps ws inner join trigger_workflowsteplists w on ws.workflowid = w.workflowid');
	
	/* SET @qry = CONCAT('select 
		distinct count(ws.workflowid) as c
	from workflowsteps ws inner join trigger_workflowsteplists w on ws.workflowid = w.workflowid
	where ws.workflowstatusid=1 and ws.userid = ',_user_id,' and Year(w.workflowcreated) = ', _year,' and Month(w.workflowcreated) = ', _month); 
	*/
	
	
	
	if _type_id <> 0 then 
		
		set type_string = concat(' and w.typeid = ', _type_id, ' order by w.workflowcreated desc ');
			
	else 
		
		set type_string = concat(' order by w.workflowcreated desc ');
		
	end if;
	
	if _all = 1 then

		set where_string = concat(' where ws.workflowstatusid=1 and ws.userid = ',_user_id);

	else

		set where_string = concat(' where ws.workflowstatusid=1 and ws.userid = ',_user_id,' and Year(w.workflowcreated) = ', _year,' and Month(w.workflowcreated) = ', _month);
	
	end if;
	
	
	-- 	@qry = concat(@qry, ' order by w.workflowcreated desc');	
		
	/*	SET @qry = CONCAT('select 
		distinct count(ws.workflowid) as c
	from workflowsteps ws inner join trigger_workflowsteplists w on ws.workflowid = w.workflowid
	where ws.workflowstatusid=1 and ws.userid = ',_user_id,' and Year(w.workflowcreated) = ', _year,' and Month(w.workflowcreated) = ', _month, '
	order by w.workflowcreated desc'); */
			
	set @qry = concat(select_string, where_string, type_string);

	PREPARE stmt FROM @qry; 
	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_workflow_get_user_active_workflow_v2`(
	in _user_id int(11),
	in _page int(11),
	in _elements int(4),
	in _year int(4),
	in _month int(4),
	in _type_id int(11),
	in _all int(11)
)
begin

	declare select_string text;
	declare where_string text;
	declare type_string text;
	declare order_string text;
	
	set @a = (_page-1)*_elements;
	set select_string = concat('select 
		distinct ws.workflowid,
		w.documentid, 
		w.workflowcreated,
		w.documentname,
		w.stepdescriptionid,
		w.stepdescriptiondraft,
		w.stepcontrollingid,
		w.stepcontrollingdraft,
		w.stepapproveid,
		w.stepapproveddraft,
		w.stepaccountingid,
		w.stepaccountingdraft,
		w.stepacceptid,
		w.stepacceptdraft,
		w.stependid,
		w.endeddate,
		w.contractorname
	from workflowsteps ws inner join trigger_workflowsteplists w on ws.workflowid = w.workflowid');
	
	if _all = 1 then
		
		set where_string = concat(' ws.workflowstatusid=1 and ws.userid = ',_user_id);
		set order_string = concat(' order by w.workflowid desc ');
			
	else
	
		set where_string = concat(' ws.workflowstatusid=1 and ws.userid = ',_user_id,' and Year(w.workflowcreated) = ', _year,' and Month(w.workflowcreated) = ', _month);
		set order_string = concat(' order by w.workflowid desc LIMIT ', @a, ', ', _elements);
	
	end if;
	
	if _type_id <> 0 then
		set type_string = concat(' and typeid = ', _type_id);
	
	else
	
		set type_string = concat(' and 1=1  ');
	
	end if;

	/*
	if _type_id <> 0 then
	
	SET @qry = CONCAT('select 
		distinct ws.workflowid,
		w.documentid, 
		w.workflowcreated,
		w.documentname,
		w.stepdescriptionid,
		w.stepdescriptiondraft,
		w.stepcontrollingid,
		w.stepcontrollingdraft,
		w.stepapproveid,
		w.stepapproveddraft,
		w.stepaccountingid,
		w.stepaccountingdraft,
		w.stepacceptid,
		w.stepacceptdraft,
		w.stependid,
		w.endeddate,
		w.contractorname
	from workflowsteps ws inner join trigger_workflowsteplists w on ws.workflowid = w.workflowid
	where ws.workflowstatusid=1 and ws.userid = ',_user_id,' and Year(w.workflowcreated) = ', _year,' and Month(w.workflowcreated) = ', _month,' and typeid = ', _type_id, ' 
	order by w.workflowid desc LIMIT ', @a, ', ', _elements); 
	
	else
	
	SET @qry = CONCAT('select 
		distinct ws.workflowid,
		w.documentid, 
		w.workflowcreated,
		w.documentname,
		w.stepdescriptionid,
		w.stepdescriptiondraft,
		w.stepcontrollingid,
		w.stepcontrollingdraft,
		w.stepapproveid,
		w.stepapproveddraft,
		w.stepaccountingid,
		w.stepaccountingdraft,
		w.stepacceptid,
		w.stepacceptdraft,
		w.stependid,
		w.endeddate,
		w.contractorname
	from workflowsteps ws inner join trigger_workflowsteplists w on ws.workflowid = w.workflowid
	where ws.workflowstatusid=1 and ws.userid = ',_user_id,' and Year(w.workflowcreated) = ', _year,' and Month(w.workflowcreated) = ', _month,' 
	order by w.workflowid desc LIMIT ', @a, ', ', _elements); 
	
	end if;
	
	*/
	
	SET @qry = concat(select_string, ' where ', where_string, type_string, order_string);
	PREPARE stmt FROM @qry; 
	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt;
	
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_workflow_get_user_workflow_count_v2`(
	in _user_id int(11),
	in _year int(4),
	in _month int(4),
	in _type_id int(11),
	in _all int(1)
)
begin

	if _all = 1 then
	
		SET @qry = CONCAT('select 
			distinct count(w.workflowid) as c
			from workflowsteps ws inner join trigger_workflowsteplists w on ws.workflowid = w.workflowid
			where ws.userid = ',_user_id);
	
	elseif _type_id <> 0 then
	
		SET @qry = CONCAT('select 
			distinct count(w.workflowid) as c
			from workflowsteps ws inner join trigger_workflowsteplists w on ws.workflowid = w.workflowid
			where ws.userid = ',_user_id, ' and Year(w.workflowcreated) = ', _year, ' and Month(w.workflowcreated) = ', _month, ' and w.typeid = ', _type_id);
	
	else
	
		SET @qry = CONCAT('select 
			distinct count(w.workflowid) as c
			from workflowsteps ws inner join trigger_workflowsteplists w on ws.workflowid = w.workflowid
			where ws.userid = ',_user_id, ' and Year(w.workflowcreated) = ', _year, ' and Month(w.workflowcreated) = ', _month);
	
	end if; 

	PREPARE stmt FROM @qry; 
	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_workflow_get_user_workflow_v2`(
	in _user_id int(11),
	in _page int(4),
	in _elements int(4),
	in _year int(4),
	in _month int(4),
	in _type_id int(11),
	in _all int(1)
)
begin
	
	set @a = (_page-1)*_elements;
	set @b = (_page*_elements);

	if _all = 1 then
	
		SET @qry = CONCAT('select 
		distinct ws.workflowid,
		w.documentid, 
		w.workflowcreated,
		w.documentname,
		w.stepdescriptionid,
		w.stepdescriptiondraft,
		w.stepcontrollingid,
		w.stepcontrollingdraft,
		w.stepapproveid,
		w.stepapproveddraft,
		w.stepaccountingid,
		w.stepaccountingdraft,
		w.stepacceptid,
		w.stepacceptdraft,
		w.stependid,
		w.endeddate,
		w.contractorname
		from workflowsteps ws inner join trigger_workflowsteplists w on ws.workflowid = w.workflowid
		where ws.userid = ',_user_id,'   
		order by w.workflowid desc'); 
	
	elseif _type_id <> 0 then
	
		SET @qry = CONCAT('select 
		distinct ws.workflowid,
		w.documentid, 
		w.workflowcreated,
		w.documentname,
		w.stepdescriptionid,
		w.stepdescriptiondraft,
		w.stepcontrollingid,
		w.stepcontrollingdraft,
		w.stepapproveid,
		w.stepapproveddraft,
		w.stepaccountingid,
		w.stepaccountingdraft,
		w.stepacceptid,
		w.stepacceptdraft,
		w.stependid,
		w.endeddate,
		w.contractorname
		from workflowsteps ws inner join trigger_workflowsteplists w on ws.workflowid = w.workflowid
		where ws.userid = ',_user_id,' and Year(w.workflowcreated) = ', _year, ' and Month(w.workflowcreated) = ', _month, ' and w.typeid = ', _type_id, '  
		order by w.workflowid desc LIMIT ', @a, ', ', _elements); 
	
	else
	
		SET @qry = CONCAT('select 
		distinct ws.workflowid,
		w.documentid, 
		w.workflowcreated,
		w.documentname,
		w.stepdescriptionid,
		w.stepdescriptiondraft,
		w.stepcontrollingid,
		w.stepcontrollingdraft,
		w.stepapproveid,
		w.stepapproveddraft,
		w.stepaccountingid,
		w.stepaccountingdraft,
		w.stepacceptid,
		w.stepacceptdraft,
		w.stependid,
		w.endeddate,
		w.contractorname
		from workflowsteps ws inner join trigger_workflowsteplists w on ws.workflowid = w.workflowid
		where ws.userid = ',_user_id,' and Year(w.workflowcreated) = ', _year, ' and Month(w.workflowcreated) = ', _month, '  
		order by w.workflowid desc LIMIT ', @a, ', ', _elements);
	
	end if;


	PREPARE stmt FROM @qry; 
	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt;
	
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet_workflow_months`()
begin
	select distinct Month(data_wplywu) from trigger_workflowsearch order by data_wplywu ASC;
end$$

CREATE DEFINER=`intranet` PROCEDURE `sp_intranet__user_default_tree_group`(
	in t_groupid int(11)
)
begin
 declare t_userid int(11);
 declare no_more_users int default false;
 declare users_cursor cursor for select id from users where partner_prowadzacy_sklep = 1;
 declare continue handler for not found set no_more_users = true;
	
 delete from tree_groupusers where groupid = t_groupid;

 open users_cursor;
 LOOP1: loop

   fetch users_cursor into t_userid;
   if no_more_users then
     close users_cursor;
     leave LOOP1;
   end if;

   insert into tree_groupusers (groupid, userid) values (t_groupid, t_userid);

 end loop LOOP1;

end$$
