<cfthread action="run" name="prestockReport" priority="NORMAL" >
<cfsetting requesttimeout="3600" />

<cfset local = {} />
<cfset local.ColumnNames = ['upc', 'sklep', 'prestock'] />
<cfset local.ColumnCount = arrayLen(local.ColumnNames) />
<cfset local.Buffer = createObject( "java", "java.lang.StringBuffer" ).init() />
<cfset local.NewLine = ( Chr(13) & Chr(10) ) />

<cfset fName = "files/raport_prestock/RaportSieci[#DateFormat(Now(), "yyyy-mm-dd")#].csv" />
<cfset fSrc = expandPath( fName ) />

<cfif not fileExists( fSrc )>
	<cfset fileWrite( fSrc, "" ) />
</cfif>
<cfset fileObj = FileOpen( fSrc, "append" ) />

<cfset local.RowData = [] />
<!---<cfset local.ColumnName = 1 />--->
<cfloop index="ColumnName" from="1" to="#local.ColumnCount#" step="1">
	<cfset local.RowData[ColumnName] = """#local.ColumnNames[ColumnName]#""" /> 
</cfloop>
	
<cfset local.Buffer.Append( JavaCast( "string", arrayToList( local.RowData, "," ) & local.NewLine ) ) />

<cfmail from="intranet@monkey.xyz" subject="prestock" to="admin@monkey.xyz" type="html">
	Zaczynam prestock<br />
	<cfdump var="#local#" />
</cfmail>

<cfloop query="indeksy">
	<cfinvoke method="prestockIndeksu" component="models.Store_store" returnvariable="raportPrestock" >
		<cfinvokeargument name="upc" value="#indeksy.upc#" />
	</cfinvoke>
	<!---<cfset var raportPrestock = model("store_store").prestockIndeksu(upc = indeksy.upc) />--->
			
	<cfloop query="raportPrestock">
		<cfset local.RowData = [] />
		<cfloop index="ColumnIndex" from="1" to="#local.ColumnCount#" step="1">
			<cfset local.RowData[ColumnIndex] = """#Replace( raportPrestock[ local.ColumnNames[ ColumnIndex ] ][ raportPrestock.CurrentRow ], """", """""", "all" )#""" />
		</cfloop>
				
		<cfset local.Buffer.Append( JavaCast( "string", arrayToList( local.RowData, "," ) & local.NewLine ) ) />
	</cfloop>
			
	<cfset FileWrite( fileObj, local.Buffer.toString() ) />
	<cfset local.Buffer.setLength(0) />
</cfloop>
			
<cfset fileClose( fileObj ) />		

<cfmail from="intranet@monkey.xyz" subject="prestock" to="admin@monkey.xyz" type="html">
	Skończyłem prestock<br />
	<cfdump var="#fileObj#" />
</cfmail>

</cfthread>