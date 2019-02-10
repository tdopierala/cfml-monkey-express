<cfcomponent displayname="Place_eleader" output="false" extends="Controller">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset super.init() />
		<cfset filters(type="before",through="loadLayout") />
	</cffunction>
	
	<cffunction name="loadLayout" output="false" access="public" hint="">
		<cfset usesLayout("/layout") />
	</cffunction>
	
	<cffunction name="index" output="false" access="public" hint="">
	</cffunction>
	
	<cffunction name="formularzSklepu" output="false" access="public" hint="">
		<cfset eleader = createObject("component", "cfc.eleaderNieruchomosci").init(
			localDsn = "MSIntranet",
			remoteDsn = "eleader",
			intranetDsn = get('loc').datasource.intranet) />
		
		<cfset kolumnySklepu = eleader.pobierzKolumnySklepu() />
		
	</cffunction>
	
</cfcomponent>