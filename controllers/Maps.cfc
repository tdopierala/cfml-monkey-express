<cfcomponent
	extends="Controller">

	<cffunction
		name="init">
	
<!--- 		<cfset super.init() /> --->
		<cfset filters("beforeRender") />
	
	</cffunction>
	
	<cffunction
		name="beforeRender">
	
		<cfset usesLayout(template="layout",ajax=false) />
		
	</cffunction>
	
	<cffunction
		name="placeMaps"
		hint="Mapy lokalizacji"
		description="Metoda generująca listę wszystkich map przypisanych do danej lokalizacji">
	
		<cfset place = model("place").findByKey(params.key) />
	
	</cffunction>
	
	<cffunction
		name="savePlace"
		hint="Zapisanie mapy nieruchomości"
		description="">
		
		<!---
		04.09.2012
		Zapisanie mapy do lokalizacji.
		- zapisuje mapę
		- zapisuje punkty, jeden po drugim, z referencją do wcześniej zapisanej mapy
		--->
		
		<!--- Zapisanie mapy --->
		<cfset mapStruct = DeserializeJSON(params.map) />
		<cfset map = model("map").create(mapStruct) />
		
		<!--- Zapisane markerów --->
		<cfset markersArray = DeserializeJSON(params.marker) />
		<cfloop array="#markersArray#" index="i">
		
			<cfset mapmarker = model("mapMarker").new() />
			<cfset mapmarker.markerlat = i.lat />
			<cfset mapmarker.markerlng = i.lng />
			<cfset mapmarker.markericon = i.icon />
			<cfset mapmarker.markertitle = i.title />
			<cfset mapmarker.mapid = map.id />
			<cfset mapmarker.markeraddress = i.address />
			<cfset mapmarker.save(callbacks=false) />
		
		</cfloop>
		
		<cfset place = model("place").findByKey(params.key) />
		<cfset markers = model("mapMarker").findAll(where="mapid=#map.id#") />
		
	</cffunction>
	
	<cffunction
		name="list"
		hint="Lista map danej lokalizacji"
		description="">
	
		<cfset place = model("place").findByKey(params.key) />
		<cfset maps = model("map").findAll(where="placeid=#params.key#") />
	
	</cffunction>

</cfcomponent>