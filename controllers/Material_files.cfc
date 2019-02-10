<cfcomponent
	extends="Controller"
	output="false">
		
	<cffunction
		name="init">
	
		<cfset super.init() />
	
	</cffunction>
	
	<cffunction
		name="newFile"
		hint="Dodawanie nowego pliku do materiałów szkoleniowcyh">
	
		<cfset materials = model("material_material").getAllMaterials() />
	
	</cffunction>
	
	<cffunction
		name="actionNewFile"
		hint="Zapisanie nowego pliku w materiale">
		
		<!--- Zapisuje plik na serwerze --->
		<cfset myfile = APPLICATION.cfc.upload.SetDirName(dirName="materials") />
		<cfset myfile = APPLICATION.cfc.upload.upload(file_field="materialfile") />
		
		<!---
			Jeżeli plik został zapisany na dysku to dodaję odpowiednie definicje
			w bazie.
		--->
		<cfif isStruct(myfile)>
			
			<cfset new_file = model("material_file").new() />
			<cfset new_file.filenote = params.filenote />
			<cfset new_file.materialid = params.materialid />
			<cfset new_file.filesrc = myfile.NEWSERVERNAME />
			<cfset new_file.filebinary = myfile.BINARYCONTENT />
			<cfset new_file.filename = myfile.CLIENTFILENAME & "." & myfile.CLIENTFILEEXT />
			<cfset new_file.created = Now() />
			<cfset new_file.save(callbacks=false) />
			
		</cfif>
		
	</cffunction>
		
</cfcomponent>