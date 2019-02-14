/*
 * Trigger tworźcy pierwszy krok obieku nieruchomů[ci.
 * Pierwszym krokiem jest dodanie wsystkich danych przez partnera.
 */
drop trigger if exists t_start_place_steps_statuses$$
drop trigger if exists trigger_create_new_place$$
drop trigger if exists trigger_insert_places$$
create trigger trigger_insert_places after insert on places for each row
begin
  -- Tworź pierwszy krok obiegu nieruchomů[ci
  insert into placeworkflows (placeid, userid, placestatusid, placestepid, placeworkflowstart) 
  values (NEW.id, NEW.userid, 1, 1, Now());

  -- update places set placestepid = 1, placestatusid=1 where id=NEW.id;

  -- Tworze puste atrybuty dla nieruchomů[ci
  call sp_intranet_create_blank_place_attributes(NEW.id);

  -- Tworź pierwszy wpis do tabeli raport뿯½w obiegu nieruchomů[ci
  -- insert into trigger_placesteplists (placeid, step1, step1datetime, step1status) values (NEW.id, 1, Now(), 1);
end$$

drop trigger if exists trigger_insert_placeworkflows$$
create trigger trigger_insert_placeworkflows after insert on placeworkflows for each row
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
create trigger trigger_update_placeworkflows after update on placeworkflows for each row
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


/**
 * Trigger uruchamiaŪcy sũ po dodaniu nowego atrybutu do tabeli z atrybutami.
 * DodaŪc nowy atrybut musź dodš powũzanie dla: uzytkownika, nieruchomů[ci, dokumentu, protokůBu
 * Powũzania ų dodawane przy pomocy procedur zdefiniowanych na bazie
 */
drop trigger if exists trigger_insert_attribute$$
create definer='intranet' trigger trigger_insert_attribute after insert on attributes for each row
begin
  call sp_intranet_add_blank_user_attribute(NEW.id);
  call sp_intranet_add_blank_document_attribute(NEW.id);
  call sp_intranet_add_blank_place_attribute(NEW.id);
  call sp_intranet_add_blank_store_attribute(NEW.id);
end$$

/**
 * Trigger uruchamiany po dodaniu nowej grupy.
 * Trigger wyzwala procedury aktualizuŪce powũzania z gruŰ. Dodawane jest powũzanie
 * group-rule i group-user
 */
drop trigger if exists trigger_insert_group$$
create definer='intranet' trigger triggers_insert_group after insert on groups for each row
begin
  call sp_intranet_join_group_with_rules(NEW.id);
  call sp_intranet_join_group_with_users(NEW.id);
end$$

delimiter //
create trigger t_documentattributevalue after insert on documentattributevalues for each row
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
end//

--
-- Trigger uruchamiany przy aktualizacji danych na fakturze
--
create trigger trigger_update_documentattributevalues after update on documentattributevalues for each row
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

--
-- Trigger uruchamiany przy dodawaniu nowego dokumentu do obiegu
--
delimiter //
create trigger t_workflow after insert on workflows for each row
begin
 
  declare l_nazwa1 text character set utf8;
  declare l_contractorid int(11);
  declare l_documentname text character set utf8;

  set l_contractorid = (select contractorid from documents where id = new.documentid);
  set l_documentname = (select documentattributetextvalue from documentattributevalues where documentid = new.documentid and attributeid = 100);

  -- Aktualizacja danych o obiegu dokument뿯½w w tabeli z raportami faktur
  update cron_invoicereports set workflowid = new.id where documentid = new.documentid;

  set l_nazwa1 = (select nazwa1 from contractors where id = l_contractorid);

  -- Zaktualizowanie wpisu z tabeŬ krok뿯½w.
  -- Wpis zostšB dodany przez trigger t_document
  update trigger_workflowsteplists set workflowid = new.id, workflowcreated = new.workflowcreated, documentname = l_documentname where documentid = new.documentid;
  -- insert into trigger_workflowsteplists (workflowid, documentid, contractorname, workflowcreated, documentname) values (new.id, new.documentid, l_nazwa1, new.workflowcreated, l_documentname);

  update trigger_workflowsearch set workflowid = new.id where documentid = new.documentid;
end//

/**
 * Trigger uruchamiany kiedy tworzony jest nowy krok obiegu dokument뿯½w
 */
drop trigger if exists t_workflowstep$$
drop trigger if exists trigger_insert_workflowsteps$$
create trigger trigger_insert_workflowsteps after insert on workflowsteps for each row
begin

  if new.workflowstepstatusid = 1 then
    update trigger_workflowsteplists set stepdescriptionid = new.workflowstatusid where workflowid = new.workflowid;
    -- Dodanie informacji o departamencie, kt뿯½ry wygenerowšB faktuŲ
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

/**
 * Trigger aktualizuŪcy tabele:
 * - do wyszukiwania nieruchomů[ci
 * - do listowania faktur w obiegu
 * - z raportem dla controllingu
 *
 * Kš|da zmiana w obiegu dokument뿯½w powoduje usupťBnienie tabel o kolejne informacje.
 */
drop trigger if exists t_updateworkflowstep$$
drop trigger if exists trigger_update_workflowteps$$
drop trigger if exists trigger_update_workflowtep$$
create trigger trigger_update_workflowteps after update on workflowsteps for each row
begin

  -- Aktualizacja pierwszego kroku obiegu dokument뿯½w
  if new.workflowstepstatusid = 1 then
    update trigger_workflowsteplists set stepdescriptionid = new.workflowstatusid, workflowstepnote = new.workflowstepnote where workflowid = new.workflowid;
    update trigger_workflowsearch set workflowstepnote = new.workflowstepnote where workflowid = new.workflowid;
    -- Dodanie informacji o departamencie, kt뿯½ry wygenerowšB faktuŲ
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

  -- Ksũgowůś
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

/**
 * Trigger zbieraŪcy dane do raportu faktur w obiegu.
 * Tworzony jest pierwszy, pusty wpis z definicŪ dokumentu.
*/
drop trigger if exists t_document$$
drop trigger if exists trigger_insert_documents$$
create trigger trigger_insert_documents after insert on documents for each row
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

/**
 * Trigger zapisuŪcy typ faktury 
 */
drop trigger if exists trigger_update_documents$$
create trigger trigger_update_documents after update on documents for each row
begin

  if new.typeid != 0 then
    update trigger_workflowsteplists set typeid=new.typeid where documentid = new.id;
  end if;

end$$

/**
 * Trigger tworźcy puste pytania dla kwestionariusza.
 */
drop trigger if exists trigger_insert_ssg_questionaire$$
create trigger trigger_insert_ssg_questionaire after insert on ssg_questionnaires for each row
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

-- Trigger generuŪcy puste formularze do nieruchomů[ci
drop trigger if exists trigger_intranet_place_create_blank_elements$$
create trigger trigger_intranet_place_create_blank_elements after insert on place_instances for each row
begin

	declare t_givenname varchar(64) character set utf8;
	declare t_sn varchar(64) character set utf8;
	declare t_position varchar(128) character set utf8;
	
	set t_givenname = (select givenname from users where id = NEW.userid);
	set t_sn = (select sn from users where id = NEW.userid);
	set t_position = '';
	
	insert into trigger_place_instances (instanceid, instancecreated, userid, givenname, sn, position, source) values (NEW.id, NEW.instancecreated, NEW.userid, t_givenname, t_sn, t_position, NEW.source);

  call sp_intranet_generate_blank_first_place_step(NEW.id, NEW.userid);
  call sp_intranet_generate_blank_place_step_form_instances(NEW.id, -1);
  -- call sp_intranet_generate_blank_place_file_instances(NEW.id, -1);
  -- call sp_intranet_generate_blank_place_photo_instances(NEW.id, -1);
  
  -- Zapisanie ŵ|ytkownika, ⁫ 뿯½ry bierze udzišB w tej nieruchomů[ci
  insert into place_participants (instanceid, userid) values (NEW.id, NEW.userid);
  
end$$

-- Trigger dodaŪcy informacje o nieruchomů[ci do tabeli listuŪcej wszystkie instancje
drop trigger if exists trigger_place_instance_forms_update$$
create trigger trigger_place_instance_forms_update after update on place_instanceforms for each row
begin
	-- Zapisanie miejscowů[ci
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

  if NEW.formfieldid = 167 then
    update trigger_place_instances set destination = NEW.formfieldvalue where instanceid = NEW.instanceid;
  end if;
	
	insert into place_participants (instanceid, userid) values (NEW.instanceid, NEW.userid);
	
end$$

-- Trigger wywůBuje sũ przy tworzeniu nowej instancji zbioru.
-- Trigger wywůBuje metoŤ tworźţ puste pola formularza dla nowego zbioru.
-- Przy tworzeniu pustego formularza zapisuŪ tť| informacŪ o ŵ|ytkowniku, kt뿯½ry bršB udzišB w tej nieruchomů[ci.
drop trigger if exists trigger_intranet_place_generate_blank_collection_fields$$
create trigger trigger_intranet_place_generate_blank_collection_fields after insert on place_collectioninstances for each row
begin

	call sp_intranet_place_generate_blank_collection_instance(NEW.instanceid, NEW.collectionid, NEW.id, NEW.userid);
	insert into place_participants (instanceid, userid) values (NEW.instanceid, NEW.userid); 
	
end$$

drop trigger if exists trigger_intranet_place_update_collection_instance$$
create trigger trigger_intranet_place_update_collection_instance after update on place_collectioninstancevalues for each row
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
	
	if LENGTH(NEW.fieldbinarysrc) > 0 then
		update trigger_rivals set file_src = NEW.fieldbinarysrc where collectioninstanceid = NEW.collectioninstanceid;
	end if;
	
	if LENGTH(NEW.fieldbinarythumb) > 0 then
		update trigger_rivals set file_thumb = NEW.fieldbinarythumb where collectioninstanceid = NEW.collectioninstanceid;
	end if;
	
	
end$$

-- Dodanie informacji o ŵ|ytkowniku, kt뿯½ry dodšB zdŪcie do nieruchomů[ci
drop trigger if exists trigger_intranet_place_add_photo_to_place_instance$$
create trigger trigger_intranet_place_add_photo_to_place_instance after insert on place_instancephototypes for each row 
begin
	insert into place_participants (instanceid, userid) values (NEW.instanceid, NEW.userid);
end$$

-- Dodanie informacji o uzytkowniku, kt뿯½ry komentowšB formularz w nieruchomů[ci
drop trigger if exists trigger_intranet_place_instance_form_comment_add$$
create trigger trigger_intranet_place_instance_form_comment_add after insert on place_instanceformcomments for each row
begin
	insert into place_participants (instanceid, userid) values (NEW.instanceid, NEW.userid);
end$$

-- Dodanie informacji o uzytkowniku, kt뿯½ry skomentowšB zbi뿯½r
drop trigger if exists trigger_intranet_place_collection_instance_comments_add$$
create trigger trigger_intranet_place_collection_instance_comments_add after insert on place_collectioninstancecomments for each row
begin
	insert into place_participants (instanceid, userid) values (NEW.instanceid, NEW.userid);
end$$

-- Dodanie informacji o ŵ|ytkowniku, kt뿯½ry komentowšB pole formularza w zbiorze
drop trigger if exists trigger_intranet_place_collection_instance_value_comment_add$$
create trigger trigger_intranet_place_collection_instance_value_comment_add after insert on place_collectioninstancevaluecomments for each row
begin
	insert into place_participants (instanceid, userid) values (NEW.instanceid, NEW.userid);
end$$

-- Dodanie informacji o ŵ|ytkowniku, kt뿯½ry komentowšB plik
drop trigger if exists trigger_intranet_place_instance_file_type_comment_add$$
create trigger trigger_intranet_place_instance_file_type_comment_add after insert on place_instancefiletypecomments for each row
begin
	insert into place_participants (instanceid, userid) values (NEW.instanceid, NEW.userid);
end$$

-- Dodanie informacji o ŵ|ytkowniku, dodšB nowy plik
drop trigger if exists trigger_intranet_place_instance_file_type_add$$
create trigger trigger_intranet_place_instance_file_type_add after insert on place_instancefiletypes for each row
begin
	insert into place_participants (instanceid, userid) values (NEW.instanceid, NEW.userid);
end$$

-- Triggery zmieniaŪce status i pow뿯½d zmiany statusu przy nieruchomů[ci
-- Sprawdzane ų zmiany na tabeli place_workflows i na tej podstawie aktualizowana jest tabela trigger_place_instances
drop trigger if exists trigger_intranet_place_workflow_change_step_status$$
create trigger trigger_intranet_place_workflow_change_step_status after update on place_workflows for each row
begin

	update trigger_place_instances set
	stepid = 
	case
		when NEW.stepid = 8
			then stepid = -1
			else stepid = NEW.stepid
	end 
	
	,instancestatusid = NEW.statusid, instancereasonid = NEW.instancereasonid
	

	,rejectreasonid = NEW.instancereasonid, rejectnote = NEW.workflownote, rejectuserid = NEW.user2, rejectdatetime = Now() 
	
	where 
		instanceid = NEW.instanceid;
		
	insert into place_participants (instanceid, userid) values (NEW.instanceid, NEW.user2);
	
end$$

drop trigger if exists trigger_intranet_place_workflow_add_step_status$$
create trigger trigger_intranet_place_workflow_add_step_status after insert on place_workflows for each row
begin
	update trigger_place_instances t set stepid = NEW.stepid, instancestatusid = NEW.statusid, instancereasonid = NEW.instancereasonid where t.instanceid = NEW.instanceid;
end$$

--
--
--
-- Wš|ny trigger. Wszystkie ų wš|ne...
-- Trigger dodaŪcy powũzanie regŵBy z grupami. Po dodaniu nowej regŵBy tworzone jest půłcznie.
-- Půłczenie jest tworzone przy pomocy kursora
--
drop trigger if exists trigger_intranet_add_new_rule$$
create trigger trigger_intranet_add_new_rule after insert on rules for each row
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

--
-- Trigger dodaŪcy uprawnienia do zbioru
--
--
drop trigger if exists trigger_intranet_add_collection$$
create trigger trigger_intranet_add_collection after insert on place_collections for each row
begin
	call sp_intranet_place_add_user_collection_privileges(NEW.id);
end$$

--
-- Trigger dodaŪcy pola do nowopowstšBej grupy
--
--
drop trigger if exists trigger_intranet_add_place_group$$
create trigger trigger_intranet_add_place_group after insert on place_groups for each row
begin
	call sp_intranet_place_report_assign_fields_to_group(NEW.id);
end$$


drop trigger if exists trigger_intranet_add_user_groups$$
create trigger trigger_intranet_add_user_groups after insert on users for each row
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

drop procedure if exists trigger_intranet_add_report$$
create trigger trigger_intranet_add_report after insert on place_reports for each row
begin
	call sp_intranet_place_add_user_report_privileges(NEW.id);
end$$

--
-- Trigger aktualizuŪcy uprawnienia po dodaniu nowego formularza
--
--
drop trigger if exists trigger_intranet_add_place_form$$
create trigger trigger_intranet_add_place_form after insert on place_forms for each row
begin
	call sp_intranet_create_blank_user_place_user_to_form_privileges(NEW.id);
end$$

-- drop trigger if exists trigger_intranet_add_place_form$$
create trigger trigger_intranet_add_place_file_type after insert on place_filetypes for each row
begin
	call sp_intranet_create_blank_place_file_type_privileges(NEW.id);
end$$

drop trigger if exists trigger_intranet_add_protocol_field$$
create trigger trigger_intranet_add_protocol_field after insert on protocol_fields for each row
begin
	call sp_intranet_protocol_assign_field_with_groups(NEW.id);
end$$

drop trigger if exists trigger_intranet_protocol_add_group$$
create trigger trigger_intranet_protocol_add_group after insert on protocol_groups for each row
begin
	call sp_intranet_protocol_assign_group_with_fields(NEW.id);
	call sp_intranet_protocol_assign_group_with_types(NEW.id);
end$$

drop trigger if exists trigger_intranet_protocol_add_type$$
create trigger trigger_intranet_protocol_add_type after insert on protocol_types for each row
begin
	call sp_intranet_protocol_assign_type_with_groups(NEW.id);
end$$

drop trigger if exists trigger_intranet_protocol_add_instance$$
create trigger trigger_intranet_protocol_add_instance after insert on protocol_instances for each row
begin
	call sp_intranet_protocol_create_blank_protocol(NEW.id, NEW.typeid);
end$$