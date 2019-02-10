<cfcomponent
	extends="Controller"
	output="false">

	<cffunction
		name="init">

		<cfset super.init() />

	</cffunction>

	<cffunction
		name="newPage"
		hint="Formularz dodawania nowej strony do materiału">

		<cfset materials = model("material_material").getAllMaterials() />

	</cffunction>

	<cffunction
		name="actionNewPage"
		hint="Zapisanie strony w materiale szkoleniowym">

		<cfset new_page = model("material_page").new() />
		<cfset new_page.pagename = params.pagename />
		<cfset new_page.pagecontent = params.pagecontent />
		<cfset new_page.userid = session.userid />
		<cfset new_page.pagecreated = Now() />
		<cfset new_page.materialid = params.materialid />
		<cfset new_page.save() />

	</cffunction>

	<cffunction
		name="view"
		hind="Wygenerowanie pliku PDF zawierającego dokument">

		<cfset my_page = model("material_page").findByKey(params.key) />
		<cfif StructKeyExists(params, "format")>
			<cfset renderWith(data="my_page",layout=false) />
		</cfif>

	</cffunction>

</cfcomponent>