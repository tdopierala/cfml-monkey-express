<cfcomponent
	extends="Controller">


	<cffunction
		name="init">
	
		<cfset super.init() />
	
	</cffunction>
	
	<cffunction 
		name="add"
		hint="Formularz dodawania pliku"
		description="Metoda generująca formularz dodawania pliku do systemu. Plik jest dodawany Ajaxowo przy pomocy SEFUpload. Po zapisaniu pliku przydzielam go do odpowiedniego zasobu.">
	
	
	</cffunction>
	
	<cffunction
		name="getComments"
		hint="Pobieranie komentarzy do pliku"
		description="Procedura pobierająca komentarze do pliku">
	
		<cfset comments = model("file").getComments(fileid=params.key) />
		
		<cfif IsAjax()>
		
			<cfset renderWith(data="comments",layout=false) />
		
		</cfif>
	
	</cffunction>

</cfcomponent>