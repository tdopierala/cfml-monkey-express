<cfcomponent displayname="Objects" output="false" extends="Controller">
	
	<cffunction name="init" output="false" access="public" hint="">
		<cfset super.init() />
		<cfset filters(type="before",through="loadLayout,initVariables") />
		
	</cffunction>
	
	<cffunction name="loadLayout" output="false" access="public" hint="">
		<cfset usesLayout("/layout") />
		<cfset application.ajaxImportFiles &= ",initObjects" />
	</cffunction>
	
	<cffunction name="initVariables" output="false" access="public" hint="">
		<!--- Inicjuje niezbędne componenty --->
		<cfparam name="variables.objectGateway" default="#createObject("component", "cfc.objects.objectGateway").init(get('loc').datasource.intranet)#" />
		<cfparam name="variables.object_attrGateway" default="#createObject("component", "cfc.objects.object_attrGateway").init(get('loc').datasource.intranet)#" />
		<cfparam name="variables.object_defGateway" default="#createObject("component", "cfc.objects.object_defGateway").init(get('loc').datasource.intranet)#" />
		<cfparam name="variables.object_def_attrGateway" default="#createObject("component", "cfc.objects.object_def_attrGateway").init(get('loc').datasource.intranet)#" />
		<cfparam name="variables.object_instGateway" default="#createObject("component", "cfc.objects.object_instGateway").init(get('loc').datasource.intranet)#" />
			
		<cfparam name="variables.object_attrDAO" default="#createObject("component", "cfc.objects.object_attrDAO").init(get('loc').datasource.intranet)#" />
		
		<cfparam name="variables.object_attr_typeDAO" default="#createObject("component", "cfc.objects.object_attr_typeDAO").init(get('loc').datasource.intranet)#" />
		
		<cfparam name="variables.object_def_attrDAO" default="#createObject("component", "cfc.objects.object_def_attrDAO").init(get('loc').datasource.intranet)#" />
		
		<cfparam name="variables.object_defDAO" default="#createObject("component", "cfc.objects.object_defDAO").init(get('loc').datasource.intranet)#" />
		
		
		<cfparam name="variables.object_instDAO" default="#createObject("component", "cfc.objects.object_instDAO").init(get('loc').datasource.intranet)#" />
		
		<cfparam name="variables.object_inst_valueDAO" default="#createObject("component", "cfc.objects.object_inst_valueDAO").init(get('loc').datasource.intranet)#" />
	</cffunction>
	
	<cffunction name="newObjectDef" output="false" access="public" hint="">
		
		<cfif IsDefined("FORM.FIELDNAMES")>
			
			<cfset var new_def = createObject("component", "cfc.objects.object_def").init(
				userid = session.user.id,
				name = FORM.DEF_NAME,
				create = Now()
			) />
			
			<cfset results = structNew() />
			<cfset results.success = true />
			<cfset results.message = "Definicja obiektu została dodana" />
			
			<cfset results = variables.object_defDAO.create(new_def) />
			
			<cfif results.success is true>
				<cfloop list="#FORM.ATTR_ID#" index="attr" >
					<cfset var new_def_attr = createObject("component", "cfc.objects.object_def_attr").init(
						defid = new_def.getId(),
						attrid = attr,
						userid = session.user.id,
						create = Now()
					) />
					
					<cfset results2 = structNew() />
					<cfset results2.success = true />
					<cfset results2.message = "Atrybut został dopisany do definicji obiektu" />
					
					<cfset variables.object_def_attrDAO.create(new_def_attr) />
				</cfloop>
			</cfif> 
			
		</cfif>
		
		<cfset attr = variables.object_attrGateway.listAttr() />
		
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="newAttrDef" output="false" access="public" hint="">
		<cfset attr_types = variables.object_attrGateway.listTypes() />
		
		<cfif IsDefined("FORM.FIELDNAMES")>
			<cfset var new_attr = createObject("component", "cfc.objects.object_attr").init(
				name = FORM.ATTR_NAME,
				userid = session.user.id,
				create = "#Now()#",
				typeid = FORM.ATTR_TYPE_ID
			) />
			
			<cfset results = structNew() />
			<cfset results.success = true />
			<cfset results.message = "Atrybut został dodany" />
			
			<cfset results = variables.object_attrDAO.create(new_attr) />
		</cfif>
		
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="listObjects" output="false" access="public" hint="">
		<cfset obiekty = variables.object_defGateway.listAllObjects() />
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="moveObjectDef" output="false" access="public" hint="">
		<cfset results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Obiekt został przeniesiony w strukturze" />

		<cfset results = variables.object_defGateway.move(
			currentNode = FORM.MY_ROOT,
			newNode = FORM.NEW_PARENT) />

		<cfset obiekty = variables.object_defGateway.listAllObjects() />
		<cfset renderPage(template="listobjects",layout=false) />
	</cffunction>

	<cffunction name="deleteObjectDef" output="false" access="public" hint="">
		<cfset results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Definicja obiektu została usunięta" />

		<cfset def = createObject("component", "cfc.objects.object_def").init(
			id = URL.KEY) />

		<cfset results = variables.object_defDAO.delete(def) />

		<cfset obiekty = variables.object_defGateway.listAllObjects() />
		<cfset renderPage(template="listobjects",layout=false) />
	</cffunction>

	<cffunction name="nodeNextLevel" output="false" access="public" hint="">
		<cfset obiekty = queryNew("id") />
		<cfif IsDefined("FORM.ID")>
			<cfset obiekty = variables.object_defGateway.nodeNextLevel(
				id = FORM.ID,
				depth = 1) />
		</cfif>
	</cffunction>

	<cffunction name="add" output="false" access="public" hint="">
		<cfset obiekty = variables.object_defGateway.tree() />
	</cffunction>

	<cffunction name="instanceForm" output="false" access="public" hint="">

		<cfif IsDefined("FORM.FIELDNAMES")>
			
			<cfset var pid = "" />
			
			<cfif IsDefined("FORM.PARENTID")>
				<cfloop list="#FORM.PARENTID#" index="element" >
					<cfset pid &= ":#element#:" />
				</cfloop>
			</cfif>
			
			<cfset inst = createObject("component", "cfc.objects.object_inst").init(
				defid = FORM.DEFID,
				userid = session.user.id,
				create = Now(),
				note = "",
				name = FORM.INST_NAME,
				parentid = pid) />

			<cfset results = structNew() />
			<cfset results.success = true />
			<cfset results.message = "Instancja obiektu została utworzona" />

			<cfset results = variables.object_instDAO.create(inst) />
			<cfif results.success is true>
				<!--- Przechodzę przez wszystkie przesłane pola formularza --->
				<cfloop list="#FORM.FIELDNAMES#" delimiters="," index="field">

					<!--- SPrawdzam, czy przesłanym polem jest atrybut obiektu --->
					<cfif find(":", field)>
						
						<!--- Wyciągam potrzebne identyfikatory z nazwy pola --->
						<cfset var attribute = listToArray("#field#", ":") />
						<cfset var attributeIds = listToArray("#attribute[2]#", ".") />
						<cfset instVal = createObject("component", "cfc.objects.object_inst_value").init(
							defid = attributeIds[1],
							instid = inst.getId(),
							attrid = attributeIds[2],
							defattrid = attributeIds[3],
							attrtypeid = attributeIds[4],
							text = FORM["#field#"]) />

						<cfset results2 = structNew() />
						<cfset results2.success = true />
						<cfset results2.message = "Atrybut instancji został zapisany" />

						<cfset results2 = variables.object_inst_valueDAO.create(instVal) />
					</cfif>
				</cfloop>
			</cfif>

		</cfif>

		<cfset object = createObject("component", "cfc.objects.object_def").init(
			id = URL.DEFID) />

		<cfset variables.object_defDAO.read(object) />
		<cfset atrybuty = variables.object_defGateway.defAttributes(URL.DEFID) />
		<cfset parents = variables.object_instGateway.getInstances() />
		<cfset usesLayout(false) />
	</cffunction>

	<cffunction name="defInstances" output="false" access="public" hint="">
		
	</cffunction>
	
	<cffunction name="objectAttributes" output="false" access="public" hint="">
		<cfset atrybuty = queryNew("id") />
		
		<cfif IsDefined("URL.DEFID")>
			<cfset atrybuty = variables.object_defGateway.defAttributes(URL.DEFID) />
			<cfset object = createObject("component", "cfc.objects.object_def").init(
				id = URL.DEFID) />
			<cfset variables.object_defDAO.read(object) />
		</cfif>
		
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="removeObjectAttr" output="false" access="public" hint="">
		<cfset defAttrId = variables.object_def_attrGateway.getDefAttrId(
			defid = URL.DEFID,
			attrid = URL.ATTRID
		) />
		
		<cfset results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Atrybut został usunięty z definicji obiektu" />
		
		<cfset defAttr = createObject("component", "cfc.objects.object_def_attr").init(
			id = defAttrId) />
		<cfset results = variables.object_def_attrDAO.delete(defAttr) />
		
		<cfset atrybuty = variables.object_defGateway.defAttributes(URL.DEFID) />
		<cfset object = createObject("component", "cfc.objects.object_def").init(
			id = URL.DEFID) />
		<cfset variables.object_defDAO.read(object) />
		<cfset renderPage(template="objectattributes",layout=false) />
		
	</cffunction>
	
	<cffunction name="addObjectAttr" output="false" access="public" hint="">
		
		<cfif IsDefined("FORM.FIELDNAMES")>
			<cfset var new_def_attr = createObject("component", "cfc.objects.object_def_attr").init(
				defid = URL.DEFID,
				attrid = FORM.ATTRID,
				userid = session.user.id,
				create = Now()
			) />
			
			<cfset results = structNew() />
			<cfset results.success = true />
			<cfset results.message = "Atrybut został dodany do definicji obiektu" />
			
			<cfset results = variables.object_def_attrDAO.create(new_def_attr) />
		</cfif>
		
		<cfset defid = URL.DEFID />
		<cfset availableAttr = variables.object_defGateway.defAvailableAttr(URL.DEFID) />
		<cfset usesLayout(false) />
	</cffunction>
	
</cfcomponent>