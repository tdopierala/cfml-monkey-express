<cfcomponent displayname="User_course" extends="Model" hint="">

	<cffunction name="init" access="public" hint="">
		<cfset table("user_courses") />
	</cffunction>
	
	<cffunction name="getCourses" access="public" output="false" hint="">
		<cfargument name="userid" type="numeric" required="true" />
		
		<cfset var userCourses = "" />
		<cfquery name="userCourses" datasource="#get('loc').datasource.intranet#" 
			cachedwithin="#createTimeSpan(
				APPLICATION.cache.query.days,
				APPLICATION.cache.query.hours,
				APPLICATION.cache.query.minutes,
				APPLICATION.cache.query.seconds)#">
			select
				u.givenname as givenname
				,u.sn as sn
				,u.id as userid
				,c.course_name as course_name
				,c.course_certificate_name as certificate_name
				,c.course_stand_from as stand_from
				,c.course_stand_to as stand_to
				,c.course_certificate_number as certificate_number
				,c.course_date_from as date_from
				,c.course_date_to as date_to
			from user_courses c 
				inner join users u on c.userid = u.id
			where c.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
			order by c.course_date_from desc
		</cfquery>
		
		<cfreturn userCourses />
	</cffunction>

</cfcomponent>