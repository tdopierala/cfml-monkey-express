<cfcomponent displayname="Proposals" extends="Controller">

	<cffunction name="init">
		<cfset super.init() />
		<cfset provides("html,pdf,json") />
		
		<!---<cfset filters(type="before",through="before",except="citySearch,saveProposalCheckForm,proposalToPdf") />--->
		<cfset filters(type="before",through="before") />
	</cffunction>

	<cffunction name="before" output="false" access="private" hint="" >
		<cfset usesLayout(template="/layout") />
	</cffunction> 

	<cffunction
		name="index" 
		hint="Strona z wnioskami pracownika." 
		description="Strona zawiera wszystkie zdefiniowane przez pracownika wnioski w systemie.">
			
		<cfif session.user.id eq 345>
			<cfset userid = 345 />
		<cfelse>
			<cfset userid = session.user.id />
		</cfif>

		<cfset uProposals = model("proposal").getUserProposals(userid=userid,page=1,num=15) />
		
		<cfset proposal_days = model("TriggerHolidayProposal").getProposalDays(userid=userid)/>
		<cfset renderWith(data="uProposals",layout=false) />

	</cffunction>

	<cffunction
		name="add"
		hint="Wybór wniosku do wypełnienia"
		description="Plansza z wyborem wniosku do wypełnienia">
			
		<cfset session.proposaladd = true />

		<cfset proposaltypes = model("proposalType").findAll() /> 

	</cffunction>

	<cffunction
		name="actionAdd"
		hint="Stworzenie nowego wniosku."
		description="Akcja tworząca nowy wniosek i zapiująca domyślne pola wniosku w bazie.">
		
		<cftry>
			
			<cfset Request.settings = parseSettings(settings=model("setting").findAll()) />
			
			<!--- Tomek 16.09.2013 --->
			<!--- Wyszukuje czy istnieje już wniosek użytkownika o danym typie na etapie tworzenia --->
			<cfset proposalcheck = model('triggerHolidayProposal').findOne(
				where="userid=#session.userid# AND proposaltypeid=#params.proposaltypeid# AND proposalstep1status=1",
				order="id DESC"
			) />
			
			<!---<cfif not IsObject(proposalcheck)>--->
							
				<!--- Tworzę definicję wniosku --->
				<cfset proposal = model("proposal").new() />
				<cfset proposal.userid = session.userid />
				
				<cfset maxnum = model("proposal").maximum(property="proposalnum", where="proposaltypeid=#params.proposaltypeid#") />
				<cfset proposal.proposalnum = maxnum + 1 />
				
				<!---<cfset proposal.proposalnum = proposal.maximum("proposalnum") + 1 />--->
					
					
				<cfset proposal.proposalcreated = Now() />
				<cfset proposal.proposaltypeid = params.proposaltypeid />
				<cfset proposal.proposalstatusid = 1 /> <!--- Ustawiam status wniosku na "szkic" --->
				<cfset proposal.save(callbacks=false) /><!--- Zapisuje wniosek --->
	
				<!--- 2. Tworzę pierwszy krok obiegu wniosku --->
				<cfset proposalstep = model("proposalStep").new() />
				<cfset proposalstep.proposalid = proposal.id /> <!--- id wniosku --->
				<cfset proposalstep.proposaltypeid = proposal.proposaltypeid /> <!--- Typ wniosku --->
				<cfset proposalstep.proposalstatusid = 1 /> <!--- Status szkicu wniosku --->
				<cfset proposalstep.proposalstepcreated = Now() />
				<cfset proposalstep.proposalstepstatusid = 1 /> <!--- Pierwszy krok obiegu wniosku - wypełnianie wniosku --->
				<cfset proposalstep.userid = session.userid /> <!--- Identyfikator użytkownika, do którego należy ten krok obiegu wniosku --->
				<cfset proposalstep.save(callbacks=false) /> <!--- Zapisuje krok obiegu dokumentu --->
	
				<!--- 3. Wypełniam domyślne pola wniosku --->
				<!--- Po zapisaniu wniosku generuję puste pola i zapisuje je w bazie --->
				<cfset proposalattributes = model("proposalAttribute").findAll(where="proposaltypeid=#proposal.proposaltypeid#") />
				<!--- Przechodzę przez wszystkie atrybuty wniosku i tworzę szkic (2) --->
				<cfloop query="proposalattributes">
	
					<cfset proposalattributevalue = model("proposalAttributeValue").new() />
					<cfset proposalattributevalue.proposalid = proposal.id />
					<cfset proposalattributevalue.proposaltypeid = proposal.proposaltypeid />
					<cfset proposalattributevalue.attributeid = attributeid />
	
					<cfswitch expression="#attributeid#">
	
						<cfcase value="132">
	
							<cfset proposalattributevalue.proposalattributevaluetext = "#session.user.givenname# #session.user.sn#" />
	
						</cfcase>
	
						<cfcase value="130">
							<cfset tmpdepartment = model("viewUserAttributeValue").findOne(where="userid=#session.userid# AND attributeid=125") />
							<cfset proposalattributevalue.proposalattributevaluetext = tmpdepartment.userattributevaluetext />
	
						</cfcase>
	
						<cfcase value="131">
							<cfset tmptitle = model("viewUserAttributeValue").findOne(where="userid=#session.userid# AND attributeid=123") />
							<cfset proposalattributevalue.proposalattributevaluetext = tmptitle.userattributevaluetext />
	
						</cfcase>
	
						<cfcase value="133">
	
							<cfset proposalattributevalue.proposalattributevaluetext = Request.settings.proposalcity[1] & " #DateFormat(Now(), 'dd.mm.yyyy')#r." />
	
						</cfcase>
						
						<cfcase value="223">
	
							<cfset proposalattributevalue.proposalattributevaluetext = "#session.user.givenname# #session.user.sn#" />
	
						</cfcase>
	
						<cfdefaultcase>
	
						</cfdefaultcase>
	
					</cfswitch>
	
					<cfset proposalattributevalue.save(callbacks=false) />
	
				</cfloop>
				<!--- Koniec generowania domyślnych parametrów wniosku --->
				
				<cfset proposalid = proposal.id />
			
			<!---<cfelse>
				
				<cfset proposalid = proposalcheck.proposalid />
				
			</cfif>--->
			
			<!--- 4. Przekierowanie uzytkownika do strony pozwalającej na edycję wniosku --->
			<cfset redirectTo(controller="Proposals",action="edit",key=proposalid) />

			<cfcatch type="any">
				
				<cfif Find("PROPOSALTYPEID", cfcatch.message)>

					<cfset flashInsert(error="Musisz wybrać rodzaj wniosku do wypełnienia.")>

				</cfif>
				
				<!---<cfdump var="#maxnum#">--->
				<!---<cfdump var="#cfcatch#">--->
				<!---<cfabort /> --->

				<cfset redirectTo(controller="Proposals",action="add") />

			</cfcatch>

		</cftry>

	</cffunction>

	<cffunction
		name="edit"
		hint="Edycja wniosku"
		description="Po stworzeniu nowego wniosku i wypełnieniu domyślnych jego pól, uzytkownik jest przenoszony do strony edycji wniosku. Można edytować tylko niektóre pola formularza. Po zakończeniu edycji wniosek jest przekazywany do przełożonego.">

		<!--- Pola wniosku --->

			<!--- 16.04.2013
			Wywołanie osobnego zapytania w modelu w celu dowiązania tabeli proposalattributes przy pomocą dwóch kluczy obcych --->
		<cfset proposalfields = model("proposalAttributeValue").getProposalFields(params.key) />

		<!---<cfset proposalfields = model("proposalAttributeValue").findAll(where="proposalid=#params.key#",include="attribute,proposalAttribute",order="ord ASC") />--->
		<cfset proposalinformations = model("proposal").findOne(where="id=#params.key#",include="proposalType") />

 		<!--- <cfdump var="#proposalfields#" />
 		<cfabort /> --->

		<!--- Sprawdzam, czy istnieje obiekt wniosku i pobieram numer jego typu --->
		<cfif IsObject(proposalinformations)>

			<cfswitch expression="#proposalinformations.proposaltypeid#"> <!--- Wybieram typ wniosku --->

				<cfcase value="1">	<!--- Wniosek urlopowy --->

					<cfset options135 = model("selectValue").findAll(select="selectvalue,selectlabel",where="attributeid=135",order="ord ASC") />

				</cfcase>

				<cfcase value="2"> <!--- Wniosek delegacyjny --->

					<cfset options138 = model("selectValue").findAll(select="selectvalue,selectlabel",where="attributeid=138",order="ord ASC") />

				</cfcase>

				<cfcase value="3"> <!--- Wniosek o uczestnictwo --->

					<cfset options202 = model("selectValue").findAll(select="selectvalue,selectlabel",where="attributeid=202",order="ord ASC") />
					<cfset options208 = model("selectValue").findAll(select="selectvalue,selectlabel",where="attributeid=208",order="ord ASC") />

				</cfcase>
				
				<cfcase value="4">	<!--- Wniosek KoS'a --->

					<cfset options213 = model("selectValue").findAll(select="selectvalue,selectlabel",where="attributeid=213",order="ord ASC") />
					<cfset options264 = model("selectValue").findAll(select="selectvalue,selectlabel",where="attributeid=264",order="ord ASC") />

				</cfcase>

			</cfswitch>

		</cfif>


		<cfif IsAjax()>

			<cfset renderWith(data="proposalfields,proposalinformations,options",layout=false) />

		</cfif>

	</cffunction>

	<cffunction
		name="confirmProposal"
		hint="Potwierdzenie danych wypełnionych we wniosku"
		description="Potwierdzenie danych wypełnionych we wniosku">
			
		<!---<cftry>--->

			<cfset proposalfields = model("proposalAttributeValue").getProposalFields(params.proposalid) />
			
			<cfif (StructKeyExists(params, 'proposalattributefile'))>
	
				<cfloop collection="#params.proposalattributefile#" item="i">
					<cfset myfile = APPLICATION.cfc.upload.SetDirName(dirName="proposals") />
					<cfset myfile = APPLICATION.cfc.upload.upload(file_field="proposalattributefile[#i#]") />
					<cfset myfile.binarycontent = false />
	
					<cfif StructKeyExists(myfile, 'clientfilename')>
						<cfset params.proposalattributevalue[#i#] = {
							cfilename	= myfile.clientfilename & "." & myfile.clientfileext,
							sfilename	= myfile.newservername,
							fileext	= myfile.clientfileext } />
					<cfelse>
						<cfset params.proposalattributevalue[#i#] = StructNew() />
					</cfif>
	
						<!---<cfscript>
							StructInsert( params.proposalattributevalue[#i#], "cfilename", myfile.clientfilename & "." & myfile.clientfileext );
							StructInsert( params.proposalattributevalue[#i#], "sfilename", myfile.newservername );
							StructInsert( params.proposalattributevalue[#i#], "fileext",   myfile.clientfileext );
						</cfscript>--->
				</cfloop>
			</cfif>
		
		 <!---<cfif session.user.id eq 345>
			<cfdump var="#params#" />
			<cfdump var="#proposalfields#" />
	 		
		</cfif> --->

			<!---<cfcatch type="any">
				<cfdump var="#cfcatch#" />
				<cfdump var="#params#" />
			</cfcatch>
		</cftry>--->

	</cffunction>

	<cffunction
		name="actionEdit"
		hint="Zapisanie wprowadzonych przez użytkownika danych i przekazanie wniosku do akceptacji"
		description="Metoda zapisująca podane przez uzytkownika dane we wniosku. Po zapisaniu danych wniosek jest przekazywany do akceptacji przez przełożonego.">

 		<!---<cfdump var="#params#" />
 		<cfabort />--->

		<cftry>

			<!--- Przechodzę przez atrybuty przesłane w formularzu i aktualizuje je w bazie --->
			<cfloop collection="#params.proposalattributevalue#" item="i">

				<cfset proposalattributevalue = model("proposalAttributeValue").findByKey(i) />
				<cfset proposalattributevalue.proposalattributevaluetext = params.proposalattributevalue[i] />
				<cfset proposalattributevalue.save(callbacks=false) />

			</cfloop>

			<!---
			Po zaktualizowaniu atrybutów wniosku, buduję listę dat, kiedy pracownik ma urlop.
			Aktualizacja dat jest tylko dla wniosków urlopowych.

			9.07.2012
			Zapisywanie dat urlopu odbywa się w dwóch pętlach. Zewnętrzna przechodzi przez wszystkie rekordy dat od-do.
			Wewnętrzna pętla przechodzi przez dni, w których ma być urlop.
			--->
			<cfif StructKeyExists(params, "proposalholidaydate") and params.proposaltypeid neq 3>

				<cfset loc.proposaldate = '' />
				<cfset loc.proposaldayscount = 0 />
				<cfset loc.start = "" />
				<cfset loc.stop = "" />

				<!--- Zewnętrzna pętla przechodząca przez zakresy dat --->
				<cfloop collection="#params.proposalholidaydate[params.proposalholidayfrom]#" item="i">

					<!--- Sprawdzenie, czy pole nie jest puste --->
					<cfif Len(params.proposalholidaydate[params.proposalholidayfrom][i]) AND Len(params.proposalholidaydate[params.proposalholidayto][i])>

						<!--- Pętla wewnętrzna przechodząca przez daty od-do --->
						<cfset loc.start = DateFormat(params.proposalholidaydate[params.proposalholidayfrom][i], 'dd-mm-yyyy') />
						<cfset loc.stop = DateFormat(params.proposalholidaydate[params.proposalholidayto][i], 'dd-mm-yyyy') />
						<cfloop from="#loc.start#" to="#loc.stop#" index="j" step="#CreateTimeSpan(1,0,0,0)#">

							<!--- Sprawdzam, czy dzień nie jest sobotą lub niedzielą --->
							<cfset loc.datetmp = CreateDate(Year(j), Month(j), Day(j)) />

							<cfif (DayOfWeek(loc.datetmp) neq 1) and (DayOfWeek(loc.datetmp) neq 7)>
								<cfset loc.proposaldate &= DateFormat(loc.datetmp, 'dd-mm-yyyy') &"," />
								<cfset loc.proposaldayscount++ />

							</cfif>

						</cfloop> <!--- Koniec pętli wewnętrznej --->

					</cfif> <!--- Koniec sprawdzania, czy daty nie są puste --->

				</cfloop> <!--- Koniec pętli wewnętrznej --->

				<!--- Trimuje ciąg dat --->
				<cfset loc.proposaldate = Trim(loc.proposaldate) />

				<!--- Kasuje ostatni przecinek z daty --->
				<cfset loc.proposaldate = Left(loc.proposaldate, Len(loc.proposaldate)-1) />

				<!--- Mając zbudowaną całą listę z datami urlopu zapisuje ją w bazie i przesyłam wniosek do akceptacji --->
				<cfset proposaldate = model("proposalAttributeValue").findByKey(params.holidaydates) />
				<cfset proposaldate.proposalattributevaluetext = loc.proposaldate />
				<cfset proposaldate.save(callbacks=false) />

				<!---
				9.07.2012
				Po zapisaniu ciągu dat muszę jeszcze zapisać daty od i do w bazie.
				--->
				<cfset proposaldatefrom = model("proposalAttributeValue").findByKey(params.proposalholidayfrom) />
				<cfset proposaldatefrom.proposalattributevaluetext = DateFormat(loc.start, 'dd-mm-yyyy') />
				<cfset proposaldatefrom.save(callbacks=false) />

				<cfset proposaldateto = model("proposalAttributeValue").findByKey(params.proposalholidayto) />
				<cfset proposaldateto.proposalattributevaluetext = DateFormat(loc.stop, 'dd-mm-yyyy') />
				<cfset proposaldateto.save(callbacks=false) />


			</cfif> <!--- Koniec jeśli przesłałem zakres dat urlopu --->

			<!---
			Jeżeli nie ma wniosku urlopowego to przechodzę przez wszystkie daty z zakresu od-do,
			wycinam soboty i niedziele i zapisuje w bazie.
			--->
			<cfif StructKeyExists(params, "attribute") and StructKeyExists(params.attribute, "127") and StructKeyExists(params.attribute, "128")>

				<cfset loc.proposaldate = "" />
				<cfset loc.start = DateFormat(params.proposalattributevalue[params.attribute[127]], 'dd-mm-yyyy') />
				<cfset loc.stop = DateFormat(params.proposalattributevalue[params.attribute[128]], 'dd-mm-yyyy') />

				<cfloop from="#loc.start#" to="#loc.stop#" index="i" step="#CreateTimeSpan(1,0,0,0)#">

					<cfset loc.proposaldate &= DateFormat(i, 'dd-mm-yyyy') &"," />

				</cfloop>

				<cfset loc.proposaldate = Left(loc.proposaldate, Len(loc.proposaldate)-1) />

				<!--- Mając zbudowane daty, w których nie ma pracownika, zapisuje je w bazie --->
				<cfset triggerproposal = model("triggerHolidayProposal").findOne(where="proposalid=#params.proposalid#") />
				<cfset triggerproposal.update(proposaldate=loc.proposaldate) />

			</cfif>

			<!--- Pobieram identyfikator użytkownika, który ma mnie zastępować --->
			<cfif StructKeyExists(params, "substitutionsearchtext")>

				<cfset tmpuser = model("user").findOne(where="distinguishedName like '%#params.substitutionsearchtext#%'") />

				<!--- Jeżeli został wybrany pracownik na zastępstwo --->
				<cfif Len(params.substitutionsearchtext) and IsObject(tmpuser)>

					<!--- Zapisanie zastępstwa w bazie danych --->
					<cfset substitution = model("substitution").new() />
					<cfset substitution.userid = session.userid />
					<cfset substitution.proposalid = params.proposalid />
					<cfset substitution.substituteid = tmpuser.id />
					<cfset substitution.substitutename = params.substitutionsearchtext />
					<cfset substition.substitutetime = loc.proposaldate />
					<cfset substitution.substitutephoto = tmpuser.photo />
					<cfset substitution.save(callbacks=false) />

				<cfelse>

					<!--- <cfthrow message="Musisz wybrać pracownika, który Ciebie będzie zastępował." /> --->

				</cfif>

			</cfif>

			<!--- Przekazanie wniosku do akceptacji przełożonego --->
			<cfset redirectTo(controller="Proposals",action="moveToAcceptation",key=params.proposalid) />

		<cfcatch type="any">

			<cfset flashInsert(error=cfcatch.message)>
			<cfset redirectTo(controller="Proposals",action="confirmProposal",key=params.proposalid) />

		</cfcatch>

		</cftry>

	</cffunction>

	<cffunction
		name="getProposalHolidayDate"
		hint="Pobranie nowej daty do wniosku urlopowego"
		description="Pobranie nowej daty do wniosku urlopowego">

		<cfset rand = randomText(length=4) />
		<cfset datefrom = params.datefrom />
		<cfset dateto = params.dateto />
		<cfset renderWith(data="rand,datefrom,dateto",layout=false) />

	</cffunction>

	<!---
	Metoda wypełniająca wniosek. Wypełnianie wniosku odbywa się w liku etapach:
	1. Sprawdzane jest czy użytkownik wybrał rodzaj wniosku
	2. Tworzony jest szkic wniosku. Ustawiany jest status "szkic" i zapisywane są domyślne wartości.
	3. Wygenerowany jest formularz wniowku z już uzupełnionymi polami
	4. Użytkownik uzupełnia brakujące pola i zapisuje formularz.
	5. Przekazanie formularza do akceptacji przez przełożonego.
	--->
	<cffunction
		name="perform"
		hint="Wypełnienie formularza"
		description="Metoda Tworzy nowy formularz w bazie i zwraca użytkownikowi widok formularza do wypełnienia.">

		<cfif StructKeyExists(params, "proposaltypeid") AND StructKeyExists(session, "proposaladd")> <!--- Jeśli wybrałem typ wniosku to tworzę szkic --->

			<!--- 1. Tworzę definicję wniosku --->
			<cfset proposal = model("proposal").new() />
			<cfset proposal.userid = session.userid />
			<cfset proposal.proposalcreated = Now() />
			<cfset proposal.proposaltypeid = params.proposaltypeid />
			<cfset proposal.proposalstatusid = 1 /> <!--- Ustawiam status wniosku na "szkic" --->
			<cfset proposal.save(callbacks=false) /><!--- Zapisuje wniosek --->

			<!--- Po zapisaniu wniosku generuję puste pola i zapisuje je w bazie --->
			<cfset proposalattributes = model("proposalAttribute").findAll(where="proposaltypeid=#params.proposaltypeid# AND proposalattributevisible=1") />
			<!--- Przechodzę przez wszystkie atrybuty wniosku i tworzę szkic (2) --->
			<cfloop query="proposalattributes">

				<cfset proposalattributevalue = model("proposalAttributeValue").new() />
				<cfset proposalattributevalue.proposalid = proposal.id />
				<cfset proposalattributevalue.proposaltypeid = params.proposaltypeid />
				<cfset proposalattributevalue.attributeid = attributeid />

				<cfswitch expression="#attributeid#">

					<cfcase value="132">

						<cfset proposalattributevalue.proposalattributevaluetext = "#session.user.givenname# #session.user.sn#" />

					</cfcase>

					<cfcase value="130">
						<cfset tmpdepartment = model("viewUserAttributeValue").findOne(where="userid=#session.userid# AND attributeid=125") />
						<cfset proposalattributevalue.proposalattributevaluetext = tmpdepartment.userattributevaluetext />

					</cfcase>

					<cfcase value="131">
						<cfset tmptitle = model("viewUserAttributeValue").findOne(where="userid=#session.userid# AND attributeid=123") />
						<cfset proposalattributevalue.proposalattributevaluetext = tmptitle.userattributevaluetext />

					</cfcase>

					<cfcase value="133">

						<cfset proposalattributevalue.proposalattributevaluetext = Request.settings.proposalcity[1] & " #DateFormat(Now(), 'dd.mm.yyyy')#r." />

					</cfcase>

					<cfdefaultcase>

					</cfdefaultcase>

				</cfswitch>

				<cfset proposalattributevalue.save(callbacks=false) />

			</cfloop>

			<!--- Po zapisaniu wszystkich atrybutów wniosku i stworzeniu szkicu generuje widok wniosku (3) --->
			<cfset proposalfields = model("proposalAttributeValue").findAll(where="proposalid=#proposal.id#",include="attribute",order="ord ASC") />
			<cfset proposalinformations = model("proposal").findOne(include="proposalType") />

			<!--- Usuwam dane ze zmiennej params aby przy przeładowaniu strony nie dublować wniosków --->
			<cfset StructDelete(params, "proposaltypeid") />
			<!--- Usuwam z sesji informację o nowym protokole --->
			<cfset StructDelete(session, "proposaladd") />

		<cfelse>

			<cfset redirectTo(controller="Proposals",action="add") />

		</cfif>


	</cffunction>

	<!---
	Zapisanie danych wprowadzonych przez użytkownika.
	Po zapisaniu generowany jest podgląd wniosku.
	--->
	<cffunction
		name="proposalPreview"
		hint="Zapisanie danych wprowadzonych przez uzytkownika."
		description="Metoda zapisuje dane do wniosku, które wprowadził użytkownik. Po zapisaniu wszystkich wartości generowany jest podgląd wniosku z możliwością przesłania do akceptacji">

		<cfset loc.proposalid = 0 />
		<cfset loc.proposaltypeid = 0 />

		<cftry>

			<cfloop collection="#params.proposalattributevalue#" item="i"> <!--- Aktualizacja pól formularza wniosku --->

				<cfset proposalattributevalue = model("proposalAttributeValue").findByKey(i) />
				<cfset proposalattributevalue.proposalattributevaluetext = params.proposalattributevalue[i] />
				<cfset proposalattributevalue.save(callbacks=false) />

				<cfset loc.proposalid = proposalattributevalue.proposalid /> <!--- Pobieram id wniosku --->
				<cfset loc.proposaltypeid = proposalattributevalue.proposaltypeid />

			</cfloop>

			<cfset proposal = model("proposal").findByKey(loc.proposalid) />
			<cfset proposalattributes = model("proposalAttributeValue").findAll(where="proposalid=#loc.proposalid#",order="ord ASC",include="attribute") />
			<cfset proposaltype = model("proposalType").findAll(where="id=#loc.proposaltypeid#") />

			<!--- Zapisane zostały podstawowe dane o wniosku. Teraz generuje pierwszy krok obiegu wniosku - szkic --->
			<cfset proposalstep = model("proposalStep").new() />
			<cfset proposalstep.proposalid = loc.proposalid /> <!--- Id wniosku --->
			<cfset proposalstep.proposaltypeid = loc.proposaltypeid /> <!--- Id typu wniosku --->
			<cfset proposalstep.proposalstatusid = 1 /> <!--- Ustawiam status wniosku jako Szkic --->
			<cfset proposalstep.proposalstepcreated = Now() />
			<cfset proposalstep.userid = session.userid />
			<cfset proposalstep.proposalstepstatusid = 1 />
			<cfset proposalstep.save(callbacks=false) />


		<cfcatch type="any">

			<cfset error = cfcatch.message />
			<cfset renderWith(data=error,template="/apperror")/>

		</cfcatch>

		</cftry>

	</cffunction>

	<!---
	17.05.2012
	W tabeli z użytkownikami znajduje się dodatkowa kolumna z przełożnym użytkownika. Przesyłając wniosek urlopowy do akceptacji
	nie muszę wybierać osoby z listy tylko automatycznie dokument idzie do przełożonego.

	Aby wuciągnąć id przełożonego w intranecie trzeba najpierw przeparsować ciąg znaków z manager a następnie
	wyszukać w bazie użytkownika o takim imieniu i nazwisku.

	Parametr key zawiera id wniosku.
	--->
	<cffunction
		name="moveToAcceptation"
		hint="Formularz z wyborem użytkownika, do którego ma zostać przesłany wniosek."
		description="Metoda generująca formularz a wyborem użytkownika, do którego ma zostać przekazany wniosek. Metoda pobiera imię i nazwisko menedżera i jego ustawia jako domyślną osobę">

		<cftry>

			<cfset loc.manager = session.user.manager /> <!--- Zapisuje pole manager w zmiennej pomocniczej --->
			<cfset loc.managerarray = ListToArray(loc.manager, ",") /> <!--- Parsuje po przecinku , parametry pola manager --->
			<cfset loc.managernamesurname = "" /> <!--- Pole z imieniem i nazwiskiem przełożonego --->

			<cfloop array="#loc.managerarray#" index="i"> <!--- Przechodzę przez wszystkie przeparsowane wartości --->

				<cfif FindNoCase("CN=", i)>

					<cfset loc.managernamesurname = Right(i, Len(i)-3) /> <!--- Wyciągam imię i nazwisko człowieka --->
					<cfbreak />

				</cfif>

			</cfloop>

			<!--- Mam już imię i nazwisko człowieka --->
			<!--- Szukam użytkownika --->
			<cfset user = model("user").findAll(where="distinguishedName LIKE '%#loc.managernamesurname#%'") /> <!--- użytkownik, który zostanie przekazany do widoku --->

			<!--- Aktualizuje krok szkicu dokumentu i dodaje nowy krok - oczekiwanie na akceptację --->
			<cfset proposalstep = model("proposalStep").findOne(where="proposalid=#params.key# AND proposalstatusid=1 AND proposalstepstatusid=1") />

			<cfif IsObject(proposalstep)>

				<!--- <cfset proposalstep.proposalstepstatusid = 2 /> --->
				<cfset proposalstep.proposalstatusid = 2 /> <!--- Zamknięcie etapu tworzenia wniosku --->
				<cfset proposalstep.proposalstepended = Now() /> <!--- Data zamknięcia tworzenia wniosku --->
				<cfset proposalstep.save(callbacks=false) />

				<!--- Nowy krok obiegu wniosku - przekazanie go do akceptacji przez przełożonego --->
				<cfset newproposalstep = model("proposalStep").new() />
				<cfset newproposalstep.proposalid = proposalstep.proposalid /> <!--- Id wniosku --->
				<cfset newproposalstep.proposaltypeid = proposalstep.proposaltypeid /> <!--- Id typu wniosku --->
				<cfset newproposalstep.proposalstatusid = 1 /> <!--- Ustawiam status wniosku na w trakcie --->
				<cfset newproposalstep.proposalstepcreated = Now() />
				
				<!--- Jeśli nie jest to wniosek KOS --->
				<cfif proposalstep.proposaltypeid neq 4 >
					<cfset newproposalstep.userid = user.id />
				</cfif>
				
				
				<cfset newproposalstep.proposalstepstatusid = 2 /> <!--- Drugi krok obiegu wniosku - akceptacja --->
				<cfset newproposalstep.save(callbacks=false) />

			<cfelse>

				<cfset redirectTo(class="Users",action="view",key=session.userid) />
<!--- 				<cfthrow type="exists" message="Nie ma szkicu wniosku lub został on już przesłany do akceptacji" /> --->

			</cfif>

		<cfcatch type="any">

			<cfset error = cfcatch.message />
			<cfset renderWith(data=error,template="/apperror")/>

		</cfcatch>

		</cftry>

	</cffunction>

	<cffunction
		name="proposalToAccept"
		hint="Pobranie listy wniosków do akceptacji"
		description="Metoda pobiera listę wniosków do akceptacji przez uzytkownika. Wnioski akceptuje dyrektor lub prezes. Dyrektorzy akceptują wnioski pracowników. Prezes akceptuje wnioski dyrektorów. Po akceptacji wgląd we wnioski ma Adrianna Stasiak">

		<!--- Pobieram wnioski przypisane o mnie do akceptacji --->
		<cfset proposals = model("triggerHolidayProposal").findAll(where="managerid=#session.userid# AND proposalstep2status=1 AND proposaldelete=0",include="proposalType,proposalStatus") />

		<cfif IsAjax()>

			<cfset renderWith(data="proposals",layout=false) />

		</cfif>

		</cffunction>

	<cffunction
		name="discard"
		hint="Metoda odrzucająca wniosek użytkownika"
		description="Metoda dostępna dla kazdego uytkownika. Nie kazdy użytkownik otrzymuje wnioski do akceptacji/odrzucenia. Metoda odrzuca wniosek urlopowy. Zmienia jego status i zamyka jego obieg.">

		<cftry>

			<cfset userid = session.user.id />

			<cfset proposalstep = model("proposalStep").findOne(where="userid=#userid# AND proposalid=#params.key# AND proposalstepstatusid=2") />

			<cfif IsObject(proposalstep)>
				<cfset proposalstep.proposalstatusid = 3 />
				<cfset proposalstep.proposalstepended = Now() />
				<cfset proposalstep.save(callbacks=false) />
			</cfif>

			<cfset redirectTo(controller="Proposals",action="userProposals") />

			<cfcatch type="any" >
				<cfset redirectTo(controller="Proposals",action="userProposals",error="Nie ma takiego wniosku") />
			</cfcatch>

		</cftry>

	</cffunction>
	
	<cffunction
		name="discardNoUser"
		hint="Metoda odrzucająca wniosek użytkownika"
		description="Metoda odrzuca wniosek urlopowy. Zmienia jego status i zamyka jego obieg.">

		<cftry>
			
			<cfset updated = model("proposal").updateByKey(key=params.key,inName=session.user.id) />
			
			<cfset proposalstep = model("proposalStep").findOne(where="proposalid=#params.key# AND proposalstepstatusid=2") />

			<cfif IsObject(proposalstep)>
				<cfset proposalstep.proposalstatusid = 3 />
				<cfset proposalstep.proposalstepended = Now() />
				<cfset proposalstep.save(callbacks=false) />
			</cfif>

			<cfset redirectTo(controller="Proposals",action="userProposals") />

			<cfcatch type="any" >
				<cfset redirectTo(controller="Proposals",action="userProposals",error="Nie ma takiego wniosku") />
			</cfcatch>

		</cftry>

	</cffunction>

	<cffunction
		name="accept"
		hint="Akceptowanie wniosku"
		description="Metoda akceptująca wniosek użytkownika">

		<cftry>
			
			<cfif StructKeyExists(params, "status")>
				<cfset status = params.status />
			<cfelse>
				<cfset status = 2 />
			</cfif>
			
			<cfset userid = session.user.id />
			
			<cfset proposalstep = model("proposalStep").findOne(where="userid=#userid# AND proposalid=#params.key# AND proposalstepstatusid=2") />

			<cfif IsObject(proposalstep)>
				<cfset proposalstep.proposalstatusid = status />
				<cfset proposalstep.proposalstepended = Now() />
				<cfset proposalstep.save(callbacks=false) />

				<cfset updateSubstitution = model("substitution").updateAll(where="proposalid=#params.key#",substituteaccess=1) />
			</cfif>

			<cfset redirectTo(controller="Proposals",action="userProposals") />

			<cfcatch type="any" >
				<cfset redirectTo(controller="Proposals",action="userProposals",error="Nie ma takiego wniosku") />
			</cfcatch>

		</cftry>

	</cffunction>
	
	<cffunction
		name="acceptNoUser"
		hint="Akceptowanie wniosku"
		description="Metoda akceptująca wniosek bez weryfikacji użytkownika">

		<cftry>
			
			<cfif StructKeyExists(params, "status")>
				<cfset status = params.status />
			<cfelse>
				<cfset status = 2 />
			</cfif>
			
			<cfset updated = model("proposal").updateByKey(key=params.key,inName=session.user.id) />
			
			<cfset proposalstep = model("proposalStep").findOne(where="proposalid=#params.key# AND proposalstepstatusid=2") />

			<cfif IsObject(proposalstep)>
				<cfset proposalstep.proposalstatusid = status />
				<cfset proposalstep.proposalstepended = Now() />
				<cfset proposalstep.save(callbacks=false) />

				<cfset updateSubstitution = model("substitution").updateAll(where="proposalid=#params.key#",substituteaccess=1) />
			</cfif>

			<cfset redirectTo(controller="Proposals",action="userProposals") />

			<cfcatch type="any" >
				<cfset redirectTo(controller="Proposals",action="userProposals",error="Nie ma takiego wniosku") />
			</cfcatch>

		</cftry>

	</cffunction>

	<cffunction
		name="proposalToPdf"
		hint="Pobranie pliku PDF wniosku urlopowego"
		description="Metoda generuje plik PDF wniosku urlopowego">

		<cfset proposal = model("proposal").findAll(where="id=#params.key#",include="proposalType") />
		<cfset InName = model("proposal").proposalInName(params.key) />
		
		<cfset proposalsteps = model("proposalStep").findAll(where="proposalid=#params.key#",order="proposalstepcreated ASC",include="user") />
		<cfset proposalattributes = model("proposalAttributeValue").findAll(where="proposalid=#params.key#") />

		<cfswitch expression="#proposal.proposaltypeid#">

			<cfcase value="1">

				<cfset renderPage(template="proposaltopdf") />

			</cfcase>

			<cfcase value="2">

				<cfset renderPage(template="delegationproposal") />

			</cfcase>
			
			<cfcase value="3">

				<cfset renderPage(template="proposaltype3topdf") />

			</cfcase>

			<cfdefaultcase>

				<cfset renderPage(template="proposaltopdf", layout=false) />

			</cfdefaultcase>

		</cfswitch>

	</cffunction>

	<cffunction
		name="view"
		hint="Podgląd wniosku przez użytkownika."
		description="Metoda służąca do podglądu wypełnionego wniosku przez użytkownika.">

		<cfset proposal = model("proposalAttributeValue")
			.findAllProposalAttributesValue(params.key)/>
			<!---.findAll(
				where="proposalid=#params.key#",
				include="attribute,proposalType,proposalAttribute"

			)/>--->

		<cfif IsAjax()>

			<cfset renderWith(data="proposal",layout=false) />

		</cfif>

	</cffunction>

	<!---
		19.05.2013
		Metoda generująca listę wniosków do akceptacji została zaktualizowana
		do nowego wyglądu Intranetu.
	--->
	<cffunction
		name="userProposals"
		hint="Lista wszystkich wniosków użytkowników."
		description="Lista wniosków użytkowników danego menedzera.">

		<cftry>

			<!---
				Domyślny status wniosku do wyświetlenia
			--->
			<cfparam name="proposalstatusid" type="numeric" default="1" />
			<cfparam name="proposalstatustype" type="numeric" default="1" />
			
			<cfset session.proposals.proposalstatusid = proposalstatusid />
			
			<cfif StructKeyExists(params, "proposalstatusid")>
				<cfset proposalstatusid = params.proposalstatusid />
				<cfset session.proposals.proposalstatusid = params.proposalstatusid />
			</cfif>
			
			<cfif session.user.id eq 345>
				<cfset userid = 345 />
			<cfelse>
				<cfset userid = session.user.id />
			</cfif>

			<!---
				Lista wniosków do wyświetlenia.
			--->
			<cfset userproposals = model("proposal").getProposalsToAccept(
				userid = userid,
				proposalstatusid = proposalstatusid) />

			<cfset proposalstatuses = model("proposalStatus").findAll(where="proposalstatustype=1") />

			<cfset renderWith(data="userproposals,proposalstatuses,proposalstatusid",layout=false) />

		<!---
			Jak jest błąd to nie robię nic... :)
		--->
		<cfcatch type="any">

		</cfcatch>

		</cftry>

	</cffunction>

	<!---
	9.07.2012
	Do widoku wszystkich wniosków pracowników dodaje filtr pozwalający na filtrowanie po statusie wniosku.
	Dzięki temu Departament Personalny może wyszukać interesujące ich wnioski.
	--->
	<cffunction
		name="companyUserProposals"
		hint="Wnioski wszystkich pracowników w firmie. Opcja dostępna dla dep. personalnego">

		<cftry>

			<!--- 
				Ustawiam domyślny status wniosku na etapie akceptacji 
			--->
			<cfparam name="proposalstatusid" default="1" />
			<cfparam name="all" default="0" />

			<!--- 
				Ustawiam status wniosku przesłany jako parametr do metody 
			--->
			<cfif StructKeyExists(params, "key")>
				<cfset proposalstatusid = params.key />
			</cfif>
			
			<cfif not StructKeyExists(params, "page")>
				<cfset params.page = 1 />
			</cfif>
			
			<cfif not StructKeyExists(params, "user")>
				<cfset params.user = '' />
			</cfif>
			
			<cfif not StructKeyExists(params, "quantity")>
				<cfset params.quantity = 15 />
			</cfif>
			
			<!---
				Pobieram wszystkie wnioski
			--->
			<cfif structKeyExists(params, "all")>
				<cfset all = params.all />
			</cfif>

			<cfset where = 'proposalstatustype=1' />
			<cfif StructKeyExists(params, "type")>
				<cfset type = params.type />

				<cfif params.type eq 3>
					<cfset where = where & ' OR proposalstatustype=3' />
				</cfif>
			<cfelse>
				<cfset type = 0 />
			</cfif>

			<!--- Pobieram listę wszystkich statusów --->
			<cfset proposalstatuses = model("proposalStatus").findAll(where="#where#",order="proposalstatusord") />

			<!--- Pobieram wnioski o interesującym mnie statusie --->
			<cfif proposalstatusid eq 4>
				<cfset up_count = model("triggerHolidayProposal").count(where="proposalhrvisible=0 AND proposaltypeid=#type# AND proposaldelete = 0 AND usergivenname LIKE '%#params.user#%'") />
				
				<cfset userproposals = model("triggerHolidayProposal").findAll(
					where="proposalhrvisible=0 AND proposaltypeid=#type# AND proposaldelete = 0 AND usergivenname LIKE '%#params.user#%'",
					include="proposalType,proposalStatus,proposal_businesstrip",
					order="proposalid DESC",
					page=params.page,
					perPage=params.quantity) />
			<cfelse>
				<cfset up_count = model("triggerHolidayProposal").count(where="proposalstep2status=#proposalstatusid# AND proposalhrvisible=1 AND proposaltypeid=#type# AND proposaldelete = 0 AND usergivenname LIKE '%#params.user#%'") />
				
				<cfif all eq 1>
					<cfset userproposals = model("triggerHolidayProposal").findAll(
						where="proposalstep2status=#proposalstatusid# AND proposalhrvisible=1 AND proposaltypeid=#type# AND proposaldelete = 0 AND usergivenname LIKE '%#params.user#%'",
						include="proposalType,proposalStatus,proposal_businesstrip",
						order="proposalid DESC",
						page = 0) />
				<cfelse>
					<cfset userproposals = model("triggerHolidayProposal").findAll(
						where="proposalstep2status=#proposalstatusid# AND proposalhrvisible=1 AND proposaltypeid=#type# AND proposaldelete = 0 AND usergivenname LIKE '%#params.user#%'",
						include="proposalType,proposalStatus,proposal_businesstrip",
						order="proposalid DESC",
						page=params.page,
						perPage=params.quantity) />
				</cfif>
				
			</cfif>
			<!--- <cfset userproposals = model("triggerHolidayProposal").findAll(where="proposalstep2status!=1 AND proposalhrvisible=1",include="proposalType,proposalStatus") /> --->

			<cfset pages = Ceiling(up_count / params.quantity) />

			<!--- Jeśli wywołanie jest AJAXowe i przekazałem parametr z ID statusu to generuje samą tabelkę --->
			<cfif IsAjax() AND StructKeyExists(params, "key")>

				<cfset renderPartial("companyuserproposaltable") />

			<cfelseif IsAjax()>

				<cfset renderWith(data="userproposals,proposalstatuses",layout=false) />

			</cfif>
			
			<!--- <cfset renderWith(data="uProposals",layout='layout') /> --->

		<cfcatch type="any">

			<cfset error = cfcatch.message />
			<cfset renderWith(data=error,template="/apperror")/>

		</cfcatch>

		</cftry>

	</cffunction>
	
	<cffunction 
		name="proposalsTimesheet">
		
		<cfif not StructKeyExists(params, "type")>
			<cfset params.type = 4 />
		</cfif>
		
		<cfif not StructKeyExists(params, "from")>
			<cfset params.from = DateAdd("d", -1, Now()) />
		</cfif>
		
		<cfif not StructKeyExists(params, "to")>
			<cfset params.to = DateAdd("d", 0, Now()) />
		</cfif>
		
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="priv" >
			<cfinvokeargument name="groupname" value="Wnioski dla kandydata na PPS" />
		</cfinvoke>
		
		<cfif priv>
						
			<!---<cfset userproposals = model("triggerHolidayProposal").findAll(
				where="proposalstep2status=2 AND proposalhrvisible=1 AND proposaltypeid=#params.type#",
				include="proposalType, proposalAttributeValue",
				order="proposalid DESC") />--->
				
			<cfset userproposals = model("triggerHolidayProposal").getProposalTimesheet(
				typeid		=	params.type,
				datefrom	=	DateFormat(params.from, 'yyyy-mm-dd'),
				dateto		=	DateFormat(params.to, 'yyyy-mm-dd')
			) />
			
			<cfif userproposals.RecordCount gt 0>
			
				<cfset pid='' />
				<cfloop query="userproposals">
					<cfset pid &= proposalid & ',' />
				</cfloop>
				
				<cfset pid = Left(pid, len(pid)-1) />
				
				<cfset proposalsattr = model("proposalAttributeValue").findAll(
					where="proposaltypeid=4 AND attributeid IN (212, 213, 214, 215, 218, 219, 222, 223) AND proposalid IN (#pid#)",
					order="proposalid, attributeid") />
			
			</cfif>
			
			<cfif StructKeyExists(params, 'view') and params.view eq 'pdf'>
				
				<cfset renderPage(template="proposalstimesheetpdf") />
				
			<cfelseif StructKeyExists(params, 'view') and params.view eq 'xls'>
				
				<cfset filename = "timesheet_#DateFormat(Now(), 'dd-mm-yyyy')#.xls" />
				
				<cfset filepath = ExpandPath('files/proposals/') & filename />
				
				<cfset queryresult = QueryNew(
					"Imie_i_nazwisko, Rodzaj, Miejscowosc, Ulica, Email, Nr_telefonu, Data_szkolenia, KOS", 
					"VarChar, VarChar, VarChar, VarChar, VarChar, VarChar, VarChar, VarChar") /> 
				
				<cfloop query="userproposals">
					<cfset QueryAddRow(queryresult, 1) />
					
					<cfloop query="proposalsattr">
						<cfif proposalsattr.proposalid eq userproposals.proposalid>
							<cfswitch expression="#proposalsattr.attributeid#">

								<cfcase value="212">
									<cfset QuerySetCell(queryresult, "Imie_i_nazwisko", CapFirst(LCase(Trim(proposalsattr.proposalattributevaluetext)))) />
								</cfcase>
								
								<cfcase value="213">
									<cfset QuerySetCell(queryresult, "Rodzaj", CapFirst(LCase(Trim(proposalsattr.proposalattributevaluetext)))) />
								</cfcase>
								
								<cfcase value="214">
									<cfset QuerySetCell(queryresult, "Miejscowosc", CapFirst(LCase(Trim(proposalsattr.proposalattributevaluetext)))) />
								</cfcase>
								
								<cfcase value="215">
									<cfset QuerySetCell(queryresult, "Ulica", CapFirst(LCase(Trim(proposalsattr.proposalattributevaluetext)))) />
								</cfcase>
									
								<cfcase value="218">
									<cfset QuerySetCell(queryresult, "Email", LCase(Trim(proposalsattr.proposalattributevaluetext))) />
								</cfcase>
								
								<cfcase value="219">
									<cfset QuerySetCell(queryresult, "Nr_telefonu", CapFirst(LCase(ReplaceList(proposalsattr.proposalattributevaluetext,"-, ",",")))) />
								</cfcase>
													
								<cfcase value="222">
									<cfset QuerySetCell(queryresult, "Data_szkolenia", DateFormat(proposalsattr.proposalattributevaluetext, "yyyy-mm-dd")) />
								</cfcase>
										
								<cfcase value="223">
									<cfset QuerySetCell(queryresult, "KOS", CapFirst(LCase(Trim(proposalsattr.proposalattributevaluetext)))) />
								</cfcase>
										
							</cfswitch>
						</cfif>
					</cfloop>

				</cfloop>
					
				<cfspreadsheet 
					action = "write"
					filename = "#filepath#"
					query = "queryresult"
    				sheetname = "Lista obecności" 
					overwrite = "true" />
					
				<cflocation url = "files/proposals/#filename#" />
				
				<!---<cfset redirectTo(template="") />--->
				
			<cfelseif IsAjax()>
				
				<cfset renderPartial("proposalstimesheet") />
				
			</cfif>
			
		<cfelse>
			<cfset renderPage(template="/autherror") />
		</cfif>
			
	</cffunction>

	<cffunction
		name="delete"
		hint="Usunięcie wniosku z bazy danych">

		<cfif StructKeyExists(params, "key")>

			<cfset proposal = model("proposal").deleteByKey(params.key) />
			<cfset proposalattributevalue = model("proposalAttributeValue").deleteAll(where="proposalid=#params.key#") />
			<cfset proposalstep = model("proposalStep").deleteAll(where="proposalid=#params.key#") />
			<cfset substitutions = model("substitution").deleteAll(where="proposalid=#params.key#") />
			<cfset triggerholidayproposal = model("triggerHolidayProposal").deleteAll(where="proposalid=#params.key#") />

		</cfif>

		<cfif IsAjax()>

			<cfset renderWith(data="",layout=false) />

		</cfif>

	</cffunction>

	<cffunction
		name="hideProposal"
		hint="Usunięcie wniosku z listy wszystkich wniosków widocznych dla Dep. Personalnego">

		<cfset proposal = model("proposal").updateAll(where="id=#params.key#", proposalvisible=0) />
		<cfset triggerholidayproposal = model("triggerHolidayProposal").updateAll(where="proposalid=#params.key#", proposalhrvisible=0) />

		<cfif IsAjax()>

			<cfset renderWith(data="",layout=false) />

		</cfif>

	</cffunction>

	<cffunction
		name="countProposalDays"
		hint="Metoda wyliczająca ilość dni pracujących w podanym zakresie.">

<!--- 		<cfdump var="#params#" /> --->
<!--- 		<cfabort /> --->

		<cfif StructKeyExists(params, "from") AND StructKeyExists(params, "to")>

			<cfif not Len(params.from)>
				<cfset params.from = Now() />
			</cfif>

			<cfif not Len(params.to)>
				<cfset params.to = Now() />
			</cfif>

			<cfset loc.tmpdatefrom = DateFormat(params.from, "dd-mm-yyyy") />
			<cfset loc.tmpdateto = DateFormat(params.to, "dd-mm-yyyy") />

			<cfset loc.start = CreateDate(Year(loc.tmpdatefrom), Month(loc.tmpdatefrom), Day(loc.tmpdatefrom)) />
			<cfset loc.stop = CreateDate(Year(loc.tmpdateto), Month(loc.tmpdateto), Day(loc.tmpdateto)) />
			<cfset loc.count = 0 />

			<cfloop from="#loc.start#" to="#loc.stop#" index="i" step="#CreateTimeSpan(1,0,0,0)#">

				<!--- Sprawdzam, czy dzień nie jest sobotą lub niedzielą --->
				<cfset loc.datetmp = CreateDate(Year(i), Month(i), Day(i)) />

				<cfif (DayOfWeek(loc.datetmp) neq 1) and (DayOfWeek(loc.datetmp) neq 7) AND not IsHoliday(tocompare=loc.datetmp)>

					<cfset loc.count++ />

				</cfif>

			</cfloop> <!--- Koniec pętli wewnętrznej --->

			<cfset renderWith(loc) />

		</cfif>

	</cffunction>

	<cffunction name="getProposalCheckForm"
		hint="Metoda pobiera niektóre atrybuty dla formularza rozliczeń delegacji">

		<cfset proposal = model("proposal").findAll(where="id=#params.key#",include="proposalType") />
		<cfset proposalattr = model("proposalAttributeValue").findAll(where="proposalid=#params.key#",include="attribute,proposalType") />

		<!--- przypisuje poszczególne atrybuty do zmiennych --->
		<cfloop query="proposalattr">
			<cfswitch expression="#proposalattr.attributeid#">
				<cfcase value="127">
					<!--- data wyjazdu --->
					<cfset beginDate = proposalattr.proposalattributevaluetext />
				</cfcase>
				<cfcase value="128">
					<!--- data powrotu --->
					<cfset endDate = proposalattr.proposalattributevaluetext />
				</cfcase>
				<cfcase value="136">
					<!--- miejsce docelowe --->
					<cfset destination = proposalattr.proposalattributevaluetext />
				</cfcase>
				<cfcase value="138">
					<!--- środek trtansportu --->
					<cfset transport = proposalattr.proposalattributevaluetext />
				</cfcase>
			</cfswitch>
		</cfloop>

		<cfset businesstrip = model("proposal_businesstrip").findOne(where="proposalid=#params.key#") />
		<cfif IsObject(businesstrip)>
			<cfset businesstriproute = model("proposal_businesstriproute").findAll(where="businesstripid=#businesstrip.id#") />
			
			<cfif businesstriproute.RecordCount eq 0>
				<cfset _businesstriproute = model("proposal_businesstriproute") />
				<cfset _businesstriproute.create( businesstripid = businesstrip.id )/>
				<cfset _businesstriproute.save() />
				<cfset businesstriproute = _businesstriproute.findAll(where="businesstripid=#businesstrip.id#") />
			</cfif>

		<cfelse>
			<cfset businesstrip = model("proposal_businesstrip").new() />
			<cfset businesstrip.id = params.key />
			<cfset businesstrip.proposalid = params.key />
			<cfset businesstrip.status = 1 />
			<cfset businesstrip.save() />
			<cfset businesstrip.findOne(where="proposalid=#params.key#") />

			<cfset _businesstriproute = model("proposal_businesstriproute") />
			<cfset _businesstriproute.create(
				businesstripid	= businesstrip.id,
				begincity 		= "Poznań",
				begindate		= DateFormat(beginDate, 'dd-mm-yyyy')
			)/>
			<cfset _businesstriproute.save() />

			<cfset _businesstriproute.create(
				businesstripid	= businesstrip.id,
				enddate			= DateFormat(endDate, 'dd-mm-yyyy')
			)/>
			<cfset _businesstriproute.save() />

			<cfset businesstriproute = model("proposal_businesstriproute").findAll(where="businesstripid=#businesstrip.id#") />
		</cfif>

		<cfscript>
			tab = ArrayNew(1);
			tab[1] = 'zer';
			tab[2] = 'jed';
			tab[3] = 'dwa';
			tab[4] = 'trz';
			tab[5] = 'czt';
			tab[6] = 'pie';
			tab[7] = 'sze';
			tab[8] = 'sie';
			tab[9] = 'osi';
			tab[10] = 'dzi';

			if(StructKeyExists(businesstrip, 'tripcost10')){
				tabl = listToArray(businesstrip.tripcost10, ".");
				_costs = '';
				if(!ArrayIsEmpty(tabl)){
					_v = Mid(tabl[1],1,1);
					if(_v == '-') {
						_costs = 'minus ';
						tabl[1] = Mid(tabl[1],2,Len(tabl[1])+1);
					}
					else
						_costs = '';
					len = Len(tabl[1]) + 1;
					for( i = 1; i < len; i++ ){
						c = Mid(tabl[1],i,1);
						if(i != 1) _costs = _costs & '-';
						_costs = _costs & tab[ c+1 ];
					}
					_costs = _costs & ' zl ';
					len = Len(tabl[2]) + 1;
					for( i = 1; i < len; i++ ){
						c = Mid(tabl[2],i,1);
						if(i != 1) _costs = _costs & '-';
						_costs = _costs & tab[ c+1 ];
					}
					_costs = _costs & ' gr';
				}
			}
			else {
				_costs = '';
			}
		</cfscript>
		
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="personalny" >
			<cfinvokeargument name="groupname" value="Departament Personalny" />
		</cfinvoke>
		
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="root" >
			<cfinvokeargument name="groupname" value="root" />
		</cfinvoke>

		<cfif StructKeyExists(params, "view")>
			<cfswitch expression="#params.view#" >

				<cfcase value="view">
					<cfset renderPage(template="viewproposalcheckform") />
				</cfcase>
				<cfcase value="pdf">
					<cfset renderPage(template="getproposalchecktopdf") />
				</cfcase>
				<cfdefaultcase>
					<!--- <cfif businesstrip.status eq 2 and not checkUserGroup(session.user.id, 'root') and not checkUserGroup(session.user.id, 'Departament Personalny')> --->
					<cfif businesstrip.status eq 2 and not root and not personalny>
						<cfset renderPage(template="/autherror") />
					<cfelse>
						<cfset renderPage(template="getproposalcheckform") />
					</cfif>
				</cfdefaultcase>

			</cfswitch>
		<cfelse>
			<cfset renderPage(template="/autherror") />
		</cfif>

	</cffunction>

	<cffunction name="saveProposalTripRoute"
		hint="Metoda dodaje i usuwa rekordy tras przyjazdu formularza rozliczeń delegacji w bazie">

		<cfset triproute = model("proposal_businesstriproute") />

		<cfswitch expression="#params.method#">

			<cfcase value="create">
				<!--- <cfset triproute.new() />
				<cfset triproute.businesstripid = params.id />
				<cfset triproute.save() /> --->
				<cfset trip_properties = {businesstripid=params.id}>
				<cfset trip = triproute.create(properties=trip_properties) />
				<cfset result = trip.id />
			</cfcase>

			<cfcase value="remove">
				<cfset triproute.deleteByKey(params.id) />
				<cfset result = params.id />
			</cfcase>

		</cfswitch>

		<cfset json = result />
		<cfset renderWith(data="json",template="/json",layout=false) />

	</cffunction>

	<cffunction name="saveProposalCheckForm"
		hint="Metoda zapisuje dane z formularza rozliczeń delegacji w bazie">

		<cfloop collection="#params#" item="key">
			<cfset #key# = params[key] />
		</cfloop>

		<cfset _id 		= listToArray(id, ',', true) />
		<cfset _beginCity	= listToArray(beginCity, ',', true) />
		<cfset _beginDate	= listToArray(beginDate, ',', true) />
		<cfset _beginHour	= listToArray(beginHour, ',', true) />
		<cfset _endCity	= listToArray(endCity, ',') />
		<cfset _endDate	= listToArray(endDate, ',') />
		<cfset _endHour	= listToArray(endHour, ',') />
		<cfset _transport	= listToArray(transport, ',') />
		<cfset _cost		= listToArray(cost, ',') />
		<cfset _artibiute	= listToArray(artibiute, ',') />

		<cfif IsArray(_id) >
			<cfloop index="i" from="1" to="#ArrayLen(_id)#">

				<cfif _beginCity[i] eq 'null'><cfset _beginCity[i] = '' /></cfif>
				<cfif _beginDate[i] eq 'null'>
					<cfset _beginDate[i] = '' />
				<cfelse>
					<cfset bdate = listToArray(_beginDate[i], '-') />
					<cfset _beginDate[i] = bdate[3] & '-' & bdate[2] & '-' & bdate[1] />
				</cfif>
				<cfif _beginHour[i] eq 'null'><cfset _beginHour[i] = '' /></cfif>
				<cfif _endCity[i] eq 'null'><cfset _endCity[i] = '' /></cfif>
				<cfif _endDate[i] eq 'null'>
					<cfset _endDate[i] = '' />
				<cfelse>
					<cfset edate = listToArray(_endDate[i], '-') />
					<cfset _endDate[i] = edate[3] & '-' & edate[2] & '-' & edate[1] />
				</cfif>
				<cfif _endHour[i] eq 'null'><cfset _endHour[i] = '' /></cfif>
				<cfif _transport[i] eq 'null'><cfset _transport[i] = '' /></cfif>
				<cfif _cost[i] eq 'null'><cfset _cost[i] = 0 /></cfif>

				<cfif _id[i] neq 'null'>

					<cfset triproute = model("proposal_businesstriproute").findOne(where="id=#_id[i]#")/>
					<cfset triproute.update(
						begincity	= _beginCity[i],
						begindate	= _beginDate[i],
						begintime	= _beginHour[i],
						endcity	= _endCity[i],
						enddate	= _endDate[i],
						endtime	= _endHour[i],
						transport	= _transport[i],
						cost		= _cost[i]
					) />

				<cfelse>

					<cfset triproute = model("proposal_businesstriproute").create(
						businesstripid	= params.businesstripid,
						begincity 	= _beginCity[i],
						begindate		= _beginDate[i],
						begintime		= _beginHour[i],
						endcity		= _endCity[i],
						enddate		= _endDate[i],
						endtime		= _endHour[i],
						transport		= _transport[i],
						cost			= _cost[i]
					) />

				</cfif>
			</cfloop>
		</cfif>

		<cfset businesstrip = model("proposal_businesstrip").findByKey(params.businesstripid) />
		<cfif IsArray(_artibiute) >
			<cfloop index="i" from="1" to="#ArrayLen(_artibiute)#">
				<cfif _artibiute[i] eq 'null'><cfset _artibiute[i] = 0 /></cfif>
			</cfloop>

			<cfset businesstrip.update(
				tripcost1 = _artibiute[1],
				tripcost2 = _artibiute[2],
				tripcost3 = _artibiute[3],
				tripcost4 = _artibiute[4],
				tripcost5 = _artibiute[5],
				tripcost6 = _artibiute[6],
				tripcost7 = _artibiute[7],
				tripcost8 = _artibiute[8],
				tripcost9 = _artibiute[9],
				tripcost10 = _artibiute[10]
			)/>

		</cfif>

		<cfset result = 1 />
			
		<cfset json = result />
		<cfset renderWith(data="json",template="/json",layout=false) />
	</cffunction>

	<cffunction name="sendProposalCheckForm">

		<cfset businesstrip = model("proposal_businesstrip").findByKey(params.businesstripid) />
		<cfset businesstrip.status = 2 />
		<cfset businesstrip.save() />

		<cfset redirectTo(controller="proposals", action="getProposalCheckForm", key=params.proposalid, params="view=view") />

	</cffunction>

	<cffunction name="citySearch">

		<cfset cities = model("city").findAll(where="cityname LIKE '#params.phrase#%'", maxRows=10) />

		<cfset city = ArrayNew(1) />
		<cfloop query="cities">

			<cfset ArrayPrepend(city, cities.cityname) />

		</cfloop>
		
		<cfset json = city />
		<cfset renderWith(data="json",template="/json",layout=false) />
	</cffunction>
	
	<cffunction
		name="hide"
		hint="Ukrycie wniosku przez dyrektora, aby nie wyświetlał się na liście">
			
		<cfset myProposal = model("proposal").hideProposal(proposalid = params.key) />
			
		<!---
			Domyślny status wniosku do wyświetlenia
		--->
		<cfparam name="proposalstatusid" type="numeric" default="1" />

		<!---
			Lista wniosków do wyświetlenia.
		--->
		<cfset userproposals = model("proposal").getProposalsToAccept(
			userid = userid,
			proposalstatusid = session.proposals.proposalstatusid) />

		<cfset proposalstatuses = model("proposalStatus").findAll(where="proposalstatustype=1") />
			
		<cfset renderPage(controller="Proposals",action="userProposals",layout=false) />
		
		<!---<cfset renderNothing() />--->
			
	</cffunction>
	
	<cffunction name="chairmanProposals" output="false" access="public" hint="Lista z wnioskami dyrektorów do akceptacji przez p Prezesa">
		<!--- Sprawdzam, czy mogę wejść na tę stronę. Jak nie to wypad na główną --->
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="depPersonalny" >
			<cfinvokeargument name="groupname" value="Dyrektor Dep. Personalnego" />
		</cfinvoke>
		
		<cfif depPersonalny is false>
			<cfset redirectTo(controller="users",action="view",key=session.user.id) />
		</cfif>
		
		<!--- Ustawienia dla filtra --->
		<cfparam name="proposalstatusid" type="numeric" default="0" />
		<cfparam name="typeid" type="numeric" default="0" />
		<cfparam name="managerid" type="numeric" default="0" />
		
		<cfif IsDefined("session.proposal.proposalstatusid")>
			<cfset proposalstatusid = session.proposal.proposalstatusid />
		</cfif>
		<cfif IsDefined("session.proposal.typeid")>
			<cfset typeid = session.proposal.typeid />
		</cfif>
		<cfif IsDefined("session.proposal.managerid")>
			<cfset managerid = session.proposal.managerid />
		</cfif>
		
		<cfif IsDefined("FORM.PROPOSALSTATUSID")>
			<cfset proposalstatusid = FORM.PROPOSALSTATUSID />
		</cfif>
		<cfif IsDefined("FORM.TYPEID")>
			<cfset typeid = FORM.TYPEID />
		</cfif>
		<cfif IsDefined("FORM.MANAGERID")>
			<cfset managerid = FORM.MANAGERID />
		</cfif>
		
		<cfset session.proposal = {
			proposalstatusid = proposalstatusid,
			typeid = typeid,
			managerid = managerid
		} />
		
		<!--- Pobieram ID użytkownika, który ma grupę uprawnień Prezes --->
		<cfset prezes = model("tree_groupuser").getGroupByNameUsers("Prezes") />
		
		<!--- Pobieram listę wniosków przypisaną do uzytkownika Prezes --->
		<cfset wnioski = model("proposal").getUsersProposalsToAccept(proposalstatusid=proposalstatusid,typeid=typeid,managerid=managerid) />
		
		<!--- Pobieram możliwe typy wniosków --->
		<cfset typy = model("proposal").getProposalsTypes() />
		
		<!--- Pobieram możliwe statusy wniosków --->
		<cfset statusy = model("proposal").getProposalsStatuses(typeid = typeid) />
		
		<!--- Użytkownicy --->
		<cfset uzytkownicy = model("proposal").getProposalUsers(typeid = typeid, proposalstatusid = proposalstatusid) />
		
		<cfif IsDefined("FORM.FIELDNAMES")>
			<cfset usesLayout(false) />
		</cfif>

	</cffunction>
	
	<cffunction name="printProposals" output="false" access="public" hint="">
		
		<cfset wnioski = model("proposal").pobierzWnioskiPoId(FORM.PROPOSALID) />
		<cfset usesLayout(false) />
	</cffunction>
	
</cfcomponent>