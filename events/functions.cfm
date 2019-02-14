<!--- Place functions here that should be globally available in your application. --->

<cffunction name="appendToWhere" returntype="string" output="false">
	<cfargument name="where" type="string" required="true">
	<cfargument name="append" type="string" required="true">
	<cfargument name="operator" type="string" default="AND">

	<cfif Len(arguments.where)>
		<cfset arguments.where = arguments.where & " #UCase(arguments.operator)# ">
	</cfif>

	<cfset arguments.where = arguments.where & "(" & arguments.append & ")">

	<cfreturn arguments.where>
</cffunction>

<!--- http://www.bennadel.com/blog/149-Ask-Ben-Converting-A-Query-To-A-Struct.htm --->
<cffunction
	name="QueryToStruct"
	access="public"
	returntype="any"
	output="false"
	hint="Converts an entire query or the given record to a struct. This might
			return a structure (single record) or an array of structures.">

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
		for (
			LOCAL.RowIndex = LOCAL.FromIndex ;
			LOCAL.RowIndex LTE LOCAL.ToIndex ;
			LOCAL.RowIndex = (LOCAL.RowIndex + 1)) {

			// Create a new structure for this row.
			ArrayAppend( LOCAL.DataArray, StructNew() );

			// Get the index of the current data array object.
			LOCAL.DataArrayIndex = ArrayLen( LOCAL.DataArray );

			// Loop over the columns to set the structure values.
			for (
				LOCAL.ColumnIndex = 1 ;
				LOCAL.ColumnIndex LTE LOCAL.ColumnCount ;
				LOCAL.ColumnIndex = (LOCAL.ColumnIndex + 1)) {

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

<cffunction
	name="QueryToCSV"
	access="public"
	returntype="string"
	output="false"
	hint="I take a query and convert it to a comma separated value string.">
 
	<!--- Define arguments. --->
	<cfargument
		name="Query"
		type="query"
		required="true"
		hint="I am the query being converted to CSV."
		/>
 
	<cfargument
		name="Fields"
		type="string"
		required="true"
		hint="I am the list of query fields to be used when creating the CSV value."
		/>
 
	<cfargument
		name="CreateHeaderRow"
		type="boolean"
		required="false"
		default="true"
		hint="I flag whether or not to create a row of header values."
		/>
 
	<cfargument
		name="Delimiter"
		type="string"
		required="false"
		default=","
		hint="I am the field delimiter in the CSV value."
		/>
 
	<!--- Define the local scope. --->
	<cfset var LOCAL = {} />
 
	<!---
		First, we want to set up a column index so that we can
		iterate over the column names faster than if we used a
		standard list loop on the passed-in list.
	--->
	<cfset LOCAL.ColumnNames = [] />
 
	<!---
		Loop over column names and index them numerically. We
		are working with an array since I believe its loop times
		are faster than that of a list.
	--->
	<cfloop
		index="LOCAL.ColumnName"
		list="#ARGUMENTS.Fields#"
		delimiters=",">
 
		<!--- Store the current column name. --->
		<cfset ArrayAppend(
			LOCAL.ColumnNames,
			Trim( LOCAL.ColumnName )
			) />
 
	</cfloop>
 
	<!--- Store the column count. --->
	<cfset LOCAL.ColumnCount = ArrayLen( LOCAL.ColumnNames ) />
 
 
	<!---
		Now that we have our index in place, let's create
		a string buffer to help us build the CSV value more
		effiently.
	--->
	<cfset LOCAL.Buffer = CreateObject( "java", "java.lang.StringBuffer" ).Init() />
 
	<!--- Create a short hand for the new line characters. --->
	<cfset LOCAL.NewLine = (Chr( 13 ) & Chr( 10 )) />
 
 
	<!--- Check to see if we need to add a header row. --->
	<cfif ARGUMENTS.CreateHeaderRow>
 
		<!--- Create array to hold row data. --->
		<cfset LOCAL.RowData = [] />
 
		<!--- Loop over the column names. --->
		<cfloop
			index="LOCAL.ColumnIndex"
			from="1"
			to="#LOCAL.ColumnCount#"
			step="1">
 
			<!--- Add the field name to the row data. --->
			<cfset LOCAL.RowData[ LOCAL.ColumnIndex ] = """#LOCAL.ColumnNames[ LOCAL.ColumnIndex ]#""" />
 
		</cfloop>
 
		<!--- Append the row data to the string buffer. --->
		<cfset LOCAL.Buffer.Append(
			JavaCast(
				"string",
				(
					ArrayToList(
						LOCAL.RowData,
						ARGUMENTS.Delimiter
						) &
					LOCAL.NewLine
				))
			) />
 
	</cfif>
 
 
	<!---
		Now that we have dealt with any header value, let's
		convert the query body to CSV. When doing this, we are
		going to qualify each field value. This is done be
		default since it will be much faster than actually
		checking to see if a field needs to be qualified.
	--->
 
	<!--- Loop over the query. --->
	<cfloop query="ARGUMENTS.Query">
 
		<!--- Create array to hold row data. --->
		<cfset LOCAL.RowData = [] />
 
		<!--- Loop over the columns. --->
		<cfloop
			index="LOCAL.ColumnIndex"
			from="1"
			to="#LOCAL.ColumnCount#"
			step="1">
 
			<!--- Add the field to the row data. --->
			<cfset LOCAL.RowData[ LOCAL.ColumnIndex ] = """#Replace( ARGUMENTS.Query[ LOCAL.ColumnNames[ LOCAL.ColumnIndex ] ][ ARGUMENTS.Query.CurrentRow ], """", """""", "all" )#""" />
 
		</cfloop>
 
 
		<!--- Append the row data to the string buffer. --->
		<cfset LOCAL.Buffer.Append(
			JavaCast(
				"string",
				(
					ArrayToList(
						LOCAL.RowData,
						ARGUMENTS.Delimiter
						) &
					LOCAL.NewLine
				))
			) />
 
	</cfloop>
 
 
	<!--- Return the CSV value. --->
	<cfreturn LOCAL.Buffer.ToString() />
</cffunction>

<cffunction
	name="QueryToCSV2"
	access="public"
	returntype="string"
	output="false"
	hint="I take a query and convert it to a comma separated value string.">
 
	<!--- Define arguments. --->
	<cfargument
		name="Query"
		type="query"
		required="true"
		hint="I am the query being converted to CSV."
		/>
 
	<cfargument
		name="Fields"
		type="string"
		required="true"
		hint="I am the list of query fields to be used when creating the CSV value."
		/>
 
	<cfargument
		name="CreateHeaderRow"
		type="boolean"
		required="false"
		default="true"
		hint="I flag whether or not to create a row of header values."
		/>
 
	<cfargument
		name="Delimiter"
		type="string"
		required="false"
		default=","
		hint="I am the field delimiter in the CSV value."
		/>
 
	<!--- Define the local scope. --->
	<cfset var LOCAL = {} />
 
	<!---
		First, we want to set up a column index so that we can
		iterate over the column names faster than if we used a
		standard list loop on the passed-in list.
	--->
	<cfset LOCAL.ColumnNames = [] />
 
	<!---
		Loop over column names and index them numerically. We
		are going to be treating this struct almost as if it
		were an array. The reason we are doing this is that
		look-up times on a table are a bit faster than look
		up times on an array (or so I have been told).
	--->
	<cfloop
		index="LOCAL.ColumnName"
		list="#ARGUMENTS.Fields#"
		delimiters=",">
 
		<!--- Store the current column name. --->
		<cfset ArrayAppend(
			LOCAL.ColumnNames,
			Trim( LOCAL.ColumnName )
			) />
 
	</cfloop>
 
	<!--- Store the column count. --->
	<cfset LOCAL.ColumnCount = ArrayLen( LOCAL.ColumnNames ) />
 
 
	<!--- Create a short hand for the new line characters. --->
	<cfset LOCAL.NewLine = (Chr( 13 ) & Chr( 10 )) />
 
	<!--- Create an array to hold the set of row data. --->
	<cfset LOCAL.Rows = [] />
 
 
	<!--- Check to see if we need to add a header row. --->
	<cfif ARGUMENTS.CreateHeaderRow>
 
		<!--- Create array to hold row data. --->
		<cfset LOCAL.RowData = [] />
 
		<!--- Loop over the column names. --->
		<cfloop
			index="LOCAL.ColumnIndex"
			from="1"
			to="#LOCAL.ColumnCount#"
			step="1">
 
			<!--- Add the field name to the row data. --->
			<cfset LOCAL.RowData[ LOCAL.ColumnIndex ] = """#LOCAL.ColumnNames[ LOCAL.ColumnIndex ]#""" />
 
		</cfloop>
 
		<!--- Append the row data to the string buffer. --->
		<cfset ArrayAppend(
			LOCAL.Rows,
			ArrayToList( LOCAL.RowData, ARGUMENTS.Delimiter )
			) />
 
	</cfif>
 
 
	<!---
		Now that we have dealt with any header value, let's
		convert the query body to CSV. When doing this, we are
		going to qualify each field value. This is done be
		default since it will be much faster than actually
		checking to see if a field needs to be qualified.
	--->
 
	<!--- Loop over the query. --->
	<cfloop query="ARGUMENTS.Query">
 
		<!--- Create array to hold row data. --->
		<cfset LOCAL.RowData = [] />
 
		<!--- Loop over the columns. --->
		<cfloop
			index="LOCAL.ColumnIndex"
			from="1"
			to="#LOCAL.ColumnCount#"
			step="1">
 
			<!--- Add the field to the row data. --->
			<cfset LOCAL.RowData[ LOCAL.ColumnIndex ] = """#Replace( ARGUMENTS.Query[ LOCAL.ColumnNames[ LOCAL.ColumnIndex ] ][ ARGUMENTS.Query.CurrentRow ], """", """""", "all" )#""" />
 
		</cfloop>
 
 
		<!--- Append the row data to the string buffer. --->
		<cfset ArrayAppend(
			LOCAL.Rows,
			ArrayToList( LOCAL.RowData, ARGUMENTS.Delimiter )
			) />
 
	</cfloop>
 
 
	<!---
		Return the CSV value by joining all the rows together
		into one string.
	--->
	<cfreturn ArrayToList(
		LOCAL.Rows,
		LOCAL.NewLine
		) />
</cffunction>

<!---<cffunction name="styleSheetIncludeToController">
	<cfscript>
		style = params.controller;

		filename = ExpandPath('stylesheets/' & style & '.css');
		if (FileExists(filename)) {
			return styleSheetLinkTag(style);
		}

	</cfscript>
</cffunction>--->

<!---
 Capitalizes the first letter in each word.
 Made udf use strlen, rkc 3/12/02
 v2 by Sean Corfield.
 
 @param string      String to be modified. (Required)
 @return Returns a string. 
 @author Raymond Camden (ray@camdenfamily.com) 
 @version 2, March 9, 2007 
--->
<cffunction name="CapFirst" returntype="string" output="false">
    <cfargument name="str" type="string" required="true" />
    
    <cfset var newstr = "" />
    <cfset var word = "" />
    <cfset var separator = "" />
    
    <cfloop index="word" list="#arguments.str#" delimiters=" ">
        <cfset newstr = newstr & separator & UCase(left(word,1)) />
        <cfif len(word) gt 1>
            <cfset newstr = newstr & right(word,len(word)-1) />
        </cfif>
        <cfset separator = " " />
    </cfloop>

    <cfreturn newstr />
</cffunction>

<!---
	Funkcja usuwa powtarzające się elementy z listy 
 --->
<cffunction name="ListDuplicateRemove">
	<cfargument name="str" type="string" required="true" />
	<cfif str neq ''>
		<cfset listStruct = {} />
		<cfloop list="#str#" index="i">
			<cfset listStruct[i] = i />
		</cfloop>
		<cfset _result = structKeyList(listStruct) />
		<cfreturn _result />
	<cfelse>
		<cfreturn false />
	</cfif>
</cffunction>

<cffunction name="GetIconForFile" access="public" returntype="any" output="false">
	<cfargument name="filename" type="string" required="true" />
	
	<cfif Len(arguments.filename) gt 0>
		<cfset arr = ListToArray(arguments.filename, ".") />
		<cfset ext = arr[ArrayLen(arr)] />
		<cfswitch expression="#ext#">
			<cfcase value="xls">
				<cfreturn "excel-icon.png" />
			</cfcase>
			<cfcase value="xlsx">
				<cfreturn "excel-icon.png" />
			</cfcase>
			<cfcase value="doc">
				<cfreturn "file-word.png" />
			</cfcase>
			<cfcase value="docx">
				<cfreturn "file-word.png" />
			</cfcase>
			<cfcase value="pdf">
				<cfreturn "file-pdf.png" />
			</cfcase>
			<cfcase value="jpg">
				<cfreturn "file-img.png" />
			</cfcase>
			<cfcase value="jpeg">
				<cfreturn "file-img.png" />
			</cfcase>
			<cfcase value="png">
				<cfreturn "file-img.png" />
			</cfcase>
			<cfdefaultcase>
				<cfreturn "blank.png" />
			</cfdefaultcase>
		</cfswitch>	
	<cfelse>
		<cfreturn "blank.png" />
	</cfif>
	<!---<cfreturn ext>--->
</cffunction>