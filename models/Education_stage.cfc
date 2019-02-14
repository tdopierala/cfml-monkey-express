<cfcomponent displayname="Education_stage" extends="Model" output="false">

	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("education_stages") />
	</cffunction>
	
	<cffunction name="getStages" output="false" access="public" hint="">
		<cfset var stages = "" />
		
		<cfquery name="stages" datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
				APPLICATION.cache.query.days,
				APPLICATION.cache.query.hours,
				APPLICATION.cache.query.minutes,
				APPLICATION.cache.query.seconds)#">
				
			select id, stage_name from education_stages;
			
		</cfquery>
		
		<cfreturn stages />
	</cffunction>
	
</cfcomponent>