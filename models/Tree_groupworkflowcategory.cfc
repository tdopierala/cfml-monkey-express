<cfcomponent extends="Model" displayname="Tree_groupworkflowcategory">

	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("tree_groupworkflowcategories") />
	</cffunction>
	
	<cffunction name="getCategories" output="false" access="public" hint="">
		<cfargument name="userid" type="numeric" required="true" />
		
		<cfset var qCategories = "" />
		<cfquery name="qCategories" datasource="#get('loc').datasource.intranet#">
			select distinct g.categoryid as id, c.categoryname 
			from tree_groupworkflowcategories g
				inner join tree_workflowcategories c on g.categoryid = c.id 
			where g.groupid in (
				select groupid from tree_groupusers where userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
			)
		</cfquery>
		
		<cfreturn qCategories />
	</cffunction>
	
</cfcomponent>