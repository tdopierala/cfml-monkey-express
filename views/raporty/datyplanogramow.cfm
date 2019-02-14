<cfsilent>
	
	<cfset columnList = "store_type_name,shelf_category_name,shelf_type_name,data_dodania_total_units,data_dodania_planogramu,data_obowiazywania_od" />
	<cfset q = queryNew("#columnList#") />
	<cfset indeks = 1 />
	<cfloop condition="indeks LTE planogramy.RecordCount">
		<cfset queryAddRow(q) />
		<cfset querySetCell(q, "store_type_name", "#planogramy['store_type_name'][indeks]#") />
		<cfset querySetCell(q, "shelf_category_name", "#planogramy['shelf_category_name'][indeks]#") />
		<cfset querySetCell(q, "shelf_type_name", "#planogramy['shelf_type_name'][indeks]#") />
		<cfset querySetCell(q, "data_dodania_total_units", "#planogramy['data_dodania_total_units'][indeks]#") />
		<cfset querySetCell(q, "data_dodania_planogramu", "#planogramy['data_dodania_planogramu'][indeks]#") />
		<cfset querySetCell(q, "data_obowiazywania_od", "#planogramy['data_obowiazywania_od'][indeks]#") />
		<cfset indeks++ />
	</cfloop>
	
	<cfset fName = "files/raport_pokrycia_produktow/StanPlanogramow[#DateFormat(Now(), "yyyy-mm-dd")#].xls" />
	<cfset filename = expandPath(fName) />
	
	<cfset s = spreadsheetNew() />
	<cfset spreadsheetAddRow(s, columnList) />
	<cfset spreadsheetAddRows(s, q) />
	<cfset spreadsheetWrite(s, filename, true) />
	
	<cflocation url="#fname#" />
</cfsilent>