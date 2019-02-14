<cfcomponent displayname="eleader" output="false">
	
	<!--- PROPERTIES --->
	<cfproperty name="localDsn" type="string" default="" />
	<cfproperty name="remoteDsn" type="string" default="" />
	<cfproperty name="intranetDsn" type="string" default="" />
	
	<!--- PSEUDO-CONSTRUCTOR --->
	<cfscript>
		variables = {
			remoteDsn = "eleader",
			localDsn = "eleader_intranet",
			intranetDsn = "intranet"
		};
	</cfscript>
	
	<!--- PRIVATE --->
	<cffunction name="czyIstniejeZadanie" output="false" access="private" hint="">
		<cfargument name="id" type="string" required="true" />
		<cfargument name="wersja" type="numeric" required="true" />
		
		<cfset var zadanie = "" />
		<cfquery name="zadanie" datasource="#variables.localDsn#">
			select 
				IDDefinicjiZadania
			from eleader_tbdefinicjezadan
			where IDDefinicjiZadania = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar" />
			and Wersja = <cfqueryparam value="#arguments.wersja#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfreturn zadanie.RecordCount />
	</cffunction>
	
	<cffunction name="czyIstniejePole" output="false" access="private" hint="">
		<cfargument name="idPola" type="string" required="true" />
		<cfargument name="idZadania" type="string" required="true" />
		<cfargument name="Wersja" type="numeric" required="true" />
		
		<cfset var pole = "" />
		<cfquery name="pole" datasource="#variables.localDsn#">
			select 
				IDDefinicjiZadania
				,IDDefinicjiPola
			from eleader_tbdefinicjepol
			where IDDefinicjiPola = <cfqueryparam value="#arguments.idPola#" cfsqltype="cf_sql_varchar" />
				and IDDefinicjiZadania = <cfqueryparam value="#arguments.idZadania#" cfsqltype="cf_sql_varchar" />
				and Wersja = <cfqueryparam value="#arguments.Wersja#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfreturn pole.RecordCount /> 
	</cffunction>
	
	<!--- METODY eLEADER --->
		
	<cffunction name="pobierzDefinicjeZadanZEleader" output="false" access="public">
		<cfset var zadania = "" />
		<cfquery name="zadania" datasource="#variables.remoteDsn#">
			select 
				IDDefinicjiZadania
				,NazwaZadania
				,DataUtworzenia
				,DataModyfikacji
				,Wersja
			from tbDefinicjeZadan
		</cfquery>
		
		<cfreturn zadania />
	</cffunction>
	
	<cffunction name="pobierzDefinicjePolZEleader" output="false" access="public">
		<cfset var pola = "" />
		<cfquery name="pola" datasource="#variables.remoteDsn#">
			select
				IDDefinicjiPola
				,IDDefinicjiZadania
				,NazwaPola
				,KodPola
				,Punkty
				,DataUtworzenia
				,DataModyfikacji
				,Aktywne
				,Wersja
			from tbDefinicjePol
		</cfquery>
		
		<cfreturn pola />
	</cffunction>
	
	<cffunction name="pobierzWykonanieAosZEleader" output="false" access="public">
		<cfset var wykonaneAos = "" />
		
		<cfquery name="wykonaneAos" datasource="#variables.remoteDsn#">
			select
				top 500
				IDAktywnosci
				,PoczatekAktywnosci
				,KoniecAktywnosci
				,ImiePartnera
				,NazwiskoPartnera
				,Email
				,KodSklepu
				,NazwaSklepu
				,NazwaKrotkaSklepu
				,Miasto
				,Ulica
				,Budynek
				,Lokal
				,IDDefinicjiZadania
				,IDDefinicjiPola
				,WartoscInteger
				,WartoscDouble
				,WartoscData
				,WartoscBinaria
				,WartoscTekst
				,WartoscPola
				,Zaimportowane
				,DataUtworzenia
				,Wersja
			from tbWykonaniaAOS
			where Zaimportowane = 0;
		</cfquery>
		
		<cfreturn wykonaneAos />
	</cffunction>
	
	<cffunction name="pobierzWersjeZadanZEleader" output="false" access="public" hint="">
		<cfset var wersje = "" />
		<cfquery name="wersje" datasource="#variables.remoteDsn#">
			select numer, dataZmiany from tbWersjeZadan;
		</cfquery>
		
		<cfreturn wersje />
	</cffunction>
	
	<cffunction name="przygotujTabele" output="false" access="public" hint="">
		<cfset var struktura = "" />
		<cfset var strukturaResult = "" />
		<cfquery name="struktura" result="strukturaResult" datasource="#variables.localDsn#">
			
			drop table if exists daily_definicjezadan;
			create table daily_definicjezadan as
			select 
				a.iddefinicjizadania, 
				a.nazwazadania,
				a.wersja, 
				sum( NULLIF(b.punkty, '')::int ) 
			from eleader_tbdefinicjezadan a
			inner join eleader_tbdefinicjepol b on (a.iddefinicjizadania = b.iddefinicjizadania and a.wersja = b.wersja and b.aktywne = 1) 
			where a.iddefinicjizadania <> <cfqueryparam value="00238000000000000801065" cfsqltype="cf_sql_varchar" />
				and a.iddefinicjizadania <> <cfqueryparam value="00238000000000000801081" cfsqltype="cf_sql_varchar" />
				and a.iddefinicjizadania <> <cfqueryparam value="00238000000000000801267" cfsqltype="cf_sql_varchar" />
				and a.iddefinicjizadania <> <cfqueryparam value="00238000000000000801053" cfsqltype="cf_sql_varchar" />
				and a.iddefinicjizadania <> <cfqueryparam value="00238000000000000801279" cfsqltype="cf_sql_varchar" />
			group by a.iddefinicjizadania, a.nazwazadania, a.wersja;
			
			drop table if exists daily_wykonaniaaos;
			create table daily_wykonaniaaos as
			select 
				a.idaktywnosci,
				a.iddefinicjizadania,
				b.nazwazadania,
				sum(case when c.nazwapola = 'Ocena' then 0 else a.wartoscinteger::int end) as uzyskanepunkty_old,
				sum(case when c.nazwapola = 'Ocena' then a.wartoscpola::int else 0 end) as uzyskanepunkty,
				a.kodsklepu,
				a.imiepartnera,
				a.nazwiskopartnera,
				a.email,
				date_trunc('minute', a.poczatekaktywnosci + interval '30 second') as datautworzenia,
				dz.sum,
				a.budynek,
				a.lokal,
				a.miasto,
				a.ulica,
				a.wersja
			from eleader_tbwykonaniaaos a
			inner join eleader_tbdefinicjezadan b on (a.iddefinicjizadania = b.iddefinicjizadania and a.wersja = b.wersja)
