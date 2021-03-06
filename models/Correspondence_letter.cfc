<cfcomponent
	extends="Model">
		
	<cffunction
		name="init">
			
		<cfset table("correspondence_letters") />	
		
	</cffunction>
	
	<cffunction
		name="getLetters"
		hint="Pobieram listy z danego przedziału dat.">
		
		<cfargument
			name="data_od"
			default="#Now()#"
			required="false" />
			
		<cfargument
			name="data_do"
			default="#Now()#"
			required="false" />
			
		<cfquery
			name="query_get_letters"
			result="result_get_letters"
			datasource="#get('loc').datasource.intranet#">
				
			select
				l.id as id
				,t.typename as typename
				,l.typeid as typeid
				,l.letters_count as letters_count
				,l.data_nadania as data_nadania
			from correspondence_letters l
			left join correspondence_types t on l.typeid = t.id
			where Date_format(created, "%Y-%m-%d") between
					'#DateFormat(arguments.data_od, "yyyy-mm-dd")#' and
					'#DateFormat(arguments.data_do, "yyyy-mm-dd")#';
			
		</cfquery>
		
		<cfreturn query_get_letters />
			
	</cffunction>
	
	<cffunction
		name="getLettersCount"
		hint="Pobieram liczbę listów dodanych danego dnia">
			
		<cfargument
			name="data_od"
			default="#Now()#"
			required="false" />
			
		<cfargument
			name="data_do"
			default="#Now()#"
			required="false" />
			
		<cfquery
			name="query_get_letters_count"
			result="result_get_letters_count"
			datasource="#get('loc').datasource.intranet#" >
				
			select
				count(id) as c
			from correspondence_letters 
			where Date_format(created, "%Y-%m-%d") between
				'#DateFormat(arguments.data_od, "yyyy-mm-dd")#' and
				'#DateFormat(arguments.data_do, "yyyy-mm-dd")#';
				
		</cfquery>
		
		<cfreturn query_get_letters_count />
		
	</cffunction>
	
	<cffunction
		name="updateLetterField"
		hint="Aktualizuje wartość pola opisującego listy">
		
		<cfargument
			name="id"
			type="numeric"
			required="true" />
			
		<cfargument
			name="fieldname"
			type="string"
			required="true" />
			
		<cfargument
			name="fieldvalue"
			type="string"
			required="true" />
			
		<cfquery
			name="query_update_field"
			result="result_update_field"
			datasource="#get('loc').datasource.intranet#" >
		
			update correspondence_letters
			set #arguments.fieldname# = '#arguments.fieldvalue#'
			where id = #arguments.id#;
		
		</cfquery>
			 
		<cfreturn result_update_field />
			 
	</cffunction>
	
	<cffunction
		name="printLetters"
		hint="Pobieram listy z danego przedziału dat.">
		
		<cfargument
			name="data_od"
			default="#Now()#"
			required="false" />
			
		<cfargument
			name="data_do"
			default="#Now()#"
			required="false" />
			
		<cfquery
			name="query_print_letters"
			result="result_get_letters"
			datasource="#get('loc').datasource.intranet#">
				
			select
				l.id as id
				,t.typename as typename
				,l.typeid as typeid
				,l.letters_count as letters_count
				,l.data_nadania as data_nadania
			from correspondence_letters l
			left join correspondence_types t on l.typeid = t.id
			where Date_format(data_nadania, "%Y-%m-%d") between
					'#DateFormat(arguments.data_od, "yyyy-mm-dd")#' and
					'#DateFormat(arguments.data_do, "yyyy-mm-dd")#';
			
		</cfquery>
		
		<cfreturn query_print_letters />
			
	</cffunction>
		
</cfcomponent>