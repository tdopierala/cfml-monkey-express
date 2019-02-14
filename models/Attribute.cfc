<cfcomponent extends="Model">

	<cffunction name="init">
		<cfset belongsTo("attributeType")>
		<cfset hasMany("objectAttribute")>
		<cfset hasMany("objectInstanceAttributeValue")>
		<cfset hasMany("documentAttribute")>
		<cfset hasMany("userAttribute") />
		
<!--- 		<cfset afterSave("updateObjects,addDocumentAttribute,updateUserAttributes,updateUserAttributeValues")> --->
	</cffunction>
	
	<!---
	20.08.2012
	Usunąłem aktualizowanie atrybutów obiektów bo nie ma już obiektów w intranecie.
	--->
	<!---
<cffunction name="updateObjects" hint="Dodanie powiązań między nowododanym atrybutem a obiektem">
	
		<cfset objects = model("object").findAll()>
		
		<cfloop query="objects">
		
			<cfset object_attribute = model("objectAttribute").new()>
			<cfset object_attribute.objectid = id>
			<cfset object_attribute.attributeid = properties().id>
			<cfset object_attribute.visible = 0>
			<cfset object_attribute.creaed = New()>
			<cfset object_attribute.save()>

		</cfloop>
	
	</cffunction>
--->
	
	<!---
	21.08.2012
	Dodałem procedury na bazie, k†óre automatycznie aktualizują te powiązania.
	--->
	<!---
<cffunction name="addDocumentAttribute" hint="Dodaje powiązanie atrybutu z dokumentem i ustawiam jego widoczność na 0.
													Dodatkowo dopisuje pusty atrybut do już dodanych dokumentów.">
	
		<cfset documentattribute = model("documentAttribute").new()>
		<cfset documentattribute.attributeid = properties().id>
		<cfset documentattribute.documentattributevisible = 0>
		<cfset documentattribute.save()>
		
		<cfset documents = model("documentInstance").findAll(select="documentid,id")>
		
		<cfloop query="documents">
			<cfset documentattributevalue = model("documentAttributeValue").new()>
			<cfset documentattributevalue.documentid = documentid>
			<cfset documentattributevalue.documentattributeid = documentattribute.id>
			<cfset documentattributevalue.attributeid = properties().id>
			<cfset documentattributevalue.documentinstanceid = id>
			<cfset documentattributevalue.save()>
		</cfloop>
	
	</cffunction>
--->
	
	<!---
	21.08.2012
	Dodałem procedury na bazie, które automatycznie aktualizują te relacje
	--->
	<!---
<cffunction
		name="updateUserAttributes"
		hint="Dodawanie atrybutu dla użytkownika"
		description="Metoda dodająca nowy atrybut dla uzytkownika. Domyślnie ustawiam widoczność atrybutu na 0.">
		
			<cfset userattribute = model("userAttribute").new() />
			<cfset userattribute.attributeid = properties().id />
			<cfset userattribute.visible = 0 />
			<cfset userattribute.save(callbacks=false) />
	
	</cffunction>
--->
	
	<!---
	21.08.2012
	Dodałem procedury na bazie, które automatycznie aktuaizują tą relację.
	--->
	<!---
<cffunction 
		name="updateUserAttributeValues"
		hint="Dodawania pustej wartości atrybutu użytkownika"
		description="Metoda dodająca pustą wartość atrybutu użytkownika.">
	
		<cfset users = model("user").findAll(select="id") />
		
		<cfloop query="users">
		
			<cfset userattributevalue = model("userAttributeValue").new() />
			<cfset userattributevalue.userid = id />
			<cfset userattributevalue.attributeid = properties().id />
			<cfset userattributevalue.save(callbacks=false) />
		
		</cfloop>
	
	</cffunction>
--->
	
	<!---
	addProtocolAttribute
	---------------------------------------------------------------------------------------------------------------
	Dodawanie nowego atrybutu do protokołu.
	
	--->
	<cffunction 
		name="addProtocolAttribute"
		hint="Dodawnaie nowego atrybutu dla protokołów."
		description="Metoda dodająca nowy atrynut do definicji protokołu oraz do wszystkich instancji protokołów.">
	
		<!---
		Operacje aktualizacji datych w tabeli będą wykonywane poprzez zdefiniowane na bazie proedury. Taki
		sposób aktualizacji danych jest szybszy bo wszystkie operacje odbywają się bezpośrednio na serwerze bazy danych.
		--->
		
		
			
		
	
	</cffunction>

</cfcomponent>