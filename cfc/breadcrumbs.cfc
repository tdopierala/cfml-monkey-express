<cfcomponent
	displayname="breadcrumbs"
	output="false"
	hint="Komponent odpowiedzialny za zapisywanie okruszków chleba. Okruszki są zapisywane w metodach kontrolera." >

	<cfproperty
		name="sessionname"
		type="string" />
	
	<cfproperty
		name="crumbs"
		type="struct" /> 

	<!--- INICJALIZACJA --->

	<cfset THIS.sessionname = "crumbs" />
	<cfset session[THIS.sessionname] = ArrayNew(1) />
	
	<cffunction
		name="init">
		
		<cfargument name="sessionname" type="string" default="#THIS.sessionname#" required="false" />
		<cfargument name="crumbs" type="struct" default="#THIS.crumbs#" required="false" />
		
		<cfset THIS.sessionname = arguments.sessionname />
		<cfset ArrayAppend(session[THIS.sessionname], arguments.crumbs) />
	
	</cffunction>
	
	<!--- 
		Do metody jest przekazywana zmienna CGI (item = CGI)
	--->
	<cffunction
		name="push"
		hint="Dodanie nowej strony do struktury okruszków chleba."
		output="false" 
		access="public" >
		
		<cfargument name="page_name" type="string" required="true" default="" />
		
		<cfset myitem = structNew() />
		<cfset myitem.url = "#cgi.server_name##cgi.script_name#?#cgi.query_string#" />
		<cfset myitem.name = arguments.page_name />
		
		<cfreturn ArrayAppend(session[THIS.sessionname], myitem) />
	
	</cffunction>
	
	<cffunction
		name="getCrumbs"
		hint="Pobranie wszystkich okruszków chleba."
		output="false" > 
	
		<cfreturn session[THIS.sessionname] />
	
	</cffunction>
	
	<cffunction
		name="getHtmlCrumbs"
		hint="Metoda generująca listę ostatnich 6 linków, na które wchodził użytkownik"
		output="false" >
			
		<cfargument name="count" type="numeric" default="6" required="false" />
		
		<cfif not structKeyExists(session, THIS.sessionname)>
			<cfset session[THIS.sessionname] = arrayNew(1) />
		</cfif>
	
		<!--- Liczba elementów breadcrumbs zapisaych w sesji --->
		<cfset local.crumbs_size = arraylen(session[THIS.sessionname]) />
		<cfset local.html = "<ul class='breadcrumbs'>" />
		
		<cfif local.crumbs_size gt arguments.count>
		
			<cfloop index="i" from="#local.crumbs_size-(arguments.count-1)#" to="#local.crumbs_size#">
				<cfset local.html &= "<li><a href='http://#session[THIS.sessionname][i].url#'>#session[THIS.sessionname][i].name#</a></li>" />
			</cfloop>
		
		<cfelse>
		
			<cfloop array="#session[THIS.sessionname]#" index="i" >
				<cfset local.html &= "<li><a href='http://#i.url#'>#i.name#</a></li>" />
			</cfloop>
			
		</cfif>	
			
		<cfset local.html &= "</ul>" />
		
		<cfreturn local.html />
		
	</cffunction>
	
</cfcomponent>