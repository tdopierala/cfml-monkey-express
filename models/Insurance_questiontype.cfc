<cfcomponent displayname="Insurance_questiontype" output="false" extends="Model">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("insurance_questiontypes") />
	</cffunction>
	
	<cffunction name="getAllTypes" output="false" access="public" hint="">
		<cfset var listaTypow = "" />
		
		<cfquery name="listaTypow" datasource="#get('loc').datasource.intranet#">
			select id, questiontypename from insurance_questiontypes;
		</cfquery>
		
		<cfreturn listaTypow />
	</cffunction>
</cfcomponent>