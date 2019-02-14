<cfcomponent extends="Controller">
	
	<cffunction name="index">
		
		<cfset _access = checkAccess() />
		
		<!--- jeśli nie masz uprawnień to wyświetl strone o braku dostpu --->
		<cfif _access gt 4 >
			<cfset renderPage(template="/autherror") />
		</cfif>
		
		<!--- sprawdzanie i ustanawianie parametrów jeśli takowe nie istnieją --->
		<cfif not structKeyExists(params, "user")>
			<cfset params.user = 0 />
		</cfif>
		
		<cfif not structKeyExists(params, "status")>
			<cfset params.status = 0 />
		</cfif>
		
		<cfif not structKeyExists(params, "sortby")>
			<cfset params.sortby = 'id' />
		</cfif>
		
		<cfif not structKeyExists(params, "sortset")>
			<cfset params.sortset = 'desc' />
		</cfif>
		
		<cfif not structKeyExists(params, "page")>
			<cfset params.page = 1 />
		</cfif>
		
		<cfif not structKeyExists(params, "elements")>
			<cfset params.elements = 20 />
		</cfif>
		
		<!--- pobranie listy pomysłów wg wskazanych parametrów --->
		<cfset ideas = model("idea").getIdeasList(
			userid 		= 	params.user,
			statusid 	= 	params.status,
			access 		= 	_access,
			sessionuser 	= 	session.user.id,
			sortby		= 	params.sortby,
			sortset		= 	params.sortset,
			page		=	params.page,
			emelents	=	params.elements
		) />
		
		<!--- pobranie liczby wszystkich pomysłów spełniających warunki --->
		<cfset ideas_count = model("idea").getIdeasCount(
			userid 		= 	params.user,
			statusid 	= 	params.status,
			access 		= 	_access,
			sessionuser = 	session.user.id
		) />
		
		<!--- lista statusów potrzebna do filtrowania --->
		<cfset status = model("idea_status").findAll() />
		
		<!--- lista użytkowników potrzebna do filtrowania --->
		<cfset user = model("user").findAll(select="id, givenname, sn", distinct="true", include="idea") />
		
		<!--- zagregowana ilość głosów dla każdego pomysłu --->
		<!---<cfset vote = model("idea_vote").findAll(select="COUNT(id) AS v, ideaid",group="ideaid") />--->
		
	</cffunction>
	
	<cffunction name="new"
		hint="Metoda wyświetlająca formularz tworzenia nowego pomysłu">
		
		<cfset _access = checkAccess() />
		
		<cfif _access gt 4 >
			<cfset renderPage(template="/autherror") />
		</cfif>
		
		<cfset idea = model("idea").new() />
		
	</cffunction>
	
	<cffunction name="create"
		hint="Metoda tworząca nowy pomysł oraz pierwszą treść dla tego pomysłu">
			
		<!---<cfset myfile = APPLICATION.cfc.upload.SetDirName(dirName="ideas") />
		<cfset myfile = APPLICATION.cfc.upload.upload(file_field="idea[file]") />--->
		
		<cfset params.idea.userid = session.user.id />
		<cfset params.idea.date = Now() />
		
		<cfset idea = model("idea").create(params.idea) />
		<cfset idea.statusid = 1 />
		<cfset idea.save() />
		
		<cfset text = model("idea_text").new() />
		<cfset text.text = params.idea.text />
		<cfset text.reason = params.idea.reason />
		<cfset text.date = Now() />
		<cfset text.ideaid = idea.id />
		<cfset text.userid = session.user.id />
		<cfset text.save(reload=true) />
		
		<cfif StructKeyExists(params.idea, "file")>
			<cfset list = params.idea.file />
			<cfloop list="#list#" index="sfile">
				<cfset mfile = model("idea_file").create(
					file	= "#sfile#",
					ext		= Right(sfile, 3),
					textid 	= text.id,
					ideaid 	= idea.id ) />
			</cfloop>
		</cfif>
		
		<cfif idea.hasErrors() or text.hasErrors()>
			<cfset renderPage(action="new") />
		<cfelse>
			<cfset saveHistory( idea.id, 4 ) />
			<cfset flashInsert(success="Dodano nowy pomysł.") />
			<cfset redirectTo(action="new") />
		</cfif>
		
	</cffunction>
	
	<cffunction name="newText"
		hint="Metoda wyświetlająca formularz tworzenia nowej treści dla pomysłu">
		
		<cfset text = model("idea_text").new() />
		<cfset text.ideaid = params.key />
		
	</cffunction>
	
	<cffunction name="createText"
		hint="Metoda dodająca nową treść do pomysłu do tabeli idea_text">
		
		<!---<cfset myfile = APPLICATION.cfc.upload.SetDirName(dirName="ideas") />
		<cfset myfile = APPLICATION.cfc.upload.upload(file_field="text[file]") />--->
		
		<!---<cfset text = model("idea_text").create(params.text) />--->		
		<cfset text = model("idea_text").new() />
		<cfset text.ideaid = params.text.ideaid />
		<cfset text.text = params.text.text />
		<cfset text.date = Now() />
		<cfset text.userid = session.user.id />
		<cfset text.save(reload=true) />
		
		<cfif StructKeyExists(params.text, "file")>
			
			<cfset list = params.text.file />			
			<cfloop list="#list#" index="sfile">
				<cfset mfile = model("idea_file").create(
					file	= "#sfile#",
					ext		= Right(sfile, 3),
					textid 	= text.id,
					ideaid 	= text.ideaid ) />
			</cfloop>
			
		</cfif>
		
		<!---<cfset file = model("idea_file").create(
			file	= myfile.newservername, 
			ext 	= myfile.clientfileext, 
			textid 	= text.id,
			ideaid 	= text.ideaid ) />--->
			
		<!---<cfset file.file = myfile.clientfilename />
		<cfset file.ext = myfile.clientfileext />
		<cfset file.textid = text.id />--->
		<!---<cfset file.save() />--->
		
		<cfif text.hasErrors()>
			
			<cfset flashInsert(error="Wystąpił błąd podczas dodawania nowej treści") />
			<cfset renderPage(action="newtext") />
			
		<cfelse>
			
			<cfset saveHistory( params.text.ideaid, 3 ) />
			<cfset flashInsert(success="Dodano nową treść do pomysłu.") />
			<cfset redirectTo(action="view", key=params.text.ideaid) />
			
		</cfif>
		
	</cffunction>
	
	<cffunction name="edit"
		hint="Metoda wyświetlająca formularz edycji dodanego tekstu do pomysłu - działa tylko przez 30 min po dodaniu">
		
		<cfset text = model("idea_text").findByKey(key=params.key, include="idea") />
		
		<cfif DateCompare(DateAdd("n",30,text.date), Now()) neq 1 or text.userid neq session.user.id>
			<cfset renderPage(template="/autherror") />
		</cfif>
		
	</cffunction>
	
	<cffunction name="update"
		hint="Metoda edycji treści pomysłu - działa tylko przez 30 min po dodaniu">
		
		<cfset text = model("idea_text").findOne(where="id=#params.text.id#") />
		
		<cfif DateCompare(DateAdd("n",30,text.date), Now()) neq 1 or text.userid neq session.user.id>
			<cfset renderPage(template="/autherror") />
		</cfif>
		
		<cfset text.update(params.text) />
		
		<cfif text.hasErrors()>
			<cfset renderPage(action="edit") />
		<cfelse>
			<cfset flashInsert(success="Zaktualizowano treść pomysłu.") />
			<cfset redirectTo(action="edit", key=params.text.id) />
		</cfif>
		
	</cffunction>
	
	<cffunction name="view"
		hint="Metoda wyświetlająca wszystkie szczegóły pomysłu">
		
		<cfset idea = model("idea").findByKey(key="#params.key#", include="idea_status") />
		<cfset idea.update(views=idea.views+1) />
		
		<!---<cfset user = model("idea").findByKey(idea.userid) />--->
		
		<cfset texts = model("idea_text").findAll(where="ideaid=#idea.id#", order="date", include="user") />
		<cfset files = model("idea_file").findAll(where="ideaid=#idea.id#") />
		<cfset statuses = model("idea_status").findAll() />		
		<cfset history = model("idea_history").findAll(where="ideaid=#idea.id#", order="date", include="user, idea_historiesname, idea_status") />
		<cfset vote = model("idea_vote").findAll(select="count(id) AS votes, vote AS vt", where="ideaid=#idea.id#", order="vote DESC", group="vote") />
		<cfset voted = model("idea_vote").findAll(where="ideaid=#idea.id# AND userid=#session.user.id#", group="userid") />
				
		<cfset comments = model("idea_comment").findAll(where="ideaid=#idea.id# AND ctype=2", order="date", include="user") />
		<cfset subcomments = comments />
		
		<cfset vipcomments = model("idea_comment").findAll(where="ideaid=#idea.id# AND ctype=1", order="date", include="user") />
		<cfset vipsubcomments = vipcomments />
		
		<cfset comment = model("idea_comment").new() />
		<cfset comment.ideaid = idea.id />
		<cfset comment.ctype = 2 />
		
		<cfset vipcomment = model("idea_comment").new() />
		<cfset vipcomment.ideaid = idea.id />
		<cfset vipcomment.ctype = 1 />
		
		<cfset access = checkAccess() />
		
		<cfif access eq 5>
			<cfset renderPage(template="/autherror") />
		</cfif>
		
		<cfif StructKeyExists(params, "view") and params.view eq 'pdf'>
			<cfset renderPage(template="pdf") />
		</cfif>
		
	</cffunction>
	
	<cffunction name="delete"
		hint="Metoda usuwająca pomysł z bazy">
		
		<cfset idea = model("idea").findByKey(params.key) />
		<cfset idea.delete() />
		
		<cfif idea.hasErrors()>
			<cfset flashInsert(error="Próba usuniecia pomysłu zakończyła sie niepowodzeniem") />
		<cfelse>
			<cfset flashInsert(success="Zaktualizowano treść pomysłu.") />
		</cfif>
		
		<cfset redirectTo(action="index") />
		
	</cffunction>
	
	<cffunction name="addComment"
		hint="Metoda dodająca nowy komentarz do pomysłu">
		
		<cfif StructKeyExists(params, "vipcomment")>
			<cfset comment = model("idea_comment").create(params.vipcomment) />
			<cfset activity = 5 />
		<cfelse>
			<cfset comment = model("idea_comment").create(params.comment) />
			<cfset activity = 2 />
		</cfif>
		
		<cfset comment.userid = session.user.id />
		<cfset comment.date = Now() />
		<cfset comment.save(reload=true) />
		
		<cfif comment.hasErrors()>
			<cfset renderPage(action="view") />
		<cfelse>
			
			<cfset saveHistory( comment.ideaid, activity ) />

			<cfif history.hasErrors()>
				<cfset renderPage(action="view") />
			<cfelse>
				<cfset flashInsert(success="Pomyślnie dodano nowy komentarz") />
				<cfset redirectTo(action="view", key=comment.ideaid) />
			</cfif>
			
		</cfif>
		
	</cffunction>
	
	<cffunction name="editStatus"
		hint="Metoda wyświetlająca formularz zmiany statusu i jego opisu">
		
		<cfset idea = model("idea").findByKey(key=params.key, include="idea_status") />
		<cfset idea.statusdesc = "" />
		
		<cfset access = checkAccess() />
		<cfswitch expression="#access#">
			
			<cfcase value="1">
				<cfset statuses = model("idea_status").findAll() />
			</cfcase>
			
			<cfcase value="2">
				<cfset statuses = model("idea_status").findAll(where="id>=3") />
			</cfcase>
			
			<!--- <cfcase value="3">
				<cfset statuses = model("idea_status").findAll(where="id<=2") />
			</cfcase> --->
			
			<cfdefaultcase>
				<cfset renderPage(template="/autherror") />
			</cfdefaultcase>
			
		</cfswitch>
		
	</cffunction>
	
	<cffunction name="changeStatus" 
		hint="Metoda zmieniająca status pomysłu">
		
		<cfset access = checkAccess() />
		<cfif access eq 1 or access eq 2>
			
			<cfset idea = model("idea").findOne(where="id=#params.idea.id#") />			
			<cfset idea.update(statusid=params.idea.statusid, statusdesc="#params.idea.statusdesc#") />
			
			<cfif idea.hasErrors()>
				<cfset flashInsert(error="Operacja zakończyła sie niepowodzeniem") />
			<cfelse>
				
				<cfset saveHistory( params.idea.id, 1, params.idea.statusid, params.idea.statusdesc ) />
				
				<cfset flashInsert(success="Pomyślnie zmieniono status") />
			</cfif>
			
			<cfset redirectTo(action="view", key=params.idea.id) />
			
		<cfelse>
			<cfset renderPage(template="/autherror") />
		</cfif>
		
	</cffunction>
	
	<cffunction 
		name="vote">
		
		<cftry>
			<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="priv" >
				<cfinvokeargument name="groupname" value="Komisja ds. Pomysłów" />
			</cfinvoke>
			
			<cfif priv is true and StructKeyExists(params, "vote")>
				
				<cfset vote = model("idea_vote").findAll(where="ideaid=#params.ideaid# AND userid=#session.user.id#") />
				
				<cfif vote.RecordCount eq 0>
				
					<cfset votes = model("idea_vote").create(
						ideaid 	= params.ideaid, 
						userid 	= session.user.id,
						vote 	= params.vote
					) />
					
					<cfif params.vote eq 1>
						<cfset saveHistory(params.ideaid, 7) />
					<cfelse>
						<cfset saveHistory(params.ideaid, 8) />
					</cfif>

				</cfif>
				
				<cfset _votes = model("idea_vote").findAll(select="count(id) AS votes, vote AS vt", where="ideaid=#ideaid#", group="vote") />
				
				<cfset json = QueryToStruct(Query=_votes) />
				<cfset renderWith(data="json",template="/json",layout=false) />
			<cfelse>
				<cfset renderNothing() />
			</cfif>
			
			<cfcatch type="any">
				
				<cfmail
					to="webmaster@monkey.xyz"
					from="BŁĄD - Monkey<intranet@monkey.xyz>"
					replyto="intranet@monkey.xyz"
					subject="#cfcatch.message#"
					type="html">

					<cfdump var="#cfcatch#" />
					<cfdump var="#session#" />
					<cfif isDefined("Request")>
						<cfdump var="#Request#" />
					</cfif>

				</cfmail>
				
			</cfcatch>
		</cftry>
		
	</cffunction>
	
	<cffunction name="uploadFile">
		
		<cfset usesLayout(false) />
		
		<!--- Zapisuje plik na serwerze --->
		<cfparam name="strField" default="filedata" />
		<cfset myfile = {} />

		<cfif (StructKeyExists(FORM, strField) AND Len(FORM[strField]))>
			
			<cfset myfile = APPLICATION.cfc.upload.SetDirName(dirName="ideas") />
			<cfset myfile = APPLICATION.cfc.upload.upload(file_field="filedata") />
			<cfset myfile.binarycontent = false />
			
		</cfif>
		
	</cffunction>
	
	<cffunction name="saveHistory" access="private" 
		hint="Metoda zapisuje zmiany w module pomysłów do historii">
			
		<!--- 
			Metoda zapisuje zmiany w module pomysłów do tabeli idea_history
			
			@param	numeric ideaid		Identyfikator pomysłu
			@param	numeric activity	Rodzaj aktywności (tabela idea_historiesnames)
			@param	numeric statusid	Opcjonalny identyfikator zmienianego statusu
			@param	string statusdesc	Opcjonalny opis do zmienianego statusu
			
			@access	private
			@return	bool
			@author	Tomasz Dopierała
		--->
		
		<cfargument name="ideaid" type="numeric" required="yes" />
		<cfargument name="activity" type="numeric" required="yes" />
		<cfargument name="statusid" type="numeric" required="no" />
		<cfargument name="statusdesc" type="string" required="no" />
		
		<cfset history 			= model("idea_history").new() />
		<cfset history.date 	= Now() />
		<cfset history.userid 	= session.user.id />
		<cfset history.ideaid 	= ideaid />
		<cfset history.activity = activity />
		
		<cfif structKeyExists(arguments, "statusid")>
			<cfset history.target = statusid />
		</cfif>
		
		<cfif structKeyExists(arguments, "statusdesc")>
			<cfset history.descript = statusdesc />
		</cfif>
		
		<cfset history.save() />
		
		<cfreturn true />
	
	</cffunction>
	
	<cffunction name="checkAccess"
		hint="Metoda sprawdzająca uprawnienia dostpu do pomysłów wg pól w tabelu users">
			
		<!--- 
			Metoda sprawdza uprawnienia dostpu do pomysłów wg pól w tabeli users
			
			@access	public
			@return	numeric
			@author	Tomasz Dopierała
		--->

		
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="priv" >
			<cfinvokeargument name="groupname" value="root" />
		</cfinvoke>
		
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="priv1" >
			<cfinvokeargument name="groupname" value="Dyrektorzy" />
		</cfinvoke>
		
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="priv2" >
			<cfinvokeargument name="groupname" value="Zarząd" />
		</cfinvoke>
		
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="priv3" >
			<cfinvokeargument name="groupname" value="Komisja ds. Pomysłów" />
		</cfinvoke>
		
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="priv4" >
			<cfinvokeargument name="groupname" value="Partnerzy" />
		</cfinvoke>
		
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="priv5" >
			<cfinvokeargument name="groupname" value="Centrala" />
		</cfinvoke>
		
		<cfif priv is true>
			<cfreturn 1 />
		
		<cfelseif priv1 is true or priv2 is true or priv3 is true>
			<cfreturn 2 />
		
		<cfelseif priv4 is true or priv5 is true>
			<cfreturn 3 />
		
		<cfelse>
			<cfreturn 5 />
		</cfif>
	</cffunction>
	
	<cffunction name="contentAccess"
		hint="Metoda sprawdzająca dostep do wyświetlanych komentarzy oraz statusów">
			
		<!--- 
			Metoda ogranicza widoczność komentarzy i statusów wystawionych przez centrale dla PDS i PPS
			
			@param	numeric contentType	Pole zawierające wartość o przynależności do pracowników centrali
			@param	numeric access		Wynik działania metody checkAccess
			
			@access	public
			@return	bool
			@author	Tomasz Dopierała
		--->
		
		<cfargument name="contentType" type="numeric" required="true" />
		<cfargument name="access" type="numeric" required="true" />
		
		<cfif contentType eq 0>
			<cfreturn true />
		<cfelseif contentType eq 1 and access lt 3>
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
		
	</cffunction>
	
	<cffunction name="userStatus"
		hind="Metoda wyświetlająca nazwy grup w komentarzach">
		
		<!--- 
			Metoda wyświetla nazwy grup do których należy użytkownik wg pól w tabeli users
			
			@param	user query	Rekord użytkownika z tabeli users
			
			@access	public
			@return	string
			@author	Tomasz Dopierała
		--->
		
		<cfargument name="user" type="query" required="true" />
		
		<cfif user.centrala eq 1>
			<cfreturn "Centrala" />
		<cfelseif user.partner_ds_sprzedazy eq 1>
			<cfreturn "Partner ds. Sprzedazy" />
		<cfelseif user.partner_prowadzacy_sklep eq 1>
			<cfreturn "Partner prowadzacy sklep" />
		</cfif>
		
	</cffunction>
	
</cfcomponent>
