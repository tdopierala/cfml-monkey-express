<cfset filename = "products_#DateFormat(Now(), 'dd-mm-yyyy')#.xls" />
				
<cfset filepath = ExpandPath('files/products/') & filename />

<cfspreadsheet 
	action = "write"
	filename = "#filepath#"
	query = "queryresult"
    sheetname = "Lista indeksow" 
	overwrite = "true" />
					
<cflocation url = "files/products/#filename#" />