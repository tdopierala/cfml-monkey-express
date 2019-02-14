<cfcomponent 
	extends="Controller">
	
	<cffunction 
		name="init">
		
		<cfset super.init() />
		<cfset filters(through="authentication,setParameters") />
		
	</cffunction>
	
	<cffunction 
		name="authentication">
	
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="_root" >
			<cfinvokeargument name="groupname" value="root" />
		</cfinvoke>
			
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="_kos" >
			<cfinvokeargument name="groupname" value="KOS" />
		</cfinvoke>
		
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="_proposalpps" >
			<cfinvokeargument name="groupname" value="Wnioski o zmianę PPS" />
		</cfinvoke>
		
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="_pdsr" >
			<cfinvokeargument name="groupname" value="Partner ds rekrutacji" />
		</cfinvoke>
		
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="_ds" >
			<cfinvokeargument name="groupname" value="Departament Sprzedaży" />
		</cfinvoke>
		
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="_regio" >
			<cfinvokeargument name="groupname" value="Dyrektor Regionalny" />
		</cfinvoke>
		
		<cfif _root is true or _kos is true or _proposalpps is true or _pdsr is true or _ds is true>
			
		<cfelse>
			<cfset renderPage(template="/autherror") />
		</cfif>
	
	</cffunction>
	
	<cffunction 
		name="setParameters">
		
		<cfset methods = QueryNew("id,name","Integer,VarChar") />
		<cfset QueryAddRow(methods, 3) />
		<cfset QuerySetCell(methods, "id", 1, 1) />
		<cfset QuerySetCell(methods, "name", "wypowiedzenie z zachowaniem okresu z umowy współpracy", 1) />
		<cfset QuerySetCell(methods, "id", 2, 2) />
		<cfset QuerySetCell(methods, "name", "wypowiedzenie natychmiastowe", 2) />
		<cfset QuerySetCell(methods, "id", 3, 3) />
		<cfset QuerySetCell(methods, "name", "rozwiązanie za porozumieniem stron", 3) />
		
		<cfset directors = QueryNew("id,name","Integer,VarChar") />
		<cfset QueryAddRow(directors, 2) />
		<cfset QuerySetCell(directors, "id", 16, 1) />
		<cfset QuerySetCell(directors, "name", "Błażej Komorski", 1) />
		<cfset QuerySetCell(directors, "id", 1777, 2) />
		<cfset QuerySetCell(directors, "name", "Test User", 2) />
		
		<cfif _root is true>
			<cfset QueryAddRow(directors, 1) />
			<cfset QuerySetCell(directors, "id", 345, 3) />
			<cfset QuerySetCell(directors, "name", "Tomasz Dopierała", 3) />
		</cfif>
		
		<!---<cfset reasons = QueryNew("id,name","Integer,VarChar") />
		<cfset QueryAddRow(reasons, 10) />
		<cfset QuerySetCell(reasons, "id", 1, 1) />
		<cfset QuerySetCell(reasons, "name", "Nieregularne wpłaty", 1) />
		<cfset QuerySetCell(reasons, "id", 2, 2) />
		<cfset QuerySetCell(reasons, "name", "Niedostosowanie godzin otwarcia sklepu", 2) />
		<cfset QuerySetCell(reasons, "id", 3, 3) />
		<cfset QuerySetCell(reasons, "name", "Sprzedaż produktów nieoferowanych przez Centralę", 3) />
		<cfset QuerySetCell(reasons, "id", 4, 4) />
		<cfset QuerySetCell(reasons, "name", "Zaniedbanie lokalu oraz wyposażenia", 4) />
		<cfset QuerySetCell(reasons, "id", 5, 5) />
		<cfset QuerySetCell(reasons, "name", "Niedostosowanie się do Standardów Sieci", 5) />
		<cfset QuerySetCell(reasons, "id", 6, 6) />
		<cfset QuerySetCell(reasons, "name", "Niezastosowanie zasad merchandisingu", 6) />
		<cfset QuerySetCell(reasons, "id", 7, 7) />
		<cfset QuerySetCell(reasons, "name", "Nieprzestrzeganie zasad sprzedaży napojów alkoholowych, wyrobów tytoniowych, wyrobów farmaceutycznych a także usług płatniczych", 7) />
		<cfset QuerySetCell(reasons, "id", 8, 8) />
		<cfset QuerySetCell(reasons, "name", "Prowadzenie działalności konkurencyjnej", 8) />
		<cfset QuerySetCell(reasons, "id", 9, 9) />
		<cfset QuerySetCell(reasons, "name", "Niedostosowanie się do zaleceń KOS", 9) />
		<cfset QuerySetCell(reasons, "id", 10, 10) />
		<cfset QuerySetCell(reasons, "name", "inny...", 10) />--->
		
		<!---<cfset reasons = model("Pps_proposal_reason").findAll(where="active=1", order="order ASC") />--->
	
	</cffunction>
	
	<cffunction 
		name="index">
		
		<cfif _regio is true>
			
			<cfset proposals = model("Pps_proposal").findAllProposals(directorid=session.user.id) />
			
		<cfelseif _proposalpps is true or _ds is true>
			
			<cfset proposals = model("Pps_proposal").findAllProposals() />
			
		<cfelse>
			
			<cfset proposals = model("Pps_proposal").findAllProposals(userid=session.user.id) />
			
		</cfif>
		
		<!---<cfset variable = params />
		<cfset renderWith(data="variable",template="/dump",layout=false) />--->
	</cffunction>
	
	<cffunction name="add">
	
		<cfif _root is not true and _kos is not true>
			<cfset renderPage(template="/autherror") />
		</cfif>
		
		<cfset reasons = model("Pps_proposal_reason").findAll(where="active=1", order="order ASC") />
		
		<cfif StructKeyExists(params, "proposal")>
			
			<cfset lp = model("Pps_proposal").findAll(select="MAX(lp) as lpmax") />	
			
			<cfset _proposal = {} />
			
			<cfset _proposal.projekt		= params.proposal.projekt />
			<cfset _proposal.lp				= lp.lpmax + 1 />
			<cfset _proposal.reason			= params.proposal.reason />
			<cfset _proposal.reasonid		= params.proposal.reasonid />
			<cfset _proposal.methodid		= params.proposal.methodid />
			<cfset _proposal.changedate		= params.proposal.changedate />
			<cfset _proposal.directorid		= params.proposal.directorid />
			<cfset _proposal.userid			= session.user.id />
			<cfset _proposal.statusid		= 1 />
			<cfset _proposal.createddate	= Now() />
			
			<cfset proposal = model("Pps_proposal").create(_proposal) />
			
			<cfif proposal.hasErrors()>
				<cfset flashInsert(error="Wystąpił błąd. Nie dodano wniosku.") />
			<cfelse>
				<cfset flashInsert(success="Dodawanie nowego wniosku zakończono pomyślnie.") />
			</cfif>
			
			<cfset redirectTo(action="index") />
			<!---<cfset variable = _proposal />
			<cfset renderWith(data="variable",template="/dump",layout=false) />--->
		</cfif>
		
	</cffunction>
	
	<cffunction 
		name="view">
		
		<cfif StructKeyExists(params, "key")>
		
			<cfset proposal = model("Pps_proposal").findByKey(key=params.key, include="kos,reasons") />
			
			<cfset store = model("Store_store").findOne(where="projekt='#proposal.projekt#' AND is_active=1") />
			
			<cfif not IsObject(proposal)>
				<cfset flashInsert(error="Wniosek nie istnieje.") />
				<cfset redirectTo(action="index") />
			</cfif>
		<cfelse>
		
			<cfset flashInsert(error="Wniosek nie istnieje.") />
			<cfset redirectTo(action="index") />
		</cfif>
		
		<!---<cfset variable = proposal />
		<cfset renderWith(data="variable",template="/dump",layout=false) />--->
	</cffunction>
	
	<cffunction 
		name="accept">
		
		<cfif StructKeyExists(params, "key")>
			<cfset proposal = model("Pps_proposal").findByKey(params.key) />
			<cfset proposal.update(statusid=params.statusid, statusnote=params.statusnote) />
			
			<!---<cfset users = model("User").findAll(where="id=345") />
			<cfset message="Wniosek nr #proposal.id# został zaakceptowany" />
			<cfset mail = model("Email").proposalPpsNotification(user=users, message=message) />--->
		
		</cfif>
		
		<cfset json = params />
		<cfset renderWith(data="json",template="/json",layout=false) />
	
	</cffunction>
	
	<cffunction 
		name="confirm">
		
		<cfif StructKeyExists(params, "key")>
			<cfset proposal = model("Pps_proposal").findByKey(params.key) />
			<cfset proposal.update(completed=1) />
			
			<!---<cfset users = model("User").findAll(where="id=345") />
			<cfset message="Wniosek nr #proposal.id# został zaakceptowany" />
			<cfset mail = model("Email").proposalPpsNotification(user=users, message=message) />--->
		
		</cfif>
		
		<cfset json = params />
		<cfset renderWith(data="json",template="/json",layout=false) />
	
	</cffunction>
	
	<cffunction 
		name="findStores">
		
		<cfset json = '' />
		<cfif StructKeyExists(params, "q")>
			
			<cfif _root is true>
				<cfset proposal = model("Store_store").findAll(
					where="is_active=1 AND projekt LIKE '%#params.q#%'",
					include="partner") />
			<cfelse>
				<cfset proposal = model("Store_store").findAll(
					where="is_active=1 AND projekt LIKE '%#params.q#%' AND partnerid=#session.user.id#",
					include="partner") />
			</cfif>
			
			<cfset json = proposal />
		</cfif>
		
		<cfset renderWith(data="json",template="/json",layout=false) />
	
	</cffunction>
	
</cfcomponent>