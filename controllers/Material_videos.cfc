<cfcomponent
	extends="Controller"
	output="false" >
	
	<cffunction
		name="index">
			
	</cffunction>
	
	<cffunction
		name="newVideo"
		hint="Formularz dodawania pliku video do materiałów szkoleniowych">
			
		<cfset materials = model("material_material").getAllMaterials() />
			
	</cffunction>
	
	<cffunction
		name="actionNewVideo"
		hint="Dodanie nowego pliku do materiałów video">
		
		<!--- Zapisuje plik na serwerze --->
		<cfset myfile = APPLICATION.cfc.upload.SetDirName(dirName="materials") />
		<cfset myfile = APPLICATION.cfc.upload.upload(file_field="videofile") />
		
		<!---
			Jeżeli plik został zapisany na dysku to dodaję odpowiednie definicje
			w bazie.
		--->
		<cfif isStruct(myfile)>
			
			<cfset new_file = model("material_video").new() />
			<cfset new_file.videonote = params.videonote />
			<cfset new_file.materialid = params.materialid />
			<cfset new_file.videosrc = myfile.NEWSERVERNAME />
			<!---<cfset new_file.videobinary = myfile.BINARYCONTENT />--->
			<cfset new_file.videoname = myfile.CLIENTFILENAME & "." & myfile.CLIENTFILEEXT />
			<cfset new_file.created = Now() />
			<cfset new_file.save(callbacks=false) />
			
		</cfif>
		
		<cfset redirectTo(back=true) />
			
	</cffunction>
	
	<cffunction
		name="view"
		hint="Wyświetlenie pliku filmowego">
		
		<cfset my_video = model("material_video").findByKey(params.key) />
		<cfset renderWith(data="my_video",layout=false) />
		
	</cffunction>
	
</cfcomponent>