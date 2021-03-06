<cfcomponent extends="Controller">

	<cffunction name="init">
		<cfset super.init()>
	</cffunction>

	<cffunction name="index" hint="Lista reguł">
		<cfset rules = model("rule").findAll()>
	</cffunction>
	
	<cffunction name="add" hint="Formularz dodawania nowej reguły.">
		<cfset rule = model("rule").new()>
	</cffunction>
	
	<cffunction name="actionAdd" hint="Zapisywanie nowej reguły.">
		<cfset rule = model("rule").new(params.rule)>
		<cfset rule.controller = params.rule.kontroler>
		<cfset rule.save(reload=true,callbacks=false)>

		<cfset redirectTo(controller="Rules",action="add",success="Dodano nową regułę.")>
	</cffunction>

</cfcomponent>