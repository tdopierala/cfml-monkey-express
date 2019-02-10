<cfcomponent displayname="Store_attributes" output="false" hint="" extends="Controller">
	
	<cffunction name="init" output="false" access="public" hint="">
		<cfset super.init() />
		<cfset filters(through="loadLayout",type="before") />
	</cffunction>
	
	<cffunction name="loadLayout" output="false" access="public" hint="">
		<cfset usesLayout("/layout") />
	</cffunction>
	
	<cffunction name="listAttributes" output="false" access="public" hint="">
		<cfset atrybuty = model("store_attribute").listAttributes() />
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="add" output="false" access="public" hint="">
		
		<cfif IsDefined("FORM.FIELDNAMES")>
			
			<cfset var newAttr = structNew() />
			<cfset newAttr.success = true />
			<cfset newAttr.message = "Atrybut został dodany" />
			
			<cfset newAttr = model("store_attribute").create(
				typeid = FORM.ATTRIBUTE_TYPE_ID,
				name = FORM.ATTRIBUTE_NAME) />
			
			<cfif newAttr.success is true and IsDefined("FORM.DICTIONARY")>
				
				<cfloop list="#FORM.DICTIONARY#" index="element" >
					<cfset var newAttrDict = structNew() />
					<cfset newAttrDict.success = true />
					<cfset newAttrDict.message = "Element do słownika został dodany" />
					
					<cfset newAttrDict = model("store_attribute").createDictionary(
						attributeid = newAttr.id,
						typeid = FORM.ATTRIBUTE_TYPE_ID,
						value = element
					) />
				</cfloop>
				
			</cfif>

		</cfif>
		
		<cfset attributeTypes = model("store_attribute").listTypes() />
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="removeAttribute" output="false" access="public">
		<cfif IsDefined("URL.ATTRIBUTEID")>
			<cfset atrybut = model("store_attribute").delete(URL.ATTRIBUTEID) />
			<cfset atrybuty = model("store_attribute").listAttributes() />
			<cfset renderWith(data="atrybuty",template="listattributes",layout=false) />
		<cfelse>
			<cfset renderNothing() />
		</cfif>
	</cffunction>
	
	<cffunction name="attributesSelectBox" output="false" access="public" hint="">
		<cfset attributes = model("store_attribute").listAttributes() />
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="addObjectAttribute" output="false" access="public" hint="">
		<cfset var tmp = ListToArray(FORM.ATTR, ".") />
		<cfset newAttr = model("store_object").addAttribute(
			objectid = tmp[3],
			attributeid = tmp[1],
			typeid = tmp[2]) />
		
		<cfset objectid = tmp[3] />
		<cfset attributes = model("store_attribute").listAttributes() />
		<cfset renderWith(data="attributes,objectid",layout=false,template="attributesedit") />
	</cffunction>
	
	<cffunction name="addFormAttribute" output="false" access="public" hint="">
		<cfset var tmp = ListToArray(FORM.ATTR, ".") />
		<cfset newAttr = model("store_form").addAttribute(
			formid = tmp[3],
			attributeid = tmp[1],
			typeid = tmp[2]) />
			
		<cfset formid = tmp[3] />
		<cfset attributes = model("store_attribute").listAttributes() />
		<cfset renderWith(data="attributes,formid",layout=false,template="attributesformedit") />
	</cffunction>
	
	<cffunction name="removeObjectAttribute" output="false" access="public" hint="">
		<cfset removeAttr = model("store_attribute").removeObjectAttribute(URL.OBJECTATTRIBUTEID) />
		
		<cfset obiekt = model("store_object").listObjectAttributes(URL.OBJECTID) />
		<cfset atrybuty = model("store_attribute").listAttributes() />
		<cfset objectid = URL.OBJECTID />
			
		<cfset renderWith(data="obiekty",controller="store_objects",action="editobject",params="objectid=#URL.OBJECTID#",layout=false) />
	</cffunction>
	
	<cffunction name="removeFormAttribute" output="false" access="public" hint="">
		<cfset removeAttr = model("store_attribute").removeFormAttribute(URL.FORMATTRIBUTEID) />
		
		<cfset formularz = model("store_form").listFormAttributes(URL.FORMID) />
		<cfset atrybuty = model("store_attribute").listAttributes() />
		<cfset formid = URL.FORMID />
		
		<cfset renderWith(data="formularz",controller="store_forms",action="editform",params="formid=#URL.FORMID#",layout=false) />
	</cffunction>
	
</cfcomponent>