<cfcomponent extends="Model">

	<cffunction name="init">
		<cfset belongsTo("groupRule")>
		<cfset afterSave("updateGroupRules")>
	</cffunction>
	
	<cffunction name="updateGroupRules" hint="Dodawanie brakującego powiązania grupy z regułą.">
		<!--- Pobieram wszystkie zdefiniowane grupy --->
		<cfset groups = model("group").findAll(select="id")>
		
		<!--- Dodaje nową definicję reguły do grupy --->
		<cfloop query="groups">
			<cfset group_rule = model("groupRule").new()>
			<cfset group_rule.groupid = id>
			<cfset group_rule.ruleid = properties().id>
			<cfset group_rule.access = 0>
			<cfset group_rule.save()>
		</cfloop>

	</cffunction>

</cfcomponent>