<cfsilent>
	<cfset columnList = "Projekt,Miasto,Ulica,Nazwa_ajenta,Sala_sprzedazy,Sku" />
	<cfset fName = "files/raport_pokrycia_produktow/RaportPokrycia[#DateFormat(Now(), "yyyy-mm-dd")#].xls" />
	<cfset filename = expandPath(fName) />
	
	<cfset s = spreadsheetNew() />
	<cfset spreadsheetAddRow(s, "#columnList#") />
	<cfset spreadsheetAddRows(s, raportPokrycia) />
	<cfset spreadsheetWrite(s, filename, true) />
	
	<cflocation url="#fname#" />
	
</cfsilent>