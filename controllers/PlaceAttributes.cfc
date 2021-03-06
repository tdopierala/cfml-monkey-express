<cfcomponent
	extends="Controller">

	<cffunction
		name="init">
	
		<cfset super.init() />
	
	</cffunction>
	
	<cffunction
		name="index"
		hint="Lista atrybutów nieruchomości"
		description="Tabelka z listą atrybutów nieruchomości z możliwością dodania nowego atrybutu">
	
		<cfset attributes = model("placeAttribute").findAll(include="attribute(attributeType)") />
		
		<cfif IsAjax()>
		
			<cfset renderWith(data="attributes",layout=false) />
		
		</cfif>
	
	</cffunction>
	
	<cffunction
		name="updateAttribute"
		hint="Aktualizacja atrybutu nieruchomości."
		description="Metoda aktualizująca widoczność atrybutu nieruchomości. Zmieniane jest pole visible.">
	
		<cfset placeattribute = model("placeAttribute").findByKey(params.key) />
		<cfset placeattribute.update(placeattributevisible=1-placeattribute.placeattributevisible) />
		
		<cfif IsAjax()>
		
			<cfset message = "OK" />
		
		<cfelse>
		
			<cfset message = "Atrybut nie może zostać zaktualizowany" />
		
		</cfif>
		
		<cfset renderWith(data="message",layout=false) />
	
	</cffunction>

</cfcomponent>