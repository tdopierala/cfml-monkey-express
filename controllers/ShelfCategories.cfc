<cfcomponent 
	extends="Controller">

	<cffunction
		name="init">
	
		<cfset super.init() />
		<cfset filters("beforeRender") />
	
	</cffunction>
	
	<cffunction 
		name="beforeRender">
	
	</cffunction>
	
	<cffunction
		name="index"
		hint="Lista kategorii półek"
		description="Lista kategorii pólek w sklepie.">
	
		<cfset shelfcategories = model("shelfCategory").findAll() />
	
	</cffunction>
	
	<cffunction
		name="add"
		hint="Formularz dodawania kategorii regału">
	
		<cfset shelfCategory = model("shelfCategory").new() />
	
	</cffunction>
	
	<cffunction
		name="actionAdd"
		hint="Zapisanie nowej kategorii regału">
	
		<cftry>
		
			<cfset shelfcategory = model("shelfCategory").create(params.shelfCategory) />
			<cfset redirectTo(controller="shelfCategories",action="add",success="Nowa kategoria regału została dodana do systemu") />
		
		<cfcatch type="any">
		
			<cfset error = cfcatch.message />
			<cfset renderWith(data=error,template="/apperror") />
		
		</cfcatch>
		
		</cftry>
	
	</cffunction>
	
	<cffunction
		name="delete"
		hint="Usunięcie kategorii regału">
		
		<cftry>
		
			<cfset shelfcategory = model("shelfCategory").deleteByKey(key=params.key) />
			<cfset redirectTo(controller="shelfCategories",action="index",success="Kategoria została usunięta z systemu") />
			
		<cfcatch type="any">
		
			<cfset error = cfcatch.message />
			<cfset renderWith(data=error,template="/apperror") />
		
		</cfcatch>
		
		</cftry>
		
	</cffunction>

</cfcomponent>