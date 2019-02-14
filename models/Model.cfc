<!---
	This is the parent model file that all your models should extend.
	You can add functions to this file to make them globally available in all your models.
	Do not delete this file.
--->
<cfcomponent extends="Wheels">

	<cffunction name="stripHtml" returnType="string">
		<cfargument name="text" type="string" default="" required="true">
		
		<cfset var loc.stripped = REReplaceNoCase(arguments.text, "<[^>]*>", "", "ALL")>
		
		<cfreturn loc.stripped>
	</cffunction>
	
		
	<!---
	Metody używane w całej aplikacji.
	--->
	
	<!--- http://www.bennadel.com/blog/149-Ask-Ben-Converting-A-Query-To-A-Struct.htm --->
	<cffunction name="QueryToStruct" access="public" returntype="any" output="false"
									hint="Converts an entire query or the given record to a struct. 
									This might return a structure (single record) or an array of structures.">
	
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
		for (LOCAL.RowIndex = LOCAL.FromIndex ; LOCAL.RowIndex LTE LOCAL.ToIndex ; LOCAL.RowIndex = (LOCAL.RowIndex + 1)){
		
		// Create a new structure for this row.
		ArrayAppend( LOCAL.DataArray, StructNew() );
		
		// Get the index of the current data array object.
		LOCAL.DataArrayIndex = ArrayLen( LOCAL.DataArray );
		
		// Loop over the columns to set the structure values.
		for (LOCAL.ColumnIndex = 1 ; LOCAL.ColumnIndex LTE LOCAL.ColumnCount ; LOCAL.ColumnIndex = (LOCAL.ColumnIndex + 1)){
		
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
		// if (ARGUMENTS.Row){
		//
		// Return the first array item.
		// return( LOCAL.DataArray[ 1 ] );
		//
		// } else {
		//
		// Return the entire array.
		// return( LOCAL.DataArray );
		
		//}
		
		</cfscript>
		
		<cfset jsonPacket = StructNew()>
		<cfset jsonPacket.rows = LOCAL.DataArray>
		<cfset jsonPacket.rowscount = ArrayLen(LOCAL.DataArray)>
		<cfset temp = ArrayAppend(LOCAL.DataArray, 1)>
		
		<cfreturn jsonPacket>
		
	</cffunction>
	
	<cffunction name="RandDateRange" access="public" returntype="date" output="false"
	hint="This returns a random date between the two given dates (inclusive).">
 
	<!--- Define arguments. --->
	<cfargument name="FromDate" type="date" required="true" />
	<cfargument name="ToDate" type="date" required="true" />
 
	<cfscript>

		// Define the local scope.
		var LOCAL = StructNew();

		// Get the difference in seconds between the two dates.
		LOCAL.TimeDifference = DateDiff( 
			"s", 
			ARGUMENTS.FromDate, 
			ARGUMENTS.ToDate 
			);

		// Create a random time increment based on the second difference. 
		// The time span object is a representation of time-length in 
		// terms of a single floating-point number.
		LOCAL.TimeIncrement = CreateTimeSpan(
			0, // Days
			0, // Hours
			0, // Minutes
			RandRange( // Seconds
				// Our smallest possible time increment.
				0,

				// Our largest possible time increment that will not 
				// put us past the ToDate.
				LOCAL.TimeDifference
				)
			);

		// Get a new random date based on the FromDate and the random
		// time span.
		LOCAL.RandomDate = (ARGUMENTS.FromDate + LOCAL.TimeIncrement);

		// This random date now is formatted like a TimeSpan object, 
		// meaning that it is in the form of one floating point number.
		return( LOCAL.RandomDate );

	</cfscript>
</cffunction>

</cfcomponent>