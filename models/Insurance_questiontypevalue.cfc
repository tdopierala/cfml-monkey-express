<cfcomponent displayname="Insurance_questiontypevalue" output="false" extends="Model">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("insurance_questiontypevalues") />
	</cffunction>
	
	<cffunction name="getQuestionValues" output="false" access="public" hint="">
		<cfargument name="questionid" type="numeric" required="true" />
		
		<cfset var listaWartosci = "" />
		<cfquery name="listaWartosci" datasource="#get('loc').datasource.intranet#">
			select id, questionid, questiontypevalue
			from insurance_questiontypevalues
			where questionid = <cfqueryparam value="#arguments.questionid#" cfsqltype="cf_sql_integer" />
		</cfquery>
		<cfreturn listaWartosci />
	</cffunction>
</cfcomponent>