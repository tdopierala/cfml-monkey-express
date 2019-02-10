<cfcomponent
	extends="mc" >

	<cffunction name="init">
		<cfset super.init() />
	</cffunction>

	<cffunction name="index" >
		<cfset userattributes = model("userAttribute").findAll(include="attribute") />
	</cffunction>

	<cffunction
		name="updateUserAttribute"
		hint="Aktywacja atrybutu użytkownika"
		description="Metoda aktywująca atrybut uzytkownika. Zmieniana jest tabela userattributes">

		<cfif isAjax()>
			<cfset userattribute = model("userAttribute").findByKey(params.key)>
			<cfset userattribute.update(visible=1-userattribute.visible)>
			<cfset message = "Atrybut został zaktualizowany">
		<cfelse>
			<cfset message = "Atrybut nie mógł zostać zaktualizowany">
		</cfif>

		<cfset renderWith(data=message,layout=false)>

	</cffunction>

	<cffunction
		name="updateUserAttributeValues"
		hint="Aktualizuje wartości atrybutów uzytkownika"
		description="Metoda aktualizująca wartości atrybutów użytkownika.">

		<cfset userattributes = model("viewUserAttributeValue").findAll(where="userid=#session.userid#") />
		<cfset departmentoptions = model("selectValue").findAll(select="selectlabel,selectname",where="attributeid=125") />

		<cfset renderWith(data="userattributes,departmentoptions",layout=false) />

	</cffunction>

	<cffunction
		name="actionUpdateUserAttributeValue"
		hint="Zapisanie informacji o użytkowniku w bazie i eksport danych do LDAP"
		description="Metoda zapisująca dane w bazie danych Intranetu. Po zapisaniu danych w Intranecie zapisywane są w LDAP">

		<cftry>

			<!--- Zpisuje wprowadzone informacje o użytkowniku w bazie Intranetowej --->
			<cfset userattributevalue = params.userattributevalue />
			<cfloop collection="#userattributevalue#" item="i">

				<cfset userattr = model("userAttributeValue").findOne(where="attributeid=#i# AND userid=#session.userid#") />
				<cfset userattr.userattributevaluetext = userattributevalue[i] />
				<cfset userattr.save(callbacks=false) />

			</cfloop>

			<!--- Jeśli zakończyło się zapisywanie danych w bazie Intranetu to teraz zapisuje dane w bazie LDAP --->
			<cfset userattributeldapname = params.userattributeldapname />
			<cfloop collection="#userattributeldapname#" item="i">

				<cfldap action="modify"
					modifytype="replace"
					attributes="#userattributeldapname[i]#=#params.userattributevalue[i]#"
					dn="#session.user.distinguishedName#"
					password="#get('loc').ldap.password#"
					server="#get('loc').ldap.server#"
					username="#get('loc').ldap.user#@#get('loc').ldap.domain#">

			</cfloop>

			<cfset redirectTo(controller="Users",action="view",key=session.userid) />

			<cfcatch type="any">

				<cfset error = cfcatch.message />
				<cfset renderWith(data=error,layout=false,template="/apperror")/>

			</cfcatch>

		</cftry>

	</cffunction>

	<!---
	9.05.2012
	Usunąłem funkcje.
	Atrybuty są trzymane w tabeli attributes. Atrybuty przypisane do użytkownika są trzymane w userattributes.
	Wartości atrybutów są trzymane w userattributevalues.
	--->
	<!---
	<cffunction name="add" hint="Formularz dodawania nowego atrybutu użytkownika">
		<cfset user_attribute = model("userAttribute").new() >
		<cfset user = model("user").findByKey(params.key) >
		<cfset attributes = model("usersAttribute").findAll() >
	</cffunction>

	<cffunction name="actionAdd" hint="Dodawanie nowego atrybutu użytkownika">
		<cfloop collection="#params.user_attribute#" item="i">
			<cfset user_attributes = model("userAttribute").new() >
			<cfset user_attributes.userid = #params.user.id# >
			<cfset user_attributes.usersattributeid = #i# >
			<cfset user_attributes.attribute_value = #params.user_attribute[i]# >
			<cfif structKeyExists(params.visible, i)>
				<cfset user_attributes.visible=1 >
			<cfelse>
				<cfset user_attributes.visible=0 >
			</cfif>
			<cfset user_attributes.save() >
		</cfloop>

		<cfset redirectTo(
			controller="Users",
			action="index",
			success="Atrybuty zostały zapisane.") >
	</cffunction>

	<cffunction name="edit">
		<cfset user_attribute = model("userAttribute").new()>
		<cfset user_attributes = model("userAttribute").findAll(where="userid=#params.key#",include="user,usersAttribute",order="usersAttributeid ASC")>
	</cffunction>

	<cffunction name="actionEdit">
		<cfloop collection="#params.user_attribute#" item="i">
			<cfset user_attribute = model("userAttribute").findByKey(#i#)>
			<cfset params.user_attribute.attribute_value = #params.user_attribute[i]#>

			<cfif isDefined("params.visible") AND structKeyExists(params.visible, i)>
				<cfset params.user_attribute.visible = 1>
			<cfelse>
				<cfset params.user_attribute.visible = 0>
			</cfif>

			<cfset user_attribute.update(params.user_attribute)>
		</cfloop>
		<cfset redirectTo(
			controller="Users",
			action="index",
			succerr="Atrybuty użytkownika zostały zmienione.")>
	</cffunction>
	--->

</cfcomponent>