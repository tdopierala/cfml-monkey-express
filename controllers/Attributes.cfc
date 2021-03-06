<!---
Kontroler odpowiedzialny za zarządzanie atrybutami opisującymi obiekty.
--->

<cfcomponent extends="Controller">

	<cffunction name="init">
		
		<cfset super.init()>
	
	</cffunction>
	
	<cffunction name="index">
	
		<cfset attributes = model("attribute").findAll(include="attributeType")>
	
	</cffunction>
	
	<cffunction name="add" hint="Formularz dodawania atrybutu. Typy atrybutów brane są z tabeli attributetypes.
								Typy będą identyfikowały sposób wyświetlania elementu oraz rodzaj poja na formularzu.">
	
		<cfset attribute = model("attribute").new()>
		<cfset attribute_types = model("attributeType").findAll()>
	
	</cffunction>
	
	
	<cffunction name="actionAdd" hint="Zapisanie nowego atrybutu w bazie.">
	
		<cfset attribute = model("attribute").new(params.attribute)>
		<cfset attribute.created = Now() >
		<cfset attribute.attributetypeid = params.attribute.attributetypeid>
		<cfset attribute.save(callbacks=false) >
		
		<cfset redirectTo(back=true)>
	
	</cffunction>
	
	<cffunction name="assignAttribute" hint="Przypisanie atrybutu dla danego obiektu. Identyfikator obiektu jest przesyłany w GET.">
	
		<cfset object_attribute = model("objectAttribute").new()>
	
	</cffunction>
	
	<cffunction name="edit" hint="Formularz edycji atrybutu">
	
		<cfset attribute = model("attribute").findByKey(params.key)>
		<cfset attributetypename = model("attribute").findAll(where="id=#params.key#",include="attributetype").typename>
		<cfset attributetypes = model("attributetype").findAll()>
	
	</cffunction>
	
	<cffunction name="actionEdit" hint="Zapisanie zmian w atrybucie">
		
		<cfset attribute = model("attribute").findByKey(params.attribute.id)>
		<cfset attribute.update(properties=params)>
		
		<cfset redirectTo(controller="Attributes",action="index",success="Zaktualizowano atrybut <span>#attribute.attributename#</span>")>
		
	</cffunction>

</cfcomponent>