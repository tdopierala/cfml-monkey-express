<cfcomponent extends="Controller" displayname="Note_notes">
	
	<cffunction name="init" output="false" access="public" hint="">
		<cfset super.init() />

		<cfset filters(through="beforeRender",type="before") />
		<cfset filters(through="setSort",type="before",only="index") />
	</cffunction>
	
	<cffunction name="beforeRender" output="false" access="public" hint="">
		<cfset APPLICATION.ajaxImportFiles &= ",noteFileUpload" />
		<cfset usesLayout(template="/layout") />
	</cffunction>
	
	<cffunction name="setSort" output="false" access="private" hint="Ustawienia sortowania">
		<cfif not IsDefined("session.note_notes.sortString")>
			<cfset session.note_notes.sortString = "" />
		</cfif>
		
		<cfif IsDefined("url.sort")>
			<!--- 
				Parsuje string na tablicę i sprawdzam, czy element istnieje. 
				Jak istnieje to zmieniam rodzaj sortowania. Jak element nie istnieje 
				to go dopisuje.
			--->
			<cfset przeparsowanyArgument = ListToArray(url.sort, ":") />
			<cfset pozycjaStringa = Find(przeparsowanyArgument[1], session.note_notes.sortString) />
			<cfset koniecStringa = -1 />
			
			<cfif pozycjaStringa NEQ 0>
				<cfset dwukropek = FindOneOf(":", session.note_notes.sortString, pozycjaStringa) />
				<cfset koniecStringa = FindOneOf(",", session.note_notes.sortString, dwukropek) />
				
				<!--- Jeżeli koniec stringa to 0 to mogę podmienić ostatnie znaki --->
				<cfif koniecStringa EQ 0>
					<cfset session.note_notes.sortString = Left(session.note_notes.sortString, Len(session.note_notes.sortString) - Len(session.note_notes.sortString) + dwukropek) />
					<cfset session.note_notes.sortString &= przeparsowanyArgument[2] />
				
				<!--- Jeżeli koniec stringa to nie jest 0 to kopiuje to co jeso od przecinka
				w prawo, usuwam rodzaj sortowania i doklejam to co skopiowałem --->
				<cfelse>
					
					<cfset tmp = Mid(session.note_notes.sortString, koniecStringa, Len(session.note_notes.sortString)) />
					<cfset session.note_notes.sortString = Left(session.note_notes.sortString, Len(session.note_notes.sortString) - Len(session.note_notes.sortString) + dwukropek) />
					<cfset session.note_notes.sortString &= przeparsowanyArgument[2] />
					<cfset session.note_notes.sortString &= tmp />
					
				</cfif>
				
			<cfelse>
				<cfset session.note_notes.sortString &= "," & url.sort />
			</cfif>
			
		</cfif>
	</cffunction>
	
	<cffunction name="removeSortColumn" output="false" access="public" hint="">
		
		<cfif not IsDefined("session.note_notes.sortString")>
			<cfset session.note_notes.sortString = "" />
		</cfif>
		
		<!---
			Sprawdzam czy przesłałem kolumnę do usunięcia z sortowania.
			Jeżeli kolumna jest przekazana to kasuje ją ze stringa w sesji.
		--->
		<cfif IsDefined("url.sort")>
			<cfset var table_sessionsort = ListToArray(session.note_notes.sortString, ",") />
			<cfset var wynikSortowania = "" />
			
			<cfloop array="#table_sessionsort#" index="i">
				<cfset tmp = ListToArray(i, ":") />
				<cfif url.sort EQ tmp[1]>
					<cfcontinue />
				<cfelse>
					<cfset wynikSortowania &= ","& i />
				</cfif>
			</cfloop>
			
		</cfif>
		
		<cfset session.note_notes.sortString = wynikSortowania />
		
		<cfset redirectTo(controller="Note_notes",action="index") />
		
	</cffunction>
	
	<cffunction name="index" output="false" access="public" hint="">
		
		<!--- Tutaj będę listował wszystkie dostępne notatki oraz umożliwiał ich
		filtrowanie. Filtr będzie ładowany w tym widoku a tabelka z innego widoku --->
		
		<cfparam name="projekt" type="string" default="" />
		<cfparam name="partnerid" type="string" default="" />
		<cfparam name="userid" type="string" default="" />
		<cfparam name="storeid" type="string" default="" />
		<cfparam name="score" type="string" default="" />
		<cfparam name="date_from" type="string" default="" />
		<cfparam name="date_to" type="string" default="" />
		<cfparam name="str" type="string" default="" />
		<cfparam name="date_type" type="string" default="" />
		<cfparam name="elements" type="numeric" default="50" />
		<cfparam name="page" type="numeric" default="1" />
		<cfparam name="tagid" type="string" default="" />
		<cfparam name="miasto" type="string" default="" />
		
		<!--- Zapisuje ustawienia filtra z sesji --->
		<cfif IsDefined("session.noteFilter.projekt") >
			<cfset projekt = session.noteFilter.projekt />
		</cfif>
		
		<cfif IsDefined("session.noteFilter.partnerid") >
			<cfset partnerid = session.noteFilter.partnerid />
		</cfif>
		
		<cfif IsDefined("session.noteFilter.userid") >
			<cfset userid = session.noteFilter.userid />
		</cfif>
		
		<cfif IsDefined("session.noteFilter.score") >
			<cfset score = session.noteFilter.score />
		</cfif>
		
		<cfif IsDefined("session.noteFilter.date_from") >
			<cfset date_from = session.noteFilter.date_from />
		</cfif>
		
		<cfif IsDefined("session.noteFilter.date_to") >
			<cfset date_to = session.noteFilter.date_to />
		</cfif>
		
		<cfif IsDefined("session.noteFilter.str") >
			<cfset str = session.noteFilter.str />
		</cfif>
		
		<cfif IsDefined("session.noteFilter.date_type") >
			<cfset date_type = session.noteFilter.date_type />
		</cfif>
		
		<cfif IsDefined("session.noteFilter.page")>
			<cfset page = session.noteFilter.page />
		</cfif>
		
		<cfif IsDefined("session.noteFilter.tagid")>
			<cfset tagid = session.noteFilter.tagid />
		</cfif>
		
		<cfif IsDefined("session.noteFilter.elements")>
			<cfset elements = session.noteFilter.elements />
		</cfif>
		
		<cfif IsDefined("session.noteFilter.miasto") >
			<cfset miasto = session.noteFilter.miasto />
		</cfif>

		
		<!--- Teraz dla odmiany sprawdzam, czy zmieniono filtr w formularzu --->
		<cfif IsDefined("FORM.projekt") >
			<cfset projekt = FORM.projekt />
		</cfif>
		
		<cfif IsDefined("FORM.partnerid") >
			<cfset partnerid = FORM.partnerid />
		</cfif>
		
		<cfif IsDefined("FORM.userid") >
			<cfset userid = FORM.userid />
		</cfif>
		
		<cfif IsDefined("FORM.score") >
			<cfset score = FORM.score />
		</cfif>
		
		<cfif IsDefined("FORM.date_from") >
			<cfset date_from = FORM.date_from />
		</cfif>
		
		<cfif IsDefined("FORM.date_to") >
			<cfset date_to = FORM.date_to />
		</cfif>
		
		<cfif IsDefined("FORM.str") >
			<cfset str = FORM.str />
		</cfif>
		
		<cfif IsDefined("FORM.date_type") >
			<cfset date_type = FORM.date_type />
		</cfif>
		
		<cfif IsDefined("FORM.tagid")>
			<cfset tagid = FORM.tagid />
		<cfelse>
			<!---<cfset tagid = "" />--->
		</cfif>
		
		<cfif IsDefined("FORM.miasto")>
			<cfset miasto = FORM.miasto />
		</cfif>
		
		<cfif IsDefined("FORM.elements")>
			<cfset elements = FORM.elements />
		</cfif>
		
		<cfif IsDefined("URL.page")>
			<cfset page = URL.page />
		</cfif>
		
		<cfif IsDefined("URL.elements")>
			<cfset elements = URL.elements />
		</cfif>
		
		<cfif IsDefined("URL.miasto")>
			<cfset miasto = URL.miasto />
		</cfif>
		
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="pps">
			<cfinvokeargument name="groupname" value="Partner prowadzacy sklep" />
		</cfinvoke>
		
		<cfinvoke method="checkUserTreeGroup" component="controllers.Tree_groupusers" returnvariable="uprawnieniaKos">
			<cfinvokeargument name="groupname" value="KOS" />
		</cfinvoke>

		<!--- Dane do filtra --->
		<cfset kos = model("tree_groupuser").getUsersByGroupName("KOS") />
		<cfset authors = model("note_note").getAuthors() />
		<cfset scores = queryNew("key,val") />
		<cfloop from="1" to="10" index="i" >
			<cfset queryAddRow(scores) />
			<cfset scores["key"][i] = i />
			<cfset scores["val"][i] = i />
		</cfloop>
		
		<cfset tags = model("note_tag").getTags() />
		
		<cfset session.noteFilter = {
			score = score,
			projekt = projekt,
			userid = userid,
			partnerid = partnerid,
			date_from = date_from,
			date_to = date_to,
			str = str,
			date_type = date_type,
			tagid = tagid,
			page = page,
			elements = elements,
			miasto = miasto
		} />
	
		<!--- Notatki --->
		<cfset notes = model("note_note").getNotes(
			storeid = storeid,
			partnerid = partnerid,
			userid = userid,
			score = score,
			projekt = projekt,
			dateFrom = date_from,
			dateTo = date_to,
			str = str,
			dateType = date_type,
			tags = tagid,
			pps = pps,
			kos = uprawnieniaKos,
			kosid = session.user.id,
			page = page,
			elements = elements,
			miasto = miasto) />
		
		<!--- Ilość notatek --->
		<cfset notesCount = model("note_note").getNotesCount(
			storeid = storeid,
			partnerid = partnerid,
			userid = userid,
			score = score,
			projekt = projekt,
			dateFrom = date_from,
			dateTo = date_to,
			str = str,
			dateType = date_type,
			tags = tagid,
			pps = pps,
			kos = uprawnieniaKos,
			kosid = session.user.id,
			miasto = miasto) />
		
		<!--- Miasta --->
		<cfset cities = model("note_note").getCities(
			storeid = storeid,
			partnerid = partnerid,
			userid = userid,
			score = score,
			projekt = projekt,
			dateFrom = date_from,
			dateTo = date_to,
			str = str,
			dateType = date_type,
			tags = tagid,
			pps = pps,
			kos = uprawnieniaKos,
			kosid = session.user.id) />
			
		<!---
			Sprawdzam, czy istnieje zmienna, która przechowuje wszystkie ID notatek do
			przechodzenia poprzednia/następna.
		--->
		<cfif not IsDefined("session.note_notes.noteIds")>
			<cfset session.note_notes.noteIds = arrayNew(1) />
		</cfif>
		
		<!--- 
			Kasuje dane w tabelce i dodaje nowe
		--->
		<cfset arrayClear(session.note_notes.noteIds) />
		<cfloop query="notes">
			<cfset arrayAppend(session.note_notes.noteIds, id) />
		</cfloop>
		
		<!---<cfset notesCount = model("note_note").getNoteCount(
			storeid = storeid,
			partnerid = partnerid,
			userid = userid) />--->
		
		<!---<cfset renderPartial(partial="_notes") />--->
		
		<cfif IsDefined("FORM.FIELDNAMES") or ( isDefined("URL.t") and URL.t EQ 1 )>
			<cfset usesLayout(false) />
		</cfif>
		
	</cffunction>
	
	<cffunction name="add" output="false" access="public" hint="">
		
		<!--- Sprawdzam, czy formularz został przesłany --->
		<cfif IsDefined("FORM.FIELDNAMES")>
			
			<cfif IsDefined("FORM.inspection_date") and Len(FORM.inspection_date)>
				<cfset tmp = ListToArray(FORM.inspection_date, "/") />
				<cfset myDate = CreateDate(tmp[3], tmp[2], tmp[1]) />
				<cfset FORM.inspection_date = myDate />
			</cfif>
			
			<!--- Definicja notatki --->
			<cfset var curntStr = model("store_store").getStoreByProject(FORM.projekt) />
			<cfset noteCollection = FORM />
			<cfset noteCollection.notebody = FORM.notebody />
			<cfset noteCollection.userid = session.user.id />
			<cfset noteCollection.note_created = Now() />
			<cfset noteCollection.storeid = curntStr.id />
			<cfset noteCollection.partnerid = curntStr.partnerid />
			<cfset newNote = model("note_note").create(noteCollection) />
			
			<!--- Zapisanie tagów --->
			<cfset tagList = ListToArray(FORM.tag, ",") />
			<!--- Przechodzę przez tagi i sprawdzam, czy są już zapisane w systemie --->
			<cfloop array="#tagList#" index="i">
				<cfset var tg = model("note_tag").findTag(i) />
				<cfif IsQuery(tg) AND tg.recordcount EQ 1>
					<cfset var newNtTg = model("note_note_tag").create({
						noteid = newNote.id,
						tagid = tg.id}) />
				<cfelse>
					<cfset var newTg = model("note_tag").create({tag_name = i}) />
					<cfset var newNtTg = model("note_note_tag").create({
						noteid = newNote.id,
						tagid = newTg.id}) />
				</cfif>
				
			</cfloop>
			
			<!--- Zapisanie plików do notatki --->
			<cfif IsDefined("FORM.files")>
				<cfset fileList = listToArray(FORM.files, ",") />
				<!--- Przechodzę przez każdego użytkownika --->
				<cfloop array='#fileList#' index="i">
					<cfset newNf = model("note_note_file").create({
						noteid = newNote.id,
						fileid = i}) />
				</cfloop>
			</cfif>
			
		</cfif>
		
		<!--- Punktacja sklepów --->
		<cfset scoreQuery = queryNew("key,val") />
		<cfloop from="1" to="10" index="i" >
			<cfset queryAddRow(scoreQuery) />
			<cfset scoreQuery["key"][i] = i />
			<cfset scoreQuery["val"][i] = i />
		</cfloop>
		
		<!--- Typy notatek --->
		<cfset noteT = model("note_type").getTypes() />
		
		<!--- Tagi --->
		<cfset tags = model("note_tag").getTags() />
		
	</cffunction>
	
	<cffunction name="uploadNoteFile" output="false" access="public" hint="">
		<cfset json = {} />
		<cfset json["msg"] = "" />
		<cfset json["error"] = "" />

		<cfif structKeyExists(form, "file") and len(form.file)>
			<cfset myFile = APPLICATION.cfc.upload.SetDirName(dirName="note_files") />
			<cfset myFile = APPLICATION.cfc.upload.upload(file_field="file") />

			<cfset newNoteFile = model("note_file").new() />
			<cfset newNoteFile.file_name = myFile.NEWSERVERNAME />
			<cfset newNoteFile.file_src = myFile.SERVERDIRECTORY />
			<cfset newNoteFile.file_size = myFile.FILESIZE />
			<cfset newNoteFile.file_ext = myFile.CLIENTFILEEXT />
			<cfset newNoteFile.userid = session.user.id />
			<cfset newNoteFile.created = Now() />
			<cfif IsDefined("myFile.THUMBFILENAME")>
				<cfset newNoteFile.file_thumb_src = myFile.THUMBFILENAME />
			</cfif>
			<cfset newNoteFile.save(callbacks=false) />
			
			<cfset json["filename"] = newNoteFile.file_name />
			<cfset json["filesrc"] = newNoteFile.file_src />
			<cfif IsDefined("newNoteFile.file_thumb_src")>
				<cfset json["thumb"] = newNoteFile.file_thumb_src />
			</cfif>
			<cfset json["id"] = newNoteFile.id />
		<cfelse>
			<cfset json["error"] = "No file was uploaded.">
		</cfif>
		
		<cfset renderWith(data="json",template="/json",layout=false) />
	</cffunction>
	
	<cffunction name="print" output="false" access="public" hint="">
		<cfset notes = model("note_note").getNotesById(params.noteIds) />
		<cfset filter = session.noteFilter />
		
		<cfif StructKeyExists(params, "format")>
			<cfset renderWith(data="notes,filter",layout=false) />
		</cfif>
	</cffunction>
	
	<cffunction name="edit" output="false" access="public" hint="">
		
		<!--- Zapisanie zmian w notatce --->
		<cfif isDefined("FORM.FIELDNAMES")>
			
			<cfset toEdit = model("note_note").findByKey(params.key) />
			<cfset toEdit.title = FORM.TITLE />
			<cfset toEdit.notebody = FORM.NOTEBODY />
			<cfset toEdit.score = FORM.SCORE />
			<cfset toEdit.save(callbacks=false) />
			
			<!--- Zapisanie tagów --->
			<cfset tagList = ListToArray(FORM.tag, ",") />
			<!--- Przechodzę przez tagi i sprawdzam, czy są już zapisane w systemie --->
			<cfloop array="#tagList#" index="i">
				<cfset var tg = model("note_tag").findTag(i) />
				<cfif IsQuery(tg) AND tg.recordcount EQ 1>
					<cfset var newNtTg = model("note_note_tag").create({
						noteid = params.key,
						tagid = tg.id}) />
				<cfelse>
					<cfset var newTg = model("note_tag").create({tag_name = i}) />
					<cfset var newNtTg = model("note_note_tag").create({
						noteid = params.key,
						tagid = newTg.id}) />
				</cfif>
				
			</cfloop>
			
			<!--- Zapisanie plików do notatki --->
			<cfif IsDefined("FORM.files")>
				<cfset fileList = listToArray(FORM.files, ",") />
				<!--- Przechodzę przez każdego użytkownika --->
				<cfloop array='#fileList#' index="i">
					<cfset newNf = model("note_note_file").create({
						noteid = params.key,
						fileid = i}) />
				</cfloop>
			</cfif>
			
			<!--- Zapisanie informacji, jaki użytkownik którą notatkę edytował --->
			<cfset histStruct = {
				userid = session.user.id,
				noteid = toEdit.id,
				modified = Now()
				} />
			
			<cfset noteHist = model("note_history").create(histStruct) />
			
			<!--- Flash message z informacją o edycji --->
			<cfset flashInsert(msg="Zmiany zostaly zapisane.") />
		</cfif>
		
		<cfif IsDefined("params.key")>
			<cfset note = model("note_note").getNote(params.key) />
			<cfset tags = model("note_note_tag").getNoteTags(params.key) />
			<cfset files = model("note_note_file").getNoteFiles(params.key) />
			<cfset history = model("note_history").getHistory(params.key) />
			<cfset allTags = model("note_tag").getTags() />
			<!--- Punktacja sklepów --->
			<cfset scoreQuery = queryNew("key,val") />
			<cfloop from="1" to="10" index="i" >
				<cfset queryAddRow(scoreQuery) />
				<cfset scoreQuery["key"][i] = i />
				<cfset scoreQuery["val"][i] = i />
			</cfloop>
		<cfelse>
			<cfset redirectTo(controller="Note_notes",action="index") />
		</cfif>
		
	</cffunction>
	
	<cffunction name="view" output="false" access="public" hint="">
		<cfif IsDefined("url.key")>
			<cfset note = model("note_note").getNote(url.key) />
			
			<!--- Jeżeli oglądam nie swoją notatkę to mnie wyrzuca --->
			<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="pps">
				<cfinvokeargument name="groupname" value="Partner prowadzacy sklep" />
			</cfinvoke>
			
			<cfif pps is true and Compare(UCase(note.projekt), UCase(session.user.login)) NEQ 0>
				<cfset redirectTo(controller="Note_notes",action="index",message="Nie masz uprawnień do przeglądania tej notatki") />
			</cfif>
			
			<cfset tags = model("note_note_tag").getNoteTags(url.key) />
			<cfset files = model("note_note_file").getNoteFiles(url.key) />
		<cfelse>
			<cfset redirectTo(controller="Note_notes",action="index",message="Musisz wybrac notatke") />
		</cfif>
		
		<cfif IsDefined("url.t")>
			<cfset usesLayout(false) />
		</cfif>
		
	</cffunction>
	
	<cffunction name="del" output="false" access="public" hint="">
		<!--- Pobieram notatkę do usunięcia --->
		<cfset myNote = model("note_note").getNote(params.key) />
		
		<!--- Usuwam pliki --->
		<cfset myFiles = model("note_note_file").delFiles(params.key) />
		
		<!--- Usuwam tagi --->
		<cfset myTags = model("note_note_tag").delTags(params.key) />
		
		<!--- Usuwam notatkę --->
		<cfset myNoteDel = model("note_note").del(params.key) />
		
		<cfset redirectTo(back=true) />
		
	</cffunction>
	
	<cffunction name="removeFileFromNote" output="false" access="public" hint="">
		<cfif IsDefined("url.key")>
			<!--- Pobieram definicję pliku aby usunąć go z dysku i z bazy --->
			<cfset myFile = model("note_note_file").getFile(url.key) />
			
			<!--- Usuwam plik z dysku --->
			<cftry>
				<cfset fileDelete("#myFile.filesrc#/#myFile.filename#") />
				<cfset fileDelete("#myFile.filesrc#/#myFile.filethumbsrc#") />
				
				<cfset delNote = model("note_note_file").del(url.key) />
				
				<cfcatch type="any">
					<cfdump var="#cfcatch#" />
				</cfcatch>
			</cftry>
				
		</cfif>
		
		<cfset renderNothing() />
	</cffunction>
	
	<cffunction name="removeTagFromNote" output="false" access="public" hint="">
		<cfif IsDefined("url.key")>
			<cfset delTag = model("note_note_tag").del(url.key) />
		</cfif>
		
		<cfset renderNothing() />
	</cffunction>
	
	<cffunction name="next" output="false" access="public" hint="">
		
		<cfif IsDefined("url.noteId") and isDefined("session.note_notes.noteIds")>
			
			<cfset nextId = arrayFind(session.note_notes.noteIds, url.noteId) />
			<cfif nextId+1 GT arraylen(session.note_notes.noteIds) >
				<cfset redirectTo(controller="note_notes",action="view",key=session.note_notes.noteIds[1]) />
			<cfelse>
				<cfset redirectTo(controller="note_notes",action="view",key=session.note_notes.noteIds[nextId+1]) />
			</cfif>
			
		</cfif>
		
		<cfset redirectTo(controller="Note_notes",action="index") />
		<cfset renderNothing() />
	</cffunction>
	
	<cffunction name="prev" output="false" access="public" hint="">
		<cfif IsDefined("url.noteId") and isDefined("session.note_notes.noteIds")>
			
			<cfset prevId = arrayFind(session.note_notes.noteIds, url.noteId) />
			<cfif prevId-1 LT 1 >
				<cfset redirectTo(controller="note_notes",action="view",key=session.note_notes.noteIds[arraylen(session.note_notes.noteIds)]) />
			<cfelse>
				<cfset redirectTo(controller="note_notes",action="view",key=session.note_notes.noteIds[prevId-1]) />
			</cfif>
			
		</cfif>
		
		<cfset redirectTo(controller="Note_notes",action="index") />
		<cfset renderNothing() />
	</cffunction>
	
	<cffunction name="preview" output="false" access="public" hint="Podgląd notatki w odpowiedziach AOS">
		<cfif IsDefined("FORM.NOTEID")>
			<cfset noteid = FORM.NOTEID />
		</cfif>
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="noteWidget" output="false" access="public" hint="">
			
		<cfparam name="projekt" type="string" default="" />
		<cfparam name="partnerid" type="string" default="" />
		<cfparam name="userid" type="string" default="" />
		<cfparam name="storeid" type="string" default="" />
		<cfparam name="score" type="string" default="" />
		<cfparam name="date_from" type="string" default="" />
		<cfparam name="date_to" type="string" default="" />
		<cfparam name="str" type="string" default="" />
		<cfparam name="date_type" type="string" default="" />
		<cfparam name="elements" type="numeric" default="12" />
		<cfparam name="page" type="numeric" default="1" />
		<cfparam name="tagid" type="string" default="" />
		
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="pps">
			<cfinvokeargument name="groupname" value="Partner prowadzacy sklep" />
		</cfinvoke>
		
		<cfinvoke method="checkUserTreeGroup" component="controllers.Tree_groupusers" returnvariable="uprawnieniaKos">
			<cfinvokeargument name="groupname" value="KOS" />
		</cfinvoke>
		
		<!--- Notatki --->
		<cfset notes = model("note_note").getNotes(
			storeid = storeid,
			partnerid = partnerid,
			userid = userid,
			elements = elements,
			score = score,
			projekt = projekt,
			dateFrom = date_from,
			dateTo = date_to,
			str = str,
			dateType = date_type,
			tags = tagid,
			pps = pps,
			limit = true,
			kos = uprawnieniaKos,
			kosid = session.user.id) />
			
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="report" output="false" access="public" hint="">
		<cfparam name="userid" type="string" default="" />
		
		<cfif IsDefined("session.note_notes_report.userid")>
			<cfset userid = session.note_notes_report.userid />
		</cfif>
		<cfif IsDefined("FORM.userid")>
			<cfset userid = FORM.userid />
		</cfif>
		
		<cfset session.note_notes_report = {
			userid = userid
		} />
		
		<cfset raport = model("note_note").userStoreReport(userid) />
		<cfset dkin = model("tree_groupuser").getUsersByGroupName("Departament Kontroli i Nadzoru") />
		<cfset usesLayout(template="/layout_googlemap.cfm") />
		
	</cffunction>
</cfcomponent>