<cfcomponent 
	extends="Controller">

	<cffunction
		name="init">
	
		<cfset super.init() />
		<cfset filters("beforeRender") />
	
	</cffunction>
	
	<cffunction
		name="beforeRender">
	
		<cfset usesLayout(template="/layout",ajax=false) />
		
	</cffunction>
	
	<cffunction
		name="index"
		hint="Liste typów regałów"
		description="Lista z typami regałów w sklepach">
	
		<cfset shelftypes = model("shelfType").findAll() />
	
	</cffunction>
	
	<cffunction
		name="add"
		hint="Formularz dodawania nowego typu nieruchomości">
	
		<cfset shelfType = model("shelfType").new() />
	
	</cffunction>
	
	<cffunction
		name="actionAdd"
		hint="Zapisanie nowego typu"
		description="Metoda zapisująca nowy typ regału w bazie">
	
		<cftry>
		
			<cfset shelftype = model("shelfType").create(params.shelfType) />
			<cfset redirectTo(controller="ShelfTypes",action="add",success="Nowy typ regału został dodany do systemu") />
			
		<cfcatch type="any">
		
			<cfset error = cfcatch.message />
			<cfset renderWith(data=error,template="/apperror") />
		
		</cfcatch>
		
		</cftry>
	
	</cffunction>
	
	<cffunction
		name="delete"
		hint="Usunięcie typu regału"
		description="Metoda usuwająca typ regału z systemu">
	
		<cftry>
	
			<cfset shelftype = model("shelfType").deleteByKey(key=params.key) />
			<cfset redirectTo(controller="ShelfTypes",action="index",success="Typ został prawidłowo usunięty") />
			
		<cfcatch type="any">
		
			<cfset error = cfcatch.message />
			<cfset renderWith(data=error,template='/apperror') />
		
		</cfcatch>
		
		</cftry>
	
	</cffunction>

</cfcomponent>