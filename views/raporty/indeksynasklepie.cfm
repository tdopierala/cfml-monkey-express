<cfsilent>
	
	<cfset columnList = "sklep,upc,prestock" />
	<cfset q = queryNew("#columnList#") />
	<cfset indeks = 1 />
	<cfloop condition="indeks LTE indeksyNaSklepie.RecordCount">
		<cfset queryAddRow(q) />
		<cfset querySetCell(q, "Sklep", "#indeksyNaSklepie['sklep'][indeks]#") />
		<cfset querySetCell(q, "UPC", "#indeksyNaSklepie['upc'][indeks]#") />
		<cfset querySetCell(q, "PRESTOCK", "#indeksyNaSklepie['prestock'][indeks]#") />
		<cfset indeks++ />
	</cfloop>
	
	<cfset fName = "files/raport_indeksow_na_sklepie/#URL.SKLEP#[#DateFormat(Now(), "yyyy-mm-dd")#].xls" />
	<cfset filename = expandPath(fName) />
	
	<cfset s = spreadsheetNew() />
	<cfset spreadsheetAddRow(s, columnList) />
	<cfset spreadsheetAddRows(s, q) />
	<cfset spreadsheetWrite(s, filename, true) />
	
	<cflocation url="#fname#" />
</cfsilent>