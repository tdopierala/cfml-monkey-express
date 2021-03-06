<!---
Kontroler odpowiedzialny za zarządzanie grupami. Grupa jest zbiorem pewnych reguł dostępu do intranetu.
Każdy użytkownik może należeć do więcej niż jednej grupy. Każda grupa może mieć więcej niż jedną regułę dostępu.
--->

<cfcomponent extends="Controller">

	<cffunction name="index" hint="Metoda zwracająca listę wszystkich dostępnych grup w intranecie.">
	
		<cfset groups = model("group").findAll()>
	
	</cffunction>
	
	<cffunction name="add" hint="Metoda dodawania nowej grupy użytkowników do intranetu.">
	
		<cfset group = model("group").new()>
	
	</cffunction>
	
	<cffunction name="actionAdd" hint="Zapisanie nowej grupy w bazie danych i przekierowanie do strony dodawania reguł dostępu.">
	
		<cfset group = model("group").new(params.group)>
		<cfset group.created = Now()>
		<cfset group.save()>
		
		<cfset redirectTo(controller="Groups", action="editRules", key=group.id)>
	
	</cffunction>
	
	<cffunction name="editRules" hint="Metoda dodawania reguł do grupy.">
		
		<cfset group_rules = model("groupRule").findAll(where="groupid=#params.key#",include="group,rule")>
		<cfset group = model("group").findByKey(params.key)>
		<cfdump var="#group_rules#">
	
	</cffunction>
	
	<cffunction name="updateGroupRule" hint="Aktualizacja uprawnienia dla danej reguły. 
											Metoda zapisuje 1 jeśli ma uprawnienia i 0 jeśli ich nie mam.">
	
		<cfif isAjax()>
			<cfset group_rule = model("groupRule").findByKey(params.key)>
			<cfset group_rule.update(access=1-group_rule.access)>
			<cfset message = "Reguła została zaktualizowana.">
		<cfelse>
			<cfset message = "Niepoprawdze wywołanie żądania">
		</cfif>
		
		<cfset renderWith(data=message,layout=false)>
	
	</cffunction>
	
	<cffunction name="view" hint="Lista wszystkich użytkowników w danej grupie.">
		<cfset users = model("userGroup").findAll(where="groupid=#params.key# AND users.active=1 AND access=1",include="user")>
	</cffunction>
	
	<cffunction name="delete" hint="Usuwanie grupy z bazy danych">
		<cfset group = model("group").findByKey(params.key)>
		<cfset group.delete()>
		<cfset redirectTo(back=true)>
	</cffunction>

</cfcomponent>