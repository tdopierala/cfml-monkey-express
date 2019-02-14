<cfcomponent extends="Model">

	<cffunction name="init">
		<cfset belongsTo("user")>
		
		<cfset hasMany("objectAttribute")>
		<cfset hasMany("objectInstance")>
		<cfset hasMany("objectInstanceAttributeValue")>
		
		<cfset afterSave("updateAttributes")>
	</cffunction>
	
	<cffunction name="updateAttributes">
		<cfset attributes = model("attribute").findAll()>
		
		<cfloop query="attributes">
		
			<cfset object_attribute = model("objectAttribute").new()>
			<cfset object_attribute.attributeid = id>
			<cfset object_attribute.objectid = properties().id>
			<cfset object_attribute.created = Now()>
			<cfset object_attribute.visible = 0>
			<cfset object_attribute.save()>
		
		</cfloop>
		
	</cffunction>

</cfcomponent>