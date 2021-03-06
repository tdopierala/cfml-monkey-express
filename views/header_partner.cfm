<cfoutput>
	<h1>
		<cfif StructKeyExists(session, "user") AND StructKeyExists(session, "userid")>
		
			#linkTo(
				text=imageTag("logo.png"),
				controller="Partners",
				action="view",
				key=session.userid,
				title="Twój profil",
				class="monkey_intranet_logo")#
		
		<cfelse>
		
			#linkTo(
				text=imageTag("logo.png"),
				route="home",
				title="Strona główna Monkey Intranet",
				class="monkey_intranet_logo")#
		
		</cfif>
	</h1>
	
	<ul class="monkey_top_nav">
		<cfif not StructKeyExists(session, "user") AND not StructKeyExists(session, "userid")>
			<li>
				#linkTo(
					text="zaloguj",
					controller="Users",
					action="logIn")#
			</li>
		<cfelse>
			<li>
				#linkTo(
					text="wyloguj",
					controller="Users",
					action="logOut")#
			</li>
			<li>
				#linkTo(
					text="mój profil",
					controller="Users",
					action="view",
					key=session.userid,
					title="Zobacz swój profil")#
			</li>
			
		</cfif>
		<li>
			#linkTo(
				text="mapa serwisu",
				controller="Sitemaps",
				action="index")#
		</li>
	</ul>
	
	<cfif StructKeyExists(session, "user") AND StructKeyExists(session, "userid")>
	
	#startFormTag(controller="Search",action="find")#
		<ol class="monkeySearch">
			<li>
				#textFieldTag(
					name="search",
					class="input")#
			</li>
			<li>
				#submitTag(value="SZUKAJ",class="formButtonSearch")#
			</li>
		</ol>
		
		<ol class="monkey_advanced_search">
			<li>
				#checkBoxTag(
					name="searchdocuments",
					label="dokumenty",
					labelPlacement="before",
					checked=true)#
			</li>
			<li>
				#checkBoxTag(
					name="searchusers",
					label="użytkownicy",
					labelPlacement="before")#
			</li>
			<li>
				#checkBoxTag(
					name="searchinstructions",
					label="instrukcje",
					labelPlacement="before")#
			</li>
		</ol>
	#endFormTag()#
	
	</cfif>
	
</cfoutput>