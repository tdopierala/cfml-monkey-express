<cfcomponent displayname="Insurance_instance" output="false" extends="Model">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("insurance_instances") />
	</cffunction>
	
	<cffunction name="create" output="false" access="public" hint="Dodanie instancji zgłoszenia i wygenerowanie pytań.">
		<cfargument name="categoryid" type="numeric" required="true" />
		<cfargument name="userid" type="numeric" required="true" />
		<cfargument name="data_szkody" type="date" required=true />
		<cfargument name="data_zgloszenia" type="date" required="true" />
		
		<cfset var noweZgloszenie = "" />
		<cfset var noweZgloszenieResult = "" />
		
		<cfquery name="noweZgloszenie" result="noweZgloszenieResult" datasource="#get('loc').datasource.intranet#">
			insert into insurance_instances (categoryid, userid, created, data_szkody, data_zgloszenia)
			values (
			<cfqueryparam value="#arguments.categoryid#" cfsqltype="cf_sql_integer" />,
			<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />,
			<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp" />,
			<cfqueryparam value="#arguments.data_szkody#" cfsqltype="cf_sql_date" />,
			<cfqueryparam value="#arguments.data_zgloszenia#" cfsqltype="cf_sql_date" />
			);
			
			set @instId = (select LAST_INSERT_ID());
			
			<!---
				Wywołuje procedurę, która zasila bazę pustymi pytaniami do ubezpieczeń.
			--->
			call sp_intranet_insurance_add_new_instance(
				@instId, 
				<cfqueryparam value="#arguments.categoryid#" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />);
			
			select @instId as id;
		</cfquery>
		
		<cfreturn noweZgloszenie.id />
	</cffunction>
	
	<cffunction name="getUserInstances" output="false" access="public" hint="">
		<cfargument name="userid" type="numeric" required="true" />
		
		<cfset var listaZgloszen = "" />
		<cfquery name="listaZgloszen" datasource="#get('loc').datasource.intranet#">
			select i.id, i.categoryid, data_szkody, data_zgloszenia, c.categoryname
			from insurance_instances i
			inner join insurance_categories c on i.categoryid = c.id
			where i.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfreturn listaZgloszen />
	</cffunction>
</cfcomponent>