<cfcomponent displayname="Store_objects" output="false" hint="" extends="Controller">
	
	<cffunction name="init" output="false" access="public" hint="">
		<cfset super.init() />
		<cfset filters(through="loadLayout",type="before") />
	</cffunction>
	
	<cffunction name="loadLayout" output="false" access="public" hint="">
		<cfset usesLayout("/layout") />
		<cfset application.ajaxImportFiles &= ",initObjects,initAttribute" />
	</cffunction>
	
	<cffunction name="index" output="false" access="public" hint="">
		
	</cffunction>
	
	<cffunction name="listObjects" output="false" access="public" hint="">
		<cfset obiekty = model("store_object").listObjects() />
		
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="add" output="false" access="public" hint="">
		
		<cfif IsDefined("FORM.FIELDNAMES")>
			
			<cfset newObject = structNew() />
			<cfset newObject.success = true />
			<cfset newObject.message = "Obiekt został zapisany" />
			
			<cfset newObject = model("store_object").create(
				name = FORM.OBJECT_NAME,
				userid = session.user.id) />
			
			<cfif newObject.success is true>
				
				<cfloop list="#FORM.ATTRID#" index="i">
					<cfset var tmp = listToArray(i, ".") />
					
					<cfset var newObjAttr = structNew() />
					<cfset newObjAttr.success = true />
					<cfset newObjAttr.message = "Atrybut został przypisany do obiektu" />
					
					<cfset newObjAttr = model("store_object").createObjectAttribute(
						objectid = newObject.id,
						attributeid = tmp[1],
						typeid = tmp[2] 
					) />
					
				</cfloop>
				
			</cfif>

		</cfif>
		
		<cfset attributes = model("store_attribute").listAttributes() />
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="addObjectToStore" output="false" access="public" hint="">
		<cfparam name="page" type="numeric" default="1" />
		<cfparam name="elements" type="numeric" default="50" />
		
		<cfif IsDefined("URL.PAGE")>
			<cfset page = URL.PAGE />
		</cfif>
		
		<cfif IsDefined("URL.ELEMENTS")>
			<cfset elements = URL.ELEMENTS />
		</cfif>

		<cfset obiektyNaSklepach = model("store_object").storesSummary(
			page = page,
			elements = elements) />
			
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="addObjectToStoreForm" output="false" access="public" hint="">
		
		<cfif IsDefined("URL.STOREID")>
			<cfset strid = URL.STOREID />
		</cfif>
		
		<cfset sklepy = model("store_object").listStores() />
		<cfset obiekty = model("store_object").listObjects() />
		
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="addObjectToStoreFormFill" output="false" access="public" hint="">
		<cfif IsDefined("FORM.FIELDNAMES")>
			
			<cfset storeid = FORM.STOREID />
			<cfset projekt = FORM.PROJEKT />
			
			<cfset obiekty = arrayNew(1) />
			<cfset ilosci = structNew() />
			<cfloop list="#FORM.OBJECTID#" index="element" >
				
				<cfset var obiekt = model("store_object").listObjectAttributes(
					objectid = element) />
				
				<cfset arrayAppend(obiekty, obiekt) />
				<cfset structInsert(ilosci, element, FORM['obj#element#']) />
				
			</cfloop>
			
			<cfset slownik = model("store_attribute").getDictionary() />
			
			<cfset usesLayout(false) />
		<cfelse>
			<cfset renderNothing() />
		</cfif>
	</cffunction>
	
	<cffunction name="addObjectToStoreSave" output="false" access="public" hint="">
		<cfif IsDefined("FORM.FIELDNAMES")>
			<cfset objectInstance = structNew() />
			<cfset objectInstance.success = true />
			<cfset objectInstance.message = "Obiekt został dodany do sklepu" />
			
			<cfset objectInstance = model("store_object_instance").create(
				objectid = URL.OBJECTID,
				userid = session.user.id,
				storeid = URL.STOREID,
				project = FORM.STORE_PROJECT) />
				
			<cfif objectInstance.success is true>
				<cfloop list="#FORM.FIELDNAMES#" index="element">
					<cfif findNoCase("ATTRIBUTE", element)>
						<cfset var tmp = listToArray(element, "-") />
						<cfset var tmp2 = listToArray(tmp[2], ".") />
					
						<cfset var newAttr = structNew() />
						<cfset newAttr.success = true />
						<cfset newAttr.message = "Atrybut został przypisany do obiektu" />
						
						<cfset newAttr = model("store_object_instance").createValue(
							objectid = tmp2[1],
							attributeid = tmp2[2],
							typeid = tmp2[3],
							instanceid = objectInstance.id,
							text = FORM["#element#"]
						) />
					</cfif>
				</cfloop>
			</cfif>
		</cfif>
		
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="storeObjects" output="false" access="public" hint="">
		<cfset obiekty = model("store_object").storeObjects(storeid = URL.STOREID, project = URL.PROJECT) />
		<cfset storeid = URL.STOREID />
		<cfset project = URL.PROJECT />
		
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="objectDetails" output="false" access="public" hint="">
		<cfset szczegoly = model("store_object").storeObjectsDetails(
			storeid = URL.STOREID,
			objectid = URL.OBJECTID) />
			
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="removeObject" output="false" access="public" hint="">
		<cfif IsDefined("URL.OBJECTID")>
			<cfset usunObiekt = model("store_object").delete(URL.OBJECTID) />
		</cfif>
		
		<cfset obiekty = model("store_object").listObjects() />
		<cfset renderWith(data="obiekty",layout=false,template="listobjects") />
	</cffunction>
	
	<cffunction name="removeInstance" output="false" access="public" hint="">
		<cfif IsDefined("URL.INSTANCEID")>
			<cfset instance = model("store_object_instance").delete(URL.INSTANCEID) />
		</cfif>
		
		<cfset renderNothing() />
	</cffunction>
	
	<cffunction name="editObject" output="false" access="public" hint="">
		<cfif IsDefined("URL.OBJECTID")>
			
			<cfset obiekt = model("store_object").listObjectAttributes(URL.OBJECTID) />
			<cfset atrybuty = model("store_attribute").listAttributes() />
			<cfset objectid = URL.OBJECTID />
			<cfset usesLayout(false) />
			
		<cfelse>
			<cfset renderNothing() />
		</cfif>
	</cffunction>
	
	<cffunction name="editInstance" output="false" access="public" hint="">
		
		<cfif IsDefined("FORM.FIELDNAMES") and IsDefined("URL.INSTANCEID")>
			
			<cfloop list="#FORM.FIELDNAMES#" index="element">
				<cfif findNoCase("ATTRIBUTE", element)>
					<cfset var tmp = listToArray(element, "-") />
					<cfset var tmp2 = listToArray(tmp[2], ".") />
					
					<cfset var newAttr = structNew() />
					<cfset newAttr.success = true />
					<cfset newAttr.message = "Atrybut został przypisany do obiektu" />
						
					<cfset newAttr = model("store_object_instance").updateValue(
						objectid = tmp2[1],
						attributeid = tmp2[2],
						typeid = tmp2[3],
						instanceid = URL.INSTANCEID,
						text = FORM["#element#"]
					) />
				</cfif>
			</cfloop>
			
		</cfif>
		
		<cfset instanceid = URL.INSTANCEID />
		<cfset obiekt = model("store_object_instance").getObjectByInstance(URL.INSTANCEID) />
		<cfset atrybuty = model("store_object_instance").getInstanceAttributes(URL.INSTANCEID) />
		<cfset slownik = model("store_attribute").getDictionary() />
		
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="objectStores" output="false" access="public" hint="">
		<cfif IsDefined("URL.OBJECTID")>
		
			<cfset obiektyNaSklepach = model("store_object").storesSummaryByObject(URL.OBJECTID) />
			<cfset renderWith(data="obiektyNaSklepach",template="addobjecttostore",layout=false) />
			
		<cfelse>
			<cfset renderNothing() />
		</cfif>
	</cffunction>
	
</cfcomponent>