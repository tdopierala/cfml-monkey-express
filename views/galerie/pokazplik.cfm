<cfif not directoryExists( "#KATALOG#/800600" )>
	<cfdirectory action="create" directory="#KATALOG#/800600" />
</cfif>

<cfif not fileExists( "#KATALOG#/800600/#PLIK#" )>
	<cfset myImage = ImageNew( "#KATALOG#/#PLIK#" ) />
	<cfset ImageScaleToFit(myImage, 800, 600, "highQuality") />
	<cfset imageWrite(myimage, "#KATALOG#/800600/#PLIK#") />
</cfif>

<cfimage action="writeToBrowser" source="#KATALOG#/800600/#PLIK#" format="PNG" />