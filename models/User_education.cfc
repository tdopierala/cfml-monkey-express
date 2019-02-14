<cfcomponent displayname="User_education" output="false" extends="Model">

	<cffunction name="init" hint="" output="false" access="public">
		<cfset table("user_educations") />
	</cffunction>
	
	<cffunction name="getEducation" access="public" output="false" hint="">
		<cfargument name="userid" type="numeric" required="true" />
		
		<cfset var education = "" />
		<cfquery name="education" datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
				APPLICATION.cache.query.days,
				APPLICATION.cache.query.hours,
				APPLICATION.cache.query.minutes,
				APPLICATION.cache.query.seconds)#">
			
			select 
				ue.userid as userid
				,ue.education_stageid as stageid
				,ue.education_institutionid as institutionid
				,ue.institution_name as institution_name
				,ue.date_start as date_start
				,ue.date_end as date_end
				,ue.course as course
				,ue.specialization as specialization
				,ue.education_degreeid as degreeid
				,u.givenname as givenname
				,u.sn as sn
				,ed.degree_name as degree_name
				,es.stage_name as stage_name
				,ei.institution_type as ei_institution_type
				,ei.institution_name as ei_institution_name
			from user_educations ue
			left join education_stages es on ue.education_stageid = es.id
			left join education_institutions ei on ue.education_institutionid = ei.id
			inner join education_degrees ed on ue.education_degreeid = ed.id
			inner join users u on ue.userid = u.id
			where ue.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" /> 
			order by ue.date_start desc
		</cfquery>
		
		<cfreturn education />
	</cffunction>
</cfcomponent>