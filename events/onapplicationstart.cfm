<!--- Place code here that should be executed on the "onApplicationStart" event. --->
<cfset loc = {} />

<cfset loc.datasource = {} />
<cfset loc.datasource.intranet = "intranet" />
<cfset loc.datasource.rcp = "rcp" />
<cfset loc.datasource.asseco = "asseco" />
<cfset loc.datasource.ankieta = "MSIntranet" />
<cfset loc.datasource.mssql = "MSIntranet" />
<cfset loc.datasource.intranet_connector = "intranet_connector" />

<cfset loc.ldap = {} />
<cfset loc.ldap.server = "10.99.0.9" />
<cfset loc.ldap.domain = "mc.local" />
<cfset loc.ldap.user = "intranet" />
<cfset loc.ldap.password = "Malpk@12$qw" />

<cfset loc.asseco = {} />
<cfset loc.asseco.server = "10.99.0.7" />
<cfset loc.asseco.user = "intranet" />
<cfset loc.asseco.password = "intranet" />
<cfset loc.asseco.databasename = "monkeyCafe_SL" />

<cfset loc.asseco_test = {} />
<cfset loc.asseco_test.server = "10.99.0.7" />
<cfset loc.asseco_test.user = "intranet" />
<cfset loc.asseco_test.password = "intranet" />
<cfset loc.asseco_test.databasename = "monkeyCafe_SL_TEST" />

<cfset loc.intranet.directory = "intranet" />
<cfset loc.intranet.securitysalt = "gDw6Fs2w07jhD54Q" /> <!--- Ciąg znaków do szyfrowania i odszyfrowywania --->
<cfset loc.intranet.cookiename = "Intranet_" />
<cfset loc.intranet.email = "intranet@monkey.xyz" />

<cfset loc.exchange = {} />
<cfset loc.exchange.serverip = "213.156.127.197" />

<cfset loc.redmine = {} />
<cfset loc.redmine.url = "http://10.99.0.11/redmine" />

<cfset set(loc = loc) />

<!---
	DEFINIUJĘ KOMPONENTY WIDOCZNE W CAŁEJ APLIKACJI
--->
<cfset Application.cfc = StructNew() />
<cfset Application.cfc.upload = createObject("component", "#loc.intranet.directory#.cfc.upload") />
<cfset Application.cfc.asseco = createObject("component", "#loc.intranet.directory#.cfc.asseco").init(datasource="asseco") />
<cfset Application.cfc.breadcrumbs = createObject("component","#loc.intranet.directory#.cfc.breadcrumbs") />
<cfset Application.cfc.numbersconverter = createObject("component","#loc.intranet.directory#.cfc.numbersconverter") />
<cfset Application.cfc.exchange = createObject("component","#loc.intranet.directory#.cfc.exchange") />
<cfset Application.cfc.printers = createObject("component", "#loc.intranet.directory#.cfc.printers") />
<cfset Application.cfc.nieruchomosci = createObject("component", "#loc.intranet.directory#.cfc.nieruchomosci") />
<cfset Application.cfc.email = createObject("component", "#loc.intranet.directory#.cfc.email") />

<cftry>
	<cfset Application.cfc.eleader = createObject("component", "#loc.intranet.directory#.cfc.eleader").init(
		localDsn = "eleader_intranet",
		remoteDsn = "eleader") />
	
	<cfset Application.cfc.eleaderNieruchomosci = createObject("component", "#loc.intranet.directory#.cfc.eleaderNieruchomosci").init(
		localDsn = "eleader_intranet",
		remoteDsn = "eleader",
		intranetDsn = "intranet") />
	
	<cfcatch type="any"></cfcatch>
</cftry>

<cfset Application.cfc.winapp = createObject("component", "#loc.intranet.directory#.cfc.winapp") />

<!---
	Definiuje ustawienia związane z cachowaniem.
--->
<cfset Application.cache = StructNew() />
<cfset Application.cache.query = { days = 0, hours = 0, minutes = 15, seconds = 0 } />
<cfset Application.cache.place_query = { days = 0, hours = 0, minutes = 7, seconds = 0 } />
	

<!---
	Numer kolejnej faktury w obiegu
--->
<cfset numerFaktury = "" />
<cfquery name="numerFaktury" datasource="#loc.datasource.intranet#">
	select workflowsettingvalue as val from workflowsettings
	where workflowsettingname = <cfqueryparam value="invoicenumber" cfsqltype="cf_sql_varchar" />
</cfquery>

<cfset Application.workflowDocumentNumber = 0 />
<cfif numerFaktury.RecordCount EQ 1>
	<cfset Application.workflowDocumentNumber = numerFaktury.val />
</cfif>

<!---
	Dane SmsApi
--->
<cfset Application.sms = {username="dopiet",password="e10adc3949ba59abbe56e057f20f883e",apiKey="e10adc3949ba59abbe56e057f20f883e"} />