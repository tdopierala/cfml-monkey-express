<cfcomponent displayname="Instructions" extends="Controller">

	<cffunction name="init" output="false" access="public" hint="">
 		<cfset super.init() />
		<cfset filters(through="beforeRender",type="before") />
		<cfset filters(through="loadJs",type="before") />
	</cffunction>

	<cffunction name="beforeRender" output="false" access="public" hint="">
		<cfset usesLayout(template="/layout",ajax=false) />
	</cffunction>
	
	<cffunction name="loadJs" output="false" access="public" hint="">
		<cfset APPLICATION.ajaxImportFiles &= ",initInstruction" />
	</cffunction>

	<cffunction
		name="index"
		hint="Lista wszystkich instrukcji"
		description="Widok prezentujący listę wszystkich instrukcji w systemie. Możliwe jest filtrowanie po kategoriach i dacie dodania">

		<!---
			Buduję parametry dla paginacji Aktów prawnych.
			Mechanizm paginacji jest taki sam, jak w przypadku nieruchomości.
			Wszystkie dane zapisuje w sesji.
		--->
		<cfparam name="page" type="numeric" default="1" />
		<cfparam name="elements" type="numeric" default="12" />
		<cfparam name="department_name" type="string" default="" />
		<cfparam name="documenttypeid" type="string" default=""/>
		<cfparam name="typeid" type="numeric" default="0" />

		<cfif StructKeyExists(session, "instruction_filter")>
			<cfset page = session.instruction_filter.page />
			<cfset elements = session.instruction_filter.elements />
			<cfset department_name = session.instruction_filter.department_name />
			<cfset documenttypeid = session.instruction_filter.documenttypeid />
			<cfset typeid = session.instruction_filter.typeid />
		</cfif>

		<cfif StructKeyExists(params, "page")>
			<cfset page = params.page />
		</cfif>

		<cfif StructKeyExists(params, "elements")>
			<cfset elements = params.elements />
		</cfif>
		
		<cfif StructKeyExists(params, "department_name")>
			<cfset department_name = params.department_name />
		</cfif>
		
		<cfif StructKeyExists(params, "documenttypeid")>
			<cfset documenttypeid = params.documenttypeid />
		</cfif>
		
		<cfif StructKeyExists(params, "typeid")>
			<cfset typeid = params.typeid />
		</cfif>
		
		<!---
			Jeżeli jestem PPS to typ dokumentu automatycznie ustalam na taki, 
			jaki jest przypisany do mojego sklepu.
		--->
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="pps">
			<cfinvokeargument name="groupname" value="Partner prowadzacy sklep" />
		</cfinvoke>
		
		<cfif pps is true>
			<cfset var sklep = model("store_store").getStoreByProject(Trim(session.user.login)) />
			<cfset typeid = sklep.typeid />
		</cfif>
		
		
		<!---
			Zapisuje dane w sesji.
		--->
		<cfset session.instruction_filter = {
			page = page,
			elements = elements,
			department_name = department_name,
			documenttypeid = documenttypeid,
			typeid = typeid } />

		<cfset myinstructions = model("instruction").widgetUserInstructions(
			userid = session.userid,
			page = page,
			elements = elements,
			departmentName = department_name,
			documentTypeId = documenttypeid,
			typeid = typeid) />

		<cfset instructionsCount = model("instruction").userInstructionsCount(
			userid = session.userid,
			page = page,
			elements = elements,
			departmentName = department_name,
			documentTypeId = documenttypeid,
			typeid = typeid) />
			
		<cfset documenttypes = model("instruction_documenttype").findAll() />
		<cfset departments = model("selectvalue").findAll(where="attributeid=125") />
		<cfset instruction_types = model("instruction_type").pobierzTypy() />

		<cfset usesLayout(false) />

	</cffunction>

	<cffunction name="add" output="false" access="public" hint="Formularz dodawania instrukcji">
		
		<cfif IsDefined("FORM.FIELDNAMES") and Len(FORM.FILE) GT 0>
			
			<cfset results = structNew() />
			<cfset results.success = true />
			<cfset results.message = "Dodałem dokument do systemu." />
			
			<cfif Len(FORM.FILE) EQ 0>
				
				<cfset results.success = false />
				<cfset results.message = "Nie wybrano pliku." />
			
			<cfelseif Len(FORM.TYPEID) EQ 0>
				
				<cfset results.success = false />
				<cfset results.message = "Nie wybrano przeznaczenia dokumentu (typu)." />
				
			<cfelse>
				
				<cfloop list="#FORM.TYPEID#" index="t" >
					
					<cfset number = "" />
					<cfset documentnumber = "" />
						
					<cfset var fileToUpload = createObject("component", "cfc.upload2").init(
						directory = "instructions",
						maxSize = 3145728) />
					
					<cfset var fileResult = fileToUpload.uploadFile("file") />
					
					<cfif not IsDefined("fileResult.success") or fileResult.success is false>
						<cfset results.success = false />
						<cfset results.message = "Nie mogę zapisać pliku z WAP." />
						
					<cfelse>
						
						<!--- Nadawanie numeru WAP z automatu --->
						<cfswitch expression="#params.documenttypeid#" >
							<cfcase value="1" >
	
								<!--- ID 1 ma typ dokumentu - instrukcje --->
								<cfscript>
									switch (t) {
										case 2:
										
											number = parseSettings(
												settings=model("setting").findAll(
													where="settingname='type2_instructionnumber'"
													)
												);
											
											documentnumber &= "I/" & DateFormat(Now(), 'yyyy') & "/" & DateFormat(Now(), 'mm') & "/" & getInitials(text=params.department_name) & "/" & number.type2_instructionnumber[1];
												
											number_update = model("setting").updateAll(settingvalue=":"&number.type2_instructionnumber[1]+1,where="settingname='type2_instructionnumber'");
										 
											break;
										case 1:
											default:
												number = parseSettings(
													settings=model("setting").findAll(
														where="settingname='instructionnumber'"
														)
													);
												documentnumber &= "I/" & DateFormat(Now(), 'yyyy') & "/" & DateFormat(Now(), 'mm') & "/" & getInitials(text=params.department_name) & "/" & number.instructionnumber[1];
												
												number_update = model("setting").updateAll(settingvalue=":"&number.instructionnumber[1]+1,where="settingname='instructionnumber'");
											break;
									}
								</cfscript>
			
							</cfcase>
			
							<cfcase value="2" >
			
								<!--- ID 2 ma typ dokumentu - wytyczne --->
								<cfscript>
									switch (t) {
										case 2:
										
											number = parseSettings(
												settings=model("setting").findAll(
													where="settingname='type2_directivenumber'"
													)
												);
											
											documentnumber &= "W/" & DateFormat(Now(), 'yyyy') & "/" & DateFormat(Now(), 'mm') & "/" & getInitials(text=params.department_name) & "/" & number.type2_directivenumber[1];
												
											number_update = model("setting").updateAll(settingvalue=":"&number.type2_directivenumber[1]+1,where="settingname='type2_directivenumber'");
										 
											break;
										case 1:
											default:
												number = parseSettings(
													settings=model("setting").findAll(
														where="settingname='directivenumber'"
														)
													);
												documentnumber &= "W/" & DateFormat(Now(), 'yyyy') & "/" & DateFormat(Now(), 'mm') & "/" & getInitials(text=params.department_name) & "/" & number.directivenumber[1];
												
												number_update = model("setting").updateAll(settingvalue=":"&number.directivenumber[1]+1,where="settingname='directivenumber'");
											break;
									}
								</cfscript>
								
							</cfcase>
			
							<cfcase value="3" >
			
								<!---
									ID 3 ma typ dokumentu - rozporządzena
								--->
								<cfscript>
									switch (t) {
										case 2:
										
											number = parseSettings(
												settings=model("setting").findAll(
													where="settingname='type2_regulationnumber'"
													)
												);
											
											documentnumber &= "R/" & DateFormat(Now(), 'yyyy') & "/" & DateFormat(Now(), 'mm') & "/" & getInitials(text=params.department_name) & "/" & number.type2_regulationnumber[1];
												
											number_update = model("setting").updateAll(settingvalue=":"&number.type2_regulationnumber[1]+1,where="settingname='type2_regulationnumber'");
										 
											break;
										case 1:
											default:
												number = parseSettings(
													settings=model("setting").findAll(
														where="settingname='regulationnumber'"
														)
													);
												documentnumber &= "R/" & DateFormat(Now(), 'yyyy') & "/" & DateFormat(Now(), 'mm') & "/" & getInitials(text=params.department_name) & "/" & number.regulationnumber[1];
												
												number_update = model("setting").updateAll(settingvalue=":"&number.regulationnumber[1]+1,where="settingname='regulationnumber'");
											break;
									}
								</cfscript>
			
							</cfcase>
			
							<cfdefaultcase>
			
								<!---
									Wszystkie dokumenty, które nie posiadają zdefiniowanej maski.
								--->
								<cfset number = parseSettings(settings = model("setting").findAll(where="settingname='wapnumber'")) />
			
								<cfset documentnumber &= "X/" & DateFormat(Now(), 'yyyy') & "/" & DateFormat(Now(), 'mm') & "/" & getInitials(text=params.department_name) & "/" & number.wapnumber[1] />
			
								<cfset number_update = model("setting").updateAll(settingvalue=":"&number.wapnumber[1]+1,where="settingname='wapnumber'") />
							</cfdefaultcase>
			
						</cfswitch>
						
						<cfset var myOcr = "" />
	
						<cfpdf action="extracttext" source= "#fileResult.SERVERDIRECTORY#/#fileResult.NEWSERVERNAME#" 
							pages = "*" honourspaces = "true" type="string" name = "myOcr" />
			
						<cfset myinstruction = model("instruction_document").create(params) />
			
						<cfset myinstruction.instruction_number = documentnumber />
						<!---<cfset myinstruction.archive_instructions = FORM.ARCHIVE_INSTRUCTIONS />--->
						<cfset myinstruction.thumb_src = fileResult.THUMBFILENAME />
						<cfset myinstruction.filebinary = fileResult.BINARYCONTENT />
						<cfset myinstruction.filesrc = fileResult.SERVERDIRECTORY & "/" & fileResult.NEWSERVERNAME />
						<cfset myinstruction.filename = fileResult.NEWSERVERNAME />
						<cfset myinstruction.instruction_created = Now() />
						<cfset myinstruction.userid = session.userid />
						<cfset myinstruction.ocr = myOcr />
						<cfset myinstruction.typeid = t />
						<cfset myinstruction.save(callbacks=false) />
						
						<!---
							15.07.2013
							Przenoszenie WAP do archiwum odbywa się w tle. Nie jest to krytyczna
							funkcjonalność, więc można sobie pozwolić ta takie odstępstwo.
						--->
						<cfthread action="run" name="arch#TimeFormat(Now(), 'HHmmss')##documentnumber#" priority="LOW" >
							<cftry>
								
								<cfset toArchive = model("instruction").toArchive(documents = params.archive_instructions) />
								
								<cfcatch type="any" >
									<cfmail
										to="admin@monkey"
										from="Archiwizacja WAP - INTRANET - MAŁPKA S.A.<intranet@monkey>"
										replyto="#get('loc').intranet.email#"
										subject="Archiwizacja WAP"
										type="html">
								
										<cfdump var="#cfcatch#" />
										<cfdump var="#session#" />
			
									</cfmail>					
								</cfcatch>
							</cftry>
						</cfthread>
						
						<!--- Dodałem już instrukcję, teraz dodaje uprawnienia. --->
						<cfset var uprawnienia = model("instruction").addPrivileges(
							id = myinstruction.id,
							groups = FORM.GROUPID) />
						
						<!--- Wysyłam powiadomienie o nowym dokumencie --->
						<cfset powiadomienia = model("instruction").sendNotification(
							id = myinstruction.id,
							groups = FORM.GROUPID) />
					
						<cfset number = "" />
						<cfset documentnumber = "" />
					
					</cfif>
						
				</cfloop>
				
			</cfif>
			
		</cfif>

		<cfset documenttypes = model("instruction_documenttype").findAll() />
		<cfset statuses = model("instruction_status").findAll() />
		<cfset document_types = model("instruction_type").pobierzTypy() />
		<cfset departments = model("selectvalue").findAll(where="attributeid=125") />
		
		<cfset privileges = model("tree_group").getLevel(4, 4) />

	</cffunction>

	<cffunction
		name="actionAdd"
		hint="Zapisanie nowej instrukcji">
			
		<cfdump var="#FORM#" />
		<cfabort />

		<cfset myfile = APPLICATION.cfc.upload.SetDirName(dirName="instructions") />
		<cfset myfile = APPLICATION.cfc.upload.upload(file_field="file") />

		<cfif isStruct(myfile) AND NOT structIsEmpty(myfile) AND StructKeyExists(myfile, "SUCCESS")>

			<!--- Tutaj generuje automatyczny numer dokumentu. --->
			<cfparam name="number" default="0" /> 
			<cfparam name="documentnumber" default="" />

			<!--- Nadawanie numeru WAP z automatu --->
			<cfswitch expression="#params.documenttypeid#" >
				<cfcase value="1" >

					<!---
						ID 1 ma typ dokumentu - instrukcje
					--->
					<cfscript>
						switch (FORM.TYPEID) {
							case 2:
							
								number = parseSettings(
									settings=model("setting").findAll(
										where="settingname='type2_instructionnumber'"
										)
									);
								
								documentnumber &= "I/" & DateFormat(Now(), 'yyyy') & "/" & DateFormat(Now(), 'mm') & "/" & getInitials(text=params.department_name) & "/" & number.type2_instructionnumber[1];
									
								number_update = model("setting").updateAll(settingvalue=":"&number.type2_instructionnumber[1]+1,where="settingname='type2_instructionnumber'");
							 
								break;
							case 1:
								default:
									number = parseSettings(
										settings=model("setting").findAll(
											where="settingname='instructionnumber'"
											)
										);
									documentnumber &= "I/" & DateFormat(Now(), 'yyyy') & "/" & DateFormat(Now(), 'mm') & "/" & getInitials(text=params.department_name) & "/" & number.instructionnumber[1];
									
									number_update = model("setting").updateAll(settingvalue=":"&number.instructionnumber[1]+1,where="settingname='instructionnumber'");
								break;
						}
					</cfscript>

				</cfcase>

				<cfcase value="2" >

					<!---
						ID 2 ma typ dokumentu - wytyczne
					--->
					<cfscript>
						switch (FORM.TYPEID) {
							case 2:
							
								number = parseSettings(
									settings=model("setting").findAll(
										where="settingname='type2_directivenumber'"
										)
									);
								
								documentnumber &= "W/" & DateFormat(Now(), 'yyyy') & "/" & DateFormat(Now(), 'mm') & "/" & getInitials(text=params.department_name) & "/" & number.type2_directivenumber[1];
									
								number_update = model("setting").updateAll(settingvalue=":"&number.type2_directivenumber[1]+1,where="settingname='type2_directivenumber'");
							 
								break;
							case 1:
								default:
									number = parseSettings(
										settings=model("setting").findAll(
											where="settingname='directivenumber'"
											)
										);
									documentnumber &= "W/" & DateFormat(Now(), 'yyyy') & "/" & DateFormat(Now(), 'mm') & "/" & getInitials(text=params.department_name) & "/" & number.directivenumber[1];
									
									number_update = model("setting").updateAll(settingvalue=":"&number.directivenumber[1]+1,where="settingname='directivenumber'");
								break;
						}
					</cfscript>
					
				</cfcase>

				<cfcase value="3" >

					<!---
						ID 3 ma typ dokumentu - rozporządzena
					--->
					<cfscript>
						switch (FORM.TYPEID) {
							case 2:
							
								number = parseSettings(
									settings=model("setting").findAll(
										where="settingname='type2_regulationnumber'"
										)
									);
								
								documentnumber &= "R/" & DateFormat(Now(), 'yyyy') & "/" & DateFormat(Now(), 'mm') & "/" & getInitials(text=params.department_name) & "/" & number.type2_regulationnumber[1];
									
								number_update = model("setting").updateAll(settingvalue=":"&number.type2_regulationnumber[1]+1,where="settingname='type2_regulationnumber'");
							 
								break;
							case 1:
								default:
									number = parseSettings(
										settings=model("setting").findAll(
											where="settingname='regulationnumber'"
											)
										);
									documentnumber &= "R/" & DateFormat(Now(), 'yyyy') & "/" & DateFormat(Now(), 'mm') & "/" & getInitials(text=params.department_name) & "/" & number.regulationnumber[1];
									
									number_update = model("setting").updateAll(settingvalue=":"&number.regulationnumber[1]+1,where="settingname='regulationnumber'");
								break;
						}
					</cfscript>

				</cfcase>

				<cfdefaultcase>

					<!---
						Wszystkie dokumenty, które nie posiadają zdefiniowanej maski.
					--->
					<cfset number = parseSettings(settings = model("setting").findAll(where="settingname='wapnumber'")) />

					<cfset documentnumber &= "X/" & DateFormat(Now(), 'yyyy') & "/" & DateFormat(Now(), 'mm') & "/" & getInitials(text=params.department_name) & "/" & number.wapnumber[1] />

					<cfset number_update = model("setting").updateAll(settingvalue=":"&number.wapnumber[1]+1,where="settingname='wapnumber'") />
				</cfdefaultcase>

			</cfswitch>

			<cfset var myOcr = "" />

			<cfpdf
				action="extracttext" 
				source= "#myfile.SERVERDIRECTORY#/#myfile.NEWSERVERNAME#" 
				pages = "*"
				honourspaces = "true"
				type="string" 
				name = "myOcr" />

			<cfset myinstruction = model("instruction_document").create(params) />

			<cfset myinstruction.instruction_number = documentnumber />
			<cfset myinstruction.thumb_src = myfile.THUMBFILENAME />
			<cfset myinstruction.filebinary = myfile.BINARYCONTENT />
			<cfset myinstruction.filesrc = myfile.SERVERDIRECTORY & "/" & myfile.NEWSERVERNAME />
			<cfset myinstruction.filename = myfile.NEWSERVERNAME />
			<cfset myinstruction.instruction_created = Now() />
			<cfset myinstruction.userid = session.userid />
			<cfset myinstruction.ocr = myOcr />
			<cfset myinstruction.typeid = FORM.TYPEID />
			<cfset myinstruction.save(callbacks=false) />
			
			<!---
				15.07.2013
				Przenoszenie WAP do archiwum odbywa się w tle. Nie jest to krytyczna
				funkcjonalność, więc można sobie pozwolić ta takie odstępstwo.
			--->
			<cfthread action="run" name="archiveInstructions" priority="LOW" >
				<cftry>
					
					<cfset toArchive = model("instruction").toArchive(documents = params.archive_instructions) />
					
					<cfcatch type="any" >
						<cfmail
							to="admin@monkey"
							from="Archiwizacja WAP - INTRANET - MAŁPKA S.A.<intranet@monkey>"
							replyto="#get('loc').intranet.email#"
							subject="Archiwizacja WAP"
							type="html">
					
							<cfdump var="#cfcatch#" />
							<cfdump var="#session#" />

						</cfmail>					
					</cfcatch>
				</cftry>
			</cfthread>

			<!---
				24.01.2013
				Tutaj jest wysyłanie wiadomości email do zainteresowanych o nowej instrukcji.
			--->


			<!---
				Teraz sprawdzam jakie grupy uprawnień zostały załączone i na tej podstawie zniemian wartości.
			--->
			<cfset where_cond = "" />
			<cfif structKeyExists(params, "centrala") >
				<cfset where_cond &= " u.centrala=1 or " />
			</cfif>

			<cfif structKeyExists(params, "dyrektorzy") >
				<cfset where_cond &= " u.dyrektorzy=1 or " />
			</cfif>

			<cfif structKeyExists(params, "menadzer") >
				<cfset where_cond &= " u.menadzer=1 or " />
			</cfif>

			<cfif structKeyExists(params, "partner_ds_ekspansji") >
				<cfset where_cond &= " u.partner_ds_ekspansji=1 or " />
			</cfif>

			<cfif structKeyExists(params, "partner_ds_sprzedazy") >
				<cfset where_cond &= " u.partner_ds_sprzedazy=1 or " />
			</cfif>

			<cfif structKeyExists(params, "partner_prowadzacy_sklep") >
				<cfset where_cond &= " u.partner_prowadzacy_sklep=1 or " />
			</cfif>

			<!---
				Kasuje ostatnie and
			--->
			<cfif Len(where_cond)>
				<cfset where_cond = Left(where_cond, Len(where_cond)-3) />
				<cfset where_cond = " ( " & where_cond & " ) and u.active=1 " />
			<cfelse>
				<cfset where_cond = " 1=0 " />
			</cfif>

			<cfset my_users = model('instruction').getInstructionUsers(condition=where_cond,typeid=FORM.TYPEID) />

			<cfset my_email = model('email').instructionNotification(
				user = my_users,
				instruction = myinstruction) />

			<cfset redirectTo(back=true,success="Dokument został pomyślnie dodany do systemu.") />

		<cfelse>

			<cfset redirectTo(back=true,error=myfile.error) />

		</cfif>

	</cffunction>

	<!---<cffunction
		name="getInstructions"
		hint="Metoda pobierająca wszystkie instrukcje zdefiniowane w systemie">

		<cfset instructions = model("instruction").getAllInstructions(instructioncategoryid=params.instructioncategoryid,datefrom=params.datefrom,dateto=params.dateto,userid=session.userid) />

	</cffunction>--->

	<!---<cffunction
		name="getInstructionFile"
		hint="Pobranie pliku z instrukcją."
		description="Metoda zwracająca plik z instrukcją. Przy okazji zapisywane jest kliknięcie w instrukcję.">

		<cfset myuserinstruction = model("instructionUserInstruction").findByKey(params.key) />
		<cfset myuserinstruction.update(userinstructionread=myuserinstruction.userinstructionread+1,callbacks=false) />

		<cfset myinstruction = model("instruction").findByKey(myuserinstruction.instructionid) />
		<cfset myfile = model("file").findByKey(key=myinstruction.fileid,select="filesrc,filename,id") />

		<cfset usesLayout(template=false) />

	</cffunction>--->

	<cffunction
		name="getInitials"
		hint="Generuje inicjały nazwy departamentu."
		description="Metoda jest wykorzystywana przy budowaniu numeru dokumentu.
				Budowanie inicjału polega na podzieleniu ciągu znaków po spacjach,
				i z każdego z wyrazów pobieram pierwszą literę."
		access="private"
		returntype="String">

		<cfargument
			name="text"
			type="string"
			required="true" />

		<cfparam
			name="initial"
			type="string"
			default="" />

		<!---
			Dziele nazwę po spacjach.
		--->
		<cfset tmp = ListToArray(arguments.text, " ") />

		<!---
			Przechodzę przez wszystkie elementy i biorę tylko pierwszą literę.
		--->
		<cfloop array="#tmp#" index="i" >
			<cfset initial &= uCase(Left(i, 1)) />
		</cfloop>

		<cfreturn initial />

	</cffunction>

	<cffunction
		name="instructionSummary"
		hint="Widget prezentujący listę 6 ostatnich wewnętrznych aktów prawnych
			dodanych do systemu, które są widoczne dla użytkownika."
		description="Widok jest widgetem użytkownika. Ma przygotowany specjalny
				widok.">
		
		<cfparam name="Dtypeid" type="numeric" default="0" />
		
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="pps">
			<cfinvokeargument name="groupname" value="Partner prowadzacy sklep" />
		</cfinvoke>
		
		<cfif pps is true>
			<cfset var sklep = model("store_store").getStoreByProject(Trim(session.user.login)) />
			
			<cfif sklep.RecordCount GT 0>
				<cfset Dtypeid = sklep.typeid />
			<cfelse>
				<cfset Dtypeid = -1 />
			</cfif>
		</cfif>
		
		<cfset widgetInstructions = model("instruction").widgetUserInstructions(
			userid = session.user.id,
			elements = 6,
			typeid = Dtypeid) />

		<!---<cfset renderWith(data="widgetInstructions",layout=false) />--->

	</cffunction>
	
	<cffunction
		name="view"
		hint="Pobieram plik pdf z instrukcją, który jest uzupełniony o 
			pierwszą stronę."
		description="Metoda jest o tyle ciekawa, ze do wrzuconego pliku na
			serwerze dokleja pierwszą stronę zawierającą informacje o dokumencie.
			Wyświetlane jest:
			-	kto dodał plik
			- 	departament
			-	numer dokumentu
			-	czego dotyczy dokument
			-	dokumenty, które tracą ważnosć">
		
		<cfset pdfInstruction = model("instruction_document").findByKey(
			select="filesrc,department_name,instruction_number,instruction_created,instruction_about,instruction_date_from,instruction_date_to,archive_instructions",
			key=params.key) />
			
		<cfset _view = model("instruction_viewer").findOne(where="instructionid=#params.key# AND userid=#session.user.id#") />
						
		<cfif not IsStruct(_view)>
			<cfset view = model("instruction_viewer").create(
				instructionid = params.key,
				userid = session.user.id,
				datetime = Now()
			)/>
		</cfif>
		
		<cfif not FileExists(pdfInstruction.filesrc)>
			<cfset pdfContent = model("instruction_document").findByKey(select="filebinary,filename",key=params.key) />
			
			<cfpdf
				action = "write"
				destination = "#pdfInstruction.filesrc#"
				source = "pdfContent.filebinary"
				overwrite = "yes" />
				
		</cfif>
		
		<!---
			Generuję pierwszą stronę wewnętrznych aktów prawnych.
		--->
		<cfdocument
			format="PDF"
			name="firstPage"
			pagetype="A4"
			fontembed="true" >
				
			<cfoutput>
				
				<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
				<html>
				<head>
					<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
					<style type="text/css"> 
						body { font-family:'Tahoma'; font-size: 12px; }
						.width { width: 900px; margin: 0 auto; }
						.main_page { padding:  }
					</style>
				</head>
				<body>
					<div class="width">
						<div class="main_page">
							<!---
							<div style="margin:20px auto 35px;text-align:center;">
								
								<cfimage
									action="writeToBrowser" 
									source="#ExpandPath('images/logo_monkey_RGB.png')#" >
								
							</div>
							--->
							<h1 style="background-color:##EB0F0F;color:##ffffff;display:block;padding:10px 0 10px;font-weight:normal;text-align:center;font-family:'Tahoma';font-size:18px;">#pdfInstruction.instruction_number#</h1>
							<h2 style="font-weight:normal;text-align:center;font-family:'Tahoma';font-size:16px;margin: 20px 0 45px;display:inline-block;">#pdfInstruction.department_name#</h2>
							
							<table width="100%">
								<tr>
									<td width="30%">Nr. dokumentu</td>
									<td width="70%">#pdfInstruction.instruction_number#</td>
								</tr>
								<tr>
									<td>Data utworzenia</td>
									<td>#DateFormat(pdfInstruction.instruction_created, 'dd.mm.yyyy')#</td>
								</tr>
								<tr>
									<td>Dotyczy</td>
									<td>
										#pdfInstruction.instruction_about#
									</td>
								</tr>
								<tr>
									<td>Data obowiązywania od</td>
									<td>
										<cfif Len(pdfInstruction.instruction_date_from)>
											#DateFormat(pdfInstruction.instruction_date_from, "dd.mm.yyyy")#
										</cfif>
									</td>
								</tr>
								<tr>
									<td>Data obowiązywania do</td>
									<td>
										<cfif Len(pdfInstruction.instruction_date_to)>
											#DateFormat(pdfInstruction.instruction_date_to, "dd.mm.yyyy")#
										</cfif>
									</td>
								</tr>
								<tr>
									<td>Dokumenty tracące ważność</td>
									<td>
										<cfif Len(pdfInstruction.archive_instructions)>
											#pdfInstruction.archive_instructions#
										</cfif>
									</td>
								</tr>
							</table>
							
							
						</div>
					</div>
					
					<div style="position:absolute;bottom:0;left:0;width:100%;background-color:##EB0F0F;color:##ffffff;padding:20px 0 20px;text-align:center;">
						
						MAŁPKA SPÓŁKA AKCYJNA<br />
						ul. Wojskowa 6, 60-792 Poznań<br />
						NIP: 673 176 67 19 | REGON: 331444670<br />
						Zarejestrowana w Sądzie Rejonowym Poznań Nowe Miasto i Wilda<br />
						VIII Wydział Krajowego Rejestru Sądowego pod numerem 0000363985<br />
						wysokość kapitału zakładowego: 30.241.152 zł (w całości opłacony)
						
					</div>
					
				</body>
				</html>
				
			</cfoutput>
				
		</cfdocument>

			
		<!---
			Czary mary... :)
		--->
		<cfpdf
			action="read" 
			name="document" 
			source="#pdfInstruction.filesrc#" />
			
		<cfpdf 
			action = "merge"
			name = "mergedInstruction"
			 >
		
			<cfpdfparam source="firstPage" />
			<cfpdfparam source="document" />
		
		</cfpdf>
	
		
		<cfheader
			name="content-disposition"
			value="attachment; filename=#Replace( pdfInstruction.instruction_number, '/', '_', 'All' )#_#DateFormat(Now(), 'dd_mm_yyyy')#.pdf" />

		<cfcontent
			type="application/pdf" 
			variable="#ToBinary( ToBase64( mergedInstruction ) )#" />
			
		
	</cffunction>
	
	<cffunction name="preview" output="false" access="public" hint="">
		
		<cfif IsDefined("params.key")>
			<cfset pdfInstruction = model("instruction_document").getInstructionByKey(params.key, "filesrc,department_name,instruction_number,instruction_created,instruction_about,instruction_date_from,instruction_date_to,archive_instructions") />
			
			<cfset _view = model("instruction_viewer").findOne(where="instructionid=#params.key# AND userid=#session.user.id#") />
						
				<cfif not IsStruct(_view)>
					<cfset view = model("instruction_viewer").create(
						instructionid = params.key,
						userid = session.user.id,
						datetime = Now()
					)/>
				</cfif>
			
			<cfif not FileExists(pdfInstruction.filesrc)>
				
				<cfset pdfContent = model("instruction_document").findByKey(select="filebinary,filename",key=params.key) />
				<cfpdf action = "write" destination = "#pdfInstruction.filesrc#" source = "pdfContent.filebinary" overwrite = "yes" />
					
			</cfif>
			
			<!---
				Generuję pierwszą stronę wewnętrznych aktów prawnych.
			--->
			<cfdocument format="PDF" name="firstPage" pagetype="A4" fontembed="true" >
					
				<cfoutput>
					
					<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
					<html>
					<head>
						<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
						<style type="text/css"> 
							body { font-family:'Tahoma'; font-size: 12px; }
							.width { width: 900px; margin: 0 auto; }
							.main_page { padding:  }
						</style>
					</head>
					<body>
						<div class="width">
							<div class="main_page">
								<!---
								<div style="margin:20px auto 35px;text-align:center;">
									
									<cfimage
										action="writeToBrowser" 
										source="#ExpandPath('images/logo_monkey_RGB.png')#" >
									
								</div>
								--->
								<h1 style="background-color:##EB0F0F;color:##ffffff;display:block;padding:10px 0 10px;font-weight:normal;text-align:center;font-family:'Tahoma';font-size:18px;">#pdfInstruction.instruction_number#</h1>
								<h2 style="font-weight:normal;text-align:center;font-family:'Tahoma';font-size:16px;margin: 20px 0 45px;display:inline-block;">#pdfInstruction.department_name#</h2>
								
								<table width="100%">
									<tr>
										<td width="30%">Nr. dokumentu</td>
										<td width="70%">#pdfInstruction.instruction_number#</td>
									</tr>
									<tr>
										<td>Data utworzenia</td>
										<td>#DateFormat(pdfInstruction.instruction_created, 'dd.mm.yyyy')#</td>
									</tr>
									<tr>
										<td>Dotyczy</td>
										<td>
											#pdfInstruction.instruction_about#
										</td>
									</tr>
									<tr>
										<td>Data obowiązywania od</td>
										<td>
											<cfif Len(pdfInstruction.instruction_date_from)>
												#DateFormat(pdfInstruction.instruction_date_from, "dd.mm.yyyy")#
											</cfif>
										</td>
									</tr>
									<tr>
										<td>Data obowiązywania do</td>
										<td>
											<cfif Len(pdfInstruction.instruction_date_to)>
												#DateFormat(pdfInstruction.instruction_date_to, "dd.mm.yyyy")#
											</cfif>
										</td>
									</tr>
									<tr>
										<td>Dokumenty tracące ważność</td>
										<td>
											<cfif Len(pdfInstruction.archive_instructions)>
												#pdfInstruction.archive_instructions#
											</cfif>
										</td>
									</tr>
								</table>
								
								
							</div>
						</div>
						
						<div style="position:absolute;bottom:0;left:0;width:100%;background-color:##EB0F0F;color:##ffffff;padding:20px 0 20px;text-align:center;">
							
							MAŁPKA SPÓŁKA AKCYJNA<br />
							ul. Wojskowa 6, 60-792 Poznań<br />
							NIP: 673 176 67 19 | REGON: 331444670<br />
							Zarejestrowana w Sądzie Rejonowym Poznań Nowe Miasto i Wilda<br />
							VIII Wydział Krajowego Rejestru Sądowego pod numerem 0000363985<br />
							wysokość kapitału zakładowego: 30.241.152 zł (w całości opłacony)
							
						</div>
						
					</body>
					</html>
					
				</cfoutput>
					
			</cfdocument>
			
			
			<!---
				Czary mary... :)
			--->
			<cfpdf action="read" name="document" source="#pdfInstruction.filesrc#" />
			<cfpdf action="merge"name="mergedInstruction" >
				<cfpdfparam source="firstPage" />
				<cfpdfparam source="document" />
			</cfpdf>
				
			<cfset usesLayout(false) />
		
		<cfelse>
			
		</cfif>
		
	</cffunction>
	
	<cffunction name="ocr" output="false" access="public" hint="">
		<cfset var documents = model("instruction_document").getAllInstructionDocuments() />
		<cfset var mdf = 0 /> <!--- Liczba zaktualizowanych instrukcji --->
			
		<cfloop query="documents">
			
			<cfset var myPdfText = "" />
			
			<cfpdf
				action="extracttext" 
				source= "#filesrc#" 
				pages = "*"
				honourspaces = "true"
				type="string" 
				name = "myPdfText" />
				
			<cfset updt = model("instruction_document").updateOcr(id, myPdfText) />
			<cfset mdf = mdf + 1 />
			
		</cfloop>
		
		<cfdump var="#mdf#" />
		<cfabort />
		
	</cffunction>

</cfcomponent>