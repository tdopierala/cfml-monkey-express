<cfcomponent
	extends="Controller">

	<cffunction
		name="init">

		<cfset super.init() />
		<cfset provides("html,xml,json,pdf") />
		<cfset filters(through="before",type="before") />

	</cffunction>
	
	<cffunction
		name="before">
		<cfset usesLayout(template="/layout") />
	</cffunction>

	<cffunction
		name="index"
		hint="Lista wszystkich aktualności"
		decription="Metoda generująca listę wszystkich aktualności. Wpisy
				są paginowane po 8 na stronie.">
				
		<!--- Tomek, 02.10.13 
			Powiekszyłem ilość aktualnosci na stronie ze zwzgledu na brak paginacji 
		--->

		<cfparam
			name="page"
			default="1" />

		<cfparam
			name="elements"
			default="20" />

		<cfif structKeyExists(session, "post_filters") and
			structKeyExists(session.post_filters, "page")>
			<cfset page = session.post_filters.page />
		</cfif>

		<cfif structKeyExists(session, "post_filters") and
			structKeyExists(session.post_filters, "elements")>
			<cfset elements = session.post_filters.elements />
		</cfif>

		<cfif structKeyExists(params, "page")>
			<cfset page = params.page />
		</cfif>

		<cfif structKeyExists(params, "elements")>
			<cfset elements = params.elements />
		</cfif>

		<cfset session.post_filters = {
			page = page,
			elements = elements
		} />

		<cfset qPosts = model("post").getPosts(
			userid = session.user.id) />
		<cfset qPostCount = model("post").getPostCount() />

		<cfset renderWith(data="qPosts,qPostCount",layout=false) />

	</cffunction>

	<cffunction
		name="add"
		hint="Dodawanie nowej aktualności/komunikatu dla pracowników"
		description="Metoda generująca formularz dodawania nowego komunikatu dla wsystkich pracowników">
		
		<cfset privileges = model("tree_group").getLevel(4, 4) />
		
		<cfset usesLayout(false) />

	</cffunction>

	<!---
		27.05.2013
		Do aktualności jest dodawany plik z możliwością pobrania.
		Zmiany wynikają z potrzeby wysyłania newsletterów dla pracowników
		na prośbę Michaliny i dyr. Przemka Mroczka.
	--->
	<cffunction
		name="actionAdd"
		hint="Zapisanie nowej aktualności w bazie."
		description="Metoda zapisująca nową aktualność w bazie.">
		
		<!--- Tworze pustą aktualność --->
		<cfset newpost = model("post").new() />
		<cfset newpost.userid = session.userid /> <!--- Zapisuje ID osoby, która dodała aktualność --->
		<cfset newpost.save(callbacks=false) />
		
		<!--- teraz dodaje uprawnienia --->
		<cfset var uprawnienia = model("post").addPrivileges(
			id = newpost.id,
			groups = FORM.GROUPID) />
		
		<cfset post = model("post").findByKey(newpost.id) />
		
		<cfset post.posttitle = params.posttitle />
		<cfset post.postcontent = params.postcontent />
		<cfset post.postcreated = Now() /> <!--- Zapisuję datę utworzenia wpisu --->
			
		<!---<cfif StructKeyExists(FORM, "centrala")>
		 	<cfset post.centrala = FORM.CENTRALA />
		</cfif>--->
		
		<!---<cfif StructKeyExists(FORM, "partner_prowadzacy_sklep")>
			<cfset post.partner_prowadzacy_sklep = FORM.PARTNER_PROWADZACY_SKLEP />
		</cfif>--->
		
		<cfset post.filename = params.filename />
		
		<cfset post.save(callbacks=false) />
		
		<!---
			Sprawdzam, czy są dodane pliki.
			Jeżeli pliki były dodane to parsuje listę plików i zapisuje je w bazie.
		--->
		<cfif structKeyExists(FORM, "attachment_src") and structKeyExists(FORM, "attachment_name")>
			<cfset srcArray = ListToArray(FORM.attachment_src, ",", false) />
			<cfset nameArray = ListToArray(FORM.attachment_name, ",", false) />
			
			<cfset index = 1 />
			<cfloop array="#srcArray#" index="i" >
				<cfset newPostAttachment = model("post_attachment").new() />
				<cfset newPostAttachment.postid = post.id />
				<cfset newPostAttachment.attachment_src = i />
				<cfset newPostAttachment.attachment_name = nameArray[index] />
				<cfset newPostAttachment.save(callbacks=false) />
				
				<cfset index++ />
			</cfloop>
		</cfif>
						
		<!--- Wysyłam powiadomienie --->
		<cfset powiadomienia = model("post").sendNotification(
			id = post.id,
			groups = FORM.GROUPID) />
		
		<!---
			11.07.2013
			Wysłanie maila z aktualnością. W załączniku są pliki dodane do wpisu.
		--->
		<!---<cfthread action="run" name="sendUsersPostNotification" priority="NORMAL" >
			
			<cfset postFiles = model("post_attachment").findAll(where="postid=#post.id#") />
			<cfset mailUsers = model("post").getPostUsers(postid = post.id) />
			
			<cfloop query="mailUsers">
				
				<cfmail 
					from="Monkey<intranet@monkey.xyz>"
					replyto="Monkey <intranet@monkey.xyz>" 
					to="#mail#" 
					cc="intranet@monkey.xyz"
					subject = "Powiadomienie o aktualności"
					type="text/html" >
				
					Witaj #givenname# #sn#,<br />
					W Intranecie pojawiła się nowa aktualność. Jej treść zamieszczona 
					jest poniżej. 
					<br />
					----------------------------------------------------------------------------------------------------------------------------------------
					<br /><br />
					#post.postcontent#
				
					<cfloop query="postFiles">
						<cfmailparam file = "#ExpandPath('files/posts/#attachment_src#')#" />
					</cfloop>
			
				</cfmail>
			</cfloop>
			
		</cfthread>--->
		
		<cfset redirectTo(controller="Posts",action="index",success="Aktualność została dodana. Powiadomienia są w trakcie wysyłania.") />

	</cffunction>
	
	<cffunction
		name="addFile"
		hint="Zapisanie pliku załącznika do aktualnosci">
		
		<cfset json = {} />
		<cfset my_file = APPLICATION.cfc.upload.SetDirName(dirName="posts") />
		<cfset my_file = APPLICATION.cfc.upload.upload(file_field="filedata") />
		<cfif isStruct(my_file) AND StructKeyExists(my_file, "SUCCESS")> <!--- Plik został zapisany na serwerze --->
			<cfset json.STATUS = 200 /> 
			<cfset json.MESSAGE = my_file.NEWSERVERNAME />
			<cfset json.FILENAME = my_file.NEWSERVERNAME />
			
		</cfif>
		
		<cfset renderWith(data="json",template="json",layout=false) />
			
	</cffunction>

	<cffunction
		name="uploadImage">


		<cfset usesLayout(false) />

		<!--- Zapisuje plik na serwerze --->
		<cfset myfile = APPLICATION.cfc.upload.SetDirName(dirName="posts/tmp") />
		<cfset myfile = APPLICATION.cfc.upload.upload(file_field="file") />

		<cfif isStruct(myfile)>
			<cfset thumb = imageNew(myfile.binarycontent) />
			<cfset imageResize(thumb, "", "100", "highestperformance") />
			<cfimage
				action="write"
				destination="#ExpandPath('files/posts/thumb/#myfile.newservername#')#"
				source="#thumb#" />
		</cfif>

	</cffunction>

	<!---
		Pobieranie zawartości katalogu.
	--->
	<cffunction
		name="getImages">
	</cffunction>
	<!---
		Koniec procedury pobierania zawartości katalog
	--->

	<cffunction
		name="view"
		hint="Podgląd aktualności o odpowiednim ID"
		description="Metoda generująca podgląd aktualności dodanej przez użytkownika">

		<cfset post = model("post").findOne(where="id=#params.key#",include="user") />
		<cfset myAttachments = model("post_attachment").findAll(where="postid=#params.key#") />
	
		<cfif StructKeyExists(params, "layout") and params.layout eq 'true'>
			
			<cfset renderWith(data="post,myAttachments") />
		<cfelse>
			
			<cfset renderWith(data="post,myAttachments",layout=false) />
		</cfif>
		

	</cffunction>

	<cffunction
		name="widgetPostPreview"
		hint="Widget prezentujący ostatnio dodane aktualności">

		<!---
			9.04.2013
			Metoda prezentująca widok z listą ostatnio dodanych aktualności.
			Widok jest używane do wygenerowania widgetu.
		--->
		<cfset widgetPosts = model("post").getPosts(
			page = 1,
			elements = 3,
			userid = session.user.id) />

		<cfset renderWith(data="widgetPosts",layout=false) />

	</cffunction>


</cfcomponent>