<cfcomponent
	extends="Controller">

	<cffunction
		name="init">
	
		<cfset super.init() />
	
	</cffunction>
	
	<cffunction
		name="index"
		hint="Lista zdefiniowanych regałów"
		description="Metoda prezentująca listę zdefiniowanych regałów">
	
		<cfset shelfs = model("shelf").getShelfs() />
	
	</cffunction>
	
	<cffunction
		name="add"
		hint="Formularz dodawania regału">
	
		<cfset shelftypes = model("shelfType").findAll() />
		<cfset shelfcategories = model("shelfCategory").findAll() />
		
		<cfset shelf = model("shelf").new() />
	
	</cffunction>
	
	<cffunction
		name="actionAdd"
		hint="Zapisanie nowej półki w systemie"
		description="Metoda zapisująca nową półkę w systemie">
	
		<cftry>
		
			<cfset shelf = model("shelf").create(params.shelf) />
			<cfset redirectTo(controller="shelfs",action="add",success="Nowy regał został dodany do systemu") />
		
		<cfcatch type="any">
		
			<cfset error = cfcatch.message />
			<cfset renderWith(data=error,template="/apperror") />
		
		</cfcatch>
		
		</cftry>
	
	</cffunction>

</cfcomponent>