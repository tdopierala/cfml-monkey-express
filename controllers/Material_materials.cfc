<cfcomponent
	extends="Controller"
	output="false">

	<cffunction
		name="init">

		<cfset super.init() />
		<cfset filters(through="before",type="before") />

	</cffunction>
	
	<cffunction
		name="before">
			
		<cfset usesLayout(template="/layout") />
		
	</cffunction>

	<cffunction
		name="index"
		hint="Lista zdefiniowanych materiałów">

		<cfset folder_tree = model("material_material").getTree() />
		<cfset usesLayout(false) />

	</cffunction>

	<cffunction
		name="getNodes"
		hint="Lista gałęzi">

		<cfset folder_nodes = model("material_material").getNodes(level = params.key) />

	</cffunction>

	<cffunction
		name="getMaterials"
		hint="Lista materiałów przypisanych do folderu">

		<cfset json = model("material_material").getMaterials(folderid = params.key) />
		<cfset renderWith(data="json",layout=false,template="/json") />

	</cffunction>

	<cffunction
		name="getPages"
		hint="Lista stron przypisanych do materiału szkoleniowego">

		<cfset pages = model("material_material").getPages(materialid=params.key) />
		<cfset usesLayout(false) />

	</cffunction>

	<cffunction
		name="getVideos"
		hint="Lista plików video przypisanych do materiału">

		<cfset videos = model("material_material").getVideos(materialid=params.key) />
		<cfset usesLayout(false) />

	</cffunction>

	<cffunction
		name="newMaterial"
		hint="Formularz dodawania nowego materiału">

		<cfset folder_tree = model("material_material").getTree() />
		<cfset usesLayout(false) />

	</cffunction>

	<cffunction
		name="actionNewMaterial"
		hint="Zapisanie materiału szkoleniowego">
	
		<cfset new_material = model("material_material").new() />
		<cfset new_material.materialname = params.materialname />
		<cfset new_material.materialnote = params.materialnote />
		<cfset new_material.materialcreated = Now() />
		<cfset new_material.userid = session.userid />
		<cfset new_material.folderid = params.folderid />
		<cfset new_material.save() />

	</cffunction>

	<cffunction
		name="getFiles"
		hint="Pobieram listę plików, które są przypisane do materiału szkoleniowego">

		<cfset my_files = model("material_material").getFiles(materialid = params.key) />
		<cfset usesLayout(false) />

	</cffunction>
	
	<cffunction name="removeFile" output="false" access="public" hint="">
		<cfset json = {
			STATUS = "ERROR",
			MESSAGE = "Nie można usunąć pliku"} />
			
		<cfif IsDefined("params.key")>
			<cfset file = model("material_file").findByKey(params.key) />
			<cffile 
				action="delete" 
				file="#expandPath('files/materials/#file.filesrc#')#" />
			
			<cfset toRemove = model("material_file").deleteFile(params.key) />
			<cfset json = {
				STATUS = "OK",
				MESSAGE = "Plik został usunięty"} />
		</cfif>
		
		<cfset renderWith(data="json",template="/json",layout=false) />
	</cffunction>

</cfcomponent>