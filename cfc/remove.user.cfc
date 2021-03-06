<cfcomponent
	displayname="user"
	hint="Komponent obsługujący użytkowników" >

	<cfproperty 
		name="datasource"
		default="intranet" />
	
	<cfproperty
		name="tablename"
		default="users" />
	
	<cfproperty
		name="user"
		type="any" /> 
		
	<cfset variables.instance = {
		datasource			=	'intranet',
		tablename			=	'users'} />
		
	<cffunction
		name="init">
		
		<cfargument
			name="id"
			type="numeric"
			required="true" />
			
		 <cfargument
			name="datasource"
			type="string"
			required="true" />
			
		<cfset variables.instance.datasource 	= arguments.datasource />
		<cfset variables.instance.user			= getUserSql(arguments.id) />
		
		<cfreturn this />
		
	</cffunction>
	
	<!---
		PUBLIC
	--->
	<cffunction
		name="get">
		
		<cfreturn variables.instance.user />
		
	</cffunction>
	
	<cffunction
		name="ban"
		hint="Motoda banowania użytkownika."
		description="Banowanie polega na ustawieniu daty zablokowania konta."
		access="public">
		
		<cfreturn banUserSql() />
		
	</cffunction>
	
	<!---
		PRIVATE
	--->
	<--- --------------------------------------------------------------------------------------- ----
	
	Blog Entry:
	Ask Ben: Converting A Query To A Struct
	
	Code Snippet:
	2
	
	Author:
	Ben Nadel / Kinky Solutions
	
	Link:
	http://www.bennadel.com/index.cfm?event=blog.view&id=149
	
	Date Posted:
	Jul 19, 2006 at 7:32 AM
	
	---- --------------------------------------------------------------------------------------- --->
	<cffunction name="QueryToStruct" access="public" returntype="any" output="false"
		hint="Converts an entire query or the given record to a struct. This might return a structure (single record) or an array of structures.">
			
		<!--- Define arguments. --->
		<cfargument name="Query" type="query" required="true" />
		<cfargument name="Row" type="numeric" required="false" default="0" />
		
		<cfscript>

			// Define the local scope.
			var LOCAL = StructNew();

			// Determine the indexes that we will need to loop over.
			// To do so, check to see if we are working with a given row,
			// or the whole record set.
			if (ARGUMENTS.Row){

				// We are only looping over one row.
				LOCAL.FromIndex = ARGUMENTS.Row;
				LOCAL.ToIndex = ARGUMENTS.Row;

			} else {

				// We are looping over the entire query.
				LOCAL.FromIndex = 1;
				LOCAL.ToIndex = ARGUMENTS.Query.RecordCount;

			}

			// Get the list of columns as an array and the column count.
			LOCAL.Columns = ListToArray( ARGUMENTS.Query.ColumnList );
			LOCAL.ColumnCount = ArrayLen( LOCAL.Columns );

			// Create an array to keep all the objects.
			LOCAL.DataArray = ArrayNew( 1 );

			// Loop over the rows to create a structure for each row.
			for (LOCAL.RowIndex = LOCAL.FromIndex ; LOCAL.RowIndex LTE LOCAL.ToIndex ; LOCAL.RowIndex = (LOCAL.RowIndex + 1)) {

				// Create a new structure for this row.
				ArrayAppend( LOCAL.DataArray, StructNew() );

				// Get the index of the current data array object.
				LOCAL.DataArrayIndex = ArrayLen( LOCAL.DataArray );

				// Loop over the columns to set the structure values.
				for (LOCAL.ColumnIndex = 1 ; LOCAL.ColumnIndex LTE LOCAL.ColumnCount ; LOCAL.ColumnIndex = (LOCAL.ColumnIndex + 1)) {

					// Get the column value.
					LOCAL.ColumnName = LOCAL.Columns[ LOCAL.ColumnIndex ];

					// Set column value into the structure.
					LOCAL.DataArray[ LOCAL.DataArrayIndex ][ LOCAL.ColumnName ] = ARGUMENTS.Query[ LOCAL.ColumnName ][ LOCAL.RowIndex ];

				}

			}
			
			// At this point, we have an array of structure objects that
			// represent the rows in the query over the indexes that we
			// wanted to convert. If we did not want to convert a specific
			// record, return the array. If we wanted to convert a single
			// row, then return the just that STRUCTURE, not the array.
			if (ARGUMENTS.Row) {

				// Return the first array item.
				return( LOCAL.DataArray[ 1 ] );

			} else {

				// Return the entire array.
				return( LOCAL.DataArray );

			}

		</cfscript>
	</cffunction>
	
	<!--- ---------------------------------------------------------------------
		Zbanowanie użytkownika
	--------------------------------------------------------------------- --->
	<cffunction
		name="banUserSql"
		hint="Metoda ustawiająca datę zablokowania konta."
		access="private">
		
		<cfquery
			datasource="#variables.instance.datasource#"
			name="userData"
			result="userSql" >
		
			update 
				#variables.instance.tablename#
			set 
				baned_to = #DateAdd("n", 10, Now())#
			where
				id = #variables.instance.user[1].id#
		
		</cfquery>
		
		<cfreturn userSql />
		
	</cffunction>
	
	
	<!--- ---------------------------------------------------------------------
		Pobranie danych użytkownika z bazy
	--------------------------------------------------------------------- --->
	<cffunction
		name="getUserSql"
		hint="Pobranie z bazy użytkownika o podanym id."
		description="Metoda używana w konstruktorze do pobierania danych użytkownika z tabeli."
		access="private"
		returntype="Any" >
			
		<cfargument
			name="id"
			type="numeric"
			default="true" />
		
		<cfquery
			dataSource = "#variables.instance.datasource#"
			result = "userSql"
			name="userData" >
				
			select
				id, created_date, last_login, valid_password_to, active, login,
				photo, modified_date, departmentid, password, expirationtime,
				companyemail, givenname, memberof, samaccountname, sn, mail,
				firstlogin, distinguishedName, manager, departmentname, lft,
				rgt, parent_id, smstoken, smsvalidtokento, smsauth, smsvalidto,
				store, logo, ispartner, position, redmineapikey, redmineid, isshop, isstore
			from
				#variables.instance.tablename#
			where
				id = #arguments.id#
			
		</cfquery>
		
		<cfreturn QueryToStruct(userData) />
		
	</cffunction>

</cfcomponent>