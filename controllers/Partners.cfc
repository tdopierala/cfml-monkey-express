<cfcomponent extends="Controller">
	
	<cffunction name="init">
		<cfset super.init() />
		<cfset filters(through="before",type="before") />
	</cffunction>
	
	<cffunction name="before">
		<!---<cfset usesLayout(template="/layout",ajax=false) />--->
		<!---<cfset myuser = model("user").findByKey(session.userid) />
		<cfset mypartner = model("partner").findOne(where="logo='#myuser.logo#'") />--->
		<cfparam name="post" default="#getHTTPRequestData().content#" type="any" />
		<cfset usesLayout(template="/layout") />
		
		<cfset APPLICATION.bodyImportFiles &= ",initPartners" />
		
	</cffunction>
	
	<cffunction name="absences" output="false" access="public" hint="">
		
		<cfset var currentDate = Now() />
		<cfif dayOfWeek(currentDate) gt 1>
			<cfset mostRecentMonday = dateAdd("d", 2 - dayOfWeek(currentDate), currentDate) />
		<cfelse>
			<cfset mostRecentMonday = dateAdd("d", -6, currentDate)>
		</cfif>
		
		<!---
			Pobierając nieruchomości muszę sprawdzić, czy jestem w grupie 
			Dyr. Dep Sprzedaży lub Ekspansji lub Personalnego. Wtedy pokazuje
			odpowiednie nieobecności.
		--->
		<cfparam name="groupid" type="numeric" default="0" />
		<cfinvoke method="checkUserTreeGroup" component="controllers.Tree_groupusers" returnvariable="dyrSprzedazy">
			<cfinvokeargument name="groupname" value="Dyrektor Dep. Sprzedaży" />
		</cfinvoke>
		
		<cfif dyrSprzedazy is true>
			<cfset groupid = model("tree_groupuser").getGroupIdByName("Partner ds sprzedaży") />
		</cfif>
		
		<cfinvoke method="checkUserTreeGroup" component="controllers.Tree_groupusers" returnvariable="dyrEkspansji">
			<cfinvokeargument name="groupname" value="Dyrektor Dep. Ekspansji" />
		</cfinvoke>
		
		<cfinvoke method="checkUserTreeGroup" component="controllers.Tree_groupusers" returnvariable="wnioskiEkspansji">
			<cfinvokeargument name="groupname" value="Wnioski urlopowe partnerow ekspansyjnych" />
		</cfinvoke>
		
		<cfif dyrEkspansji is true>
			<cfset groupid = model("tree_groupuser").getGroupIdByName("Partner ds ekspansji") />
		</cfif>
		
		<cfinvoke method="checkUserTreeGroup" component="controllers.Tree_groupusers" returnvariable="pelnomocnik">
			<cfinvokeargument name="groupname" value="Pełnomocnik" >
		</cfinvoke>
		
		<cfif pelnomocnik is true>
			<cfset groupid = model("tree_groupuser").getGroupIdByName("Pełnomocnik") />
		</cfif>
		
		<cfinvoke method="checkUserTreeGroup" component="controllers.Tree_groupusers" returnvariable="dyrPersonalny">
			<cfinvokeargument name="groupname" value="Dyrektor Dep. Personalnego" />
		</cfinvoke>
		
		<cfif wnioskiEkspansji is true>
			<cfset groupid = model("tree_groupuser").getGroupIdByName("Partner ds ekspansji") />
		</cfif>
		
		<cfif dyrPersonalny is true>
			<cfset groupid = model("tree_groupuser").getGroupIdByName("Partnerzy") />
		</cfif>

		<cfset var gid = 0 />
		<cfif IsStruct(groupid)>
			<cfset gid = groupid["ROWS"][1].id />
		</cfif>
		
		<cfset nieobecnosci = model("partner_absence").getUserAbsences(
			groupid = gid,
			id = session.user.id,
			date_from = mostRecentMonday,
			date_to = dateAdd("d", 6, mostRecentMonday)) />
		
		<cfif IsDefined("url.t")>
			<cfset usesLayout(false) />
		</cfif>
		
	</cffunction>
	
	<cffunction name="absenceWorkflow" output="false" access="public" hint="">
		<cfset workflow = queryNew("id") />
		
		<cfif IsDefined("url.key")>
			<cfset workflow = model("partner_absence_workflow").getAbsenceWorkflow(url.key) />
		</cfif>
	</cffunction>
	
	<cffunction name="newAbsence" output="false" access="public" hint="">
		
		<cfif IsDefined("FORM.FIELDNAMES")>
			<cfset newAbsence = model("partner_absence").create(FORM, session.user) /> 
		</cfif>
		
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="acceptation" output="false" access="public" hint="">
		<cfparam name="groupid" type="numeric" default="0" />
		
		<cfinvoke method="checkUserTreeGroup" component="controllers.Tree_groupusers" returnvariable="pelnomocnik">
			<cfinvokeargument name="groupname" value="Pełnomocnik" />
		</cfinvoke>
		
		<cfif pelnomocnik is true>
			<cfset groupid = model("tree_groupuser").getGroupIdByName("Pełnomocnik") />
		</cfif>
		
		<cfinvoke method="checkUserTreeGroup" component="controllers.Tree_groupusers" returnvariable="dyrSprzedazy">
			<cfinvokeargument name="groupname" value="Dyrektor Dep. Sprzedaży" />
		</cfinvoke>
		
		<cfif dyrSprzedazy is true>
			<cfset groupid = model("tree_groupuser").getGroupIdByName("Dyrektor Dep. Sprzedaży") />
		</cfif>
		
		<cfinvoke method="checkUserTreeGroup" component="controllers.Tree_groupusers" returnvariable="dyrEkspansji">
			<cfinvokeargument name="groupname" value="Dyrektor Dep. Ekspansji" />
		</cfinvoke>
		
		<cfif dyrEkspansji is true>
			<cfset groupid = model("tree_groupuser").getGroupIdByName("Dyrektor Dep. Ekspansji") />
		</cfif>
		
		<cfinvoke method="checkUserTreeGroup" component="controllers.Tree_groupusers" returnvariable="dyrPersonalny">
			<cfinvokeargument name="groupname" value="Dyrektor Dep. Personalnego" />
		</cfinvoke>
		
		<cfif dyrPersonalny is true>
			<cfset groupid = model("tree_groupuser").getGroupIdByName("Partnerzy") />
		</cfif>
		
		<cfset nieobecnosci = model("partner_absence").getGroupAbsences(groupid=groupid["ROWS"][1].id,userid=session.user.id) />
		
		<cfif IsDefined("URL.t") and URL.t is true>
			<cfset usesLayout(false) />
		</cfif>
		
	</cffunction>
	
	<cffunction name="acceptAbsence" output="false" access="public" hint="">
		<cfif IsDefined("FORM.ABSENCEID")>
			<cfset myAbsence = model("partner_absence").accept(id=FORM.ABSENCEID,userid=session.user.id) />
		</cfif>
		<cfset renderNothing() />
	</cffunction>
	
	<cffunction name="declineAbsence" output="false" access="public" hint="">
		<cfif IsDefined("FORM.ABSENCEID")>
			<cfset myAbsence = model("partner_absence").decline(id=FORM.ABSENCEID,userid=session.user.id) />
		</cfif>
		<cfset renderNothing() />
	</cffunction>
	
	<cffunction name="sendPasswords" output="false" access="public" hint="">
	</cffunction>
	
	<cffunction name="przypiszDostawceRegNaSklep" output="false" access="public" hint="">
		<cfset var sklepyB = model("store_store").getStoresProjektFilter("B%") />
		<cfloop query="sklepyB">
			<cfset var numer = Right(login, Len(login)-1) />
			
			<cfif model("store_contractor").czyIstniejeSklep("C#numer#") is true>
				<cfset var przepisz = model("store_contractor").przepiszDane(numer) />
			</cfif>
			
		</cfloop>
		<cfdump var="#sklepyB#" />
		<cfabort />
	</cffunction>
	
	<cffunction name="raportSprzedazy" output="false" access="public" hint="">
		<cfsetting requesttimeout="540" />
		
		<cfset var a = createObject("component", "cfc.assecoConnector").init(
			assecoConnectorDsn = "assecoConnector",
			intranetDsn = "intranet",
			assecoDsn = "asseco") />
			
		<!---<cfset var b = a.pobierzRaportSprzedazy("B13045") />--->
	</cffunction>
	
</cfcomponent>