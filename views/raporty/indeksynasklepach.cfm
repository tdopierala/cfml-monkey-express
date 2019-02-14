<!---<cfsilent>--->
	<cfset LOCAL = {} />
	<cfset LOCAL.ColumnNames = [] />
	
	<cfloop index="tmp" list="#indeksyNaSklepach.ColumnList#" delimiters=",">
		<cfset arrayAppend(LOCAL.ColumnNames, Trim(tmp)) />
	</cfloop>
	
	<cfset LOCAL.ColumnCount = arrayLen(LOCAL.ColumnNames) />
	<cfset LOCAL.Buffer = createObject( "java", "java.lang.StringBuffer" ).init() />
	<cfset LOCAL.NewLine = ( Chr(13) & Chr(10) ) />
	
	<cfset LOCAL.RowData = [] />
	<cfloop index="tmp" from="1" to="#LOCAL.ColumnCount#" step="1">
		<cfset LOCAL.RowData[tmp] = """#LOCAL.ColumnNames[tmp]#""" /> 
	</cfloop>
	
	<cfset LOCAL.Buffer.Append( JavaCast( "string", arrayToList( LOCAL.RowData, "," ) & LOCAL.NewLine ) ) />
	
	<cfloop query="indeksyNaSklepach">
		<cfset LOCAL.RowData = [] />
		
		<cfloop index="tmp" from="1" to="#LOCAL.ColumnCount#" step="1">
			<cfset LOCAL.RowData[tmp] = """#Replace( indeksyNaSklepach[ LOCAL.ColumnNames[ tmp ] ][ indeksyNaSklepach.CurrentRow ], """", """""", "all" )#""" />
		</cfloop>
		
		<cfset LOCAL.Buffer.Append( JavaCast( "string", arrayToList( LOCAL.RowData, "," ) & LOCAL.NewLine ) ) />
		
	</cfloop>
	
	<cfset fName = "files/raport_indeksow_na_sklepie/Indeksy_z_planogramow[#DateFormat(Now(), "yyyy-mm-dd")#].csv" />
	<cfset fSrc = expandPath(fName) />
	<cfset fileWrite(fSrc, LOCAL.Buffer.toString()) />
	
	<cflocation url="#fName#" addtoken="false" />
	
	<!---
	<cfset columnList = "projekt,miasto,ulica,product_id,upc" />
	<cfset q = queryNew("#columnList#") />
	
	<cfset i = 1 />
	<cfloop condition="i LTE indeksyNaSklepach.RecordCount">
		<cfset queryAddRow(q) />
		<cfset querySetCell(q, "Projekt", "#indeksyNaSklepach['projekt'][i]#") />
		<cfset querySetCell(q, "Miasto", "#indeksyNaSklepach['miasto'][i]#") />
		<cfset querySetCell(q, "Ulica", "#indeksyNaSklepach['ulica'][i]#") />
		<cfset querySetCell(q, "Product_id", "#indeksyNaSklepach['product_id'][i]#") />
		<cfset querySetCell(q, "UPC", "#indeksyNaSklepach['upc'][i]#") />
		<cfset i++ />
	</cfloop> 
	
	<cfset columnList2 = "upc" />
	<cfset q2 = queryNew("#columnList2#") />
	
	<cfset j = 1 />
	<cfloop condition="j LTE indeksyNaSklepach.RecordCount">
		<cfset queryAddRow(q2) />
		<cfset querySetCell(q2, "UPC", "#indeksyNaSklepach['upc'][j]#") />
		<cfset j++ />
	</cfloop>
	
	<cfset s = spreadsheetNew() />
	<cfset spreadsheetCreateSheet(s, "Sku na sklepach") />
	<cfset spreadsheetSetActiveSheet(s, "Sku na sklepach") />
	<cfset spreadsheetAddRows(s, columnList) />
	<cfset spreadsheetAddRows(s, q) />
	
	<cfset spreadsheetCreateSheet(s, "Sku") />
	<cfset spreadsheetSetActiveSheet(s, "Sku") />
	<cfset spreadsheetAddRows(s, columnList2) />
	<cfset spreadsheetAddRows(s, q2) />
	
	<cfset fName = "files/raport_indeksow_na_sklepie/Wszystkie_sklepy[#DateFormat(Now(), "yyyy-mm-dd")#].xls" />
	<cfset filename = expandPath(fName) />
	
	<cflocation url="#fname#" />
	--->
	
<!---</cfsilent>--->