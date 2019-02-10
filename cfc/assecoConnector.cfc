<cfcomponent displayname="assecoConnector" output="false" hint="">
	<cfproperty name="assecoConnectorDsn" tyle="string" default="assecoConnector" />
	<cfproperty name="intranetDsn" type="string" default="intranet" />
	<cfproperty name="assecoDsn" type="string" default="asseco" />
	<cfproperty name="mssqlIntranetDsn" type="string" default="MSIntranet" />
	
	<!--- Pseudo constructor --->
	<cfscript>
		variables = {
			assecoConnectorDsn = "assecoConnector",
			intranetDsn = "intranet",
			assecoDsn = "asseco",
			mssqlIntranetDsn = "MSIntranet"
		};
	</cfscript>
	
	<cffunction name="init" output="false" access="public" hint="" returntype="assecoConnector">
		<cfargument name="assecoConnectorDsn" type="string" required="false" />
		<cfargument name="intranetDsn" type="string" required="false" />
		<cfargument name="assecoDsn" type="string" required="false" />
		<cfargument name="mssqlIntranetDsn" type="string" required="false" />
		
		<cfscript>
			setAssecoConnectorDsn(arguments.assecoConnectorDsn);
			setIntranetDsn(arguments.intranetDsn);
			setAssecoDsn(arguments.assecoDsn);
		</cfscript>
		
		<cfreturn this />
	</cffunction>
	
	<!--- Setters / getters --->
	<cffunction name="setAssecoConnectorDsn" output="false" access="public" hint="">
		<cfargument name="dsn" type="string" required="true" />
		<cfset variables.assecoConnectorDsn = arguments.dsn />
	</cffunction>
	
	<cffunction name="setIntranetDsn" output="false" access="public" hint="">
		<cfargument name="dsn" type="string" required="true" />
		<cfset variables.intranetDsn = arguments.dsn />
	</cffunction>
	
	<cffunction name="setAssecoDsn" output="false" access="public" hint="">
		<cfargument name="dsn" type="string" required="true" />
		<cfset variables.assecoDsn = arguments.dsn />
	</cffunction>
	
	<cffunction name="setMssqlIntranetDsn" output="false" access="public" hint="">
		<cfargument name="dsn" type="string" required="true" />
		<cfset variables.mssqlIntranetDsn = arguments.dsn />
	</cffunction>
	
	<cffunction name="getAssecoConnectorDsn" output="false" access="public" hint="" returntype="string">
		<cfreturn variables.assecoConnectorDsn />
	</cffunction>
	
	<cffunction name="getIntranetDsn" output="false" access="public" hint="" returntype="string">
		<cfreturn variables.intranetDsn />
	</cffunction>
	
	<cffunction name="getAssecoDsn" output="false" access="public" hint="" returntype="string">
		<cfreturn variables.assecoDsn />
	</cffunction>
	
	<cffunction name="getMssqlIntranetDsn" output="false" access="public" hint="" returntype="string">
		<cfreturn variables.mssqlIntranetDsn />
	</cffunction>
	
	<!--- Metody publiczne --->
	<cffunction name="pobierzRegaly" output="false" access="public" hint="" returntype="query">
		<cfset var regaly = "" />
		<cfquery name="regaly" datasource="#getIntranetDsn()#">
			
			select a.id as id, a.shelftypeid as shelftypeid, a.shelfcategoryid as shelfcategoryid,
				a.storetypeid as storetypeid, b.shelftypename as shelftypename,
				c.shelfcategoryname as shelfcategoryname,
				d.store_type_name as storetypename 
			from store_shelfs a
			inner join store_shelftypes b on a.shelftypeid = b.id
			inner join store_shelfcategories c on a.shelfcategoryid = c.id
			inner join store_types d on a.storetypeid = d.id;
			
			
			<!---select distinct a.id as id, a.shelftypeid as shelftypeid, a.shelfcategoryid as shelfcategoryid,
				a.storetypeid as storetypeid, b.shelftypename as shelftypename,
				c.shelfcategoryname as shelfcategoryname,
				d.store_type_name as storetypename
			--    ,f.projekt
			from store_shelfs a
			inner join store_shelftypes b on a.shelftypeid = b.id
			inner join store_shelfcategories c on a.shelfcategoryid = c.id
			inner join store_types d on a.storetypeid = d.id
			inner join store_storeshelfs e on a.id = e.shelfid
			inner join store_stores f on e.storeid = f.id
			where f.projekt = 'B13045';--->

		</cfquery>
		<cfreturn regaly />
	</cffunction>
	
	<cffunction name="wyslijRegaly" output="false" access="public" hint="" returntype="struct">
		<cfargument name="q" type="query" required="true" />
		
		<cfset var regaly = "" />
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Regały zostały dodane" />
		
		<!---<cfset var regalyInsert = "insert into wusr_mg_planogram_Regaly values " />--->
		<cfset var regalyInsert = "" />
		<cfloop query="arguments.q">
			<cfset regalyInsert &= "(" />
			<!---<cfset regalyInsert &= PreserveSingleQuotes(id) & "," />--->
			<cfset regalyInsert &= "'#Trim(id)#', '#Trim(storetypename)#', '#Trim(shelftypename)#', '#Trim(shelfcategoryname)#' " />
			<cfset regalyInsert &= ")," />
		</cfloop>
		
		<cfset regalyInsert = Left(regalyInsert, Len(regalyInsert)-1) />
		
		<!---<cfdump var="#regalyInsert#" />
		<cfabort />--->
		
		<cftransaction action="begin">
			
		<cftry>
			<cfquery name="regaly" datasource="#getAssecoConnectorDsn()#">
				delete from wusr_vv_mg_planogram_RegalyEditTmp;
				
				insert into wusr_vv_mg_planogram_regalyEditTmp (REGAL, OPIS, TYP, KATEGORIA)
				values #PreserveSingleQuotes(regalyInsert)#;
				
				exec wusr_mg_planogram_RegalyModify;
			</cfquery>
			<cfcatch type="database">
				<cfset results.success = false />
				<cfset results.message = "Wystąpił błąd przy dodawaniu regałów: #CFCATCH.Message#" />
				<cftransaction action="rollback" />
					
				<cfdump var="#cfcatch#" />
				<cfabort />
			</cfcatch>
		</cftry>
		
		</cftransaction>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="pobierzRegalyNaSklepach" output="false" access="public" hint="" returntype="query">
		<cfset var regalyNaSklepie = "" />
		<cfquery name="regalyNaSklepie" datasource="#getIntranetDsn()#">
			
			select b.projekt, a.shelfid from store_storeshelfs a
			inner join store_stores b on a.storeid = b.id
			inner join store_shelfs c on a.shelfid = c.id;
			where b.is_active = 1;
			
			
			<!---select b.projekt, a.shelfid from store_storeshelfs a
			inner join store_stores b on a.storeid = b.id
			inner join store_shelfs c on a.shelfid = c.id;
			where b.is_active = 1 and b.projekt = 'B12045'--->
		</cfquery>
		<cfreturn regalyNaSklepie />
	</cffunction>
	
	<cffunction name="pobierzSklepy" output="false" access="public" hint="" returntype="query">
		<cfset var s = "" />
		<cfquery name="s" datasource="#getIntranetDsn()#">
			
			select distinct b.projekt from store_storeshelfs a
			inner join store_stores b on a.storeid = b.id
			where b.is_active = 1;
			
			
			<!---select distinct b.projekt from store_storeshelfs a
			inner join store_stores b on a.storeid = b.id
			where b.is_active = 1 and b.projekt = 'B13045';--->
		</cfquery>
		<cfreturn s />
	</cffunction>
	
	<cffunction name="pobierzRegalySklepu" output="false" access="public" hint="" returntype="query">
		<cfargument name="projekt" type="string" required="true" />
		<cfset var regaly = "" />
		<cfquery name="regaly" datasource="#getIntranetDsn()#">
			select distinct b.projekt, a.shelfid 
			from store_storeshelfs a
			inner join store_stores b on a.storeid = b.id
			inner join store_shelfs c on a.shelfid = c.id
			where b.projekt = <cfqueryparam value="#arguments.projekt#" cfsqltype="cf_sql_varchar" />
			and b.is_active = 1
		</cfquery>
		<cfreturn regaly />
	</cffunction>
	
	<cffunction name="wyslijRegalyNaSklepach" output="false" access="public" hint="" returntype="struct">
		<cfargument name="q" type="query" required="true" />
		
		<cfsetting requesttimeout="5400" />
		
		<cfset var regalyNaSklepie = "" />
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Regały na sklepach zostały dodane" />
		
		<cfset var sqlValues = "" />
		<cfloop query="arguments.q">
			<cfset var regaly = pobierzRegalySklepu(projekt) />
			<cfset var regalyInsert = "" />
			<cfloop query="regaly">
				<cfset regalyInsert &= "('#Trim(regaly.projekt)#', '#Trim(regaly.shelfid)#')," />
			</cfloop>
			<cfset regalyInsert = Left(regalyInsert, Len(regalyInsert)-1) />
			
			<cfset sqlValues &= "insert into wusr_vv_planogram_Regal4SklepEditTmp (SKLEP, REGAL)
				values #regalyInsert#;" />
			
		</cfloop>
		
		<!---<cfdump var="#sqlValues#" />
		<cfabort />--->
		<!---<cfset sqlValues = Left(sqlValues, Len(sqlValues)-1) />--->

		<cftransaction action="begin" >
			
		<cftry>
			<cfquery name="regalyNaSklepie" datasource="#getAssecoConnectorDsn()#">
				delete from wusr_vv_planogram_Regal4SklepEditTmp;
				
				#PreserveSingleQuotes(sqlValues)#;
					
				exec wusr_planogram_Regal4Sklep_Modyfikacja;
			</cfquery>
				
			<cfcatch type="database">
				<cfset results.success = false />
				<cfset results.message = "Błąd przy dodawaniu regałów na sklepach: #CFCATCH.Message#" />
				
				<cftransaction action="rollback" />
					
				<cfdump var="#cfcatch#" />
				<cfabort />
			</cfcatch>
		</cftry>
		
		</cftransaction>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="pobierzPlanogramyZTu" output="false" access="public" hint="" returntype="query">
		<cfset var planogramy = "" />
		<cfquery name="planogramy" datasource="#getIntranetDsn()#">
			<!---select distinct a.store_type_id, a.shelf_type_id, a.shelf_category_id, b.id 
			from store_planogram_totalunits_values a
			inner join store_shelfs b on 
				(a.store_type_id = b.storetypeid 
				and a.shelf_type_id = b.shelftypeid 
				and a.shelf_category_id = b.shelfcategoryid);--->
				
			select distinct MAX(a.store_type_id) as store_type_id, MAX(a.shelf_type_id) as shelf_type_id, MAX(a.shelf_category_id) as shelf_category_id, MAX(b.id) as id, MAX(a.planogram_id) as planogram_id, MAX(c.created) as created
			from store_planogram_totalunits_values a
			inner join store_shelfs b on 
				(a.store_type_id = b.storetypeid 
				and a.shelf_type_id = b.shelftypeid 
				and a.shelf_category_id = b.shelfcategoryid)
			inner join store_planograms c on (a.planogram_id = c.id)
			
			<!---inner join store_storeshelfs d on b.id = d.shelfid
			inner join store_stores e on d.storeid = e.id
			where e.projekt = 'B13045'--->
			
			group by a.store_type_id, a.shelf_type_id, a.shelf_category_id;
		</cfquery>
		<cfreturn planogramy />
	</cffunction>
	
	<cffunction name="pobierzTU" output="false" access="public" hint="" returntype="query">   
		<cfargument name="storetypeid" type="numeric" required="true" />
		<cfargument name="shelftypeid" type="numeric" required="true" />
		<cfargument name="shelfcategoryid" type="numeric" required="true" />
		<cfargument name="planogramid" type="numeric" required="true" />
		
		<cfset var tu = "" />
		<cfquery name="tu" datasource="#getIntranetDsn()#">
			select distinct product_id, total_units, prestock, zapas_opt, units_case from store_planogram_totalunits_values
			where store_type_id = <cfqueryparam value="#arguments.storetypeid#" cfsqltype="cf_sql_integer" />
			and shelf_type_id = <cfqueryparam value="#arguments.shelftypeid#" cfsqltype="cf_sql_integer" />
			and shelf_category_id = <cfqueryparam value="#arguments.shelfcategoryid#" cfsqltype="cf_sql_integer" /> 
			and planogram_id = <cfqueryparam value="#arguments.planogramid#" cfsqltype="cf_sql_integer" />
		</cfquery>
		<cfreturn tu />
	</cffunction>
	
	<cffunction name="wyslijProduktyNaRegalach" output="false" access="public" hint="" returntype="struct">
		<cfargument name="p" type="query" required="true" />
		
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Wysłałem produkty na regałach" />
		
		<cfset var sqlValues = "" />
		
		<cfloop query="p">
			<cfset var tu = pobierzTU(
				storetypeid = store_type_id,
				shelftypeid = shelf_type_id,
				shelfcategoryid = shelf_category_id,
				planogramid = planogram_id) />
			<cfset var values = "" />
			<cfloop query="tu">
				<cfset values &= "('#p.id#', '#tu.product_id#', #tu.total_units#, 'szt.')," />
				<!---<cfset values &= "('#p.id#', '#tu.product_id#', #tu.total_units#, 'szt.', #tu.prestock#, #tu.zapas_opt#, #tu.units_case#)," />--->
			</cfloop>
			
			<cfset values = Left(values, Len(values)-1) />
			<cfset sqlValues &= "insert into wusr_vv_planogram_TowOnRegEditTmp (REGAL, SYMKAR, ILOSC, JM) values #values#;" />
			<!---<cfset sqlValues &= "insert into wusr_vv_planogram_TowOnRegEditTmp (REGAL, SYMKAR, ILOSC, JM, PRESTOCK, ZAPASOPT, UNITSCASE) values #values#;" />--->
			
		</cfloop>
		
		<!---<cfdump var="#sqlValues#" />
		<cfabort />--->
		
		<cftransaction action="begin" >
			
		<cftry>
			<cfset var insertQuery = "" />
			<cfquery name="insertQuery" datasource="#getAssecoConnectorDsn()#">
				delete from wusr_vv_planogram_TowOnRegEditTmp;
					
				#PreserveSingleQuotes(sqlValues)#
					
				exec wusr_planogram_Tow4Reg_Modify;
			</cfquery>
				
			
			<cfcatch type="database">
				<cftransaction action="rollback" />
					
				<cfdump var="#cfcatch#" />
				<cfabort />
				<cfset results.success = false />
				<cfset results.message = "Błąd przy zapisywaniu produktów na regałach: #cfcatch.Message#" />
			</cfcatch>
		</cftry>
		
		</cftransaction>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="pobierzRaportSprzedazy" output="false" access="public" hint="" returntype="Query" >
		<cfargument name="projekt" type="string" required="true" />
		<cfargument name="poczatek" type="string" required="true" />
		<cfargument name="koniec" type="string" required="true" />
		
		<cfsetting requesttimeout="540" />
		
		<cfset var mgKar = "" />
		<cfset var raportSprzedazy = "" />
		<cfset var wynikZapytania = "" />
		
		<cfquery name="raportSprzedazy" datasource="#getAssecoConnectorDsn()#">
			select DATA_OD, DATA_DO, SYMKAR, PD_Sklep, Projekt, <!---M2_SALE_HALL, M2_ALL, GPS_COORDINATES, LOC_MALL_SYMBOL, GodzOtwarcia, GodzZamkniecia, LOC_MALL_NAME,---> TypUlicy, NrDomu, NrLokalu, KodP, Miejscowosc, Powiat, Poczta, Logo, Nazwa1, Nazwa2, StatusOdb, Ilosc, Cena_sprz, jm, wartosc
			
			from dbo.wusr_POS_RaportSprzedazy as a
			inner join dbo.BI_wusr_vv_mg_SklepyBro as b on a.SKLEP = b.PD_Sklep
			where b.Projekt = <cfqueryparam value="#arguments.projekt#" cfsqltype="cf_sql_varchar" />
			and DATA_OD >= <cfqueryparam value="#arguments.poczatek#" cfsqltype="cf_sql_date" />
			and DATA_DO < <cfqueryparam value="#arguments.koniec#" cfsqltype="cf_sql_date" />
			<!---and DATA_OD >= DATEADD(DAY, -2, '#DateFormat(Now(), 'yyyy-mm-dd')#') and DATA_DO < DATEADD(DAY, -1, '#DateFormat(Now(), 'yyyy-mm-dd')#')--->
		</cfquery>
		
		<cfquery name="mgKar" datasource="#getAssecoDsn()#"
			cachedwithin="#createTimespan(APPLICATION.cache.query.days,
				APPLICATION.cache.query.hours,
				APPLICATION.cache.query.minutes,
				APPLICATION.cache.query.seconds)#">
			select OpiKar, SymKar from dbo.mg_Kar 
			where SYMKAR not like '6%' and SYMKAR not like '7%';
		</cfquery>
		
		
		<cfquery name="wynikZapytania" dbtype="query" >
			select * from raportSprzedazy, mgKar
			where raportSprzedazy.SYMKAR = mgKar.SYMKAR
		</cfquery>
		
		<cfreturn wynikZapytania />
		
	</cffunction>
	
	<cffunction name="pobierzCzasowyRaportSprzedazy" output="false" access="public" hint="">
		<cfargument name="projekt" type="string" required="true" />
		<cfargument name="poczatek" type="string" required="true" />
		<cfargument name="koniec" type="string" required="true" />
		<cfargument name="partner" type="string" required="true" />

		
		<cfset var tmpDataOd = listToArray(arguments.poczatek, "-") />
		<cfset var tmpDataDo = listToArray(arguments.koniec, "-") />
		<cfset var dataOd = dateAdd( "n", -1, createDate(tmpDataOd[3], tmpDataOd[2], tmpDataOd[1]) ) />
		<cfset var dataDo = createDate(tmpDataDo[3], tmpDataDo[2], tmpDataDo[1]) />
		
		<cfset var sklepy = "" />
		<cfquery name="sklepy" datasource="#variables.intranetDsn#">
			select distinct projekt from store_stores
			where 1=1
			<cfif IsDefined("arguments.partner") and Len(arguments.partner) GT 0>
				and partnerid = <cfqueryparam value="#arguments.partner#" />
			</cfif> 
			;
		</cfquery>
		
		<cfset var raport = "" />
		<cfquery name="raport" datasource="#getAssecoConnectorDsn()#">
			select 
				sum(
					case RAPORT_TYP
						when 'Z' then 0
						when 'S' then Wartosc
						else 0
					end 
				) as s,
				sum(
					case RAPORT_TYP
						when 'Z' then Wartosc
						when 'S' then 0
						else 0
					end
				) as z, dateadd(DAY,0, datediff(day,0, DATA_OD)) as Dzien,
				Logo, Projekt, Nazwa1, Nazwa2 
			
			from dbo.wusr_POS_RaportSprzedazy as a
			inner join dbo.BI_wusr_vv_mg_SklepyBro as b on a.SKLEP = b.PD_Sklep
			where 1=1
			
			<cfif IsDefined("arguments.partner") and Len(arguments.partner) GT 0>
				and b.Projekt in ('#ValueList(sklepy.projekt, "','")#')
			</cfif>
			
			<cfif IsDefined("arguments.projekt") and Len(arguments.projekt) GT 0>
				and b.Projekt like <cfqueryparam value="%#arguments.projekt#%" cfsqltype="cf_sql_varchar" />
			</cfif>
			
			and DATA_OD >= <cfqueryparam value="#dataOd#" cfsqltype="cf_sql_date" />
			and DATA_DO <= <cfqueryparam value="#dataDo#" cfsqltype="cf_sql_date" />
			and RAPORT_TYP = <cfqueryparam value="S" cfsqltype="cf_sql_varchar" />
			group by dateadd(DAY,0, datediff(day,0, DATA_OD)), Logo, Projekt, Nazwa1, Nazwa2
		</cfquery>
		
		<cfreturn raport />
	</cffunction>
	
	<!---
	<cffunction name="pobierzRaportWplat" output="false" access="public" hint="" returntype="query">
		<cfargument name="sklep" type="string" required="false" />
		<cfargument name="dzienOd" type="string" required="false" />
		<cfargument name="dzienDo" type="string" required="false" />
		<cfargument name="partnerid" type="string" required="false" />
		<cfargument name="grupowanie" type="string" required="false" />
		
		<!--- Wyniki zapytan --->
		<cfset var raportWplat = "" />
		<cfset var raportWplatDate = "" />
		<cfset var raportWplatUsun = "" />
		
		<cfset var tmp = "" />
		<!---<cfquery name="tmp" datasource="#getAssecoConnectorDsn()#">
			select * from ##temp_raportWplat;
		</cfquery>
		
		<cfdump var="#tmp#" />
		<cfabort />--->
		
		<!---<cfquery name="raportWplat" datasource="#getAssecoConnectorDsn()#">
			begin transaction;
			
			create table ##temp_raportWplat (idRaportu int, contributionReportDate date, fullLocationNumber nvarchar(16), minVer int, maxVer int)
			
			commit;
		</cfquery>--->
		
		<cfquery name="raportWplatZasilenie" datasource="#getAssecoConnectorDsn()#">
			SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE';
			
			-- begin transaction;
			
			-- IF OBJECT_ID('tempdb..##temp_raportWplat') IS NOT NULL drop table ##temp_raportWplat;
			
			-- create table ##temp_raportWplat (idRaportu int, contributionReportDate date, fullLocationNumber nvarchar(16), minVer int, maxVer int);
			
			-- insert into ##temp_raportWplat (idRaportu, contributionReportDate, fullLocationNumber, minVer, maxVer) 
			/*
			select a.idRaportu, a.contributionReportDate, a.fullLocationNumber, MIN(a.ver) as minVer, MAX(a.ver) as maxVer
			from raport_wplat_raporty a
			group by a.idRaportu, a.contributionReportDate, a.fullLocationNumber
			order by a.contributionReportDate desc;
			*/
			-- commit;
		</cfquery>
		
		<!---<cfquery name="raportWplatDane" datasource="#getAssecoConnectorDsn()#">
			begin transaction;
				select * from ##temp_raportWplat;
			commit;
		</cfquery>--->
		
		<cfdump var="#raportWplatZasilenie#" />
		<cfabort />
		
		<cfquery name="raportWplatUsun" datasource="#getAssecoConnectorDsn()#">
			begin transaction;
				drop table ##temp_raportWplat;
			commit;
		</cfquery>
		
		<cfabort />
		
		<cfreturn queryNew("id") />
	</cffunction>
	--->
	
	<cffunction name="salesContestReport" output="false" access="public" hint="">
		<!---<cfargument name="projekt" type="string" required="true" />--->
		<!---<cfargument name="poczatek" type="string" required="true" />--->
		<cfargument name="date" type="string" required="true" />
		
		<cfset var raport = "" />
		
		<cfquery name="raport" datasource="#getAssecoConnectorDsn()#">
			
			declare @oldweek table (sklep int, brutto float, netto float, primary key (sklep));
			declare @tmp_oldweek table (sklep int, brutto float, netto float, day datetime);
			declare @newweek table (sklep int, brutto float, netto float, primary key (sklep));
			declare @tmp_newweek table (sklep int, brutto float, netto float, day datetime);
			declare @place table (sklep int, projekt varchar(255), miejscowosc varchar(255));
				
			insert into @tmp_oldweek
				select 
					cast(sklep as int) as sklep 
					, sum(wartosc) as brutto
					, sum(
					    case 
					      when vat_symbol = 'npn' then wartosc
					      when vat_symbol <> 'npn' then (wartosc/(100+substring(vat_symbol,1,Len(vat_symbol)-1)))*100
					    end) as netto 
					, dateadd(DAY,0, datediff(day,0, DATA_OD)) as day
					--, count(wartosc) as ilosc, MIN(data_od) as od, MAX(data_do) as do, datepart(dw,getdate())-1 as day
				from dbo.wusr_POS_RaportSprzedazy
				where 
					-- data_od >= DATEADD(dd,DATEDIFF(dd,8,GETDATE()),0) and data_do < DATEADD(dd,DATEDIFF(dd,0,GETDATE())-1,0)
					data_od >= '2014-04-07'--DATEADD(wk,DATEDIFF(wk,7,GETDATE()),0)
					and data_do < DATEADD(d,DATEDIFF(d,'19000101',DATEADD(d,-1,<cfqueryparam value="#arguments.date#" cfsqltype="cf_sql_date" />)),'19000101') 
					<!----- and data_do < DATEADD(wk,DATEDIFF(wk,7,<cfqueryparam value="#arguments.date#" cfsqltype="cf_sql_date" />),7)--->
					and raport_typ = 'S'
				group by dateadd(DAY,0, datediff(day,0, DATA_OD)), sklep
				order by sklep;
			
			insert into @tmp_newweek
				select 
					cast(sklep as int) as sklep
					, sum(wartosc) as brutto
					, sum(
					    case 
					      when vat_symbol = 'npn' then wartosc
					      when vat_symbol <> 'npn' then (wartosc/(100+substring(vat_symbol,1,Len(vat_symbol)-1)))*100
					    end) as netto
					, dateadd(DAY,0, datediff(day,0, DATA_OD)) as day  
					--, count(wartosc) as ilosc, MIN(data_od) as od, MAX(data_do) as do, datepart(dw,getdate())-1 as day
				from dbo.wusr_POS_RaportSprzedazy
				where 
					<!----- data_od >= DATEADD(wk,DATEDIFF(wk,1,<cfqueryparam value="#arguments.date#" cfsqltype="cf_sql_date" />),0)
					-- and data_do < <cfqueryparam value="#arguments.date#" cfsqltype="cf_sql_date" />--->
					data_od >= DATEADD(d,DATEDIFF(d,'19000101',DATEADD(d,-1,<cfqueryparam value="#arguments.date#" cfsqltype="cf_sql_date" />)),'19000101') 
					-- data_od >= DATEADD(wk,DATEDIFF(wk,1,GETDATE()),0)
					and data_do < DATEADD(d,DATEDIFF(d,'19000101',DATEADD(d,0,<cfqueryparam value="#arguments.date#" cfsqltype="cf_sql_date" />)),'19000101')
					--data_od >= DATEADD(dd,DATEDIFF(dd,0,GETDATE())-1,0)
					--and data_do < DATEADD(dd,DATEDIFF(dd,0,GETDATE()),0)
					and raport_typ = 'S'
				group by dateadd(DAY,0, datediff(day,0, DATA_OD)), sklep;
			
			insert into @newweek
				select sklep, avg(brutto) as brutto, avg(netto) as netto from @tmp_newweek group by sklep;
				
			insert into @oldweek
				select sklep, avg(brutto) as brutto, avg(netto) as netto from @tmp_oldweek group by sklep;
				
			insert into @place
				select cast(sb.PD_Sklep as int) as sklep, sb.projekt, sb.miejscowosc
				from dbo.BI_wusr_vv_mg_SklepyBro sb
				where mag is not null;
			
			select p.sklep as a_sklep, p.projekt as b_projekt, p.miejscowosc as c_miejscowosc,
				cast(round(ow.brutto,2) as numeric(36,2)) as d_srednia_brutto_z_tyg, cast(round(nw.brutto,2) as numeric(36,2)) as e_obrot_brutto_na_dzien,
				cast(round(ow.netto,2) as numeric(36,2)) as g_srednia_netto_z_tyg, cast(round(nw.netto,2) as numeric(36,2)) as h_obrot_netto_na_dzien, 
				cast(round(((nw.brutto / ow.brutto)-1)*100 ,2) as numeric(36,2)) as f_przyrost_brutto,
				cast(round(((nw.netto / ow.netto)-1)*100 ,2) as numeric(36,2)) as i_przyrost_netto
				, GETDATE() as y
				<!-----, <cfqueryparam value="#arguments.date#" cfsqltype="cf_sql_date" /> as z--->
			from @place p
			inner join @newweek nw on p.sklep = nw.sklep
			inner join @oldweek ow on p.sklep = ow.sklep
			order by i_przyrost_netto desc;
			
		</cfquery>
		
		<!---<cfquery name="raport" datasource="#getAssecoConnectorDsn()#">
			
				select sklep, SUM(wartosc) as wartosc, count(wartosc) as ilosc, MIN(data_od) as od, MAX(data_do) as do, datepart(dw,getdate())-1 as day
				from dbo.wusr_POS_RaportSprzedazy
				where data_od >= DATEADD(wk,DATEDIFF(wk,1,GETDATE()),0)
				and data_do <= DATEADD(d,-1,GETDATE())
				group by sklep;			
						
		</cfquery>--->
		
		<!---<cfquery name="raport" datasource="#getAssecoConnectorDsn()#">
			
			select SUM(Wartosc) as Wartosc,
				Logo, Projekt, Nazwa1, Nazwa2 
			
			from dbo.wusr_POS_RaportSprzedazy as a
			
			inner join dbo.BI_wusr_vv_mg_SklepyBro as b on a.SKLEP = b.PD_Sklep
			
			where
				DATA_OD >= '2014-03-31'
				and DATA_DO <= '2017-04-06'
			
			group by Logo, Projekt, Nazwa1, Nazwa2
		</cfquery>--->
		
		<cfreturn raport />
	</cffunction>
	
	<cffunction name="salesContestReport2" output="false" access="public" hint="">
		<!---<cfargument name="projekt" type="string" required="true" />--->
		<!---<cfargument name="poczatek" type="string" required="true" />--->
		<!---<cfargument name="koniec" type="string" required="true" />--->
		
		<cfset var raport = "" />
		
		<cfquery name="raport" datasource="#getAssecoConnectorDsn()#">
			--declare @tmp_newweek table (sklep int, brutto float, netto float, day datetime);
    		--insert into @tmp_newweek
        select 
					cast(rp.sklep as int) as b_sklep
          --, (select sb.PD_Sklep from dbo.BI_wusr_vv_mg_SklepyBro sb. where ) as projekt
          , sb.projekt as a_projekt
					, cast(sum(wartosc) as numeric(36,2)) as c_brutto
					, cast(sum(
					    case 
					      when vat_symbol = 'npn' then wartosc
					      when vat_symbol <> 'npn' then (wartosc/(100+substring(vat_symbol,1,Len(vat_symbol)-1)))*100
					    end) as numeric(36,2)
					  ) as d_netto
					, dateadd(DAY,0, datediff(day,0, DATA_OD)) as e_day  
					--, count(wartosc) as ilosc, MIN(data_od) as od, MAX(data_do) as do, datepart(dw,getdate())-1 as day
				from dbo.wusr_POS_RaportSprzedazy rp
        join dbo.BI_wusr_vv_mg_SklepyBro sb on rp.sklep = sb.PD_Sklep
				where 
					-- data_od >= DATEADD(wk,DATEDIFF(wk,1,GETDATE()),0)
					-- and data_do < DATEADD(wk,DATEDIFF(wk,1,GETDATE()),7)
					data_od >= DATEADD(d,DATEDIFF(d,'19000101',GETDATE()-8),'19000101')
					and data_do < DATEADD(d,DATEDIFF(d,'19000101',GETDATE()),'19000101')
					and raport_typ = 'S'
				group by dateadd(DAY,0, datediff(day,0, DATA_OD)), rp.sklep, sb.projekt
        order by rp.sklep asc, e_day asc;
		</cfquery>
		
		<cfreturn raport />
	</cffunction>
	
	<cffunction name="salesContestReport3" output="false" access="public" hint="">
		<!---<cfargument name="projekt" type="string" required="true" />--->
		<!---<cfargument name="poczatek" type="string" required="true" />--->
		<!---<cfargument name="koniec" type="string" required="true" />--->
		
		<cfset var raport = "" />
		
		<cfquery name="raport" datasource="#getAssecoConnectorDsn()#">
			
			declare @oldweek table (sklep int, brutto float, netto float, primary key (sklep));
			declare @tmp_oldweek table (sklep int, brutto float, netto float, day datetime);
			declare @newweek table (sklep int, brutto float, netto float, primary key (sklep));
			declare @tmp_newweek table (sklep int, brutto float, netto float, day datetime);
			declare @place table (sklep int, projekt varchar(255), miejscowosc varchar(255));
				
			insert into @tmp_oldweek
				select 
					cast(sklep as int) as sklep 
					, sum(wartosc) as brutto
					, sum(
					    case 
					      when vat_symbol = 'npn' then wartosc
					      when vat_symbol <> 'npn' then (wartosc/(100+substring(vat_symbol,1,Len(vat_symbol)-1)))*100
					    end) as netto 
					, dateadd(DAY,0, datediff(day,0, DATA_OD)) as day
					--, count(wartosc) as ilosc, MIN(data_od) as od, MAX(data_do) as do, datepart(dw,getdate())-1 as day
				from dbo.wusr_POS_RaportSprzedazy
				where 
					-- data_od >= DATEADD(dd,DATEDIFF(dd,8,GETDATE()),0) and data_do < DATEADD(dd,DATEDIFF(dd,0,GETDATE())-1,0)
					data_od >= '2014-04-07'--DATEADD(wk,DATEDIFF(wk,7,GETDATE()),0)
					and data_do < DATEADD(d,DATEDIFF(d,'19000101',GETDATE()-1),'19000101') 
					-- and data_do < DATEADD(wk,DATEDIFF(wk,7,GETDATE()),7)
					and raport_typ = 'S'
				group by dateadd(DAY,0, datediff(day,0, DATA_OD)), sklep
				order by sklep;
			
			insert into @tmp_newweek
				select 
					cast(sklep as int) as sklep
					, sum(wartosc) as brutto
					, sum(
					    case 
					      when vat_symbol = 'npn' then wartosc
					      when vat_symbol <> 'npn' then (wartosc/(100+substring(vat_symbol,1,Len(vat_symbol)-1)))*100
					    end) as netto
					, dateadd(DAY,0, datediff(day,0, DATA_OD)) as day  
					--, count(wartosc) as ilosc, MIN(data_od) as od, MAX(data_do) as do, datepart(dw,getdate())-1 as day
				from dbo.wusr_POS_RaportSprzedazy
				where
					data_od >= DATEADD(d,DATEDIFF(d,'19000101',GETDATE()-1),'19000101') 
					-- data_od >= DATEADD(wk,DATEDIFF(wk,1,GETDATE()),0)
					and data_do < DATEADD(d,DATEDIFF(d,'19000101',GETDATE()),'19000101')
					-- and data_do < DATEADD(wk,DATEDIFF(wk,1,GETDATE()),7)
					--data_od >= DATEADD(dd,DATEDIFF(dd,0,GETDATE())-1,0)
					--and data_do < DATEADD(dd,DATEDIFF(dd,0,GETDATE()),0)
					and raport_typ = 'S'
				group by dateadd(DAY,0, datediff(day,0, DATA_OD)), sklep;
			
			insert into @newweek
				select sklep, avg(brutto) as brutto, avg(netto) as netto from @tmp_newweek group by sklep;
			
			insert into @oldweek
				select sklep, avg(brutto) as brutto, avg(netto) as netto from @tmp_oldweek group by sklep;
				
			insert into @place
				select cast(sb.PD_Sklep as int) as sklep, sb.projekt, sb.miejscowosc
				from dbo.BI_wusr_vv_mg_SklepyBro sb
				where mag is not null;
			
			select cast(p.sklep as int) as a_sklep, p.projekt as b_projekt, p.miejscowosc as c_miejscowosc,
				cast(round(ow.brutto,2) as numeric(36,2)) as d_srednia_brutto_z_tyg, cast(round(nw.brutto,2) as numeric(36,2)) as e_obrot_brutto_na_dzien,
				cast(round(ow.netto,2) as numeric(36,2)) as g_srednia_netto_z_tyg, cast(round(nw.netto,2) as numeric(36,2)) as h_obrot_netto_na_dzien, 
				cast(round(((nw.brutto / ow.brutto)-1)*100 ,2) as numeric(36,2)) as f_przyrost_brutto,
				cast(round(((nw.netto / ow.netto)-1)*100 ,2) as numeric(36,2)) as i_przyrost_netto
			from @place p
			inner join @newweek nw on p.sklep = nw.sklep
			inner join @oldweek ow on p.sklep = ow.sklep
			order by i_przyrost_netto desc;

		</cfquery>
		
		<cfreturn raport />
	</cffunction>
	
	<cffunction name="cigarettesPoll" output="false" access="public" hint="">
		
		<cfset var raport = "" />
		
		<cfquery name="raport" datasource="#getAssecoConnectorDsn()#">
			
			select KODKRES, PD_AUTONR, MG_KARID, SYMKAR, OPIKAR1 from mg_kar
			
			where PD_GRUPAAKCYZOWA = 'F'
			
		</cfquery>
		
		<cfreturn raport />
	</cffunction>

</cfcomponent>