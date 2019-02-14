<cfcomponent extends="Model" >
	<cffunction name="init" >
<!---
		<cfset hasMany("userAttributes") >
		
		<cfset afterSave("updateUsersAttributes")>
--->
		
	</cffunction>
	
<!---
	<cffunction name="updateUsersAttributes">
	
		<cfset users = model("user").findAll()>
		
		<cfloop query="users">
			<cfset user_attribute = model("userAttribute").new()>
			<cfset user_attribute.userid = id>
			<cfset user_attribute.usersattributeid = properties().id>
			<cfset user_attribute.attribute_value = "">
			<cfset user_attribute.visible = 1>
			<cfset user_attribute.save()>
		</cfloop>
	
	</cffunction>
--->
	
</cfcomponent>