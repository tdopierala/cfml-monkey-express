<cfcomponent 
	extends="Model">

	<cffunction 
		name="init">
	
		<cfset table("place_phototypes") />
	
	</cffunction>
	
	<cffunction 
		name="getPhotoTypesToSelectBox"
		hint="Pobranie listy typów zdjęć do selectboxów">
	
		<cfstoredproc 
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_get_place_photo_types_selectbox"
			returnCode="No">
				
			<cfprocresult name="phototypes" resultSet="1" />
		
		</cfstoredproc>

		<cfreturn phototypes />
	
	</cffunction>
	
	<cffunction 
		name="getAllPhotoTypes"
		hint="Pobranie listy typów zdjęć">
	
		<cfstoredproc 
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_get_all_place_photo_types"
			returnCode="No">
				
			<cfprocresult name="phototypes" resultSet="1" />
		
		</cfstoredproc>

		<cfreturn phototypes />
	
	</cffunction>
	
	<cffunction 
		name="getPhotoTypesByStep"
		hint="Pobranie typów zdjęć dla danego etapu">
	
		<cfargument name="step_id" type="numeric" required="true" default="0" />
		
		<cfstoredproc 
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_get_place_photo_types_by_step"
			returnCode="No">
			
			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.stepid#"
				dbVarName="@step_id" />
					
			<cfprocresult name="phototypes" resultSet="1" />
		
		</cfstoredproc>
		
		<cfreturn phototypes />
	
	</cffunction>
	
	<cffunction 
		name="getPhotosByStepSummary"
		hint="Pobranie listy zdjęć przypisanych do etapu obiegu nieruchomości" >
		
		<cfargument name="instanceid" type="numeric" default="0" required="true" />
		<cfargument name="stepid" type="numeric" default="0" required="true" />
		
		<cfstoredproc
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_get_place_instance_step_photo_types"
			returncode="false" >
		
			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.instanceid#"
				dbVarName="@instance_id" />
			
			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.stepid#"
				dbVarName="@step_id" />
			
			<cfprocresult name="photos" resultSet="1" />
		
		</cfstoredproc>
		
		<cfreturn photos />
		
	</cffunction>
	
	<cffunction
		name="getInstancePhotoTypes"
		hint="Metoda pobierająca listę plików danego typu dla instancji nieruchomości">
	
		<cfargument name="instanceid" default="0" type="numeric" required="true" />
		<cfargument name="phototypeid" default="0" type="numeric" required="true" />
		
		<cfset var zdjecia = "" />
		<cfquery name="zdjecia" datasource="#get('loc').datasource.intranet#" cachedwithin="#createTimespan(APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#" >
			select 
				ipt.id as id
				,ipt.phototypecreated as phototypecreated
				,ipt.phototypesrc as phototypesrc
				,ipt.phototypename as phototypename
				,ipt.phototypethumb as phototypethumb
				,ipt.userid as userid
				,u.givenname as givenname
				,u.sn as sn
				,u.position as position
			from place_instancephototypes ipt
			inner join users u on ipt.userid = u.id
			where ipt.instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />
				and ipt.phototypeid = <cfqueryparam value="#arguments.phototypeid#" cfsqltype="cf_sql_integer" />;
		</cfquery>
		
		<cfreturn zdjecia />
	
	</cffunction>
	
	<cffunction
		name="photoReport"
		hint="Metoda generująca raport ze zdjęć dodanych do nieruchomości">
		
		<cfargument
			name="instanceid"
			type="numeric" 
			required="true" />
			
		<cfquery name="query_photo_report" datasource="#get('loc').datasource.intranet#" result="result_photo_report" cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#">
				
			select
				p.phototypesrc
				,pt.phototypename
			from place_instancephototypes p
			inner join place_phototypes pt on p.phototypeid = pt.id
			where p.instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
				
		</cfquery>
		
		<cfreturn query_photo_report />
		
	</cffunction>

</cfcomponent>