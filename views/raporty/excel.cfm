<cfsilent>
	
	<cfset columnList = "Sprzedaz_cl,Sprzedaz_elektroniczna,Kwota_zwrotu,Karty_elektroniczne,Sklep" />
	
	<cfset q = queryNew("#columnList#") />
	<cfset indeks = 1 />
	<cfloop condition="indeks LTE raport.RecordCount">
		<cfset queryAddRow(q) />
		<cfset querySetCell(q, "Sprzedaz_cl", "#raport["products_sale_amount"][indeks]#") />
		
		<cfset sumaElektroniczna = 	raport["electronic_sale_type_1_amount"][indeks]+
			raport["electronic_sale_type_2_amount"][indeks]+
			raport["electronic_sale_type_3_amount"][indeks]+
			raport["electronic_sale_type_4_amount"][indeks]+
			raport["electronic_sale_type_5_amount"][indeks] />
		<cfset sumaElektroniczna = numberFormat(sumaElektroniczna, "0.00") />
		
		<cfset querySetCell(q, "Sprzedaz_elektroniczna", "#sumaElektroniczna#") />
		
		<cfset querySetCell(q, "Kwota_zwrotu", "-#raport["promo_discount_amount"][indeks]#") />
		
		<cfset querySetCell(q, "Karty_elektroniczne", "-#raport["electronic_payment_amount"][indeks]#") />
		
		<cfset querySetCell(q, "Sklep", "#raport["location_number"][indeks]#") />
		
		<cfset indeks++ />
	</cfloop>

	<cfset fName = "files/raporty/Raport_wplat[#DateFormat(Now(), "yyyy-mm-dd")#].xls" />
	<cfset filename = expandPath(fName) />
	
	<cfset s = spreadsheetNew() />
	<cfset spreadsheetAddRow(s, "#columnList#") />
	<cfset spreadsheetAddRows(s, q) />
	<cfset spreadsheetWrite(s, filename, true) />
	
	<cflocation url="#fname#" />
	
</cfsilent>