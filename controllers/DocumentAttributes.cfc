<!---
Komponent z atrybutami dokumentu.
Na początek dodawane będą faktury i atrybuty opisujące fakture:
- numer
- data wystawienia
- data płatności
- kwota brutto
--->
<cfcomponent extends="Controller">

	<cffunction name="init">
	
		<cfset super.init()>
	
	</cffunction>
	
	<cffunction name="index" hint="Lista wszystkich atrybutów">
		<cfset attributes = model("documentAttribute").findAll(include="attribute(attributeType)")>
	</cffunction>
	
	<cffunction name="updateDocumentAttribute" hint="Aktywacja danego atrybutu dla dokumentu.
													Metoda zmiania wartość pola documentattributevisible aby pole stało się
													widoczne przy dodawaniu dokumentu i przeglądaniu już istniejących">
		
		<cfif isAjax()>
			<cfset documentattribute = model("documentAttribute").findByKey(params.key)>
			<cfset documentattribute.update(documentattributevisible=1-documentattribute.documentattributevisible,callbacks=false)>
			<cfset message = "Atrybut został zaktualizowany.">
		<cfelse>
			<cfset message = "Nieprawidłowe wywołanie żądania.">
		</cfif>
		
		<cfset renderWith(data=message,layout=false)>
	
	</cffunction>
	
	<!---
<cffunction name="add" hint="Formularz dodawania nowego atrybutu">
		<cfset types = model("documentattributetype").findAll()>
		<cfset documentattribute = model("documentattribute").new()>
	</cffunction>
	
	<cffunction name="actionAdd" hint="Dodawanie nowego atrybutu dokumentu">
		<cfset documentattribute = model("documentattribute").new(params.documentattribute)>
		<cfset documentattribute.documentattributecreated = Now()>
		<cfset documentattribute.documentattributevisible = 1>
		<cfset documentattribute.save()>
		
		<cfset redirectTo(controller="DocumentAttributes",action="add",success="Dodano nowy atrybut <span>#documentattribute.documentattributename#</span>")>
	</cffunction>
--->

</cfcomponent>