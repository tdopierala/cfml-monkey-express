<cfcomponent displayname="Store_contribution_reports" output="false" hint="" extends="Controller">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset super.init() />
		<cfset filters(through="loadLayout",type="before") />
	</cffunction>
	
	<cffunction name="loadLayout" output="false" access="public" hint="">
		<cfset usesLayout("/layout") />
	</cffunction>
	
	<cffunction name="index" output="false" access="public" hint="">
		
		<cfparam name="sklep" type="string" default="" />
		<cfparam name="partnerid" type="string" default="" />
		<cfparam name="dzienOd" type="string" default="#DateFormat(Now(), "dd-mm-yyyy")#" />
		<cfparam name="dzienDo" type="string" default="#DateFormat(Now(), "dd-mm-yyyy")#" />
		<cfparam name="grupowanie" type="string" default="" />
		
		<cfif isDefined("session.raportWplat.sklep")>
			<cfset sklep = session.raportWplat.sklep />
		</cfif>
		
		<cfif isDefined("session.raportWplat.partnerid")>
			<cfset partnerid = session.raportWplat.partnerid />
		</cfif>
		
		<cfif isDefined("session.raportWplat.dzienOd")>
			<cfset dzienOd = session.raportWplat.dzienOd />
		</cfif>
		
		<cfif isDefined("session.raportWplat.dzienDo")>
			<cfset dzienDo = session.raportWplat.dzienDo />
		</cfif>
		
		<cfif isDefined("session.raportWplat.grupowanie")>
			<cfset grupowanie = session.raportWplat.grupowanie />
		</cfif>
		
		<cfif isDefined("FORM.sklep")>
			<cfset sklep = FORM.sklep />
		</cfif>
		
		<cfif isDefined("FORM.partnerid")>
			<cfset partnerid = FORM.partnerid />
		</cfif>
		
		<cfif isDefined("FORM.dzienOd")>
			<cfset dzienOd = FORM.dzienOd />
		</cfif>
		
		<cfif isDefined("FORM.dzienDo")>
			<cfset dzienDo = FORM.dzienDo />
		</cfif>
		
		<cfif isDefined("FORM.grupowanie")>
			<cfset grupowanie = FORM.grupowanie />
		</cfif>
		
		<cfset var a = createObject("component", "cfc.RaportWplatGateway").init(get('loc').datasource.mssql) />
		
		<cfset var tmpDataOd = listToArray(dzienOd, "-") />
		<cfset var tmpDataDo = listToArray(dzienDo, "-") />
		
		<cfset raport = a.pobierzRaportWplat(
			projekt = sklep,
			poczatek=DateFormat(createDate(tmpDataOd[3], tmpDataOd[2], tmpDataOd[1]), "dd-mm-yyyy"),
			koniec=DateFormat(createDate(tmpDataDo[3], tmpDataDo[2], tmpDataDo[1]), "dd-mm-yyyy"),
			partner = partnerid,
			grupowanie = grupowanie
		) />
		
		<cfset kos = model("tree_groupuser").getUsersByGroupName("KOS") />
		<cfset usesLayout(false) />
	</cffunction>
</cfcomponent>