<cfcomponent extends="Model">

	<cffunction name="init">
	
		<cfset belongsTo("object")>
		<cfset belongsTo("user")>
		
		<cfset hasMany("objectInstanceAttributeValue")>
		<cfset hasMany("userObjectInstance")>
		
		<cfset afterSave("defineAttributes,manageUsers")>
	
	</cffunction>
	
	<cffunction name="defineAttributes" hint="Dodaje powiązania między definicją obiektu a atrybutami. 
											Domyślnie wartości atrybutów są puste.">
		
		<!---
		Pobieram wszystkie atrybuty dla danego obiektu. Przechodzę przez wszystkie atrybuty i dodaje puste definicje
		do tabeli objectinstanceattributevalues.
		--->
		<cfset object_attributes = model("objectAttributes").findAll(where="objectid=#properties().objectid#")>
		
		<cfloop query="object_attributes">
		
			<cfset objectinstanceattributevalue = model("objectInstanceAttributeValue").new()>
			<cfset objectinstanceattributevalue.objectid = properties().objectid>
			<cfset objectinstanceattributevalue.objectinstanceid = properties().id>
			<cfset objectinstanceattributevalue.objectattributeid = id>
			<cfset objectinstanceattributevalue.attributeid = attributeid>
			<cfset objectinstanceattributevalue.created = Now()>
			<cfset objectinstanceattributevalue.save()>
		
		</cfloop>
		
	</cffunction>
	
	<!---
	Metoda dodająca powiązanie między użytkownikiem a obiektem. Domyślnie powiązanie mówi, że użytkownik nie ma dostędu.
	--->
	<cffunction name="manageUsers" hint="Zarządzanie powiązaniami i uprawnieniami użytkowników do danego obiektu.">
	
		<cfset users = model("user").findAll()>
		
		<!---
		Przechodzę przez wszystkich użytkowników i dodaje odpowiednie wpisy do tabeli łączącej usera z obiektem.
		--->
		<cfloop query="users">
		
			<cfset userobjectinstance = model("userObjectInstance").new()>
			<cfset userobjectinstance.userid = id>
			<cfset userobjectinstance.objectinstanceid = properties().id>
			<cfset userobjectinstance.save()>
		
		</cfloop>
	
	</cffunction>

</cfcomponent>