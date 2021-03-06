<cfcomponent
	extends="Controller">

	<cffunction
		name="init">
		
		<cfset super.init() />
		
	</cffunction>
	
	<cffunction
		name="index"
		hint="Tabelka z listą uzytkowników i opcjami menu."
		description="Lista użytkowników i opcjie w menu. Zaznaczając checkbox przydzielam dostęp do danego linku.">
	
		<cfif StructKeyExists(params, "key")>
		
			<cfset loc.userid = params.key />
		
		<cfelse>
		
			<cfset loc.userid = session.userid />
		
		</cfif>
		
		<cfset username = model("user").findByKey(loc.userid) />
		<cfset usermenu = model("viewUserMenu").findAll(where="userid=#loc.userid#") />
	
	</cffunction>
	
	<cffunction
		name="grantRevokeMenu"
		hint="Zmiana uprawnień użytkownika do opcji menu"
		description="Metoda zmieniająca uprawnienia uzytkownika do danej opcji w menu">
	
		<cfif IsAjax()>
		
			<cfset usermenu = model("userMenu").findOne(where="userid=#params.userid# AND menuid=#params.menuid#")>
			<cfset usermenu.update(usermenuaccess=1-usermenu.usermenuaccess)>
			<cfset message = "Dostęp został zaktualizowany">

		<cfelse>

			<cfset message = "Niepoprawdze wywołanie żądania">

		</cfif>

	</cffunction>

</cfcomponent>