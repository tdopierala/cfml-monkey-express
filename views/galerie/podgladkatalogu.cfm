<div class="uiGalleryHeader">
	<a href="javascript:ColdFusion.navigate('index.cfm?controller=galerie&action=pokaz-sklepy', 'swieta2014')" class="back-icon">Pokaż sklepy</a>
</div>

<cfdirectory action="list" directory="/home/admin/galeria/swieta/#KATALOG#" name="foty" filter="*.png|*.jpg|*.jpeg|*.JPG|*.JPEG|*.PNG" />

<div class="uiGalleryThumbnails">
	<cfoutput query="foty">
		<cfif not directoryExists( "#DIRECTORY#/thumb" )>
			<cfdirectory action="create" directory="#DIRECTORY#/thumb" />
		</cfif>
		
		<cfif not fileExists( "#DIRECTORY#/thumb/#NAME#" )>
			
			<cfset myImage = ImageNew( "#DIRECTORY#/#NAME#" ) />
			<cfset ImageScaleToFit(myImage, 100, 125, "highestperformance") />
			<cfset imageWrite(myimage, "#DIRECTORY#/thumb/#NAME#") />
		
		</cfif>
		
		
		<a href="javascript:showCFWindow('#NAME#', '#NAME#', 'index.cfm?controller=galerie&action=pokaz-plik&katalog=#DIRECTORY#&plik=#NAME#', 600, 900)" class="thumbnail">
			<cfimage action="writeToBrowser" source="#DIRECTORY#/thumb/#NAME#" format="PNG" />
		</a>
	</cfoutput>
</div>
