<cfcomponent extends="Controller" >

	<cffunction name="index" hint="Lista wszystkich zdefiniowanych departamentów">
	
		<cfset departments_tmp = model("department").findAll(order="department_name asc")>
		<cfset departments = structNew()>
		
		<!---
		Tworzę strukturę zawierającą departament i ilość pracowników
		--->
		<cfloop query = "departments_tmp">
			<cfset departments[id] = structNew()>
			<cfset departments[id].departmentid=#id#>
			<cfset departments[id].department_name=#department_name#>
			<cfset departments[id].users_count = model("user").count(where="departmentid=#id#")>
		</cfloop>
	
	</cffunction>
	
	<cffunction name="add" >
		<cfset department = model("department").new()>
	</cffunction>
	
	<cffunction name="actionAdd" >
		<cfset department = model("department").create(params.department)>
		<cfset redirectTo(
			controller="Users",
			succes="Dodano nowy departament")>
	</cffunction>
	
	<cffunction name="view" >
		<cfset department = model("department").findByKey(params.key)>
		<cfset department_users = model("user").findAll(where="departmentid=#params.key#")>
	</cffunction>
	
	<cffunction name="delete" >
		
	</cffunction>
	
</cfcomponent>