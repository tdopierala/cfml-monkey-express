<cfcomponent
	extends="Model">

	<cffunction
		name="init">
	
		<cfset table("place_instanceformcomments") />
	
	</cffunction>
	
	<cffunction
		name="getComments"
		hint="Pobranie listy komentarzy do odpowiedniego pola formularza">
	
		<cfargument name="instanceformid" type="numeric" default="0" required="true" />
		
		<cfstoredproc 
			procedure="sp_intranet_place_get_instance_form_comments" 
			datasource="#get('loc').datasource.intranet#" 
			returncode="false" >
			
			<cfprocparam 
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.instanceformid#"
				dbVarName="@instanceform_id" />
				
			<cfprocresult name="comments" >
			
		</cfstoredproc>
		
		<cfreturn comments />
	
	</cffunction>
		
</cfcomponent>