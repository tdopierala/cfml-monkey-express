<cfcomponent displayname="Raporty" output="false" hint="" extends="Controller">
	
	<cffunction name="init" output="false" access="public" hint="">
		<cfset super.init() />
		<cfset filters(through="loadLayout",type="before") />
	</cffunction>
	
	<cffunction name="loadLayout" output="false" access="public" hint="">
		<cfset usesLayout("/layout") />
	</cffunction>
	
	<cffunction name="bledyWFakturach" output="false" access="public" hint="">
		<cfset bledy = model("document").pobierzBledyWFakturach() />
		<cfset wprowadzono = model("document").pobierzWprowadzoneFaktury() />
	</cffunction>
	
	<cffunction name="obrotySklepow" output="false" access="public" hint="">
		<cfsetting requesttimeout="3600" />

		<cfparam name="miesiac" type="string" default="styczen" />
		<cfparam name="rok" type="string" default="#Year(Now())#" />

		<cfif IsDefined("session.raporty.miesiac")>
			<cfset miesiac = session.raporty.miesiac />
		</cfif>

		<cfif IsDefined("session.raporty.rok")>
			<cfset rok = session.raporty.rok />
		</cfif>

		<cfif IsDefined("FORM.MIESIAC")>
			<cfset miesiac = FORM.MIESIAC />
		</cfif>

		<cfif IsDefined("FORM.ROK")>
			<cfset rok = FORM.ROK />
		</cfif>

		<cfset session.raporty = {
			miesiac = miesiac,
			rok = rok
		} />

		<cfset obroty = application.cfc.winapp.obroty("#miesiac##rok#") />
		<cfset sklepy = model("store_gps").getAllStores() />

		<cfset usesLayout(template="/layout_googlemap.cfm") />
	</cffunction>
	
	<!---
	<cffunction name="wplaty" output="false" access="public" hint="">
		
		<cfsetting requesttimeout="540" />
		
		<cfparam name="data" type="string" default="#DateFormat(Now(), 'yyyy-mm-dd')#" />
		<cfparam name="sklep" type="string" default="%" />
		
		<cfif IsDefined("session.raporty.wplaty.sklep")>
			<cfset sklep = session.raporty.wplaty.sklep />
		</cfif>
		
		<cfif IsDefined("session.raporty.wplaty.data")>
			<cfset data = session.raporty.wplaty.data />
		</cfif>
		
		<cfif IsDefined("FORM.SKLEP")>
			<cfset sklep = FORM.SKLEP />
		</cfif>
		
		<cfif IsDefined("FORM.DATA")>
			<cfset data = FORM.DATA />
		</cfif>
		
		<cfset session.raporty.wplaty = {
			sklep = sklep,
			data = data
		} />
		
		<cfset raport = model("ftp_raport_wplat").pobierzRaport(
			sklep = "%",
			data = data
		) />
		
		<cfif IsDefined("URL.format") and URL.format is "xls">
			<cfset renderWith(data="raport",layout=false,template="excel") />
		</cfif>
		
		<cfif IsDefined("URL.t")>
			<cfset usesLayout(false) />
		</cfif>
		
	</cffunction>
	--->
	
	<cffunction name="iloscWprowadzonychFaktur" output="false" access="public" hint="">
		<cfsetting requesttimeout="540" />
		
		<cfparam name="miesiac_od" default="#DateFormat(Now(), "m")#" />
		<cfparam name="miesiac_do" default="#DateFormat(Now(), "m")#" />
		<cfparam name="rok" default="#DateFormat(Now(), "yyyy")#" />
		
		<cfif IsDefined("session.ilosc_faktur.miesiac_od")>
			<cfset miesiac_od = session.ilosc_faktur.miesiac_od />
		</cfif>
		
		<cfif IsDefined("session.ilosc_faktur.miesiac_do")>
			<cfset miesiac_do = session.ilosc_faktur.miesiac_do />
		</cfif>
		
		<cfif IsDefined("session.ilosc_faktur.rok")>
			<cfset rok = session.ilosc_faktur.rok />
		</cfif>
		
		<cfif IsDefined("FORM.MIESIAC_OD")>
			<cfset miesiac_od = FORM.MIESIAC_OD />
		</cfif>
		
		<cfif IsDefined("FORM.MIESIAC_DO")>
			<cfset miesiac_do = FORM.MIESIAC_DO />
		</cfif>
		
		<cfif IsDefined("FORM.ROK")>
			<cfset rok = FORM.ROK />
		</cfif>
		
		<cfset session.ilosc_faktur = {
			miesiac_od = miesiac_od,
			miesiac_do = miesiac_do,
			rok = rok } />
		
		<cfset miesiace = model("workflow").getMonths() />
		<cfset lata = model("workflow").getYears() />
		<cfset raport = model("document").pobierzWprowadzoneFaktury(session.ilosc_faktur) />
		
		<cfset session.ilosc_faktur = {
			miesiac_od = miesiac_od,
			miesiac_do = miesiac_do,
			rok = rok } />
		
		<cfif IsDefined("URL.t") and URL.t is true>
			<cfset usesLayout(false) />
		</cfif>
		
	</cffunction>
	
	<cffunction name="raportPokryciaProduktow" output="false" access="public" hint="" displayname="raportPokryciaProduktow">
		<cfparam name="elements" type="numeric" default="50" />
		<cfparam name="page" type="numeric" default="1" />
		 
		<cfset raportPokrycia = model("store_store").raportPokryciaProduktow(page = page, elements = elements) />
		<cfset raportPokryciaCount = model("store_store").raportPokryciaProduktowCount() />
		
		
		<cfset session.raport_pokrycia = {
			page = page,
			elements = elements
		} />
		
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="raportPokryciaProduktowExcel" output="false" access="public" hint="" displayname="raportPokryciaProduktowExcel">
		
		<cfset var iloscWszystkich = model("store_store").raportPokryciaProduktowCount() />
		<cfset raportPokrycia = model("store_store").raportPokryciaProduktow(page = 1, elements = iloscWszystkich) />
		
	</cffunction>
	
	<cffunction name="planogramyNaSklepie" output="false" access="public" hint="" displayname="planogramyNaSklepie">
		<cfset projekt = URL.SKLEP />
		<cfset planogramy = model("store_store").planogramyNaSklepie(projekt) />
		
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="indeksyNaSklepie" output="false" access="public" hint="" displayname="indeksyNaSklepie">
		<cfset projekt = URL.SKLEP />
		<cfset indeksyNaSklepie = model("store_store").indeksyNaSklepie(projekt) />
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="indeksyNaSklepach" output="false" access="public" hint="" displayname="indeksyNaSklepach">
		<cfsetting requesttimeout="600" />
		<cfset indeksyNaSklepach = model("store_store").indeksyNaSklepie() />
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="raportPokryciaProduktowSieci" output="false" access="public" hint="">
		<cfset var path = "files/raport_pokrycia_produktow/RaportPokryciaSieci[#DateFormat(Now(), "yyyy-mm-dd")#].csv.zip" />
		<cfset usesLayout(false) />
		<!---
		<cfset var fSrc = expandPath( path ) />
		<cfif fileExists( fSrc )>
			<cflocation url="#path#" addToken="false" />
		</cfif>
		--->
	</cffunction>
	
	<cffunction name="prestockIndeksu" output="false" access="public" hint="">
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="zerowyPrestock" output="false" access="public" hint="">
		<cfset prestock = model("store_store").pobierzZerowyPrestock() />
		
		<cfset fName = "tmp/zero-#DateFormat(Now(), 'yyyy_mm_dd')#.csv" />
		<cfset fSrc = expandPath( fName ) />
		
		<cfif not fileExists( fSrc )>
			<cfset fileWrite( fSrc, "" ) />
		</cfif>
		<cfset fileObj = FileOpen( fSrc, "append" ) />
		
		<cfset var local = {} />
		<cfset local.ColumnNames = ['store_type_id', 'shelf_type_id', 'shelf_category_id', 'store_type_name', 'shelf_type_name', 'shelf_category_name', 'file_src', 'planogram_id'] />
		<cfset local.ColumnCount = arrayLen(local.ColumnNames) />
		<cfset local.Buffer = createObject( "java", "java.lang.StringBuffer" ).init() />
		<cfset local.NewLine = ( Chr(13) & Chr(10) ) />
		
		<cfset local.RowData = [] />
		<cfloop index="local.ColumnName" from="1" to="#local.ColumnCount#" step="1">
			<cfset local.RowData[local.ColumnName] = """#local.ColumnNames[local.ColumnName]#""" /> 
		</cfloop>
	
		<cfset local.Buffer.Append( JavaCast( "string", arrayToList( local.RowData, "," ) & local.NewLine ) ) />
		
		<cfset FileWrite( fileObj, local.Buffer.toString() ) />
		<cfset local.Buffer.setLength(0) />
		
		<cfloop query="prestock">
			<cfloop index="local.ColumnIndex" from="1" to="#local.ColumnCount#" step="1">
				<cfset local.RowData[local.ColumnIndex] = """#Replace( prestock[ local.ColumnNames[ local.ColumnIndex ] ][ prestock.CurrentRow ], """", """""", "all" )#""" />
			</cfloop>
			<cfset local.Buffer.Append( JavaCast( "string", arrayToList( local.RowData, "," ) & local.NewLine ) ) />
			<cfset FileWrite( fileObj, local.Buffer.toString() ) />
			<cfset local.Buffer.setLength(0) />
		</cfloop>
		
		<cfset fileClose( fileObj ) />
			
		<cfzip action="zip" file="#fSrc#.zip" overwrite="yes" >
			<cfzipparam source="#fSrc#" />
		</cfzip>
		
		<cfset fileDelete( fSrc ) />
		
		<cflocation url="#fName#.zip" addtoken="false" />
		
	</cffunction>
	
	<cffunction name="datyPlanogramow" output="false" access="public" hint="">
		<cfset planogramy = model("store_store").pobierzDatyPlanogramow() />
	</cffunction>
	
</cfcomponent>