<cfcomponent displayname="Store_sale_reports" output="false" hint="" extends="Controller">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset super.init() />
		<cfset filters(through="loadLayout",type="before") />
		<cfset filters(through="loadJs",type="before") />
	</cffunction>
	
	<cffunction name="loadLayout" output="false" access="public" hint="">
		<cfset usesLayout("/layout") />
	</cffunction>
	
	<cffunction name="loadJs" output="false" access="public" hint="">
		
	</cffunction>
	
	<cffunction name="index" output="false" access="public" hint="">
		<cfparam name="sklep" type="string" default="" />
		<cfparam name="dzienOd" type="string" default="#DateFormat(Now(), "dd-mm-yyyy")#" />
		<cfparam name="dzienDo" type="string" default="#DateFormat(Now(), "dd-mm-yyyy")#" />
		<cfparam name="partnerid" type="string" default="" />
		
		<cfif IsDefined("session.raport_sprzedazy.sklep")>
			<cfset sklep = session.raport_sprzedazy.sklep />
		</cfif>
		
		<cfif IsDefined("session.raport_sprzedazy.dzienOd")>
			<cfset dzienOd = session.raport_sprzedazy.dzienOd />
		</cfif>
		
		<cfif IsDefined("session.raport_sprzedazy.dzienDo")>
			<cfset dzienDo = session.raport_sprzedazy.dzienDo />
		</cfif>
		
		<cfif IsDefined("session.raport_sprzedazy.partnerid")>
			<cfset partnerid = session.raport_sprzedazy.partnerid />
		</cfif>
		
		<cfif IsDefined("FORM.SKLEP")>
			<cfset sklep = FORM.SKLEP />
		</cfif>
		
		<cfif IsDefined("FORM.PARTNERID")>
			<cfset partnerid = FORM.PARTNERID />
		</cfif>
		
		<cfif IsDefined("FORM.DZIENOD")>
			<cfset dzienod = FORM.DZIENOD />
		</cfif>
		
		<cfif IsDefined("FORM.DZIENDO")>
			<cfset dziendo = FORM.DZIENDO />
		</cfif>
		
		<cfset kos = model("tree_groupuser").getUsersByGroupName("KOS") />
		
		<cfset var a = createObject("component", "cfc.assecoConnector").init(
			assecoConnectorDsn = "assecoConnector",
			intranetDsn = "intranet",
			assecoDsn = "asseco") />
		
		<cfset var tmpDataOd = listToArray(dzienOd, "-") />
		<cfset var tmpDataDo = listToArray(dzienDo, "-") />
		
		<cfset raport = a.pobierzCzasowyRaportSprzedazy(
			projekt=sklep,
			poczatek=DateFormat(createDate(tmpDataOd[3], tmpDataOd[2], tmpDataOd[1]), "dd-mm-yyyy"),
			koniec=DateFormat(createDate(tmpDataDo[3], tmpDataDo[2], tmpDataDo[1]), "dd-mm-yyyy"),
			partner = partnerid) />
		
		<cfset session.raport_sprzedazy = {
			dzienOd = DateFormat(createDate(tmpDataOd[3], tmpDataOd[2], tmpDataOd[1]), "dd-mm-yyyy"),
			dzienDo = DateFormat(createDate(tmpDataDo[3], tmpDataDo[2], tmpDataDo[1]), "dd-mm-yyyy"),
			sklep = sklep,
			partnerid = partnerid
		} />
		
		<cfset usesLayout(false) />
		
	</cffunction>
</cfcomponent> 