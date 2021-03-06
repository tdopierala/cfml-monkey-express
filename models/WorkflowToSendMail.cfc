<cfcomponent extends="Model" hint="Model zawierający informację o wiadomościach z powiadomieniami o dokumentach w obiegu.">

	<cffunction name="init">
	</cffunction>
	
	<!---
	getUserWorkflow
	---------------------------------------------------------------------------------------------------------------
	Metoda zwracająca informacje o ilości dokumentów przypisanych do użytkownika.
	
	--->
	<cffunction name="getUserWorkflow" hint="Pobieranie informacji o dokumentach użytkownika" returnType="query">
	
		<cfset loc.userworkflowsql = "select 
				workflows, 
				userid, 
				givenname, 
				sn, 
				email
			from 
				view_workflowreminders" />
		
		<cfquery name="get_user_workflows" dataSource="#get('loc').datasource.intranet#" >
		
			#loc.userworkflowsql#
		
		</cfquery>
		
		<cfreturn get_user_workflows />
	
	</cffunction>

</cfcomponent>