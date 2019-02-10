<cfcomponent
	extends="mc">

	<cffunction
		name="init"
		output="false" >
	
		<cfset super.init() />
	
	</cffunction>
	
	<cffunction
		name="index"
		output="false" >
	
		<!---<cfset fields = model("place_field").getAllFields() />--->
		<cfset fieldtypes = model("place_fieldtype").getTypes() />
		<cfset groups = model("protocol_group").getGroups() />
	
	</cffunction>
	
	<!---
		Metoda dodająca nowe pole protokołów.
	--->
	<cffunction 
		name="add"
		output="false" >
		
		<!---<cfdump var="#params#" />--->
		<!---<cfabort />--->
		
		<cfset myfield = model("protocol_field").create(params) />
		
		<!---
			22.01.2013
			Zapisuje opcje wyboru przy SelectBox.
		--->		
		<cfif structKeyExists(params, "selectboxname") and StructCount(params.selectboxname) gt 0>
			<!---
				Jeżeli sa przesłane pola do zapisania to w tępli przechodzę przez wszystkie i je zapisuje.
			--->
			<cfset my_values = params.selectboxname />
			<cfloop collection="#my_values#" item="i" >
				<cfset new_value = model("protocol_fieldvalue").new() />
				<cfset new_value.fieldid = myfield.id />
				<cfset new_value.fieldvalue = my_values[i] />
				<cfset new_value.save(callbacks=false) />
			</cfloop>
		</cfif>
		
		<cfset redirectTo(back="true") />
		
		
	</cffunction>
	
	<cffunction
		name="addFieldGroup"
		output="false">
			
		<cfset mygroup = model("protocol_group").create(params) />
		<cfset redirectTo(back="true") />
			
	</cffunction>
	
	<cffunction 
		name="updateAccess"
		output="false" >
		
		<cfset myfieldgroup = model("protocol_fieldgroup").findByKey(params.id) />
		<cfset myfieldgroup.update(
			access=1-myfieldgroup.access,
			callbacks=false) />
		
	</cffunction>
		
</cfcomponent>