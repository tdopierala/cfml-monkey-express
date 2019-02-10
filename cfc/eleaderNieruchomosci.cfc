<cfcomponent displayname="eleaderNieruchomosci" output="false">
	
	<!--- PROPERTIES --->
	<cfproperty name="localDsn" type="string" default="MSIntranet" />
	<cfproperty name="remoteDsn" type="string" default="eleader" />
	<cfproperty name="intranetDsn" type="string" default="intranet" />
	
	<!--- PSEUDO-CONSTRUCTOR --->
	<cfscript>
		variables = {
			localDsn = "",
			remoteDsn = "",
			intranetDsn = ""
		};
	</cfscript>
	
	<cffunction name="init" output="false" access="public" hint="" returnType="eleaderNieruchomosci">
		<cfargument name="localDsn" type="string" required="false" />
		<cfargument name="remoteDsn" type="string" required="false" />
		<cfargument name="intranetDsn" type="string" required="false" />
		
		<cfscript>
			setLocalDsn(arguments.localDsn);
			setRemoteDsn(arguments.remoteDsn);
			setIntranetDsn(arguments.intranetDsn);
		</cfscript>
		
		<cfreturn this />
	</cffunction>
	
	<!--- PRIVATE --->
	<cffunction name="setLocalDsn" output="false" access="private" hint="">
		<cfargument name="local" type="string" required="true" />
		<cfset variables.localDsn = arguments.local />
	</cffunction>
	
	<cffunction name="setRemoteDsn" output="false" access="private" hint="">
		<cfargument name="remote" type="string" required="true" />
		<cfset variables.remoteDsn = arguments.remote />
	</cffunction>
	
	<cffunction name="setIntranetDsn" output="false" access="private" hint="">
		<cfargument name="intranet" type="string" required="true" />
		<cfset variables.intranetDsn = arguments.intranet />
	</cffunction>
	
	<!--- PRIVATE AKTUALIZACJA DANYCH --->
	<cffunction name="aktualizacjaSklepow" output="false" access="private" hint="Zapisanie sklepów w bazie intranetu">
		<cfargument name="sklepy" type="query" required="true" />
		
		<cfloop query="arguments.sklepy">
			
			<cfset var aktualizujSklep = "" />
			<cfquery name="aktualizujSklep" datasource="#getLocalDsn()#">
				<cfif czyIstniejeSklep("#IDSKLEPU#")>
					
					update eleader_tbsklepy set 
						kodsklepu = <cfqueryparam value="#KODSKLEPU#" cfsqltype="cf_sql_varchar" />, 
						nazwasklepu = <cfqueryparam value="#NAZWASKLEPU#" cfsqltype="cf_sql_varchar"  >, 
						miasto = <cfqueryparam value="#MIASTO#" cfsqltype="cf_sql_varchar" />, 
						ulica = <cfqueryparam value="#ULICA#" cfsqltype="cf_sql_varchar" />, 
						budynek = <cfqueryparam value="#BUDYNEK#" cfsqltype="cf_sql_varchar" />, 
						lokal = <cfqueryparam value="#LOKAL#" cfsqltype="cf_sql_varchar" />, 
						kodpocztowy = <cfqueryparam value="#KODPOCZTOWY#" cfsqltype="cf_sql_varchar" />, 
						email = <cfqueryparam value="#EMAIL#" cfsqltype="cf_sql_varchar" />, 
						telefon = <cfqueryparam value="#TELEFON#" cfsqltype="cf_sql_varchar" />, 
						telefonkomorkowy = <cfqueryparam value="#TELEFONKOMORKOWY#" cfsqltype="cf_sql_varchar" />, 
						partnersprzedazowy = <cfqueryparam value="#PARTNERSPRZEDAZOWY#" cfsqltype="cf_sql_varchar" />, 
						<cfif Len(DATAPARTNERSPRZEDAZOWY) EQ 0>
							datapartnersprzedazowy = null,
						<cfelse>
							datapartnersprzedazowy = <cfqueryparam value="#DATAPARTNERSPRZEDAZOWY#" cfsqltype="cf_sql_timestamp" />, 
						</cfif> 
						menedzerprojektu = <cfqueryparam value="#MENEDZERPROJEKTU#" cfsqltype="cf_sql_varchar" />, 
						<cfif Len(DATAMENEDZERPROJEKTU) EQ 0>
							datamenedzerprojektu = null,
						<cfelse>
							datamenedzerprojektu = <cfqueryparam value="#DATAMENEDZERPROJEKTU#" cfsqltype="cf_sql_timestamp" />, 
						</cfif> 
						mailmenedzerprojektu = <cfqueryparam value="#MAILMENEDZERPROJEKTU#" cfsqltype="cf_sql_varchar" />, 
						dataostatniejaktualizacji = <cfqueryparam value="#DATAOSTATNIEJAKTUALIZACJI#" cfsqltype="cf_sql_timestamp" />, 
						zaimportowane = <cfqueryparam value="#ZAIMPORTOWANE#" cfsqltype="cf_sql_smallint" />
					where idsklepu = <cfqueryparam value="#IDSKLEPU#" cfsqltype="cf_sql_varchar" />;
					
				<cfelse>
					
					insert into eleader_tbsklepy (idsklepu, kodsklepu, nazwasklepu, miasto, ulica, budynek, lokal, kodpocztowy, email, telefon, telefonkomorkowy, partnersprzedazowy, datapartnersprzedazowy, menedzerprojektu, datamenedzerprojektu, mailmenedzerprojektu, dataostatniejaktualizacji, zaimportowane)
					values (
						<cfqueryparam value="#IDSKLEPU#" cfsqltype="cf_sql_varchar" />,
						<cfqueryparam value="#KODSKLEPU#" cfsqltype="cf_sql_varchar" />, 
						<cfqueryparam value="#NAZWASKLEPU#" cfsqltype="cf_sql_varchar"  >, 
						<cfqueryparam value="#MIASTO#" cfsqltype="cf_sql_varchar" />, 
						<cfqueryparam value="#ULICA#" cfsqltype="cf_sql_varchar" />, 
						<cfqueryparam value="#BUDYNEK#" cfsqltype="cf_sql_varchar" />, 
						<cfqueryparam value="#LOKAL#" cfsqltype="cf_sql_varchar" />, 
						<cfqueryparam value="#KODPOCZTOWY#" cfsqltype="cf_sql_varchar" />, 
						<cfqueryparam value="#EMAIL#" cfsqltype="cf_sql_varchar" />, 
						<cfqueryparam value="#TELEFON#" cfsqltype="cf_sql_varchar" />, 
						<cfqueryparam value="#TELEFONKOMORKOWY#" cfsqltype="cf_sql_varchar" />, 
						<cfqueryparam value="#PARTNERSPRZEDAZOWY#" cfsqltype="cf_sql_varchar" />,
						<cfif Len(DATAPARTNERSPRZEDAZOWY) EQ 0>
							null,
						<cfelse>
							<cfqueryparam value="#DATAPARTNERSPRZEDAZOWY#" cfsqltype="cf_sql_timestamp" />, 
						</cfif> 
						<cfqueryparam value="#MENEDZERPROJEKTU#" cfsqltype="cf_sql_varchar" />,
						<cfif Len(DATAMENEDZERPROJEKTU) EQ 0>
							null,
						<cfelse>
							<cfqueryparam value="#DATAMENEDZERPROJEKTU#" cfsqltype="cf_sql_timestamp" />, 
						</cfif> 
						<cfqueryparam value="#MAILMENEDZERPROJEKTU#" cfsqltype="cf_sql_varchar" />, 
						<cfqueryparam value="#DATAOSTATNIEJAKTUALIZACJI#" cfsqltype="cf_sql_timestamp" />, 
						<cfqueryparam value="#ZAIMPORTOWANE#" cfsqltype="cf_sql_smallint" />
					);
					
				</cfif>
				
				<!--- Ustawienie flagi Zaimportowane = 1 --->
				<cfset var zaimportowana = "" />
				<cfquery name="zaimportowana" datasource="#this.getRemoteDsn()#">
					update tbSklepy set Zaimportowane = 1
					where IDSklepu = <cfqueryparam value="#IDSKLEPU#" cfsqltype="cf_sql_varchar" />;
				</cfquery>
			</cfquery>
			
		</cfloop>
		
		<cfreturn true /> 
	</cffunction>
	
	<cffunction name="aktualizacjaParametrowSklepu" output="false" access="private" hint="Pobranie parametrów sklepów z eLeader do Intranetu">
		<cfargument name="parametry" type="query" required="true" />
		
		<cfloop query="arguments.parametry">
			
			<cfset var aktualizujSklep = "" />
			<cfset var aktualizujSklepResult = "" />
			<cfquery name="aktualizujSklep" result="aktualizujSklepResult" datasource="#getLocalDsn()#">
			
			<cfif czyIstniejeParametr(IDPARAMETRUSKLEPU, IDSKLEPU)>
				
					update eleader_tbsklepyparametry set 
						nazwaparametru = <cfqueryparam value="#NAZWAPARAMETRU#" cfsqltype="cf_sql_varchar" />, 
						kodparametru = <cfqueryparam value="#KODPARAMETRU#" cfsqltype="cf_sql_varchar" />,  
						<cfif Len(WARTOSCINTEGER) EQ 0>
							wartoscinteger = null,
						<cfelse>
							wartoscinteger = <cfqueryparam value="#WARTOSCINTEGER#" cfsqltype="cf_sql_integer" />,
						</cfif>
						<cfif Len(WARTOSCDOUBLE) EQ 0>
							<!---wartoscdouble = (null::double precision),--->
							wartoscdouble = null,
						<cfelse>
							wartoscdouble = <cfqueryparam value="#WARTOSCDOUBLE#" cfsqltype="cf_sql_double" />,
						</cfif> 
						<cfif Len(WARTOSCDATA) EQ 0>
							wartoscdata = null,
						<cfelse>
							wartoscdata = <cfqueryparam value="#WARTOSCDATA#" cfsqltype="cf_sql_timestamp" />,
						</cfif> 
						wartosctekst = <cfqueryparam value="#WARTOSCTEKST#" cfsqltype="cf_sql_varchar" />, 
						<cfif Len(WARTOSCBINARIA) EQ 0>
							<!---wartoscbinaria = (null::bytea),--->
								wartoscbinaria = null,
						<cfelse>
							wartoscbinaria = <cfqueryparam value="#WARTOSCBINARIA#" cfsqltype="cf_sql_blob" />,
						</cfif>
						wartoscparametru = <cfqueryparam value="#WARTOSCPARAMETRU#" cfsqltype="cf_sql_varchar" />
					where idparametrusklepu = <cfqueryparam value="#IDPARAMETRUSKLEPU#" cfsqltype="cf_sql_varchar" />
						and idsklepu = <cfqueryparam value="#IDSKLEPU#" cfsqltype="cf_sql_varchar" />;
				
				<cfelse>
				
					insert into eleader_tbsklepyparametry (idparametrusklepu, idsklepu, nazwaparametru, kodparametru, wartoscinteger, wartoscdouble, wartoscdata, wartosctekst, wartoscbinaria, wartoscparametru)
					values (
						<cfqueryparam value="#IDPARAMETRUSKLEPU#" cfsqltype="cf_sql_varchar" />,
						<cfqueryparam value="#IDSKLEPU#" cfsqltype="cf_sql_varchar" />,
						<cfqueryparam value="#NAZWAPARAMETRU#" cfsqltype="cf_sql_varchar" />, 
						<cfqueryparam value="#KODPARAMETRU#" cfsqltype="cf_sql_varchar" />, 
						<cfif Len(WARTOSCINTEGER) EQ 0>
							null,
						<cfelse>
							<cfqueryparam value="#WARTOSCINTEGER#" cfsqltype="cf_sql_integer" />,
						</cfif>
						<cfif Len(WARTOSCDOUBLE) EQ 0>
							<!---(null::double precision),--->
							null,
						<cfelse>
							<cfqueryparam value="#WARTOSCDOUBLE#" cfsqltype="cf_sql_double" />,
						</cfif> 
						<cfif Len(WARTOSCDATA) EQ 0>
							null,
						<cfelse>
							<cfqueryparam value="#WARTOSCDATA#" cfsqltype="cf_sql_timestamp" />,
						</cfif> 
						<cfqueryparam value="#WARTOSCTEKST#" cfsqltype="cf_sql_varchar" />, 
						<cfif Len(WARTOSCBINARIA) EQ 0>
							<!---(null::bytea),--->
							null,
						<cfelse>
							<cfqueryparam value="#WARTOSCBINARIA#" cfsqltype="cf_sql_blob" />,
						</cfif> 
						<cfqueryparam value="#WARTOSCPARAMETRU#" cfsqltype="cf_sql_varchar" />
					);
				</cfif>
				
			</cfquery>
			
			<cfset var aktualizacja = "" />
			<cfquery name="aktualizacja" datasource="#getRemoteDsn()#">
				update tbSklepyParametry set Zaimportowane = 1
				where IDParametruSklepu = <cfqueryparam value="#IDPARAMETRUSKLEPU#" cfsqltype="cf_sql_varchar" />
					and IDSklepu = <cfqueryparam value="#IDSKLEPU#" cfsqltype="cf_sql_varchar" />;
			</cfquery>
			
		</cfloop>
	</cffunction>
	
	<!---<cffunction name="wstawListeAktualizacjiSklepow" output="false" access="private" returntype="boolean" hint="Kopiuje z eLeader listę sklepów, która mają być aktualizowane. Po skopiowaniu zeruje wartosci w bazie eLeader" >
		<cfargument name="q" type="query" required="true" />
		
		<cfloop query="arguments.q">
			<cfset var wstawAktualizacjeSklepow = "" />
			<cfquery name="wstawAktualizacjeSklepow" datasource="#getLocalDsn()#">
				insert into eleader_AktualizacjaSklepu (IDSklepu, eLeader, Intranet, DataAktualizacji)
				values (
					<cfqueryparam value="#IDSklepu#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#eLeader#" cfsqltype="cf_sql_bit" />,
					<cfqueryparam value="#Intranet#" cfsqltype="cf_sql_bit" />,
					<cfqueryparam value="#DataAktualizacji#" cfsqltype="cf_sql_timestamp" />   
				);
			</cfquery>
		</cfloop>
		
		<cfreturn true />
	</cffunction>---> 
	
	<cffunction name="czyIstniejeSklep" output="false" access="private" returntype="boolean" hin="">
		<cfargument name="idsklepu" type="string" required="true" />
		
		<cfset var istniejeSklep = "" />
		<cfquery name="istniejeSklep" datasource="#getLocalDsn()#">
			select idsklepu, zaimportowane from eleader_tbsklepy
			where idsklepu = <cfqueryparam value="#arguments.idsklepu#" cfsqltype="cf_sql_varchar" />;
		</cfquery>
		
		<cfif istniejeSklep.RecordCount EQ 0>
			<cfreturn false />
		</cfif>
			
		<cfreturn true />
	</cffunction> 
	
	<cffunction name="czyIstniejeParametr" output="false" access="private" returntype="boolean">
		<cfargument name="idparametrusklepu" type="string" required="true" />
		<cfargument name="idsklepu" type="string" required="true" />
		
		<cfset var istniejeParametr = "" />
		<cfquery name="istniejeParametr" datasource="#getLocalDsn()#">
			select idparametrusklepu, idsklepu
			from eleader_tbsklepyparametry
			where idparametrusklepu = <cfqueryparam value="#arguments.idparametrusklepu#" cfsqltype="cf_sql_varchar" />
				and	idsklepu = <cfqueryparam value="#arguments.idsklepu#" cfsqltype="cf_sql_varchar" />;
		</cfquery> 
		
		<cfif istniejeParametr.RecordCount EQ 0>
			<cfreturn false />
		</cfif>
		
		<cfreturn true />
	</cffunction> 
	
	<cffunction name="pobierzListeAktualizacjiSklepowZEleader" output="false" access="private" returntype="query">
		<cfset var listaAktualizacji = "" />
		<cfquery name="listaAktualizacji" datasource="#getRemoteDsn()#">
			select * from AktualizacjaSklepu;
		</cfquery>
		<cfreturn listaAktualizacji />
	</cffunction>
	
	<cffunction name="pobierzSklepyZEleader" output="false" access="public" returntype="query" hint="">
		<cfset var sklepy = "" />
		<cfquery name="sklepy" datasource="#this.getRemoteDsn()#">
			select * from tbSklepy
			where Zaimportowane = 0;
		</cfquery>
		
		<cfreturn sklepy />
	</cffunction>
	
	<cffunction name="pobierzSklepyParametryZEleader" output="false" access="public" returntype="query" hint="">
		<cfset var parametry = "" />
		<cfquery name="parametry" datasource="#this.getRemoteDsn()#">
			select * from tbSklepyParametry
			where Zaimportowane = 0;
		</cfquery>
		
		<cfreturn parametry />
	</cffunction>
	
	<!--- PUBLIC --->
	<cffunction name="getLocalDsn" output="false" access="public" returntype="string" hint="">
		<cfreturn variables.localDsn/>
	</cffunction>
	
	<cffunction name="getRemoteDsn" output="false" access="public" returntype="string" hint="">
		<cfreturn variables.remoteDsn />
	</cffunction>
	
	<cffunction name="getIntranetDsn" output="false" access="public" returntype="string" hint="">
		<cfreturn variables.intranetDsn />
	</cffunction>
	
	<cffunction name="synchronizujBaze" output="false" access="public" hint="">
		
		<cfset var sklepy = pobierzSklepyZEleader() />
		<cfset aktualizacjaSklepow(sklepy) />
		
		<cfset var parametry = pobierzSklepyParametryZEleader() />
		<cfset aktualizacjaParametrowSklepu(parametry) />
		
		<cfset var aktualizacjaSklepow = pobierzListeAktualizacjiSklepowZEleader() />
		
		<cfreturn true />
		
	</cffunction>
	
	<!---
		Integracja bazy nieruchomości z eLeaderem
	--->
	<cffunction name="kodyParametrow" output="false" access="public" hint="" returntype="query">
		<cfset var kody = "" />
		<cfquery name="kody" datasource="#getLocalDsn()#">
			select distinct KodParametru, NazwaParametru from eleader_tbSklepyParametry;
		</cfquery>
		<cfreturn kody />
	</cffunction>
	
	<cffunction name="pobierzKolumnySklepu" output="false" access="public" hint="" returntype="query">
		<cfset var kolumny = "" />
		<cfquery name="kolumny" datasource="#getLocalDsn()#">
			select a.name as ColumnName, b.name as TableName from sys.columns a
			inner join sys.tables b on a.object_id = b.object_id
			where b.name = 'eleader_tbSklepy' and b.type = 'U';
		</cfquery>
		<cfreturn kolumny />
	</cffunction>
	
</cfcomponent>