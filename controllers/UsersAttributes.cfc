<cfcomponent extends="Controller" >
	
	<cffunction name="init">
	
		<cfset super.init() />
	
	</cffunction>

	<cffunction name="index" >
		<cfset usersAttributes = model("usersAttribute").findAll(order="id")>
	</cffunction>
	
	<cffunction name="add" >	
		<cfset usersAttributes = model("usersAttribute").new() >
		<cfset parentAttributes = model("usersAttribute").findAll(order="id") >
		<cfset childAttributes = model("usersAttribute").findAll(order="id") >
	</cffunction>
	
	<cffunction name="actionAdd">
		<cfset newAttr = model("usersAttribute").new(params.usersAttributes) >
		<cfset newAttr.save() >
		
		<cfset redirectTo(controller="UsersAttributes", action="index", success="Atrybut #params.usersAttributes.attribute_name#")>
	</cffunction> 
	
	<cffunction name="delete" >
		<cfset usersAttribute = model("usersAttribute").findByKey(params.key)>
    	<cfset usersAttribute.delete()>
		
		<cfset deleted = model("userAttribute").deleteAll(where="usersAttributeid=#params.key#")>
    	
    	<cfset redirectTo(
			controller="UsersAttributes",
			action="index",
			success="Atrybut #usersAttribute.attribute_name# został usunięty.")>
	</cffunction>
</cfcomponent>