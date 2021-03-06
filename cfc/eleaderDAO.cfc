<cfcomponent displayname="eleaderDAO" output="false">
	<!--- PROPERTIES --->
	<cfproperty name="localDsn" type="string" default="" />
	<cfproperty name="remoteDsn" type="string" default="" />
	<cfproperty name="intranetDsn" type="string" default="" />
	
	<!--- PSEUDO-CONSTRUCTOR --->
	<cfscript>
		variables = {
			localDsn = "eleader_intranet",
			remoteDsn = "eleader",
			intranetDsn = "intranet"
		};
	</cfscript>
	
	<!--- PRIVATE --->
	<cffunction name="czyIstniejeZadanie" output="false" access="private" hint="">
		<cfargument name="id" type="string" required="true" />
		
		<cfset var zadanie = "" />
		<cfquery name="zadanie" datasource="#variables.localDsn#">
			select 
				IDDefinicjiZadania
			from eleader_tbdefinicjezadan
			where IDDefinicjiZadania = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar" />
		</cfquery>
		
		<cfreturn zadanie.RecordCount />
	</cffunction>
	
	<cffunction name="czyIstniejePole" output="false" access="private" hint="">
		<cfargument name="idPola" type="string" required="true" />
		<cfargument name="idZadania" type="string" required="true" />
		
		<cfset var pole = "" />
		<cfquery name="pole" datasource="#variables.localDsn#">
			select 
				IDDefinicjiZadania
				,IDDefinicjiPola
			from eleader_tbdefinicjepol
			where IDDefinicjiPola = <cfqueryparam value="#arguments.idPola#" cfsqltype="cf_sql_varchar" />
				and IDDefinicjiZadania = <cfqueryparam value="#arguments.idZadania#" cfsqltype="cf_sql_varchar" />
		</cfquery>
		
		<cfreturn pole.RecordCount /> 
	</cffunction>
	
	<!--- PUBLIC --->
	
	<cffunction name="init" output="false" access="public" hint="">
		<cfargument name="localDsn" type="string" required="true" />
		<cfargument name="remoteDsn" type="string" required="true" />
		
		<cfset variables.localDsn = arguments.localDsn />
		<cfset variables.remoteDsn = arguments.remoteDsn />
		
		<cfreturn this />
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
			from tbDefinicjePol
		</cfquery>
		
		<cfreturn pola />
	</cffunction>
	
	<cffunction name="pobierzWykonanieAosZEleader" output="false" access="public">
		<cfset var wykonaneAos = "" />
		
		<cfquery name="wykonaneAos" datasource="#variables.remoteDsn#">
			select
				top 120
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
			from tbWykonaniaAOS
			where Zaimportowane = 0;
		</cfquery>
		
		<cfreturn wykonaneAos />
	</cffunction>
	
	<!--- METODY INTRANET --->
		
	<cffunction name="aktualizujDefinicjeZadan" output="false" access="public">

		<cfargument name="zadania" type="query" required="true" />
		
		<cfset var noweZadanie = "" />
		<cfset var aktualizacjaZadania = "" />
		
		<cfloop query="arguments.zadania">
			<!--- Przechodzę przez wszystkie zadania i aktualizuje je w lokalnej bazie --->
			
			<!--- Jeżeli zadanie jest już zdefiniowane to aktualizuje je --->
			<cfif czyIstniejeZadanie(IDDefinicjiZadania) GT 0>
			
				<cfquery name="aktualizacjaZadania" datasource="#variables.localDsn#">
					update eleader_tbdefinicjezadan set
						nazwazadania = <cfqueryparam value="#NazwaZadania#" cfsqltype="cf_sql_varchar" />,
						datautworzenia = <cfqueryparam value="#DataUtworzenia#" cfsqltype="cf_sql_timestamp" />,
						datamodyfikacji = <cfqueryparam value="#DataModyfikacji#" cfsqltype="cf_sql_timestamp" />
					where iddefinicjizadania = <cfqueryparam value="#IDDefinicjiZadania#" cfsqltype="cf_sql_varchar" />;
				</cfquery>
			
			<!--- Jeżeli zadanie nie jest zdefiniowane to dodaje nowe --->
			<cfelse>
				
				<cfquery name="noweZadanie" datasource="#variables.localDsn#">
					insert into eleader_tbdefinicjezadan 
						(iddefinicjizadania, nazwazadania, datautworzenia, datamodyfikacji)
					values (
						<cfqueryparam value="#IDDefinicjiZadania#" cfsqltype="cf_sql_varchar" />,
						<cfqueryparam value="#NazwaZadania#" cfsqltype="cf_sql_varchar" />,
						<cfqueryparam value="#DataUtworzenia#" cfsqltype="cf_sql_timestamp" />,
						<cfqueryparam value="#DataModyfikacji#" cfsqltype="cf_sql_timestamp" />
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
			<cfif czyIstniejePole(IDDefinicjiPola, IDDefinicjiZadania) GT 0>
				
				<cfquery name="aktualizujPole" datasource="#variables.localDsn#">
					update eleader_tbdefinicjepol set
						nazwapola = <cfqueryparam value="#NazwaPola#" cfsqltype="cf_sql_varchar" />,
						kodpola = <cfqueryparam value="#KodPola#" cfsqltype="cf_sql_varchar" />,
						punkty = <cfqueryparam value="#Punkty#" cfsqltype="cf_sql_varchar" />,
						datautworzenia = <cfqueryparam value="#DataUtworzenia#" cfsqltype="cf_sql_timestamp" />,
						datamodyfikacji = <cfqueryparam value="#DataModyfikacji#" cfsqltype="cf_sql_timestamp" />
					where iddefinicjipola = <cfqueryparam value="#IDDefinicjiPola#" cfsqltype="cf_sql_varchar" />
						and iddefinicjizadania = <cfqueryparam value="#IDDefinicjiZadania#" cfsqltype="cf_sql_varchar" />
				</cfquery>
				
			<!--- Jeżeli nie ma definicji pola to dodaje ją --->
			<cfelse>
				
				<cfquery name="nowePole" datasource="#variables.localDsn#">
					insert into eleader_tbdefinicjepol 
						(iddefinicjipola, iddefinicjizadania ,nazwapola ,kodpola, punkty, datautworzenia, datamodyfikacji)
					values (
						<cfqueryparam value="#IDDefinicjiPola#" cfsqltype="cf_sql_varchar" />,
						<cfqueryparam value="#IDDefinicjiZadania#" cfsqltype="cf_sql_varchar" />,
						<cfqueryparam value="#NazwaPola#" cfsqltype="cf_sql_varchar" />,
						<cfqueryparam value="#KodPola#" cfsqltype="cf_sql_varchar" />,
						<cfqueryparam value="#Punkty#" cfsqltype="cf_sql_varchar" />,
						<cfqueryparam value="#DataUtworzenia#" cfsqltype="cf_sql_timestamp" />,
						<cfqueryparam value="#DataModyfikacji#" cfsqltype="cf_sql_timestamp" />
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
					datautworzenia)
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
						<cfqueryparam value="#DataUtworzenia#" cfsqltype="cf_sql_timestamp" />
					<cfelse>
						(null:timestamp)
					</cfif>
					
					
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
	
	<!--- METODY AOS INTRANET --->
	<cffunction name="listaSklepowZAos" output="false" access="public" hint="Pobiera listę sklepów ze wszystkich wypełnionych AOS.">
		<cfset var listaSklepow = "" />
		<cfquery name="listaSklepow" datasource="#variables.localDsn#">
			select
				a.kodsklepu, a.miasto, a.ulica
			from eleader_tbwykonaniaaos a
			group by a.kodsklepu, a.miasto, a.ulica
			order by a.kodsklepu asc;
		</cfquery>
 	</cffunction>
	
	<cffunction name="pobierzPogrupowanaListeAos" output="false" access="public" hint="">
		<cfset var pogrupowanaLista = "" />
		<cfset var listaSklepow = "" />
		<cfset var wynikiZAos = "" />
		<cfquery name="pogrupowanaLista" datasource="#variables.localDsn#">
			select 
				a.kodsklepu,
				a.miasto,
				a.ulica
			from eleader_tbwykonaniaaos a
			group by 
				kodsklepu,
				miasto,
				ulica
			order by kodsklepu asc;
		</cfquery>
		
		<cfquery name="listaSklepow" datasource="#variables.intranetDsn#">
			select 
				a.projekt, 
				a.partnerid, 
				a.is_active, 
				a.dataobowiazywaniaod,
				a.nazwaajenta,
				b.givenname,
				b.sn
			from store_stores a
			left join users b on a.partnerid = b.id 
			where is_active = 1
		</cfquery>
		
		<cfquery name="wynikiZAos" dbtype="query">
			select
				projekt, 
				partnerid, 
				is_active, 
				dataobowiazywaniaod,
				nazwaajenta,
				givenname,
				sn,
				kodsklepu,
				miasto,
				ulica
			from pogrupowanaLista, listaSklepow
			where pogrupowanaLista.kodsklepu = listaSklepow.projekt
		</cfquery>

		<cfreturn wynikiZAos />
	</cffunction>
	
	<cffunction name="pobierzListeAosDlaSklepu" output="false" access="public" hint="">
		<cfargument name="sklep" type="string" required="true" />
		
		<cfset var listaAos = "" />
		<cfset var listaAosZadaniami = "" />
		<cfquery name="listaAos" datasource="#variables.localDsn#">
			select
				a.idaktywnosci,
				a.kodsklepu,
				a.imiepartnera,
				a.nazwiskopartnera,
				date_trunc('minute', a.poczatekaktywnosci + interval '30 second'),
				a.email
			from eleader_tbwykonaniaaos a
			where a.kodsklepu = <cfqueryparam value="#arguments.sklep#" cfsqltype="cf_sql_varchar" />
			group by 
				a.idaktywnosci, 
				a.kodsklepu, 
				a.imiepartnera, 
				a.nazwiskopartnera, 
				date_trunc('minute', a.poczatekaktywnosci + interval '30 second'), 
				a.email
			order by date_trunc('minute', a.poczatekaktywnosci + interval '30 second') desc
		</cfquery>
		
		<cfreturn listaAos />
	</cffunction>
	
	<cffunction name="pobierzListeAosDlaSklepuZadaniami" output="false" access="public" hint="">
		<cfargument name="kodsklepu" type="string" required="true" />
		
		<cfset var listaAosZadaniami = "" />
		<cfquery name="listaAosZadaniami" datasource="#variables.localDsn#">
			select * from daily_wykonaniaaos where kodsklepu = <cfqueryparam value="#arguments.kodsklepu#" cfsqltype="cf_sql_varchar" />
		</cfquery>
		
		<cfreturn listaAosZadaniami />
	</cffunction>
	
	<cffunction name="pobierzListeAosDlaSklepuZadaniamiPivot" output="false" access="public" hint="">
		<cfargument name="kodsklepu" type="string" required="true" />
		
		<cfset var listaAosZadaniami = "" />
		<cfquery name="listaAosZadaniami" datasource="#variables.localDsn#">
			SET CLIENT_ENCODING TO 'UTF8';
			SET NAMES 'UTF8';
			SELECT * FROM crosstab('select idaktywnosci::text, iddefinicjizadania::text, uzyskanepunkty::text from daily_wykonaniaaos  where kodsklepu = ''#arguments.kodsklepu#'' ')
AS ct(idaktywnosci text, "00238000000000000799575" text, "00238000000000000800831" text, "00238000000000000800890" text, "00238000000000000801040" text, "00238000000000000801053" text, "00238000000000000801065" text, "00238000000000000801081" text, "00238000000000000801104" text, "00238000000000000801119" text);

		</cfquery>
		
		<cfreturn listaAosZadaniami />
	</cffunction>
	
	<cffunction name="pobierzListeZagadnien" output="false" access="public" hint="">
		<cfset var listaZagadnien = "" />
		<cfquery name="listaZagadnien" datasource="#variables.localDsn#">
			select * from daily_definicjezadan;	
		</cfquery>
		
		<cfreturn listaZagadnien />
	</cffunction>
	
	<cffunction name="pobierzListeZadanAosu" output="false" access="public" hint="">
		<cfargument name="idaktywnosci" type="string" required="true" />
		
		<cfset var listaZadan = "" />
		<cfquery name="listaZadan" datasource="#variables.localDsn#">
			select idaktywnosci, iddefinicjizadania, nazwazadania, uzyskanepunkty
			from daily_wykonaniaaos
			where idaktywnosci = <cfqueryparam value="#arguments.idaktywnosci#" cfsqltype="cf_sql_varchar" />
		</cfquery>
		
		<cfreturn listaZadan />
	</cffunction>
	
	<cffunction name="pobierzListePytan" output="false" access="public" hint="">
		<cfargument name="idaktywnosci" type="string" required="true" />
		<cfargument name="iddefinicjizadania" type="string" required="true" />
		
		<cfset var listaPytan = "" />
		<cfquery name="listaPytan" datasource="#variables.localDsn#">
			select a.idaktywnosci, a.iddefinicjizadania, a.iddefinicjipola, b.nazwapola, b.punkty, a.wartoscpola, a.wartoscbinaria, a.wartosctekst
			from eleader_tbwykonaniaaos a
			inner join eleader_tbdefinicjepol b on a.iddefinicjipola = b.iddefinicjipola and a.iddefinicjizadania = b.iddefinicjizadania 
			where a.idaktywnosci = <cfqueryparam value="#arguments.idaktywnosci#" cfsqltype="cf_sql_varchar" />
				and a.iddefinicjizadania = <cfqueryparam value="#arguments.iddefinicjizadania#" cfsqltype="cf_sql_varchar" />
				and b.nazwapola != 'Ocena';
		</cfquery>
		
		<cfreturn listaPytan />
	</cffunction>
	
	<cffunction name="pobierzZdjecie" output="false" access="public" hint="">
		<cfargument name="idaktywnosci" type="string" required="true" />
		<cfargument name="iddefinicjipola" type="string" required="true" />
		<cfargument name="iddefinicjizadania" type="string" required="true" />
		
		<cfset var zdjecie = "" />
		<cfquery name="zdjecie" datasource="#variables.localDsn#">
			select wartoscbinaria, wartosctekst from eleader_tbwykonaniaaos
			where idaktywnosci = <cfqueryparam value="#arguments.idaktywnosci#" cfsqltype="cf_sql_varchar" />
				and iddefinicjipola = <cfqueryparam value="#arguments.iddefinicjipola#" cfsqltype="cf_sql_varchar" />
				and iddefinicjizadania = <cfqueryparam value="#arguments.iddefinicjizadania#" cfsqltype="cf_sql_varchar" />
		</cfquery>
		
		<cfreturn zdjecie />
	</cffunction>
	
</cfcomponent>