<cfcomponent
	extends="Controller"
	output="false" >
		
	<cffunction
		name="init">
			
		<cfset super.init() />
		
	</cffunction>
	
	<cffunction
		name="new"
		hint="Utworzenie nowego katalogu z materiałami">
			
		<cfset folder_tree = model("material_material").getTree() />

	</cffunction>
	
	<cffunction
		name="actionNew"
		hint="Zapisanie nowego katalogu w systemie">
			
		<cfset new_folder = model("material_folder").add(folder_name = params.foldername) />
		<cfset folder_tree = model("material_material").getTree() />
			
	</cffunction>
	
	<cffunction
		name="move"
		hint="Przesunięcie elementu w drzewie">
	
		<cfset my_node = model("material_folder").move(
			my_root = params.my_root,
			new_parent = params.new_parent) />
			
		<cfset folder_tree = model("material_material").getTree() />
		
		<cfset renderWith(data="folder_tree",layout=false,template="actionnew") />
	
	</cffunction>
	
	<cffunction
		name="delete"
		hint="Usunięcie gałęzi z drzewa">
	
		<cfset my_node = model("material_folder").delete(
			subtree_id = params.key) />
			
		<cfset folder_tree = model("material_material").getTree() />
		
		<cfset renderWith(data="folder_tree",layout=false,template="actionnew") />
	
	</cffunction>
	
	<cffunction
		name="create"
		hint="Formularz tworzący nowy katalog z materiałami."
		description="Tworzenie nowego katalogu z materiałami. Po utworzeniu katalogu
			zwracam w formacie JSON dane opisujące katalog. Dane są potrzebne 
			do sortowania katalogu w strukturze (nested set)">
				
		
				
	</cffunction>
		
</cfcomponent>