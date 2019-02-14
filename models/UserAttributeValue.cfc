<cfcomponent extends="Model">

	<cffunction
		name="init">
		
		<cfset belongsTo("user") />
		<cfset belongsTo("userAttribute") />
		<cfset belongsTo("attribute") />
	
	</cffunction>
	
	<cffunction
		name="ldapToIntranet"
		hint="Aktualizacja danych użytkownika z LDAP do Intranetu"
		description="Metoda pobierająca dane użytkownika z serwera LDAP i zapisująca je w bazie Intranetu. Na tym etapie synchronizacja odbywa się w jedną stronę LDAP -> Intranet">
	
		<!--- Argumenty potrzebne do zaktualizowania informacji o użytkowniku --->
		<cfargument name="userid" type="numeric" required="true" default="0" />
		<cfargument name="ldap" type="struct" required="true" />
		
		<cfset userattributes = model("viewUserAttributeValue").findAll(where="userid=#arguments.userid#",select="attributeid,attributename") />
		
		<!--- Przechodzę przez wszystkie atrybuty do aktualizacji i aktualizuje je --->
		<cfloop collection="#arguments.ldap#" item="i">
			
			<cfloop query="userattributes">
			
				<cfif attributename eq i>
				
					<cfset userattributevalue = model("userAttributeValue").findOne(where="userid=#arguments.userid# AND attributeid=#attributeid#") />
					<cfset userattributevalue.userattributevaluetext = arguments.ldap[i] />
					<cfset userattributevalue.save(callbacks=false) />
				
				</cfif> 
			
			</cfloop>
		
		</cfloop>
			
	</cffunction>

</cfcomponent>