<cfcomponent extends="Model">
	
	<cffunction name="init">
		
		<cfset table('users_structure') />
		
	</cffunction>
	
	<cffunction name="usersStructureView" 
		hint="Metoda wyciąga struktóre organizacyjną w postaci drzewa nested set">
		
		<cfstoredproc 
			datasource="#get('loc').datasource.intranet#" 
			procedure="sp_intranet_users_structure"
			returncode="false" >
			
			<cfprocresult name="structure" resultSet="1" />
			
		</cfstoredproc>
		
		<cfreturn structure />
		
	</cffunction>
	
	<cffunction name="moveStructureElement" 
		hint="Zmiana miejsca położenia elementu w strukturze">
		
		<cfargument name="myid" type="numeric" required="true" />
		
		<cfargument name="rootid" type="numeric" required="true" />
		
		<cfstoredproc 
			datasource="#get('loc').datasource.intranet#" 
			procedure="sp_intranet_users_structure_move"
			returncode="false" >
			
			<cfprocparam cfsqltype="CF_SQL_INTEGER" type="in" value="#arguments.myid#" dbVarName="@my_root">
			
			<cfprocparam cfsqltype="CF_SQL_INTEGER" type="in" value="#arguments.rootid#" dbVarName="@new_parent">
			
		</cfstoredproc>
		
	</cffunction>
	
	<cffunction name="addStructureElement" 
		hint="Dodanie nowego elementu do struktury">
		
		<cfargument name="_type" type="numeric" required="true" />
		
		<cfargument name="_name" type="string" required="true" />
		
		<cfargument name="_uid" type="any" required="false" />
		
		<cfstoredproc 
			datasource="#get('loc').datasource.intranet#" 
			procedure="sp_intranet_users_structure_add"
			returncode="false" >
			
			<cfprocparam cfsqltype="CF_SQL_INTEGER" type="in" value="#arguments._uid#" dbVarName="@_keyid">
			
			<cfprocparam cfsqltype="CF_SQL_INTEGER" type="in" value="#arguments._type#" dbVarName="@_type">
			
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" type="in" value="#arguments._name#" dbVarName = "@_name">
			
		</cfstoredproc>
		
	</cffunction>
	
	<cffunction name="deleteStructureElement"
		hint="Usuwanie elementu ze struktury organizacyjnej">
		
		<cfargument name="_id" type="any" required="false" />
		
		<cfstoredproc 
			datasource="#get('loc').datasource.intranet#" 
			procedure="sp_intranet_users_structure_delete"
			returncode="false" >
			
			<cfprocparam cfsqltype="CF_SQL_INTEGER" type="in" value="#arguments._id#" dbVarName="@_id">
			
		</cfstoredproc>
		
	</cffunction>
	
</cfcomponent>