inner join eleader_tbdefinicjepol c on (a.iddefinicjipola = c.iddefinicjipola and a.wersja = c.wersja)
inner join daily_definicjezadan dz on (a.iddefinicjizadania = dz.iddefinicjizadania and a.wersja = dz.wersja)
			group by 
				a.idaktywnosci, 
				a.iddefinicjizadania, 
				b.nazwazadania, 
				a.kodsklepu, 
				a.imiepartnera, 
				a.nazwiskopartnera, 
				a.email, 
				date_trunc('minute', a.poczatekaktywnosci + interval '30 second'),
				dz.sum,
				a.budynek,
				a.lokal,
				a.miasto,
				a.ulica,
				a.wersja;
				
			<!---
			drop table if exists pivot_wykonaniaaos;
			create table pivot_wykonaniaaos as
			select distinct 
				a.idaktywnosci as tmp, 
				a.idaktywnosci as idaktywnosci,
				MAX(bar.email) as email, 
				MAX(bar.kodsklepu) as kodsklepu, 
				MAX(bar.imiepartnera) as imiepartnera, 
				MAX(bar.nazwiskopartnera) as nazwiskopartnera, 
				MAX(bar.datautworzenia) as datautworzenia,
				MAX(case iddefinicjizadania when '00238000000000000799575' then uzyskanepunkty::text end) as "00238000000000000799575",
				MAX(case iddefinicjizadania when '00238000000000000800831' then uzyskanepunkty::text end) as "00238000000000000800831",
				MAX(case iddefinicjizadania when '00238000000000000800890' then uzyskanepunkty::text end) as "00238000000000000800890",
				MAX(case iddefinicjizadania when '00238000000000000801040' then uzyskanepunkty::text end) as "00238000000000000801040",
				MAX(case iddefinicjizadania when '00238000000000000801053' then uzyskanepunkty::text end) as "00238000000000000799575",
				MAX(case iddefinicjizadania when '00238000000000000801065' then uzyskanepunkty::text end) as "00238000000000000801065",
				MAX(case iddefinicjizadania when '00238000000000000801081' then uzyskanepunkty::text end) as "00238000000000000801081",
				MAX(case iddefinicjizadania when '00238000000000000801104' then uzyskanepunkty::text end) as "00238000000000000801104",
				MAX(case iddefinicjizadania when '00238000000000000801119' then uzyskanepunkty::text end) as "00238000000000000801119",
				MAX(case iddefinicjizadania when '00238000000000000801267' then uzyskanepunkty::text end) as "00238000000000000801267",
				MAX(case iddefinicjizadania when '00238000000000000801279' then uzyskanepunkty::text end) as "00238000000000000801279",
				MAX(case iddefinicjizadania when '00238000000000000801053' then uzyskanepunkty::text end) as "00238000000000000801053"
			from daily_wykonaniaaos a
			inner join (
				 	select distinct idaktywnosci, email, kodsklepu, imiepartnera, nazwiskopartnera, datautworzenia 
				 	from daily_wykonaniaaos) bar on a.idaktywnosci = bar.idaktywnosci
			group by a.idaktywnosci;
			--->
			
		</cfquery>
		
		<cfreturn true />
	</cffunction>
	
	<cffunction name="definicjeZadanColumnCount" output="false" access="public" hint="">
		<cfargument name="idaktywnosci" type="string" required="false" />
		<cfargument name="wersja" type="numeric" required="false" />
		
		<cfset var w = "" />
		<cfif IsDefined("arguments.idaktywnosci")>
			
			<cfquery name="w" datasource="#variables.localDsn#">
				select MAX(wersja) as wersja from daily_wykonaniaaos 
				where idaktywnosci = <cfqueryparam value="#arguments.idaktywnosci#" cfsqltype="cf_sql_varchar" />
			</cfquery>
			
		</cfif>
		
		<cfset var ccolumns = "" />
		<cfquery name="ccolumns" datasource="#variables.localDsn#">
			select count(*) as c from daily_definicjezadan where
			<cfif IsDefined("arguments.idaktywnosci")>
				wersja = <cfqueryparam value="#w.wersja#" cfsqltype="cf_sql_integer" />;
			<cfelseif isDefined("arguments.wersja")>
				wersja = <cfqueryparam value="#arguments.wersja#" cfsqltype="cf_sql_integer" />;
			<cfelse>
				wersja = (select MAX(wersja) from daily_definicjezadan);
			</cfif>
		</cfquery>
		<cfreturn ccolumns.c />
	</cffunction>
	
	<!--- METODY INTRANET --->
		
	<cffunction name="aktualizujDefinicjeZadan" output="false" access="public">

		<cfargument name="zadania" type="query" required="true" />
		
		<cfset var noweZadanie = "" />
		<cfset var aktualizacjaZadania = "" />
		
		<cfloop query="arguments.zadania">
			<!--- Przechodzę przez wszystkie zadania i aktualizuje je w lokalnej bazie --->
			
			<!--- Jeżeli zadanie jest już zdefiniowane to aktualizuje je --->
			<cfif czyIstniejeZadanie(IDDefinicjiZadania, Wersja) GT 0>
			
				<cfquery name="aktualizacjaZadania" datasource="#variables.localDsn#">
					update eleader_tbdefinicjezadan set
						nazwazadania = <cfqueryparam value="#NazwaZadania#" cfsqltype="cf_sql_varchar" />,
						datautworzenia = <cfqueryparam value="#DataUtworzenia#" cfsqltype="cf_sql_timestamp" />,
						datamodyfikacji = <cfqueryparam value="#DataModyfikacji#" cfsqltype="cf_sql_timestamp" />,
						wersja = <cfqueryparam value="#Wersja#" cfsqltype="cf_sql_integer" />
					where iddefinicjizadania = <cfqueryparam value="#IDDefinicjiZadania#" cfsqltype="cf_sql_varchar" />
					and wersja = <cfqueryparam value="#Wersja#" cfsqltype="cf_sql_integer" />;
				</cfquery>
			
			<!--- Jeżeli zadanie nie jest zdefiniowane to dodaje nowe --->
			<cfelse>
				
				<cfquery name="noweZadanie" datasource="#variables.localDsn#">
					insert into eleader_tbdefinicjezadan 
						(iddefinicjizadania, nazwazadania, datautworzenia, datamodyfikacji, wersja)
					values (
						<cfqueryparam value="#IDDefinicjiZadania#" cfsqltype="cf_sql_varchar" />,
						<cfqueryparam value="#NazwaZadania#" cfsqltype="cf_sql_varchar" />,
						<cfqueryparam value="#DataUtworzenia#" cfsqltype="cf_sql_timestamp" />,
						<cfqueryparam value="#DataModyfikacji#" cfsqltype="cf_sql_timestamp" />,
						<cfqueryparam value="#Wersja#" cfsqltype="cf_sql_integer" />
					);
				</cfquery>
				
			</cfif>
			
		</cfloop> 
		<cfreturn true />
	</cffunction>
	
	<cffunction name="aktualizujDefinicjePol" output="false" access="public" hint="">
		<cfargument name="pola" type="query" required="true" />
		
		<!--- Przechodzę przez wszystkie definicje pol i sprawdzam, czy istnieje --->
		<cfloop query="arguments.pola">
			<cfset var nowePole = "" />
			<cfset var aktualizujPole = "" />
			
			<!--- Sprawdzam czy istnieje definicja --->
			<!--- Jeżeli definicja nie istnieje to dodaje ją --->
			<cfif czyIstniejePole(IDDefinicjiPola, IDDefinicjiZadania, Wersja) GT 0>
				
				<cfquery name="aktualizujPole" datasource="#variables.localDsn#">
					update eleader_tbdefinicjepol set
						nazwapola = <cfqueryparam value="#NazwaPola#" cfsqltype="cf_sql_varchar" />,
						kodpola = <cfqueryparam value="#KodPola#" cfsqltype="cf_sql_varchar" />,
						punkty = <cfqueryparam value="#Punkty#" cfsqltype="cf_sql_varchar" />,
						datautworzenia = <cfqueryparam value="#DataUtworzenia#" cfsqltype="cf_sql_timestamp" />,
						datamodyfikacji = <cfqueryparam value="#DataModyfikacji#" cfsqltype="cf_sql_timestamp" />,
						aktywne = <cfqueryparam value="#Aktywne#" cfsqltype="cf_sql_integer" />,
						wersja = <cfqueryparam value="#Wersja#" cfsqltype="cf_sql_integer" />
					where iddefinicjipola = <cfqueryparam value="#IDDefinicjiPola#" cfsqltype="cf_sql_varchar" />
						and iddefinicjizadania = <cfqueryparam value="#IDDefinicjiZadania#" cfsqltype="cf_sql_varchar" />
						and wersja = <cfqueryparam value="#Wersja#" cfsqltype="cf_sql_integer" />
				</cfquery>
				
			<!--- Jeżeli nie ma definicji pola to dodaje ją --->
			<cfelse>
				
				<cfquery name="nowePole" datasource="#variables.localDsn#">
					insert into eleader_tbdefinicjepol 
						(iddefinicjipola, iddefinicjizadania ,nazwapola ,kodpola, punkty, datautworzenia, datamodyfikacji, aktywne, wersja)
					values (
						<cfqueryparam value="#IDDefinicjiPola#" cfsqltype="cf_sql_varchar" />,
						<cfqueryparam value="#IDDefinicjiZadania#" cfsqltype="cf_sql_varchar" />,
						<cfqueryparam value="#NazwaPola#" cfsqltype="cf_sql_varchar" />,
						<cfqueryparam value="#KodPola#" cfsqltype="cf_sql_varchar" />,
						<cfqueryparam value="#Punkty#" cfsqltype="cf_sql_varchar" />,
						<cfqueryparam value="#DataUtworzenia#" cfsqltype="cf_sql_timestamp" />,
						<cfqueryparam value="#DataModyfikacji#" cfsqltype="cf_sql_timestamp" />,
						<cfqueryparam value="#Aktywne#" cfsqltype="cf_sql_integer" />,
						<cfqueryparam value="#Wersja#" cfsqltype="cf_sql_integer" />
					)
				</cfquery>
				
			</cfif>
		</cfloop>
		
		<cfreturn true />
	</cffunction>

	<cffunction name="aktualizujWykonanieAos" output="false" access="public" hint="">
		<cfargument name="aos" type="query" required="true" />
		
		<cfloop query="arguments.aos">
			
			<cfset var noweWykonanieAos = "" />
			<cfset var aktualizacjaAos = "" />
			<cfquery name="noweWykonanieAos" datasource="#variables.localDsn#">
				insert into eleader_tbwykonaniaaos (
					idaktywnosci, 
					poczatekaktywnosci,
					koniecaktywnosci,
					imiepartnera, 
					nazwiskopartnera,
					email, 
					kodsklepu, 
					nazwasklepu, 
					nazwakrotkasklepu, 
					miasto, 
					ulica, 
					budynek, 
					lokal,
					iddefinicjizadania, 
					iddefinicjipola, 
					wartoscinteger, 
					wartoscdouble,
					wartoscdata,
					wartoscbinaria,
					wartosctekst, 
					wartoscpola, 
					zaimportowane,
					datautworzenia,
					wersja)
				values (
					<cfqueryparam value="#IDAktywnosci#" cfsqltype="cf_sql_varchar" />,
					
					<cfif Len(PoczatekAktywnosci)>
						<cfqueryparam value="#PoczatekAktywnosci#" cfsqltype="cf_sql_timestamp" />,
					<cfelse>
						(null::timestamp),
					</cfif>
					
					<cfif Len(KoniecAktywnosci)>
						<cfqueryparam value="#KoniecAktywnosci#" cfsqltype="cf_sql_timestamp" />,
					<cfelse>
						(null::timestamp),
					</cfif>
					
					<cfqueryparam value="#ImiePartnera#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#NazwiskoPartnera#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#Email#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#KodSklepu#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#NazwaSklepu#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#NazwaKrotkaSklepu#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#Miasto#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#Ulica#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#Budynek#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#Lokal#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#IDDefinicjiZadania#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#IDDefinicjiPola#" cfsqltype="cf_sql_varchar" />,
					<cfif Len(WartoscInteger)>
						<cfqueryparam value="#WartoscInteger#" cfsqltype="cf_sql_integer" />,
					<cfelse>
						(null::integer),
					</cfif>
					
					<cfif not Len(WartoscDouble)>
						(null::double precision),
					<cfelse>
						<cfqueryparam value="#WartoscDouble#" cfsqltype="cf_sql_double" />,
					</cfif>
					
					<cfif Len(WartoscData)>
						<cfqueryparam value="#WartoscData#" cfsqltype="cf_sql_timestamp" />,
					<cfelse>
						(null::timestamp),
					</cfif>
					<cfif Len(WartoscBinaria)>
						<cfqueryparam value="#WartoscBinaria#" cfsqltype="cf_sql_blob" />,
					<cfelse>
						(null::bytea),
					</cfif>
					<cfqueryparam value="#WartoscTekst#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#WartoscPola#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#Zaimportowane#" cfsqltype="cf_sql_integer" />,
					<cfif Len(DataUtworzenia)>
						<cfqueryparam value="#DataUtworzenia#" cfsqltype="cf_sql_timestamp" />,
					<cfelse>
						(null:timestamp),
					</cfif>
					
					<cfqueryparam value="#Wersja#" cfsqltype="cf_sql_integer" />
				);
			</cfquery>
			
			<cfquery name="aktualizacjaAos" datasource="#variables.remoteDsn#">
				update tbWykonaniaAOS set Zaimportowane = 1
				where IDAktywnosci = <cfqueryparam value="#IDAktywnosci#" cfsqltype="cf_sql_varchar" />
					and IDDefinicjiZadania = <cfqueryparam value="#IDDefinicjiZadania#" cfsqltype="cf_sql_varchar" />
					and IDDefinicjiPola = <cfqueryparam value="#IDDefinicjiPola#" cfsqltype="cf_sql_varchar" />
			</cfquery>
			
		</cfloop>
		
		<cfreturn arguments.aos.RecordCount />
	</cffunction>
	
	<cffunction name="aktualizujWersjeZadan" output="false" access="public" hint="">
		<cfargument name="wersje" type="query" required="true" />
		
		<cfset var usunUtworzTabelke = "" />
		<cfquery name="usunUtworzTabelke" datasource="#variables.localDsn#">
			drop table if exists eleader_tbwersjezadan;
			create table eleader_tbwersjezadan (
				numer integer,
				datazmiany varchar(255)
			);
		</cfquery>
		
		<cfloop query="arguments.wersje">
			<cfset var wersjeZadan = "" />
			<cfquery name="wersjeZadan" datasource="#variables.localDsn#">
				insert into eleader_tbwersjezadan (numer, datazmiany)
				values (
					<cfqueryparam value="#numer#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#datazmiany#" cfsqltype="cf_sql_varchar" />
				);
			</cfquery>
		</cfloop>
		
		<cfreturn true />
	</cffunction>
	
	<!--- PUBLIC --->
	<cffunction name="init" output="false" access="public" hint="">
		<cfargument name="localDsn" type="string" required="true" />
		<cfargument name="remoteDsn" type="string" required="true" />
		
		<cfset variables.localDsn = arguments.localDsn />
		<cfset variables.remoteDsn = arguments.remoteDsn />
		
		<cfreturn this />
	</cffunction>
	
	<!--- METODY AOS INTRANET --->
	<cffunction name="listaSklepowZAos" output="false" access="public" hint="">
		<cfset var listaSklepow = "" />
		<cfquery name="listaSklepow" datasource="#variables.localDsn#" cachedwithin="#createTimespan(0, 0, 15, 0)#">
			select
				a.kodsklepu, a.miasto, a.ulica
			from eleader_tbwykonaniaaos a
			group by a.kodsklepu, a.miasto, a.ulica
			order by a.kodsklepu asc;
		</cfquery>
		<cfreturn listaSklepow />
	</cffunction>
	
	<cffunction name="listaKos" output="false" access="public" hint="">
		<cfset var listaKos = "" />
		<cfquery name="listaKos" datasource="#variables.intranetDsn#" cachedwithin="#createTimespan(0, 1, 0, 0)#">
			select distinct u.givenname, u.sn, u.mail, (
				select count(*) from store_stores where partnerid = tgu.userid and is_active = 1) as iloscsklepow
			from tree_groupusers tgu
				inner join tree_groups tg on tgu.groupid= tg.id
				inner join users u on tgu.userid = u.id
			where tg.groupname = "KOS" or tg.groupname = "Departament Kontroli i Nadzoru"
		</cfquery>
		<cfreturn listaKos />
	</cffunction>
	
	<cffunction name="iloscKontroliUzytkownikow" output="false" access="public" hint="">
		<cfset var iloscKontroli = "" />
		<cfquery name="iloscKontroli" datasource="#variables.localDsn#" cachedwithin="#createTimespan(0, 1, 0, 0)#">
			drop table if exists tmp_eleader_wykonaniaaos;
			create temporary table tmp_eleader_wykonaniaaos as select distinct idaktywnosci, imiepartnera, nazwiskopartnera, email, kodsklepu from eleader_tbwykonaniaaos;
			
			select
 				count(*) as ilosckontroli, 
 				imiepartnera, 
 				nazwiskopartnera, 
 				email
			from tmp_eleader_wykonaniaaos foo
			group by foo.imiepartnera, foo.nazwiskopartnera, foo.email;
		</cfquery>
		<cfreturn iloscKontroli />
	</cffunction>
	
	<cffunction name="idAktywnosciIEmail" output="false" access="public" hint="Pobranie kontroli AOS na podstawie adresu email">
		<cfargument name="email" type="string" required="false" />
		<cfargument name="interval" type="numeric" required="false" />
		
		<cfset var kontrole = "" />
		<cfset var sklepyKosLista = '' />
		<cfif IsDefined("arguments.email")>
		
			<cfset var sklepyKos = this.sklepyKosaIntranet(LCase(arguments.email)) />
			<cfloop query="sklepyKos">
				<cfset sklepyKosLista &= " kodsklepu = '" & projekt & "' or " />
			</cfloop>
			
			<cfif Len(sklepyKosLista) GT 5>
				<cfset sklepyKosLista = Left(sklepyKosLista, Len(sklepyKosLista)-3) />
			</cfif>
		
		</cfif>
		
		<cfquery name="kontrole" datasource="#variables.localDsn#" cachedwithin="#createTimespan(0, 1, 0, 0)#">
			select distinct idaktywnosci, email, kodsklepu from daily_wykonaniaaos
			where 1=1
			<cfif IsDefined("arguments.interval")>
				and datautworzenia > CURRENT_DATE - INTERVAL '#arguments.interval# months'
			</cfif>
			<cfif Len(sklepyKosLista) GT 5>
				and ( #PreserveSingleQuotes(sklepyKosLista)# )
			<cfelse>
				and 1 = 0
			</cfif>
		</cfquery>
		<cfreturn kontrole />
	</cffunction>
	
	<cffunction name="punktacjaAktywnosci" output="false" access="public" hint="">
		<cfargument name="email" type="string" required="false" />
		<cfargument name="sklep" type="string" required="false" />
		<cfargument name="interval" type="numeric" required="false" />
		
		<cfset var punktacja = "" />
		<cfquery name="punktacja" datasource="#variables.localDsn#" cachedwithin="#createTimespan(0, 1, 0, 0)#">
			select distinct 
			a.idaktywnosci as tmp, 
			a.idaktywnosci as idaktywnosci,
			MAX(bar.wersja) as wersja,
			MAX(bar.email) as email, 
			MAX(bar.kodsklepu) as kodsklepu, 
			MAX(bar.imiepartnera) as imiepartnera, 
			MAX(bar.nazwiskopartnera) as nazwiskopartnera, 
			MAX(bar.datautworzenia) as datautworzenia,
			MAX(case iddefinicjizadania when '00238000000000001574944' then uzyskanepunkty::text end) as "00238000000000001574944",
			MAX(case iddefinicjizadania when '00238000000000001574974' then uzyskanepunkty::text end) as "00238000000000001574974",
			MAX(case iddefinicjizadania when '00238000000000001575005' then uzyskanepunkty::text end) as "00238000000000001575005",
			MAX(case iddefinicjizadania when '00238000000000001575046' then uzyskanepunkty::text end) as "00238000000000001575046",
			<!---MAX(case iddefinicjizadania when '00238000000000000801053' then uzyskanepunkty::text end) as "00238000000000000801053",--->
			<!---MAX(case iddefinicjizadania when '00238000000000000801065' then uzyskanepunkty::text end) as "00238000000000000801065",--->
			<!---MAX(case iddefinicjizadania when '00238000000000000801081' then uzyskanepunkty::text end) as "00238000000000000801081",--->
			<!---MAX(case iddefinicjizadania when '00238000000000000801104' then uzyskanepunkty::text end) as "00238000000000000801104",--->
			MAX(case iddefinicjizadania when '00238000000000001575127' then uzyskanepunkty::text end) as "00238000000000001575127",
			<!---MAX(case iddefinicjizadania when '00238000000000000801267' then uzyskanepunkty::text end) as "00238000000000000801267",--->
			<!---MAX(case iddefinicjizadania when '00238000000000000801279' then uzyskanepunkty::text end) as "00238000000000000801279",--->
			<!---MAX(case iddefinicjizadania when '00238000000000000801053' then uzyskanepunkty::text end) as "00238000000000000801053",--->
			MAX(case iddefinicjizadania when '00238000000000001575146' then uzyskanepunkty::text end) as "00238000000000001575146",
			(select SUM(sum) from daily_definicjezadan t where t.wersja = wersja) as douzyskania
			from daily_wykonaniaaos a
			inner join (
			 	select distinct idaktywnosci, email, kodsklepu, imiepartnera, nazwiskopartnera, datautworzenia, wersja 
			 	from daily_wykonaniaaos) bar on (a.idaktywnosci = bar.idaktywnosci and a.wersja = bar.wersja)
 	
 			where 1=1
			
			<cfif IsDefined("arguments.interval")>
				and bar.datautworzenia > CURRENT_DATE - INTERVAL '#arguments.interval# months'
			</cfif>
			
			<cfif IsDefined("arguments.email")>
				and bar.email = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar" />
			</cfif>
			
			<cfif IsDefined("arguments.sklep")>
				and bar.kodsklepu = <cfqueryparam value="#arguments.sklep#" cfsqltype="cf_sql_varchar" />
			</cfif>
			
			and a.wersja = (select max(numer) from eleader_tbwersjezadan)
			 
			group by a.idaktywnosci 
			
 			order by MAX(bar.datautworzenia) desc

		</cfquery>
		<cfreturn punktacja />
	</cffunction>
	
	<cffunction name="punktacjaAktywnosciDlaKos" output="false" access="public" hint="">
		<cfargument name="interval" type="numeric" required="false" />
		<cfargument name="email" type="string" required="true" />
		
		<cfset var sklepyKos = this.sklepyKosaIntranet(LCase(arguments.email)) />
		<cfset var sklepyKosLista = '' />
		<cfloop query="sklepyKos">
			<cfset sklepyKosLista &= " bar.kodsklepu = '" & projekt & "' or " />
		</cfloop>
		<cfif Len(sklepyKosLista) GT 5>
			<cfset sklepyKosLista = Left(sklepyKosLista, Len(sklepyKosLista)-3) />
		</cfif>
		
		<!--- Zapytanie pobierające wypełnione arkusze w danym przedziale czasu --->
		<cfquery name="punktacjaKos" result="punktacjaKosResult" datasource="eleader_intranet" cachedwithin="#createTimespan(0, 1, 0, 0)#">
			
			select distinct 
			a.idaktywnosci as tmp, 
			a.idaktywnosci as idaktywnosci, 
			MAX(foo.douzyskania) as douzyskania,
			MAX(bar.wersja) as wersja,
			MAX(bar.email) as email, 
			MAX(bar.kodsklepu) as kodsklepu, 
			MAX(bar.imiepartnera) as imiepartnera, 
			MAX(bar.nazwiskopartnera) as nazwiskopartnera, 
			MAX(bar.datautworzenia) as datautworzenia,
			MAX(case iddefinicjizadania when '00238000000000001574944' then uzyskanepunkty::text end) as "00238000000000001574944",
			MAX(case iddefinicjizadania when '00238000000000001574974' then uzyskanepunkty::text end) as "00238000000000001574974",
			MAX(case iddefinicjizadania when '00238000000000001575005' then uzyskanepunkty::text end) as "00238000000000001575005",
			MAX(case iddefinicjizadania when '00238000000000001575046' then uzyskanepunkty::text end) as "00238000000000001575046",
			<!---MAX(case iddefinicjizadania when '00238000000000000801053' then uzyskanepunkty::text end) as "00238000000000000801053",--->
			<!---MAX(case iddefinicjizadania when '00238000000000000801065' then uzyskanepunkty::text end) as "00238000000000000801065",--->
			<!---MAX(case iddefinicjizadania when '00238000000000000801081' then uzyskanepunkty::text end) as "00238000000000000801081",--->
			<!---MAX(case iddefinicjizadania when '00238000000000000801104' then uzyskanepunkty::text end) as "00238000000000000801104",--->
			MAX(case iddefinicjizadania when '00238000000000001575127' then uzyskanepunkty::text end) as "00238000000000001575127",
			<!---MAX(case iddefinicjizadania when '00238000000000000801267' then uzyskanepunkty::text end) as "00238000000000000801267",--->
			<!---MAX(case iddefinicjizadania when '00238000000000000801279' then uzyskanepunkty::text end) as "00238000000000000801279",--->
			<!---MAX(case iddefinicjizadania when '00238000000000000801053' then uzyskanepunkty::text end) as "00238000000000000801053",--->
			MAX(case iddefinicjizadania when '00238000000000001575146' then uzyskanepunkty::text end) as "00238000000000001575146"
			from daily_wykonaniaaos a
			inner join (
			 	select distinct idaktywnosci, email, kodsklepu, imiepartnera, nazwiskopartnera, datautworzenia, wersja 
			 	from daily_wykonaniaaos) bar on (a.idaktywnosci = bar.idaktywnosci and a.wersja = bar.wersja)
			 inner join (
			 	select SUM(sum) as douzyskania, wersja from daily_definicjezadan group by wersja) foo on a.wersja = foo.wersja
			 
 	
 			where 1=1
			
			<cfif IsDefined("arguments.interval")>
				and bar.datautworzenia > CURRENT_DATE - INTERVAL '#arguments.interval# months'
			</cfif>
			
			<cfif Len(sklepyKosLista) GT 5>
				and ( #PreserveSingleQuotes(sklepyKosLista)# )
			<cfelse>
				and 1 = 0
			</cfif>
			group by a.idaktywnosci, a.kodsklepu
			<!---order by MAX(bar.datautworzenia) desc
			limit 1--->
			
			<!---SELECT * FROM crosstab('select idaktywnosci::text, iddefinicjizadania::text, uzyskanepunkty::text from daily_wykonaniaaos')
AS ct(tmp text, "00238000000000000799575" text, 
	"00238000000000000800831" text, 
	"00238000000000000800890" text, 
	"00238000000000000801040" text, 
	"00238000000000000801053" text, 
	"00238000000000000801065" text, 
	"00238000000000000801081" text, 
	"00238000000000000801104" text, 
	"00238000000000000801119" text,
	"00238000000000000801267" text,
	"00238000000000000801279" text)
inner join (select distinct idaktywnosci, email, kodsklepu, imiepartnera, nazwiskopartnera, datautworzenia from daily_wykonaniaaos) as bar on tmp = bar.idaktywnosci
			where 1=1
			
			<cfif IsDefined("arguments.interval")>
				and bar.datautworzenia > CURRENT_DATE - INTERVAL '#arguments.interval# months'
			</cfif>
			
			<cfif Len(sklepyKosLista) GT 5>
				and ( #PreserveSingleQuotes(sklepyKosLista)# )
			<cfelse>
				and 1 = 0
			</cfif>--->
			
		</cfquery>
		
		<cfreturn punktacjaKos />
	</cffunction>
	
	<cffunction name="listaZagadnien" output="false" access="public" hint="">
		<cfargument name="idaktywnosci" type="string" required="false" />
		<cfargument name="wersja" type="numeric" required="false" />
		
		<cfset var zagadnienia = "" />
		<cfset var w = "" />
		
		<cfif IsDefined("arguments.idaktywnosci")>
			<cfquery name="w" datasource="#variables.localDsn#">
				select MAX(wersja) as wersja from daily_wykonaniaaos
				where idaktywnosci = <cfqueryparam value="#arguments.idaktywnosci#" cfsqltype="cf_sql_varchar" />
				<!---and iddefinicjizadania <> <cfqueryparam value="00238000000000000801065" cfsqltype="cf_sql_varchar" />--->
				<!---and iddefinicjizadania <> <cfqueryparam value="00238000000000000801081" cfsqltype="cf_sql_varchar" />--->
				<!---and iddefinicjizadania <> <cfqueryparam value="00238000000000000801267" cfsqltype="cf_sql_varchar" />--->
				<!---and iddefinicjizadania <> <cfqueryparam value="00238000000000000801053" cfsqltype="cf_sql_varchar" />--->
				<!---and iddefinicjizadania <> <cfqueryparam value="00238000000000000801279" cfsqltype="cf_sql_varchar" />--->
				;
			</cfquery>
		</cfif>
		
		<cfquery name="zagadnienia" datasource="#variables.localDsn#">
			select * from daily_definicjezadan where 
			
			<cfif IsDefined("arguments.idaktywnosci")>
				wersja = <cfqueryparam value="#w.wersja#" cfsqltype="cf_sql_integer" />
			<cfelseif isDefined("arguments.wersja")>
				wersja = <cfqueryparam value="#arguments.wersja#" cfsqltype="cf_sql_integer" />
			<cfelse>
				wersja = (select MAX(wersja) from daily_definicjezadan)
			</cfif>
			
			<!---and iddefinicjizadania <> <cfqueryparam value="00238000000000000801065" cfsqltype="cf_sql_varchar" />--->
			<!---and iddefinicjizadania <> <cfqueryparam value="00238000000000000801081" cfsqltype="cf_sql_varchar" />--->
			<!---and iddefinicjizadania <> <cfqueryparam value="00238000000000000801267" cfsqltype="cf_sql_varchar" />--->
			<!---and iddefinicjizadania <> <cfqueryparam value="00238000000000000801053" cfsqltype="cf_sql_varchar" />--->
			<!---and iddefinicjizadania <> <cfqueryparam value="00238000000000000801279" cfsqltype="cf_sql_varchar" />--->
			<!---and iddefinicjizadania <> '00238000000000000801104'--->
			;
				
		</cfquery>
		
		<cfreturn zagadnienia />
	</cffunction>
	
	<cffunction name="listaWszystkichZagadnien" output="false" access="public" hint="">
		<cfset var zagadnienia = "" />
		<cfquery name="zagadnienia" datasource="#variables.localDsn#">
			select *, sum as sumadouzyskania from daily_definicjezadan
			where 1=1
			<!---and iddefinicjizadania <> <cfqueryparam value="00238000000000000801065" cfsqltype="cf_sql_varchar" />--->
			<!---and iddefinicjizadania <> <cfqueryparam value="00238000000000000801081" cfsqltype="cf_sql_varchar" />--->
			<!---and iddefinicjizadania <> <cfqueryparam value="00238000000000000801267" cfsqltype="cf_sql_varchar" />--->
			<!---and iddefinicjizadania <> <cfqueryparam value="00238000000000000801053" cfsqltype="cf_sql_varchar" />--->
			<!---and iddefinicjizadania <> <cfqueryparam value="00238000000000000801279" cfsqltype="cf_sql_varchar" />--->
			<!---and iddefinicjizadania <> '00238000000000000801104'--->
			;
		</cfquery>
		
		<cfreturn zagadnienia />
	</cffunction>
	
	<cffunction name="wersjeZadan" output="false" access="public" hint="">
		<cfset var wersje = "" />
		<cfquery name="wersje" datasource="#variables.localDsn#">
			select * from eleader_tbwersjezadan;
		</cfquery>
		
		<cfreturn wersje />
	</cffunction>
	
	<cffunction name="maxWersjeZadan" output="false" access="public" hint="">
		<cfset var wersje = "" />
		<cfquery name="wersje" datasource="#variables.localDsn#">
			select * from eleader_tbwersjezadan
			where numer = (select max(numer) from eleader_tbwersjezadan);
		</cfquery>
		
		<cfreturn wersje />
	</cffunction>
	
	<cffunction name="pobierzMaxWersjaZadan" output="false" access="public" hint="" returntype="Numeric">
		<cfset var wersja = "" />
		<cfquery name="wersja" datasource="#variables.localDsn#">
			select max(numer) as w from eleader_tbwersjezadan;
		</cfquery>
		<cfreturn wersja.w />
	</cffunction> 
	
	<cffunction name="sklepyKosa" output="false" access="public" hint="Pobieram sklepy KOSa na podstawie jego emaila">
		<cfargument name="email" type="string" required="false" />
		<cfargument name="interval" type="string" required="false" >
		
		<cfset var sklepy = "" />
		<cfquery name="sklepy" datasource="eleader_intranet" cachedwithin="#createTimespan(0, 0, 15, 0)#">
			select 
				distinct kodsklepu, 
				email,
				miasto,
				ulica,
				budynek,
				lokal,
				(
					select count(distinct idaktywnosci) 
					from daily_wykonaniaaos b 
					where 1=1 
						and b.kodsklepu = a.kodsklepu
						<cfif IsDefined("arguments.interval")>
							and b.datautworzenia > CURRENT_DATE - INTERVAL '#arguments.interval# months'
						</cfif>
				) ilosckontroli,
				(
					select count(id) from odwolania_aos c where c.kodsklepu = a.kodsklepu 
					<cfif IsDefined("arguments.interval")>
						and c.datapowstaniaaos > CURRENT_DATE - INTERVAL '#arguments.interval# months'
					</cfif>
				) as iloscodwolan,
				(
					select count(distinct idaktywnosci)
					from daily_wykonaniaaos d
					where 1=1
						and d.kodsklepu = a.kodsklepu
						and d.email like <cfqueryparam value="%@monkey.xyz" cfsqltype="cf_sql_varchar" />
						<cfif IsDefined("arguments.interval")>
							and d.datautworzenia > CURRENT_DATE - INTERVAL '#arguments.interval# months'
						</cfif>
				) as ilosckontrolicentrali
				from daily_wykonaniaaos a
			<cfif IsDefined("arguments.email")>
				where email = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar" />
			</cfif>
			group by email, kodsklepu, miasto, ulica, budynek, lokal
			order by kodsklepu asc
		</cfquery>
		<cfreturn sklepy />
	</cffunction>
	
	<cffunction name="sklepyKosaIntranet" output="false" access="public" hint="Pobieram sklepy KOSa z Intranetu. Dane są potrzebne aby mieć imię i nazwisko PPSa">
		<cfargument name="email" type="string" required="false" />
		<cfset var sklepy = ""/>
		<cfquery name="sklepy" datasource="#variables.intranetDsn#" cachedwithin="#createTimespan(0, 0, 15, 0)#">
			select distinct s.projekt, s.nazwaajenta, u.login as loginkosa, u.givenname as nazwakosa, s.adressklepu
			from store_stores s
				inner join users u on s.partnerid= u.id
			where s.is_active = 1
			<cfif IsDefined("arguments.email")>
				and login = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar" />
			</cfif>
		</cfquery>
		<cfreturn sklepy />
	</cffunction>
	
	<cffunction name="kontroleNaSklepachKos" output="false" access="public" hint="Zapytanie zwracające ilość kontroli na sklepach kos">
		<cfargument name="email" type="string" required="false" />
		<cfargument name="interval" type="numeric" required="false" />
		
		<cfset var kontrole = "" />
		<cfquery name="kontrole" datasource="eleader_intranet" cachedwithin="#createTimespan(0, 0, 15, 0)#">
			drop table if exists tmp_kodsklepu;
			create temporary table tmp_kodsklepu as (
			select
				distinct kodsklepu,
				email
			from daily_wykonaniaaos a
			where 1=1
			<cfif IsDefined("arguments.email")>
				and email = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar" /> 
			</cfif>
			group by email, kodsklepu
			);
			
			select distinct count(*) as kontrolenasklepie
			
			from daily_wykonaniaaos a
			inner join (
			 	select distinct idaktywnosci, email, kodsklepu, imiepartnera, nazwiskopartnera, datautworzenia 
			 	from daily_wykonaniaaos) bar on a.idaktywnosci = bar.idaktywnosci
 	
 			where bar.kodsklepu in (
				select kodsklepu from tmp_kodsklepu
			)
			
			<cfif IsDefined("arguments.interval")>
			 and bar.datautworzenia > CURRENT_DATE - INTERVAL '#arguments.interval# months'
			</cfif>
 	
			group by a.idaktywnosci
			
			<!---SELECT count(*) as kontrolenasklepie FROM crosstab('select idaktywnosci::text, iddefinicjizadania::text, uzyskanepunkty::text from daily_wykonaniaaos')
AS ct(tmp text, "00238000000000000799575" text, 
	"00238000000000000800831" text, 
	"00238000000000000800890" text, 
	"00238000000000000801040" text, 
	"00238000000000000801053" text, 
	"00238000000000000801065" text, 
	"00238000000000000801081" text, 
	"00238000000000000801104" text, 
	"00238000000000000801119" text,
	"00238000000000000801267" text,
	"00238000000000000801279" text)
inner join (select distinct idaktywnosci, email, kodsklepu, imiepartnera, nazwiskopartnera, datautworzenia from daily_wykonaniaaos) as bar on tmp = bar.idaktywnosci
			where kodsklepu in (
				select kodsklepu from tmp_kodsklepu
			)
			<cfif IsDefined("arguments.interval")>
			 and datautworzenia > CURRENT_DATE - INTERVAL '#arguments.interval# months'
			</cfif>--->
		</cfquery>
		<cfreturn kontrole />
	</cffunction>
	
	<cffunction name="pobierzOdpowiedziArkusza" output="false" access="public" hint="">
		<cfargument name="idaktywnosci" type="string" required="true" />
		<cfset var pytaniaArkusza = "" />
		<cfquery name="pytaniaArkusza" datasource="#variables.localDsn#" cachedwithin="#createTimespan(0, 1, 0, 0)#">
			select a.idaktywnosci, a.iddefinicjizadania, a.iddefinicjipola, b.nazwapola, b.punkty, a.wartoscpola, a.wartosctekst, date_trunc('minute', a.poczatekaktywnosci + interval '30 second') as poczatekaktywnosci, a.wartoscinteger, a.wartoscdouble, a.wartoscdata, a.kodsklepu, d.nazwastatusu, c.id as idodwolania
			from eleader_tbwykonaniaaos a
			inner join eleader_tbdefinicjepol b on (a.iddefinicjipola = b.iddefinicjipola and a.iddefinicjizadania = b.iddefinicjizadania and a.wersja = b.wersja) 
			left join odwolania_aos c on (a.idaktywnosci = c.idaktywnosci
					and a.iddefinicjipola = c.iddefinicjipola 
					and a.iddefinicjizadania = c.iddefinicjizadania)
			left join statusy_odwolan_aos d on c.idstatusuodwolania = d.id
			where a.idaktywnosci = <cfqueryparam value="#arguments.idaktywnosci#" cfsqltype="cf_sql_varchar" />
		</cfquery>
		<cfreturn pytaniaArkusza />
	</cffunction>
	
	<cffunction name="dodajOdwolanie" output="false" access="public" hint="Akcja zapisywania odwołania w bazie" >
		<cfargument name="formularz" type="struct" required="true" />
		<cfset var noweOdwolanie = "" />
		<cfquery name="noweOdwolanie" datasource="#variables.localDsn#">
			
			insert into odwolania_aos (iddefinicjizadania, iddefinicjipola, idaktywnosci, kodsklepu, userid, trescodwolania, dataodwolania, idstatusuodwolania, datapowstaniaaos)
			values (
				<cfqueryparam value="#arguments.formularz.iddefinicjizadania#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.formularz.iddefinicjipola#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.formularz.idaktywnosci#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.formularz.kodsklepu#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.formularz.userid#" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value="#arguments.formularz.trescodwolania#" cfsqltype="cf_sql_varchar" />,
				Now(),
				1,
				(select MAX(datautworzenia) from daily_wykonaniaaos where idaktywnosci = <cfqueryparam value="#arguments.formularz.idaktywnosci#" cfsqltype="cf_sql_varchar" />)
			) returning id, idstatusuodwolania, dataodwolania, userid;
			
		</cfquery>
		
		<cfreturn noweOdwolanie />
	</cffunction>
	
	<cffunction name="pobierzOdwolanie" output="false" access="public" hint="Pobierz treść odwołania">
		<cfargument name="id" type="numeric" required="false" />
		<cfset var listaOdwolan = "" />
		<cfquery name="listaOdwolan" datasource="#variables.localDsn#">
			select a.*, b.nazwapola, c.nazwazadania, d.nazwastatusu
			from odwolania_aos a 
			inner join eleader_tbwykonaniaaos z on (z.idaktywnosci = a.idaktywnosci and z.iddefinicjipola = a.iddefinicjipola and z.iddefinicjizadania = a.iddefinicjizadania)
			inner join eleader_tbdefinicjepol b on (a.iddefinicjipola = b.iddefinicjipola and b.wersja = z.wersja)
			inner join eleader_tbdefinicjezadan c on (a.iddefinicjizadania = c.iddefinicjizadania and c.wersja = z.wersja)
			inner join statusy_odwolan_aos d on d.id = a.idstatusuodwolania
			<cfif IsDefined("arguments.id")>
				where a.id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />
			</cfif>
		</cfquery>
		<cfreturn listaOdwolan />
	</cffunction>
	
	<cffunction name="pobierzOdwolaniePoIdAktywnosci" output="false" access="public" hint="">
		<cfargument name="idaktywnosci" type="string" required="true" />

		<cfset var odwolania = "" />
		<cfquery name="odwolania"datasource="#variables.localDsn#">
			select a.id, a.idaktywnosci, a.iddefinicjipola, a.iddefinicjizadania, a.dataodwolania, a.trescodwolania,
				b.kodsklepu, b.datautworzenia, b.imiepartnera, b.nazwiskopartnera,
				c.nazwapola,
				d.nazwazadania
				from odwolania_aos a
				left join eleader_tbwykonaniaaos b on (a.idaktywnosci = b.idaktywnosci 
													and a.iddefinicjipola = b.iddefinicjipola 
													and a.iddefinicjizadania = b.iddefinicjizadania)
				left join eleader_tbdefinicjepol c on (a.iddefinicjipola = c.iddefinicjipola and b.wersja = c.wersja and c.aktywne = 1)
				left join eleader_tbdefinicjezadan d on (a.iddefinicjizadania = d.iddefinicjizadania and b.wersja = d.wersja)
			where a.idaktywnosci = <cfqueryparam value="#arguments.idaktywnosci#" cfsqltype="cf_sql_varchar" />
			and a.idstatusuodwolania = 1
		</cfquery>
		<cfreturn odwolania />
	</cffunction>
	
	<cffunction name="dodajHistorieOdwolanAos" output="false" access="public" hint="Dodawanie wpisu do historii zmian statusów odwołań">
		<cfargument name="dane" type="query" required="true" />
		<cfset var historiaStatusu = "" />
		<cfquery name="historiaStatusu" datasource="#variables.localDsn#">
			insert into historia_odwolan_aos (idstatusuodwolania, idodwolania, datazmiany, userid)
			values (
				<cfqueryparam value="#arguments.dane.idstatusuodwolania#" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value="#arguments.dane.id#" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value="#arguments.dane.dataodwolania#" cfsqltype="cf_sql_timestamp" />,
				<cfqueryparam value="#arguments.dane.userid#" cfsqltype="cf_sql_integer" />
			) returning id;
		</cfquery>
		<cfreturn historiaStatusu />
	</cffunction>
	
	<cffunction name="pobierzOdwolanieDoPytania" output="false" access="public" hint="Pobranie odwołań na podstawie danych pytania.">
		<cfargument name="dane" type="struct" required="true" />
		<cfset var odwolanie = "" />
		<cfquery name="odwolanie" datasource="#variables.localDsn#">
			select * from odwolania_aos
			where 
			iddefinicjizadania = <cfqueryparam value="#arguments.dane.iddefinicjizadania#" cfsqltype="cf_sql_varchar" />
			and idaktywnosci = <cfqueryparam value="#arguments.dane.idaktywnosci#" cfsqltype="cf_sql_varchar" />
			and iddefinicjipola = <cfqueryparam value="#arguments.dane.iddefinicjipola#" cfsqltype="cf_sql_varchar" />
		</cfquery>
		<cfreturn odwolanie />
	</cffunction>
	
	<cffunction name="iloscOdwolan" output="false" access="public" hint="Zliczenie ilości odwołań">
		<cfargument name="interval" type="numeric" required="false" />
		
		<cfset var odwolania = "" />
		<cfquery name="odwolania" datasource="#variables.localDsn#">
			select 
				kodsklepu,
				count(*) as iloscodwolan 
			from odwolania_aos
			where idstatusuodwolania = 1
			<cfif IsDefined("arguments.interval")>
				and datapowstaniaaos > CURRENT_DATE - INTERVAL '#arguments.interval# months'
			</cfif>
			group by kodsklepu;
		</cfquery>
		<cfreturn odwolania />
	</cffunction>
	
	<cffunction name="iloscOdwolanPoAktywnosci" output="false" access="public" hint="Zliczenie ilości odwołań pogrupowanych po idaktywnosci">
		<cfargument name="interval" type="numeric" required="false" />
		
		<cfset var odwolania = "" />
		<cfquery name="odwolania" datasource="#variables.localDsn#">
			select idaktywnosci, count(*) as iloscodwolan 
			from odwolania_aos
			where 1=1 
			<cfif IsDefined("arguments.interval")>
				and datapowstaniaaos > CURRENT_DATE - INTERVAL '#arguments.interval# months'
			</cfif>
			group by idaktywnosci;
		</cfquery>
		<cfreturn odwolania />
	</cffunction>
	
	<cffunction name="pobierzZdjecie" output="false" access="public" hint="">
		<cfargument name="idaktywnosci" type="string" required="true" />
		<cfargument name="iddefinicjipola" type="string" required="true" />
		<cfargument name="iddefinicjizadania" type="string" required="true" />
		
		<cfset var zdjecie = "" />
		<cfquery name="zdjecie" datasource="#variables.localDsn#">
			select a.idaktywnosci, a.iddefinicjipola, a.iddefinicjizadania, c.wartosctekst as notatka, a.wartoscbinaria, a.wartosctekst 
			from eleader_tbwykonaniaaos a
			left join eleader_zdjecie_notatka b on a.iddefinicjipola = b.idzdjecia
			left join eleader_tbwykonaniaaos c on (c.iddefinicjipola = b.idnotatki and c.idaktywnosci = a.idaktywnosci)
			where a.idaktywnosci = <cfqueryparam value="#arguments.idaktywnosci#" cfsqltype="cf_sql_varchar" />
				and a.iddefinicjipola = <cfqueryparam value="#arguments.iddefinicjipola#" cfsqltype="cf_sql_varchar" />
				and a.iddefinicjizadania = <cfqueryparam value="#arguments.iddefinicjizadania#" cfsqltype="cf_sql_varchar" />
		</cfquery>
		
		<cfreturn zdjecie />
	</cffunction>
	
	<cffunction name="ostatniArkusz" output="false" access="public" hint="">
		<cfset var dataOstatniegoArkusza = "" />
		<cfquery name="dataOstatniegoArkusza" datasource="#variables.localDsn#">
			select MAX(datautworzenia) from daily_wykonaniaaos;
		</cfquery>
		<cfreturn dataOstatniegoArkusza />
	</cffunction>
	
	<!---
		METODY POBIERAJĄZE AOS DLA SPRZEDAŻY
	--->
	<cffunction name="aosSklepu" output="false" access="public" hint="">
		<cfargument name="sklep" type="string" required="false" />
		<cfargument name="aosSklepuOd" type="string" required="false" />
		<cfargument name="aosSklepuDo" type="string" required="false" />
		<cfargument name="kosEmail" type="string" required="false" />
		<cfargument name="odwolania" type="boolean" required="false" />
		<cfargument name="wersja" type="numeric" required="false" />
		
		<!--- Zmienne przechowujące wynik zapytania --->
		<cfset var sklepy = "" />
		<cfset var arkusze = "" />
		
		<!--- Zmienne z datą do filtrowania --->
		<cfset var dateFrom = "" />
		<cfset var dateTo = "" />
		
		<!--- Wyciągnięcie prawidłowej daty --->
		<cfif IsDefined("arguments.aosSklepuOd") and Len(arguments.aosSklepuOd) GT 4>
			<cfset var tmp = ListToArray(arguments.aosSklepuOd, "/") /> 
			<cfset dateFrom = CreateDate(tmp[3], tmp[2], tmp[1]) />
		</cfif>
		
		<cfif IsDefined("arguments.aosSklepuDo") and Len(arguments.aosSklepuDo) GT 4>
			<cfset var tmp = ListToArray(arguments.aosSklepuDo, "/") />
			<cfset dateTo = CreateDate(tmp[3], tmp[2], tmp[1]) />
		</cfif>
		
		<!--- Sprawdzam, czy podano ID KOSa. Jak tak to pobieram jego sklepy --->
		<cfif IsDefined("arguments.kosEmail") and Len(arguments.kosEmail) GT 0>
			<cfset sklepyKos = this.sklepyKosaIntranet(arguments.kosEmail) />
			
			<cfset var sklepyKosLista = '' />
			<cfloop query="sklepyKos">
				<cfset sklepyKosLista &= " bar.kodsklepu = '" & projekt & "' or " />
			</cfloop>
			<cfif Len(sklepyKosLista) GT 5>
				<cfset sklepyKosLista = Left(sklepyKosLista, Len(sklepyKosLista)-3) />
			</cfif>
		</cfif>
		
		<cfquery name="arkusze" datasource="#variables.localDsn#" cachedwithin="#createTimespan(0, 1, 0, 0)#">
			
			select distinct 
				a.idaktywnosci as idaktywnosci,
				MAX(bar.email) as email, 
				MAX(bar.kodsklepu) as kodsklepu, 
				MAX(bar.imiepartnera) as imiepartnera, 
				MAX(bar.nazwiskopartnera) as nazwiskopartnera, 
				MAX(bar.datautworzenia) as datautworzenia,
				MAX(case iddefinicjizadania when '00238000000000001574944' then uzyskanepunkty::text end) as "00238000000000001574944",
				MAX(case iddefinicjizadania when '00238000000000001574974' then uzyskanepunkty::text end) as "00238000000000001574974",
				MAX(case iddefinicjizadania when '00238000000000001575005' then uzyskanepunkty::text end) as "00238000000000001575005",
				MAX(case iddefinicjizadania when '00238000000000001575046' then uzyskanepunkty::text end) as "00238000000000001575046",
				<!---MAX(case iddefinicjizadania when '00238000000000000801053' then uzyskanepunkty::text end) as "00238000000000000801053",--->
				<!---MAX(case iddefinicjizadania when '00238000000000000801065' then uzyskanepunkty::text end) as "00238000000000000801065",--->
				<!---MAX(case iddefinicjizadania when '00238000000000000801081' then uzyskanepunkty::text end) as "00238000000000000801081",--->
				<!---MAX(case iddefinicjizadania when '00238000000000000801104' then uzyskanepunkty::text end) as "00238000000000000801104",--->
				MAX(case iddefinicjizadania when '00238000000000001575127' then uzyskanepunkty::text end) as "00238000000000001575127",
				<!---MAX(case iddefinicjizadania when '00238000000000000801267' then uzyskanepunkty::text end) as "00238000000000000801267",--->
				<!---MAX(case iddefinicjizadania when '00238000000000000801279' then uzyskanepunkty::text end) as "00238000000000000801279",--->
				<!---MAX(case iddefinicjizadania when '00238000000000000801053' then uzyskanepunkty::text end) as "00238000000000000801053",--->
				MAX(case iddefinicjizadania when '00238000000000001575146' then uzyskanepunkty::text end) as "00238000000000001575146",
				(select count(*) from odwolania_aos x where x.idaktywnosci = a.idaktywnosci and x.idstatusuodwolania = 1) as iloscodwolan,
				(select SUM(case _a.iddefinicjipola when '00238000000000000799597' then 

					(select MAX(sum::int) from daily_definicjezadan _d where _d.iddefinicjizadania = _a.iddefinicjizadania)-(
						
						select sum(_e.wartoscinteger) 
						from eleader_tbwykonaniaaos _e 
						inner join eleader_tbdefinicjepol _f 
							on (_e.iddefinicjipola = _f.iddefinicjipola 
								and _e.iddefinicjizadania = _f.iddefinicjizadania 
								and _e.wersja = _f.wersja) 
						where _e.iddefinicjizadania = _a.iddefinicjizadania 
							and _e.idaktywnosci = _a.idaktywnosci 
							and _e.wersja = _b.wersja
							and _f.nazwapola <> 'Ocena')+(
						
						select MAX(_g.punkty::int) 
						from eleader_tbdefinicjepol _g 
						where _g.iddefinicjipola = _a.iddefinicjipola
							and _g.iddefinicjizadania = _a.iddefinicjizadania
							and _g.wersja = _b.wersja)
					
					else _c.punkty::int
					
					end
				) 
					from odwolania_aos _a
					inner join daily_wykonaniaaos _b on (_a.idaktywnosci = _b.idaktywnosci and _a.iddefinicjizadania = _b.iddefinicjizadania)
					inner join eleader_tbdefinicjepol _c on (_a.iddefinicjipola = _c.iddefinicjipola and _a.iddefinicjizadania = _c.iddefinicjizadania and _b.wersja = _c.wersja)
					where _a.idstatusuodwolania = 2 and _a.idaktywnosci = a.idaktywnosci ) as punktyzodwolan
			from daily_wykonaniaaos a
			inner join (
				 	select distinct idaktywnosci, email, kodsklepu, imiepartnera, nazwiskopartnera, datautworzenia 
				 	from daily_wykonaniaaos) bar on a.idaktywnosci = bar.idaktywnosci
			
			where 1=1
				
				<cfif IsDefined("arguments.odwolania") and arguments.odwolania EQ 0>
					and (select count(*) from odwolania_aos x where x.idaktywnosci = a.idaktywnosci and x.idstatusuodwolania = 1) = 0
				</cfif>
				
				<cfif IsDefined("arguments.odwolania") and arguments.odwolania EQ 1>
					and (select count(*) from odwolania_aos x where x.idaktywnosci = a.idaktywnosci and x.idstatusuodwolania = 1) <> 0
				</cfif>
				
				<cfif IsDefined("sklepyKosLista") and Len(sklepyKosLista) GT 5>
					and ( #PreserveSingleQuotes(sklepyKosLista)# )
				</cfif>
				
				<cfif IsDefined("arguments.sklep") and Len(arguments.sklep) GT 5>
					and bar.kodsklepu = <cfqueryparam value="#arguments.sklep#" cfsqltype="cf_sql_varchar" />
				</cfif>
				
				<cfif IsDefined("dateFrom") and Len(dateFrom) GT 6>
					and bar.datautworzenia > <cfqueryparam value="#dateFrom#" cfsqltype="cf_sql_date" /> 
				</cfif>
				
				<cfif IsDefined("dateTo") and Len(dateTo) GT 6>
					and bar.datautworzenia < <cfqueryparam value="#dateTo#" cfsqltype="cf_sql_date" />
				</cfif>
				
				<cfif isDefined("arguments.wersja")>
					and a.wersja = <cfqueryparam value="#arguments.wersja#" cfsqltype="cf_sql_integer" />
				<cfelse>
					and a.wersja >= <cfqueryparam value="#pobierzMaxWersjaZadan()#" cfsqltype="cf_sql_integer" />
				</cfif>
				
			group by a.idaktywnosci
			order by datautworzenia desc;
			
		</cfquery>
		
		<cfreturn arkusze />
	</cffunction>
	
	<cffunction name="pobierzOstatniaKontroleNaSklepie" output="false" access="public" hint="">
		<cfargument name="sklep" type="string" default="%" required="false" />
		<cfargument name="email" type="string" default="%" required="false" />
		<cfargument name="kos" type="string" required="false" />
		<cfargument name="interval" type="numeric" required="false" />
		
		<cfif IsDefined("arguments.kos")>
			<cfset var sklepyKos = this.sklepyKosaIntranet(LCase(arguments.kos)) />
			<cfset var sklepyKosLista = '' />
			<cfloop query="sklepyKos">
				<cfset sklepyKosLista &= " bar.kodsklepu = '" & projekt & "' or " />
			</cfloop>
			<cfif Len(sklepyKosLista) GT 5>
				<cfset sklepyKosLista = Left(sklepyKosLista, Len(sklepyKosLista)-3) />
			</cfif>
		</cfif>
		
		<cfset var ostatniaKontrola = "" />
		<cfquery name="ostatniaKontrola" datasource="#variables.localDsn#">
			
			select distinct 
				MAX(a.idaktywnosci) as tmp, 
				MAX(a.idaktywnosci) as idaktywnosci,
				MAX(bar.wersja) as wersja,
				MAX(bar.email) as email, 
				bar.kodsklepu as kodsklepu, 
				MAX(bar.imiepartnera) as imiepartnera, 
				MAX(bar.nazwiskopartnera) as nazwiskopartnera, 
				MAX(bar.datautworzenia) as datautworzenia,
				MAX(foo.douzyskania) as douzyskania,
				MAX(case iddefinicjizadania when '00238000000000001574944' then uzyskanepunkty::text end) as "00238000000000001574944",
				MAX(case iddefinicjizadania when '00238000000000001574974' then uzyskanepunkty::text end) as "00238000000000001574974",
				MAX(case iddefinicjizadania when '00238000000000001575005' then uzyskanepunkty::text end) as "00238000000000001575005",
				MAX(case iddefinicjizadania when '00238000000000001575046' then uzyskanepunkty::text end) as "00238000000000001575046",
				<!---MAX(case iddefinicjizadania when '00238000000000000801053' then uzyskanepunkty::text end) as "00238000000000000801053",--->
				<!---MAX(case iddefinicjizadania when '00238000000000000801065' then uzyskanepunkty::text end) as "00238000000000000801065",--->
				<!---MAX(case iddefinicjizadania when '00238000000000000801081' then uzyskanepunkty::text end) as "00238000000000000801081",--->
				<!---MAX(case iddefinicjizadania when '00238000000000000801104' then uzyskanepunkty::text end) as "00238000000000000801104",--->
				MAX(case iddefinicjizadania when '00238000000000001575127' then uzyskanepunkty::text end) as "00238000000000001575127",
				<!---MAX(case iddefinicjizadania when '00238000000000000801267' then uzyskanepunkty::text end) as "00238000000000000801267",--->
				<!---MAX(case iddefinicjizadania when '00238000000000000801279' then uzyskanepunkty::text end) as "00238000000000000801279",--->
				<!---MAX(case iddefinicjizadania when '00238000000000000801053' then uzyskanepunkty::text end) as "00238000000000000801053",--->
				MAX(case iddefinicjizadania when '00238000000000001575146' then uzyskanepunkty::text end) as "00238000000000001575146"
				from daily_wykonaniaaos a
				inner join (
				 	select distinct idaktywnosci, email, kodsklepu, imiepartnera, nazwiskopartnera, datautworzenia, wersja 
				 	from daily_wykonaniaaos) bar on (a.idaktywnosci = bar.idaktywnosci and a.wersja = bar.wersja)
				inner join (
				 	select SUM(sum) as douzyskania, wersja 
				 	from daily_definicjezadan group by wersja
				 	) foo on a.wersja = foo.wersja
				 	
				where bar.kodsklepu like <cfqueryparam value="#arguments.sklep#" cfsqltype="cf_sql_varchar" />
					and bar.email like <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar" />
				 
			 	<cfif IsDefined("sklepyKosLista") and Len(sklepyKosLista) GT 0>
					and ( #PreserveSingleQuotes(sklepyKosLista)# )
				<cfelse>
					and (1=0)
				</cfif>
				 
				group by bar.kodsklepu 			
				order by MAX(bar.datautworzenia) desc;
			
		</cfquery>
		
		<cfreturn ostatniaKontrola />
	</cffunction>
	
	<cffunction name="akceptacjaOdwolania" output="false" access="public" hint="">
		<cfargument name="id" type="numeric" required="true" />
		<cfargument name="userid" type="numeric" required="true" />
		<cfargument name="uzasadnienie" type="string" required="false" default="" />
		
		<cfset var odwolanie = "" />
		<cfquery name="odwolanie" datasource="#variables.localDsn#">
			update odwolania_aos set idstatusuodwolania = 2, uzasadnienie = <cfqueryparam value="#arguments.uzasadnienie#" cfsqltype="cf_sql_varchar" />
			where id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />;
			
			insert into historia_odwolan_aos (idstatusuodwolania, idodwolania, datazmiany, userid)
			values (
				<cfqueryparam value="2" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp" />,
				<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" /> 
			);
		</cfquery>
		<cfreturn true />
	</cffunction>
	
	<cffunction name="odrzucenieOdwolania" output="false" access="public" hint="">
		<cfargument name="id" type="numeric" required="true" />
		<cfargument name="userid" type="numeric" required="true" />
		<cfargument name="uzasadnienie" type="string" required="false" default="" />
		
		<cfset var odwolanie = "" />
		<cfquery name="odwolanie" datasource="#variables.localDsn#">
			update odwolania_aos set idstatusuodwolania = 3, uzasadnienie = <cfqueryparam value="#arguments.uzasadnienie#" cfsqltype="cf_sql_varchar" />
			where id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />;
			
			insert into historia_odwolan_aos (idstatusuodwolania, idodwolania, datazmiany, userid)
			values (
				<cfqueryparam value="3" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp" />,
				<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" /> 
			);
		</cfquery>
		<cfreturn true />
	</cffunction>
	
	<cffunction name="arkuszeSklepuV2" output="false" access="public" hint="">
		<cfargument name="numerSklepu" type="string" required="false" />
		<cfargument name="odwolania" type="numeric" required="false" />
		<cfargument name="kosEmail" type="string" required="false" />
		<cfargument name="aosSklepuOd" type="string" required="false" /> 
		<cfargument name="aosSklepuDo" type="string" required="false" />
		
		<cfset var arkusze = "" />
		<cfquery name="arkusze" datasource="#variables.localDsn#">
			select a.kodsklepu, a.imiepartnera, a.nazwiskopartnera, a.idaktywnosci, a.poczatekaktywnosci,
			(select count(*) from odwolania_aos x where x.idaktywnosci = a.idaktywnosci and x.idstatusuodwolania = 1) as iloscodwolan
			from eleader_tbwykonaniaaos a
			where 1=1
			
			<cfif isDefined("arguments.numerSklepu") and Len(arguments.numerSklepu) GT 0>
				and a.kodsklepu = <cfqueryparam value="#arguments.numerSklepu#" cfsqltype="cf_sql_varchar" />
			</cfif>
			group by a.kodsklepu, a.imiepartnera, a.nazwiskopartnera, a.idaktywnosci, a.poczatekaktywnosci
			order by a.poczatekaktywnosci desc
		</cfquery>
		
		<cfreturn arkusze />
	</cffunction>
	
	<cffunction name="zgadnieniaArkuszaV2" output="false" access="public" hint="">
		<cfargument name="idaktywnosci" type="string" required="true" />
		
		<cfset var zagadnienia = "" />
		<cfquery name="zagadnienia" datasource="#variables.localDsn#">
			select *,
				(
					select sum(wartoscinteger) 
					from eleader_tbwykonaniaaos b 
					where (b.wartoscpola = 'Tak') 
						and b.idaktywnosci = <cfqueryparam value="#arguments.idaktywnosci#" cfsqltype="cf_sql_varchar" /> 
						and b.iddefinicjizadania = a.iddefinicjizadania 
				) as uzyskane,
				(
					select sum( NULLIF(d.punkty, '')::int )
					from eleader_tbdefinicjepol d 
					where d.iddefinicjizadania = a.iddefinicjizadania
					and d.wersja = a.wersja
					and d.aktywne = 1
				) as douzyskania 
				
			from eleader_tbdefinicjezadan a
				where a.wersja = (select wersja from eleader_tbwykonaniaaos 
					where idaktywnosci = <cfqueryparam value="#arguments.idaktywnosci#" cfsqltype="cf_sql_varchar" />
					limit 1
				);
		</cfquery>
		<cfreturn zagadnienia />
	</cffunction>
	
	<cffunction name="odpowiedziZagadnieniaV2" output="false" access="public" hint="">
		<cfargument name="idaktywnosci" type="string" required="true" />
		<cfargument name="idzadania" type="string" required="true" />
		
		<cfset var odpowiedzi = "" />
		<cfquery name="odpowiedzi" datasource="#variables.localDsn#">
			select *,
			(select c.nazwastatusu from odwolania_aos b inner join statusy_odwolan_aos c on b.idstatusuodwolania = c.id where b.idaktywnosci = a.idaktywnosci and b.iddefinicjipola = a.iddefinicjipola and b.iddefinicjizadania = a.iddefinicjizadania) as statusodwolania
			from eleader_tbwykonaniaaos a
			inner join eleader_tbdefinicjepol b on (a.iddefinicjipola = b.iddefinicjipola and a.wersja = b.wersja)
			where a.idaktywnosci = <cfqueryparam value="#arguments.idaktywnosci#" cfsqltype="cf_sql_varchar" />
			and a.iddefinicjizadania = <cfqueryparam value="#arguments.idzadania#" cfsqltype="cf_sql_varchar" />
		</cfquery>
		<cfreturn odpowiedzi />
	</cffunction>
	
</cfcomponent>