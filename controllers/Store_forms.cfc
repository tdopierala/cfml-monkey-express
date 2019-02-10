<cfcomponent displayname="Store_forms" output="false" extends="Controller" >
	<cffunction name="init" output="false" access="public" hint="">
		<cfset super.init() />
		<cfset filters(type="before",through="loadLayout") />
	</cffunction>
	
	<cffunction name="loadLayout" output="false" access="public" hint="">
		<cfset usesLayout("/layout") />
		<cfset application.ajaxImportFiles &= ",initForms,initAttribute,initStoreForms" />
	</cffunction>
	
	<cffunction name="index" output="false" access="public" hint="">
		
	</cffunction>
	
	<cffunction name="storesForms" output="false" access="public" hint="">
		<cfparam name="page" type="numeric" default="1" />
		<cfparam name="elements" type="numeric" default="50" />
		<cfparam name="szukaj" type="string" default="" />
		
		<cfif IsDefined("URL.PAGE")>
			<cfset page = URL.PAGE />
		</cfif>
		
		<cfif IsDefined("URL.ELEMENTS")>
			<cfset elements = URL.ELEMENTS />
		</cfif>
		
		<cfif IsDefined("URL.SZUKAJ")>
			<cfset szukaj = URL.SZUKAJ />
		</cfif>
		
		<cfif IsDefined("FORM.SZUKAJ")>
			<cfset szukaj = FORM.SZUKAJ />
		</cfif>

		<cfset formularzeNaSklepach = model("store_form").storesForms(
			page = page,
			elements = elements,
			search = szukaj) />
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="storeForms" output="false" access="public" hint="">
		<cfset formularze = model("store_form").storeForms(storeid = URL.STOREID, projekt = URL.PROJEKT) />
		<cfset storeid = URL.STOREID />
		
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="formList" output="false" access="public" hint="">
		<cfset formularze = model("store_form").listForms() />
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="addForm" output="false" access="public" hint="">
		<cfif IsDefined("FORM.FIELDNAMES")> 
			
			<cfset newForm = structNew() />
			<cfset newForm.success = true />
			<cfset newForm.message = "Stworzyłem nową definicję formularza" />
			
			<cfset newForm = model("store_form").create(
				name = FORM.FORM_NAME,
				userid = session.user.id) />
			
			<cfif newForm.success is true>
				<cfloop list="#FORM.ATTRID#" index="i">
					<cfset var tmp = listToArray(i, ".") />
					
					<cfset var newFrmAttr = structNew() />
					<cfset newFrmAttr.success = true />
					<cfset newFrmAttr.message = "Przypisałem atrybut do formularza" />
					
					<cfset newFrmAttr = model("store_form").createFormAttribute(
						formid = newForm.id,
						attributeid = tmp[1],
						typeid = tmp[2] 
					) />
				</cfloop>
			</cfif>
			
		</cfif>
		
		<cfset attributes = model("store_attribute").listAttributes() />
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="removeForm" output="false" access="public" hint="">
		<cfif IsDefined("URL.FORMID")>
			<cfset usunFormularz = model("store_form").delete(URL.FORMID) />
		</cfif>
		
		<cfset formularze = model("store_form").listForms() />
		<cfset renderWith(data="obiekty",layout=false,template="formlist") />
	</cffunction>
	
	<cffunction name="editForm" output="false" access="public" hint="">
		<cfif IsDefined("URL.FORMID")>
			<cfset formularz = model("store_form").listFormAttributes(URL.FORMID) />
			
			<cfset atrybuty = model("store_attribute").listAttributes() />
			<cfset formid = URL.FORMID />
			<cfset usesLayout(false) />
		<cfelse>
			<cfset renderNothing() />
		</cfif>
		
	</cffunction>
	
	<cffunction name="formAttributes" output="false" access="public" hint="">
		<cfset json = model("store_form").listFormAttributes(URL.FORMID) />
		<cfset json = QueryToStruct(Query = json) />
		<cfset renderWith(data="json",template="/json",layout=false) />
	</cffunction>
	
	<cffunction name="addFormToStore" output="false" access="public" hint="">
		<cfif IsDefined("URL.STOREID")>
			<cfset strid = URL.STOREID />
		</cfif>
		
		<cfset sklepy = model("store_form").listStores() />		
		<cfset formularze = model("store_form").listForms() />
		
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="addFormToStoreAction" output="false" access="public" hint="">
		<cfif IsDefined("FORM.FIELDNAMES") AND IsDefined("FORM.FORMID") AND Len("FORM.FORMID") GT 0>
			<cfset storeid = FORM.STOREID />
			<cfset store = model("store_store").getStoreById(storeid) />
			
			<cfset formularze = arrayNew(1) />
			<cfloop list="#FORM.FORMID#" index="element" >
				
				<cfset var formularz = model("store_form").listFormAttributes(
					formid = element) />
				
				<cfset arrayAppend(formularze, formularz) />
				
			</cfloop>
			
			<cfset slownik = model("store_attribute").getDictionary() />
			
			<cfset usesLayout(false) />
		<cfelse>
			<cfset renderNothing() />
		</cfif>
	</cffunction>
	
	<cffunction name="saveStoreForm" output="false" access="public" hint="">
		<cfif IsDefined("FORM.FIELDNAMES")>
			<cfset formInstance = structNew() />
			<cfset formInstance.success = true />
			<cfset formInstance.message = "Dodałem formularz do sklepu" />
			
			<cfset formInstance = model("store_form_instance").create(
				formid = URL.FORMID,
				userid = session.user.id,
				storeid = URL.STOREID,
				project = FORM.PROJEKT) />
				
			<cfif formInstance.success is true>
				<cfloop list="#FORM.FIELDNAMES#" index="element">
					<cfif findNoCase("ATTRIBUTE", element)>
						<cfset var tmp = listToArray(element, "-") />
						<cfset var tmp2 = listToArray(tmp[2], ".") />
					
						<cfset var newAttr = structNew() />
						<cfset newAttr.success = true />
						<cfset newAttr.message = "Dodałem atrybut do formularza" />
						
						<cfset newAttr = model("store_form_instance").createValue(
							formid = tmp2[1],
							attributeid = tmp2[2],
							typeid = tmp2[3],
							instanceid = formInstance.id,
							text = FORM["#element#"]
						) />
					</cfif>
				</cfloop>
			</cfif>
		</cfif>
		
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="formDetails" output="false" access="public" hint="">
		<cfset szczegoly = model("store_form").storeFormDetails(
			storeid = URL.STOREID,
			formid = URL.FORMID,
			projekt = URL.PROJEKT) />
			
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="removeInstance" output="false" access="public" hint="">
		<cfif IsDefined("URL.INSTANCEID")>
			<cfset instance = model("store_form_instance").delete(URL.INSTANCEID) />
		</cfif>
		
		<cfset renderNothing() />
	</cffunction>
	
	<cffunction name="editInstance" output="false" access="public" hint="">
		
		<cfif IsDefined("FORM.FIELDNAMES") and IsDefined("URL.INSTANCEID")>
			
			<cfloop list="#FORM.FIELDNAMES#" index="element">
				<cfif findNoCase("ATTRIBUTE", element)>
					<cfset var tmp = listToArray(element, "-") />
					<cfset var tmp2 = listToArray(tmp[2], ".") />
					
					<cfset var newAttr = structNew() />
					<cfset newAttr.success = true />
					<cfset newAttr.message = "Atrybut został przypisany do formularza" />
						
					<cfset newAttr = model("store_form_instance").updateValue(
						formid = tmp2[1],
						attributeid = tmp2[2],
						typeid = tmp2[3],
						instanceid = URL.INSTANCEID,
						text = FORM["#element#"]
					) />
				</cfif>
			</cfloop>
			
		</cfif>
		
		<cfset instanceid = URL.INSTANCEID />
		<cfset formularz = model("store_form_instance").getFormByInstance(URL.INSTANCEID) />
		<cfset atrybuty = model("store_form_instance").getInstanceAttributes(URL.INSTANCEID) />
		<cfset slownik = model("store_attribute").getDictionary() />
		
		<cfset usesLayout(false) />
	</cffunction>
	
</cfcomponent>