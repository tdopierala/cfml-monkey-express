<cfcomponent displayname="Insurance_instancequestion" output="false" extends="Model">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("insurance_instancequestions") />
	</cffunction>
	
	<cffunction name="getInstanceQuestions" output="false" access="public" hint="">
		<cfargument name="instanceid" type="numeric" required="true" />
		
		<cfset var listaPytan = "" />
		<cfquery name="listaPytan" datasource="#get('loc').datasource.intranet#">
			select iq.id, iq.answer, q.question, q.lft, q.rgt, q.questiontypeid, q.id as questionid
			from insurance_instancequestions iq
			inner join insurance_questions q on iq.questionid = q.id
			where iq.instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
		</cfquery>
		
		<cfreturn listaPytan />
	</cffunction>
	
	<cffunction name="update" output="false" access="public" hint="">
		<cfargument name="id" type="numeric" required="true" />
		<cfargument name="answer" type="string" required="true" />
		
		<cfset var odpowiedz = "" />
		<cfquery name="odpowiedz" datasource="#get('loc').datasource.intranet#">
			update insurance_instancequestions 
			set answer = <cfqueryparam value="#arguments.answer#" cfsqltype="cf_sql_varchar" />
			where id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />;
		</cfquery>
		
		<cfreturn true />
	</cffunction>
</cfcomponent>