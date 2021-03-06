<cfcomponent 
	extends="Controller">
	
	<cffunction 
		name="init">
			
		<cfset super.init() />
		<cfset provides("html,json,js")>
		<cfset usesLayout(template="/layout",only="index") />
	</cffunction>

	<cffunction 
		name="index"
		hint="Wyświetla strukturę organizacyjną">
			
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="centrala" >
			<cfinvokeargument name="groupname" value="Centrala" />
		</cfinvoke>
			
		<cfif centrala is true>
		
			<cfset struct = model('usersStructure').usersStructureView() />
			<cfset priv = model('tree_groupuser').getUserGroups(session.userid) />
			
			<cfif StructKeyExists(params, 'edit') and params.edit eq 'true' >
				
				<cfif not privArrayContains(priv.rows, 14) and not privArrayContains(priv.rows, 31) >
					<cfset renderPage(template="/autherror") />
				</cfif>
				
			</cfif>
			
			<cfif IsAjax()>
				<cfset renderPartial('index') >
			</cfif>
			
		</cfif>
		
	</cffunction>
	
	<cffunction 
		name="usersStructDetails" 
		hint="Pobiera szczególowe dane użytkownika do struktóry organizacyjnej">
		
		<cfset user = model('user').findByKey(params.key) />
		<cfset attribute = model('userAttributeValue').findAll(where="userid=#params.key#", include="attribute") />
		
	</cffunction>
	
	<cffunction 
		name="usersStructMove"
		hint="Zmienia miejsce położenia użytkownika/grupy w strukturze organizacyjnej">
		
		<cfif structKeyExists(params, "my_id") && structKeyExists(params, "parent_id")>
			
			<cfset groups = model("usersStructure").moveStructureElement(
				myid 	= 	params.my_id,
				rootid 	= 	params.parent_id
			)>
			
		</cfif>
		
		<cfset renderNothing() />
		<!--- <cfset renderPartial('/groups_tmp/groups_ajax') > --->
		
	</cffunction>
	
	<cffunction 
		name="usersStructAdd"
		hint="Dodaje użytkownika lub departament do struktury organizacyjnej">
		
		<!--- <cfcontent type="application/json; charset=utf-8"> --->
		
		<cfif structKeyExists(params, "type") && structKeyExists(params, "name") && structKeyExists(params, "id")>
			
			<cfif params.id eq '' >
				<cfset params.id = 0 />
			</cfif>
			
			<cfset groups = model("usersStructure").addStructureElement(
				_type	=	params.type,
				_name	=	params.name,
				_uid		=	params.id
			)>
			
		</cfif>

		<cfset renderNothing() />
		<!--- <cfset renderPartial('/groups_tmp/groups_ajax') > --->
		
	</cffunction>
	
	<cffunction 
		name="usersStructDelete"
		hint="Usuwa uzytkownika lub departament ze struktury organizacyjnej">
			
		<cfif structKeyExists(params, "id")>
			
			<cfset groups = model("usersStructure").deleteStructureElement(
				_id	=	params.id
			)>
			
		</cfif>

		<cfset renderNothing() />
		<!--- <cfset renderPartial('/groups_tmp/groups_ajax') > --->
			
	</cffunction>
	
	<cffunction 
		name="privArrayContains"
		hint="Listuje tablicę przypisanych grup i sprawdza dostępność">
		
		<cfargument name="tab" type="array" required="true" />
		
		<cfargument name="num" type="numeric" required="true" />
		
		<cfset flag=0 />
		<cfloop array="#arguments.tab#" index="idx">
			
			<cfif idx.groupid eq arguments.num>
				<cfset flag=1 />
				<cfreturn true />
			</cfif>
			
		</cfloop>
		
		<cfif flag eq 0>
			<cfreturn false />
		</cfif>
		
	</cffunction>
	
</cfcomponent>