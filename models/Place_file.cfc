<cfcomponent 
	extends="Model">

	<cffunction 
		name="init">
	
		<cfset table("place_filetypes") />
	
	</cffunction>
	
	<cffunction 
		name="getAllPlaceFileTypes"
		hint="Pobranie listy wszystkich typów plików">
	
		<cfstoredproc 
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_get_all_place_file_types"
			returnCode="No">
				
			<cfprocresult name="filetypes" resultSet="1" />
		
		</cfstoredproc>

		<cfreturn filetypes />
	
	</cffunction>
	
	<cffunction 
		name="getAllPlaceFileTypeToSelectBox"
		hint="Pobranie listy typów plików do selectbox">
	
		<cfstoredproc 
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_get_all_place_file_types_selectbox"
			returnCode="No">
				
			<cfprocresult name="filetypes" resultSet="1" />
		
		</cfstoredproc>

		<cfreturn filetypes />
	
	</cffunction>
	
	<cffunction 
		name="getAllFileTypesByStep"
		hint="Pobranie listy typów plików dla etapu">
	
		<cfargument name="step_id" type="numeric" required="true" default="0" />
		
		<cfstoredproc 
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_get_all_place_file_types_by_step"
			returnCode="No">
			
			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.stepid#"
				dbVarName="@step_id" />
					
			<cfprocresult name="filetypes" resultSet="1" />
		
		</cfstoredproc>
		
		<cfreturn filetypes />
	
	</cffunction>
	
	<cffunction 
		name="getFilesByStepSummary"
		hint="Pobranie listy plików do umieszczenia w danym kroku obiegu nieruchomości" >
			
		<cfargument name="instanceid" default="0" type="numeric" required="true" />
		<cfargument name="stepid" default="0" type="numeric" required="true" />
		
		<cfstoredproc
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_get_place_instance_step_file_types"
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
			
			<cfprocresult name="files" resultSet="1" />
		
		</cfstoredproc>
		
		<cfreturn files />
		
	</cffunction>
	
	<cffunction name="getInstanceFilesByType" hint="Pobranie listy plików danego typu w danym kroku." description="Argumentami funkcji jest id typu pliku oraz id instancji nieruchomości.">
		
		<cfargument name="instanceid" type="numeric" required="true" default="0" />
		<cfargument name="filetypeid" type="numeric" required="true" default="0" />
		
		<cfset var pliki = "" />
		<cfquery name="pliki" datasource="#get('loc').datasource.intranet#" cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#">
			select
				ift.id as id 
				,ift.instanceid as instanceid
				,ift.fileid as fileid
				,ift.filetypeid as filetypeid
				,ft.filetypename as filetypename
				,ift.filesrc as filesrc
				,ift.filename as filename
				,ift.userid as userid
				,ift.filetypedescription as filetypedescription
				,u.givenname as givenname
				,u.sn as sn
				,'' as position
				,ift.filecreated as filecreated
				,ift.filetypethumb as filetypethumb
				,(select count(id) from place_instancefiletypecomments a where a.instancefiletypeid = ift.id) as commentscount
			from place_instancefiletypes ift
			inner join place_filetypes ft on ift.filetypeid = ft.id
			inner join users u on ift.userid = u.id
			where ift.filetypeid = <cfqueryparam value="#arguments.filetypeid#" cfsqltype="cf_sql_integer" /> 
				and ift.instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;

		</cfquery>
		
		<cfreturn pliki />
		
	</cffunction>

</cfcomponent>