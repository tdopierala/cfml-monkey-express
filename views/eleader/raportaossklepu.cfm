<cfsilent>
	<cfset columnList = "Data,Kontrolujacy,Sklep," />
	<cfset tablicaZadan = arrayNew(1) />
	<cfset numerZadania = 1 />
	<cfloop condition="numerZadania LTE listaZagadnien.RecordCount">
		<cfset columnList &= "Grupa_#numerZadania#," />
		<cfset arrayAppend(tablicaZadan, listaZagadnien["nazwazadania"][numerZadania]) />
		<cfset numerZadania++ />
	</cfloop>
	
	<cfset columnList &= "Odwolania,Z_odwolan" />
	<cfset q = queryNew("#columnList#") />
	<cfset indeks = 1 />
	<cfloop condition="indeks LTE arkuszeDlaSprzedazy.RecordCount">
		<cfset queryAddRow(q) />
		<cfset querySetCell(q, "Data", "#DateFormat(arkuszeDlaSprzedazy["datautworzenia"][indeks], "yyyy/mm/dd")#") />
		<cfset querySetCell(q, "Kontrolujacy", "#arkuszeDlaSprzedazy["imiepartnera"][indeks]# #Left(arkuszeDlaSprzedazy["nazwiskopartnera"][indeks], 1)#") />
		<cfset querySetCell(q, "Sklep", "#arkuszeDlaSprzedazy["kodsklepu"][indeks]#") />
		
		<cfset numerZadania = 1 />
		<cfloop condition="numerZadania LTE listaZagadnien.RecordCount">
			<cfset querySetCell(q, "Grupa_#numerZadania#", "#arkuszeDlaSprzedazy["#listaZagadnien["IDDEFINICJIZADANIA"][numerZadania]#"][indeks]#") />
			<cfset numerZadania++ />
		</cfloop>
		
		<cfset querySetCell(q, "Odwolania", "#arkuszeDlaSprzedazy["iloscodwolan"][indeks]#") />
		<cfset querySetCell(q, "Z_odwolan", "#arkuszeDlaSprzedazy["punktyzodwolan"][indeks]#") />
		
		<cfset indeks++ />
	</cfloop>
	
	<cfset fName = "files/eleader_raporty_aos/Raport[#DateFormat(Now(), "yyyy-mm-dd")#].xls" />
	<cfset filename = expandPath(fName) />
	
	<cfset s = spreadsheetNew() />
	<cfset spreadsheetAddRow(s, "#columnList#") />
	<cfset spreadsheetAddRows(s, q) />
	<cfset spreadsheetWrite(s, filename, true) />
	
	<cflocation url="#fname#" />
	
</cfsilent>