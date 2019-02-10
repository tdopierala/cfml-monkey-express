<!---
Komponent obsługujący bazę LDAP.

Podstawowe metody:
importUsers	-	importuje wszystkich użytkowników z LDAP do intranetu. 
				Jeśli jakiś użytkownik istnieje już w intranecie jest pomijany.
--->
<cfcomponent extends="Controller">

	<cffunction name="init">
	
		<cfset super.init()>
	
	</cffunction>
	
	<cffunction name="importUsers" hint="Importowanie użytkowników z LDAP do intranetu">
	
		<cfset skipped = 0> <!--- Liczba użytkowników, których nie zaimportowano --->
		<cfset added = 0> <!--- Liczba zaimportowanych użytkowników --->
	
		<cftry>

			<cfldap 
				action="query"
				attributes="sAMAccountName,mail,memberOf,sn,givenName"
				filter="(&(objectCategory=person)(objectClass=user))"
				name="ldapusers"
				password="#get('loc').ldap.password#"
				server="#get('loc').ldap.server#"
				username="#get('loc').ldap.user#@#get('loc').ldap.domain#"
				start="ou=Monkey,dc=mc,dc=local">
				
			
			<!--- Przechodzę przez wszystkich użytkowników z LDAP --->
			<cfloop query="ldapusers">
			
				<!--- Pobieram użytkownika o danym loginie z bazy intranetowej --->
				<cfset intranetuser = model("user").findOne(where="samaccountname='#samaccountname#' AND active=1")>
				
				<!--- Jeśli jest taki użytkownik to nic z nim nie robie --->
				<cfif IsObject(intranetuser)>
				
					<cfset skipped++> <!--- Zwiększam licznik pominiętych użytkowników --->
				
				<!--- Jeśli nie ma takiego użytkownika to go dodaje --->	
				<cfelse>
				
					<!--- Dodawanie nowego uzytkownika --->
					<cfset timestamp = now() >
					<cfset newuser = model("user").new() >
					<cfset newuser.created_date = timestamp >
					<cfset newuser.last_login = timestamp >
					<cfset newuser.valid_password_to = timestamp >
					<cfset newuser.samaccountname = samaccountname>
					<cfset newuser.login = samaccountname>
					<cfset newuser.mail = mail>
					<cfset newuser.memberof = memberof>
					<cfset newuser.sn = sn>
					<cfset newuser.givenname = givenname>
					<cfset newuser.photo = "monkeyavatar.png">
					<cfset newuser.firstlogin = 1>
					<cfset newuser.save(callbacks=false) >
					
					<!--- 
					Tutaj wkleić fragment z pliku userUpdateMembership 
					Aktualizowanie struktury użytkownika w firmie
					--->
				
					<cfset added++> <!--- Zwiększam licznik dodanych użytkowników --->
				
				</cfif>
			
			</cfloop>
		
		<cfcatch type="any">
			
			<cfdump var="#cfcatch#">
			<cfabort>
		
		</cfcatch>
		
		</cftry>
		
		<cfdump var="#added#">
		<cfdump var="#skipped#">
		
		<cfabort>
		
	</cffunction>
	
	<cffunction name="importUsersStatus" hint="Status importu użytkowników. Podaje informacje ilu użytkowników zostało zaimportowanych,
												ilu użytkowników już było zdefiniowanych w systemie.">
	
		<cfargument name="skipped" default="0" type="numeric" hint="Liczba pominiętych kont, które już istniały w Intranecie."/>
		<cfargument name="added" default="0" type="numeric" hint="Liczba zaimportowanych kont do Intranetu."/>
		
		
	
	</cffunction>

</cfcomponent>