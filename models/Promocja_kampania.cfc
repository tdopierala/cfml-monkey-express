<cfcomponent displayname="Promocja_kampania" output="false" extends="Model">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("a") />
	</cffunction> 
	
	<cffunction name="pobierzKampanie" output="false" access="public" hint="" returntype="query">
		<cfargument name="elements" type="numeric" required="false" default="30" />
		<cfargument name="page" type="numeric" required="false" default="1" />
		
		<cfset var startElement = (arguments.page-1)*arguments.elements />
		<cfset var stopElement = (arguments.page)*arguments.elements />
		
		<cfset var kampanie = "" />
		<cfquery name="kampanie" datasource="#get('loc').datasource.mssql#" cachedwithin="#createTimeSpan(0, 0, 0, 0)#">
			SELECT *
			FROM (SELECT ROW_NUMBER() OVER(ORDER BY dataKampaniiOd DESC) as rownum, c.idKampani, c.nazwaKampanii, c.dataKampaniiOd, c.dataKampaniiDo, c.userId, c.dataUtworzenia, c.przewidzianyBudzet, c.czyAktywna, 
			(select count(*) from promocja_sklepyKampanii b where b.idKampanii = c.idKampani) as iloscSklepow
			FROM promocja_kampanie c
			) as Kampanie
			WHERE rownum BETWEEN <cfqueryparam value="#startElement#" cfsqltype="cf_sql_integer" /> 
				AND <cfqueryparam value="#stopElement#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfreturn kampanie />
	</cffunction>
	
	<cffunction name="pobierzDaneKampanii" output="false" access="public" hint="" returntype="query">
		<cfargument name="idKampanii" type="numeric" required="true" />
		
		<cfset var kampania = "" />
		<cfquery name="kampania" datasource="#get('loc').datasource.mssql#">
			SELECT * 
			FROM (SELECT ROW_NUMBER() OVER(ORDER BY dataKampaniiOd DESC) as rownum, * FROM promocja_kampanie) as Kampanie
			WHERE idKampani = <cfqueryparam value="#arguments.idKampanii#" cfsqltype="cf_sql_integer" />;
		</cfquery>
		
		<cfreturn kampania />
	</cffunction>
	
	<cffunction name="dodajKampanie" output="false" access="public" hint="" returntype="numeric">
		<cfargument name="dataRozpoczecia" type="string" required="false" />
		<cfargument name="dataZakonczenia" type="string" required="false" />
		<cfargument name="nazwaKampanii" type="string" required="false" />
		<cfargument name="przewidzianyBudzet" type="string" required="false" />
		<cfargument name="userId" type="numeric" required="false" />
		
		<cfset var nowaKampania = "" />
		<cfset var nowaKampaniaResult = "" />
		<cftry>
			<cfquery name="nowaKampania" result="nowaKampaniaResult" datasource="#get('loc').datasource.mssql#">
				insert into promocja_kampanie (nazwaKampanii, dataKampaniiOd, dataKampaniiDo, dataUtworzenia, userID, przewidzianyBudzet)
				values (
					<cfqueryparam value="#arguments.nazwaKampanii#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.dataRozpoczecia#" cfsqltype="cf_sql_date" />,
					<cfqueryparam value="#arguments.dataZakonczenia#" cfsqltype="cf_sql_date" />,
					<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp" />,
					<cfqueryparam value="#arguments.userId#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.przewidzianyBudzet#" cfsqltype="cf_sql_varchar" />
				);
			</cfquery>
			
			<cfcatch type="any">
				<cfset results.success = false />
				<cfset results.message = "Nie moge dodac kampanii: #cfcatch.message#" />
			</cfcatch>
		</cftry>
		
		<cfreturn nowaKampaniaResult.generatedKey />
	</cffunction>
	
	<cffunction name="dodajSklepDoKampanii" output="false" access="public" hint="" returntype="struct">
		<cfargument name="kodSklepu" type="string" required="false" />
		<cfargument name="idKampanii" type="numeric" required="false" />
		
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Dodalem sklep do kampanii" />
		
		<cfset var sklepKampanii = "" />
		
		<cftry>
		
			<cfquery name="sklepKampanii" datasource="#get('loc').datasource.mssql#">
				insert into promocja_sklepyKampanii (kodSklepu, idKampanii) values (
					<cfqueryparam value="#arguments.kodSklepu#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.idKampanii#" cfsqltype="cf_sql_integer" />
				);
			</cfquery>
			
			<cfcatch type="database">
				<cfset results.success = false />
				<cfset results.message = "Nie moge dodac sklepu do kampanii: #cfcatch.message#" />
			</cfcatch>
			
		</cftry>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="dodajTypMaterialuDoKampanii" output="false" access="public" hint="">
		<cfargument name="idKampanii" type="numeric" required="false" />
		<cfargument name="idTypuMaterialuReklamowego" type="numeric" required="false" />
		
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Dodalem typ materialu reklamowego" />
		
		<cfset var typMaterialu = "" />
		
		<cftry>
			
			<cfquery name="typMaterialu" datasource="#get('loc').datasource.mssql#">
				insert into promocja_materialyKampanii (idKampanii, idTypuMaterialuReklamowego) values (
					<cfqueryparam value="#arguments.idKampanii#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.idTypuMaterialuReklamowego#" cfsqltype="cf_sql_integer" />
				);
			</cfquery>
			
			<cfcatch tyep="database">
				
				<cfset results.success = false />
				<cfset results.message = "Nie moge dodac typu materialu reklamowego: #cfcatch.message#" />
				
			</cfcatch>
			
		</cftry>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="dodajPlikDoMaterialuKampanii" output="false" access="public" hint="" returntype="any">
		<cfargument name="idKampanii" type="numeric" required="false" />
		<cfargument name="idMaterialuKampanii" type="numeric" required="false" />
		<cfargument name="idTypuMaterialuReklamowego" type="numeric" required="false" />
		<cfargument name="srcMaterialu" type="string" required="false" />
		<cfargument name="userId" type="numeric" required="false" />
		
		<cfset var nowyPlik = "" />
		<cfset var nowyPlikResult = "" />
		<cfquery name="nowyPlik" result="nowyPlikResult" datasource="#get('loc').datasource.mssql#">
			insert into promocja_plikiMaterialowKampanii (idMaterialuKampanii, idKampanii, idTypuMaterialuReklamowego, srcMaterialu, userId)
			values (
				<cfqueryparam value="#arguments.idMaterialuKampanii#" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value="#arguments.idKampanii#" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value="#arguments.idTypuMaterialuReklamowego#" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value="#arguments.srcMaterialu#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.userId#" cfsqltype="cf_sql_integer" /> 
			);
		</cfquery>
		
		<cfreturn nowyPlikResult />
	</cffunction>
	
	<cffunction name="usunSklepZKampanii" output="false" access="public" hint="" returntype="struct">
		<cfargument name="kodSklepu" type="string" required="false" />
		<cfargument name="idKampanii" type="numeric" required="false" />
		
		<cfset var results = structNew() />
		<cfset results.success = false />
		<cfset results.message = "Usunalem #arguments.kodSklepu# z kampanii" />
		
		<cfset var sklepKampanii = "" />
		
		<cftry>
			
			<cfquery name="sklepKampanii" datasource="#get('loc').datasource.mssql#">
				delete from promocja_sklepyKampanii
				where idKampanii = <cfqueryparam value="#arguments.idKampanii#" cfsqltype="cf_sql_integer" />
				and kodSklepu = <cfqueryparam value="#arguments.kodSklepu#" cfsqltype="cf_sql_varchar" />
				;
			</cfquery>
			
			<cfcatch type="database">
				<cfset results.success = false />
				<cfset results.message = "Nie moge usunac #arguments.kodSklepu# z kampanii: #cfcatch.message#" />
			</cfcatch>
			
		</cftry>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="pobierzListeSklepowDoPrzypisania" output="false" access="public" hint="" returntype="query">
		<cfargument name="idKampanii" type="numeric" required="false" />
		
		<cfset var sklepyKampanii = "" />
		<cfset var sklepyZIntranetu = ""/ >
		<cfset var sklepyDoPrzypisania = "" />
		
		<cfquery name="sklepyKampanii" datasource="#get('loc').datasource.mssql#">
			select idSklepKampanii, kodSklepu, idKampanii from promocja_sklepyKampanii
			<cfif IsDefined("arguments.idKampanii")>
				where idKampanii = <cfqueryparam value="#arguments.idKampanii#" cfsqltype="cf_sql_integer" />
			</cfif>
			;
		</cfquery>
		
		<cfquery name="sklepyZIntranetu" datasource="#get('loc').datasource.intranet#">
			select projekt, sklep, ulica, miasto, nazwaajenta, ajent
			from store_stores
			where is_active = 1;
		</cfquery>
		
		<cfquery name="sklepyDoPrzypisania" dbtype="query">
			select * from sklepyZIntranetu
			where projekt not in (<cfqueryparam value="#valueList(sklepyKampanii.kodSklepu)#" list="true" cfsqltype="cf_sql_varchar"/>) 
		</cfquery>
		
		<cfreturn sklepyDoPrzypisania />
	</cffunction>
	
	<cffunction name="pobierzPrzypisaneSklepyDoKampanii" output="false" access="public" hint="" returntype="query">
		<cfargument name="idKampanii" type="numeric" required="false" />
		
		<cfset var sklepyKampanii = "" />
		<cfquery name="sklepyKampanii" datasource="#get('loc').datasource.mssql#">
			select idSklepKampanii, kodSklepu, idKampanii from promocja_sklepyKampanii
			where idKampanii = <cfqueryparam value="#arguments.idKampanii#" cfsqltype="cf_sql_integer" />;
		</cfquery>
		<cfreturn sklepyKampanii />
	</cffunction>
	
	<cffunction name="pobierzMaterialyKampanii" output="false" access="public" hint="" returntype="any" >
		<cfargument name="idKampanii" type="numeric" required="false" />
		
		<cfset var materialyKampanii = "" />
		<cfquery name="materialyKampanii" datasource="#get('loc').datasource.mssql#">
			select a.idKampanii, a.idMaterialuKampanii, a.idTypuMaterialuReklamowego, a.ilosc, a.cenaJednostkowa, b.nazwaMaterialuReklamowego, b.opisMaterialu, b.srcMiniaturki, b.opisMaterialu from promocja_materialyKampanii a 
			inner join promocja_typyMaterialowReklamowych b on a.idTypuMaterialuReklamowego = b.idTypuMaterialuReklamowego
			where a.idKampanii = <cfqueryparam value="#arguments.idKampanii#" cfsqltype="cf_sql_integer" />;
		</cfquery>
		
		<cfset var tablicaMaterialow = arrayNew(1) />
		<cfloop query="materialyKampanii">
			<cfset var plikiMaterialu = "" />
			<cfquery name="plikiMaterialu" datasource="#get('loc').datasource.mssql#">
				select * from promocja_plikiMaterialowKampanii where idMaterialuKampanii = <cfqueryparam value="#materialyKampanii.idMaterialuKampanii#" cfsqltype="cf_sql_integer" />;
			</cfquery>
			
			<cfset var tmp = {nazwaTypuMaterialuReklamowego = materialyKampanii.nazwaMaterialuReklamowego,
							idKampanii = arguments.idKampanii,
							idTypuMaterialuReklamowego = materialyKampanii.idTypuMaterialuReklamowego,
							idMaterialuKampanii = materialyKampanii.idMaterialuKampanii,
							srcMiniaturki = materialyKampanii.srcMiniaturki,
							ilosc = materialyKampanii.ilosc,
							cenaJednostkowa = materialyKampanii.cenaJednostkowa,
							opisMaterialu = materialyKampanii.opisMaterialu,
							plikiMaterialuReklamowego = plikiMaterialu} />
			<cfset arrayAppend(tablicaMaterialow, tmp) />
 			
		</cfloop>
		
		<cfreturn tablicaMaterialow />
	</cffunction>
	
	<cffunction name="pobierzMaterialKampanii" output="false" access="public" hint="" returntype="array">
		<cfargument name="idMaterialuKampanii" type="numeric" required="false" />
		
		<cfset var materialKampanii = "" />
		<cfquery name="materialKampanii" datasource="#get('loc').datasource.mssql#">
			select a.idKampanii, a.idMaterialuKampanii, a.idTypuMaterialuReklamowego, a.ilosc, a.cenaJednostkowa, b.nazwaMaterialuReklamowego, b.opisMaterialu, b.srcMiniaturki, b.opisMaterialu 
			from promocja_materialyKampanii a 
			inner join promocja_typyMaterialowReklamowych b on a.idTypuMaterialuReklamowego = b.idTypuMaterialuReklamowego
			where a.idMaterialuKampanii = <cfqueryparam value="#arguments.idMaterialuKampanii#" cfsqltype="cf_sql_integer" />;
		</cfquery>
		
		<cfset var tablicaMaterialow = arrayNew(1) />
		<cfloop query="materialKampanii">
			<cfset var plikiMaterialu = "" />
			<cfquery name="plikiMaterialu" datasource="#get('loc').datasource.mssql#">
				select * from promocja_plikiMaterialowKampanii where idMaterialuKampanii = <cfqueryparam value="#materialKampanii.idMaterialuKampanii#" cfsqltype="cf_sql_integer" />;
			</cfquery>
			
			<cfset var tmp = {nazwaTypuMaterialuReklamowego = materialKampanii.nazwaMaterialuReklamowego,
							idKampanii = materialKampanii.idKampanii,
							idTypuMaterialuReklamowego = materialKampanii.idTypuMaterialuReklamowego,
							idMaterialuKampanii = materialKampanii.idMaterialuKampanii,
							srcMiniaturki = materialKampanii.srcMiniaturki,
							ilosc = materialKampanii.ilosc,
							cenaJednostkowa = materialKampanii.cenaJednostkowa,
							opisMaterialu = materialKampanii.opisMaterialu,
							plikiMaterialuReklamowego = plikiMaterialu} />
			<cfset arrayAppend(tablicaMaterialow, tmp) />
		</cfloop>
		
		<cfreturn tablicaMaterialow />
	</cffunction>
	
	<cffunction name="zapiszMaterialKampanii" outut="false" access="public" hint="" returntype="any" >
		<cfargument name="idMaterialuKampanii" type="numeric" required="false" />
		<cfargument name="ilosc" type="string" required="false" />
		<cfargument name="cenaJednostkowa" type="string" required="false" />
		
		<cfset var materialKampanii = "" />
		<cfset var materialKampaniiResult = "" />
		
		<cfquery name="materialKampanii" result="materialKampaniiResult" datasource="#get('loc').datasource.mssql#">
			update promocja_materialyKampanii set ilosc = <cfqueryparam value="#arguments.ilosc#" cfsqltype="cf_sql_varchar" />,
			cenaJednostkowa = <cfqueryparam value="#arguments.cenaJednostkowa#" cfsqltype="cf_sql_varchar" />
			where idMaterialuKampanii = <cfqueryparam value="#arguments.idMaterialuKampanii#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfreturn materialKampaniiResult />
	</cffunction>
	
	<cffunction name="usunKampanieReklamowa" output="false" access="public" hint="">
		<cfargument name="idKampanii" type="numeric" required="false" />
		
		<cfset var usunKampanie = "" />
		<cfset var usunKampanieResult = "" />
		<cfquery name="usunKampanie" result="usunKampanieResult" datasource="#get('loc').datasource.mssql#">
			delete from promocja_kampanie where idKampani = <cfqueryparam value="#arguments.idKampanii#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfif directoryExists( expandPath( "files/promocja_materialy/#arguments.idKampanii#" ) ) >
			<cfset directoryDelete( expandPath( "files/promocja_materialy/#arguments.idKampanii#" ), true ) />
		</cfif>
		
		<cfreturn usunKampanieResult />
	</cffunction>
	
	<cffunction name="zmienStatusKampanii" output="false" access="public" hint="" returntype="any">
		<cfargument name="idKampanii" type="numeric" required="false" />
		
		<cfset var aktualizacja = "" />
		<cfset var aktualizacjaResult = "" />
		
		<cfquery name="aktualizacja" result="aktualizacjaResult" datasource="#get('loc').datasource.mssql#">
			update promocja_kampanie set czyAktywna = 1 - czyAktywna
			where idKampani = <cfqueryparam value="#arguments.idKampanii#" cfsqltype="cf_sql_integer" />
		</cfquery>
		<cfreturn aktualizacjaResult />
	</cffunction>
		
</cfcomponent>