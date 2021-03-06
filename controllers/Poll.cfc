<cfcomponent 
	extends="Controller"> 
	
	<cffunction 
		name="init">
    	
    	<cfset super.init() />
    	<!---<cfset usesLayout(template="/layout.cfm", only="canvas", useDefault="false")>--->
		
	</cffunction>

	<cffunction 
		name="index">
		
		<cfset renderNothing() />
	</cffunction>

	<cffunction 
		name="cigarettes" output="false" access="public" hint="">
			
		<cfset cigarette = model("Poll_cigarette").findAll(where="userid=#session.user.id#") />
		
		<cfset cigtab=ArrayNew(1) />
		<cfloop query="cigarette">
			<cfset ArrayAppend(cigtab, symkar) />
		</cfloop>
		
		<cfif StructKeyExists(cigarette, "RecordCount")>
			<cfset count = cigarette.RecordCount />
		<cfelse>
			<cfset count = 0 />
		</cfif>
			
		<!---<cfif IsDefined("FORM") and StructKeyExists(FORM, "symkar") and count eq 0>
			
			<cfset cig = ListToArray(FORM.symkar) />
			
			<cfloop array="#cig#" index="idx">
				
				<cfset cigarette = model("Poll_cigarette").new() />
				<cfset cigarette.userid = session.user.id />
				<cfset cigarette.symkar = idx />
				<cfset cigarette.createddate = Now() />
				
				<cfset cigarette.save() />
				
			</cfloop>
			
		</cfif>--->
		
		<cfset var asseco = createObject("component", "cfc.assecoConnector").init(
			assecoConnectorDsn = "assecoConnector",
			intranetDsn = "intranet",
			assecoDsn = "asseco") />
			
		<cfset cigarettes = asseco.cigarettesPoll() />
		
		<!---<cfset variable = cigarettes />
		<cfset renderWith(data="variable",template="/dump",layout=false) />--->
	</cffunction>
	
	<cffunction 
		name="cigarettesAction">
		
		<cfset cigarette = model("Poll_cigarette").findAll(where="userid=#session.user.id#") />
		
		<cfif StructKeyExists(cigarette, "RecordCount")>
			<cfset count = cigarette.RecordCount />
		<cfelse>
			<cfset count = 0 />
		</cfif>
			
		<cfif IsDefined("FORM") and StructKeyExists(FORM, "symkar") and count eq 0>
			
			<cfset cig = ListToArray(FORM.symkar) />
			
			<cfloop array="#cig#" index="idx">
				
				<cfset cigarette = model("Poll_cigarette").new() />
				<cfset cigarette.userid = session.user.id />
				<cfset cigarette.symkar = idx />
				<cfset cigarette.createddate = Now() />
				
				<cfset cigarette.save() />
				
			</cfloop>
			
		</cfif>
		
		<cfset redirectTo(action="cigarettes") />
	</cffunction>
	
	<cffunction 
		name="cigarettesResult">
		
		<cfset stores = model("Poll_cigarette")
			.findAll(
				group="userid",
				order="login ASC",
				include="User") />
		
	</cffunction>
	
	<cffunction 
		name="cigarettesDetails">
			
		<cfif StructKeyExists(params, "key")>
			
			<cfset chosen = model("Poll_cigarette").findAll(where="userid=#params.key#") />
			
			<cfset cigtab=ArrayNew(1) />
			<cfloop query="chosen">
				<cfset ArrayAppend(cigtab, symkar) />
			</cfloop>
			
			<cfset var asseco = createObject("component", "cfc.assecoConnector").init(
				assecoConnectorDsn = "assecoConnector",
				intranetDsn = "intranet",
				assecoDsn = "asseco") />
				
			<cfset cigarettes = asseco.cigarettesPoll() />
			
		<cfelse>
			<cfset renderNothing() />
		</cfif>
		
	</cffunction>
	
	<cffunction 
		name="cigarettesResultCount">
		
		<cfset pollresult = model("Poll_cigarette").countBySymkar() />
				
		<cfset cigarettesCount = model("Poll_cigarette").findAll(select="count(id) as c") />
		
		<cfset var asseco = createObject("component", "cfc.assecoConnector").init(
				assecoConnectorDsn = "assecoConnector",
				intranetDsn = "intranet",
				assecoDsn = "asseco") />
				
		<cfset qCigarettes = asseco.cigarettesPoll() />
		
	</cffunction>
	
</cfcomponent>