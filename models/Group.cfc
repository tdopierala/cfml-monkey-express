<cfcomponent extends="Model">

	<cffunction name="init">
		<cfset table("groups")>
		<cfset hasMany("groupRule")>
		<cfset hasMany("userGroup")>
		
		<!--- <cfset afterSave("addRules")> --->
		<cfset afterDelete("deleteConnections")>
		
	</cffunction>

	<!---
	23.08.2012
	Usunąłem procedury i przeniosłem je do MySQL.
	Dodałem trigger, który je wyzwala.
	--->	
<!---
	<cffunction name="addRules">
		
		<cfset rules = model("rule").findAll(select="id")>
		
		<cfloop query="rules">
			<cfset group_rule = model("groupRule").new()>
			<cfset group_rule.groupid = properties().id>
			<cfset group_rule.ruleid = id>
			<cfset group_rule.access = 0>
			<cfset group_rule.save()>
		</cfloop>
		
		<cfset users = model("user").findAll()>
		
		<cfloop query="users">
			<cfset user_group = model("userGroup").new()>
			<cfset user_group.groupid = properties().id>
			<cfset user_group.userid = id>
			<cfset user_group.access = 0>
			<cfset user_group.save()>
		</cfloop>
		
	</cffunction>
--->
	
	<cffunction name="deleteConnections">
	
		<cfset group_rule = model("groupRule").deleteAll(where="groupid=#properties().id#")>
		<cfset user_group = model("userGroup").deleteAll(where="groupid=#properties().id#")>
	
	</cffunction>
	
	<cffunction name="addNewNestedGroup" 
		hint="Metoda dodaje nową grupe do drzewa nested set">
		
	</cffunction>

</cfcomponent>