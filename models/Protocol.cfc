<cfcomponent extends="Model">

	<cffunction name="init">
	
		<cfset hasMany("protocolTypeAttribute") />
	
	</cffunction>
	
	<!---
		28.12.2012
		Metoda pobierająca listę protokołów utworzonych przez użytkownika.
		Parametry przekazane do metody pozwalają na paginację wyników. 
	--->
	<cffunction
		name="getUserProtocols"
		output="false">
			
		<cfargument
			name="userid"
			type="numeric"
			required="true" /> 
			
		<cfargument
			name="elements"
			type="numeric"
			required="true" />
			
		<cfargument
			name="page"
			type="numeric"
			required="true" />
		
		<cfstoredproc 
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_protocol_get_user_protocols"
			returnCode="No">
			
			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER" 
				value="#arguments.userid#"
				dbVarName="@_user_id" />
				
			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER" 
				value="#arguments.elements#"
				dbVarName="@_elements" />
				
			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER" 
				value="#arguments.page#"
				dbVarName="@_page" />
					
			<cfprocresult name="protocols" resultSet="1" />
		
		</cfstoredproc>
		
		<cfreturn protocols />
	
	</cffunction>
	
	<!---
		28.12.2012
		Metoda zwracająca liczbę protokołów utworzonych przez użytkownika.
		Metoda potrzebna do paginacji i wyliczeni ilości stron wyników.
	--->
	<cffunction
		name="getUserProtocolsCount"
		hint="Liczba protokołów uzytkownika">
	
		<cfargument
			name="userid"
			type="numeric"
			required="true" /> 
		
		<cfstoredproc 
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_protocol_get_user_protocols_count"
			returnCode="No">
			
			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER" 
				value="#arguments.userid#"
				dbVarName="@_user_id" />
					
			<cfprocresult name="protocols" resultSet="1" />
		
		</cfstoredproc>
		
		<cfreturn protocols />
	
	</cffunction>

</cfcomponent>