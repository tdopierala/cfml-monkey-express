<cfcomponent 
	extends="Model">

	<cffunction
		name="init">
	
		<cfset table("place_forms") />
	
	</cffunction>
	
	<cffunction 
		name="getAllForms"
		hint="Pobranie listy wszystkich formularzy">
	
		<cfset var allForms = "" />
		<cfquery 
			name="allForms" 
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#">
			
			select 
				f.id as id
				,f.formname as formname
				,f.formdescription as formdescription
				,(select count(id) from place_formfields where formid = f.id) as fieldcount
				,f.formcreated as formcreated
				,f.def as def
			from place_forms f
			
		</cfquery> 
		
		<cfreturn allForms />
	
	</cffunction>
	
	<cffunction 
		name="getFormsToSelectBox"
		hint="Pobranie listy formularzy do selectboxów">
	
		<cfstoredproc 
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_get_all_place_forms_selectbox"
			returnCode="No">
				
			<cfprocresult name="forms" resultSet="1" />
		
		</cfstoredproc>
		
		<cfreturn forms />
	
	</cffunction>
	
	<cffunction 
		name="getFormsByStep"
		hint="Pobranie listy formularzy dla danego etapu">
	
		<cfargument name="stepid" type="numeric" required="false" default="0" />
		
		<cfquery
			name="qStepForms"
			result="rStepForms"
			datasource="#get('loc').datasource.intranet#">
			
			select 
				sf.id as stepformid
				,f.formname as formname
				,f.formdescription as formdescription
				,f.formcreated as formcreated
				,f.id as id
				,(select count(id) from place_formfields ff where ff.formid = f.id) as fieldcount
				,<cfqueryparam value="#arguments.stepid#" cfsqltype="cf_sql_integer" /> as stepid
				,sf.defaultform as defaultform
			from place_stepforms sf
			inner join place_forms f on sf.formid = f.id
			where sf.stepid = <cfqueryparam value="#arguments.stepid#" cfsqltype="cf_sql_integer" />
  		
		</cfquery>
		
		<cfreturn qStepForms />
	
	</cffunction>
	
	<cffunction 
		name="getFormsByStepSummary"
		hint="Pobranie nazw formularzy dla etapu obiegu nieruchomości i 
				wyliczenie % ich ukończenia">
	
		<cfargument name="instanceid" type="numeric" default="0" required="true" />
		<cfargument name="stepid" type="numeric" default="0" required="true" />
		
		<cfquery
			name="qFormsByStepSummary"
			result="rFormsByStepSummary"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#">
			
			select
				sf.id as placestepformid
				,<cfqueryparam value="#arguments.stepid#" cfsqltype="cf_sql_integer" /> as step_id
				,<cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" /> as instance_id
				,f.formname as formname
				,f.id as formid
				,IFNULL(af.allfields, 0) as allfields
				,IFNULL(ff.filledfield, 0) as filledfield
				,IFNULL(a.accepted, 0) as accepted
									
			from place_stepforms sf
			inner join place_forms f on sf.formid = f.id
			left join cache_place_forms_allfields af on (sf.formid= af.formid)
			left join cache_place_forms_filledfields ff on (sf.formid = ff.formid and ff.instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />)
			left join cache_place_forms_accepted a on (sf.formid = a.formid and a.instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />)
			where sf.stepid = <cfqueryparam value="#arguments.stepid#" cfsqltype="cf_sql_integer" />;

			<!---
			select
				sf.id as placestepformid
				,<cfqueryparam value="#arguments.stepid#" cfsqltype="cf_sql_integer" /> as step_id
				,<cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" /> as instance_id
				,f.formname as formname
				,f.id as formid
				,(select count(id) 
					from place_instanceforms pif
					where pif.instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" /> 
						and pif.formid = f.id) as allfields
				
				,(select count(id) 
					from place_instanceforms pif2 
					where pif2.instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" /> 
						and pif2.formid = f.id 
						and pif2.formfieldvalue <> '') as filledfield
						
				,(select sum(accepted) 
					from place_instanceforms pif3 
					where pif3.instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" /> 
						and pif3.formid =f.id) as accepted
						
			from place_stepforms sf
			inner join place_forms f on sf.formid = f.id
			where sf.stepid = <cfqueryparam value="#arguments.stepid#" cfsqltype="cf_sql_integer" />
			--->
		</cfquery>
		
		<cfreturn qFormsByStepSummary />
	
	</cffunction>
	
	<!--- 
		Pobranie pól formularza.
	--->
	<cffunction 
		name="getFormFields" >
		
		<cfargument name="formid" type="numeric" default="0" required="true" />
		<cfargument name="instanceid" type="numeric" default="0" required="true" />
		
		<cfstoredproc 
			procedure="sp_intranet_get_place_instance_get_form_fields" 
			datasource="#get('loc').datasource.intranet#" 
			returncode="false" >
			
			<cfprocparam 
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.formid#"
				dbVarName="@form_id" />
			
			<cfprocparam 
				cfsqltype="CF_SQL_INTEGER" 
				value="#arguments.instanceid#" 
				type="in" 
				dbvarname="@instance_id" />
				
			<cfprocresult name="fields" >
			
		</cfstoredproc>
		
		<cfreturn fields />
	</cffunction>
	
	<cffunction
		name="getFormNotes"
		hint="Metoda pobierająca listę notaket do formularza">
	
		<cfargument name="formid" type="numeric" default="0" required="true" />
		<cfargument name="instanveid" type="numeric" default="0" required="true" />
		
		<cfstoredproc 
			procedure="sp_intranet_get_place_form_notes" 
			datasource="#get('loc').datasource.intranet#" 
			returncode="false" >
			
			<cfprocparam 
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.formid#"
				dbVarName="@form_id" />
				
			<cfprocparam 
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.instanceid#"
				dbVarName="@instance_id" />
				
			<cfprocresult name="notes" >
			
		</cfstoredproc>
		
		<cfreturn notes />
	
	</cffunction>

</cfcomponent>