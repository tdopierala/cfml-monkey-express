<cfcomponent displayname="Store_audio" output="false" hint="" extends="Model">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("store_audio") />
		<cfset setPrimaryKey("idStoreAudio") />
	</cffunction>
	
	<cffunction name="pobierzListe" output="false" access="public" hint="" returntype="query">
		<cfset var lista = "" />
		<cfquery name="lista" datasource="#get('loc').datasource.intranet#">
			select * from store_audio
		</cfquery>
		<cfreturn lista />
	</cffunction>
	
	<cffunction name="importujDane" output="false" access="public" hint="">
		<cfargument name="dane" type="query" required="true" />
		
		<cfset var szukaj = "" />
		<cfset var wstaw = "" />
		<cfset var aktualizuj = "" />
		<cfset sklepy = 0 />
		
		<cfloop query="arguments.dane">
			<cfquery name="szukaj" datasource="#get('loc').datasource.intranet#">
				select idStoreAudio, mpk, login, loginMobilny, haslo from store_audio
				where mpk = <cfqueryparam value="#Trim(MPK)#" cfsqltype="cf_sql_varchar" />
			</cfquery>
			
			<cfif szukaj.recordCount eq 1>
				<cfquery name="aktualizuj" datasource="#get('loc').datasource.intranet#">
					update store_audio set
						mpk = <cfqueryparam value="#arguments.dane['MPK'][arguments.dane.currentRow]#" cfsqltype="cf_sql_varchar" />,
						login = <cfqueryparam value="#arguments.dane['LOGIN'][arguments.dane.currentRow]#" cfsqltype="cf_sql_varchar" />,
						loginMobilny = <cfqueryparam value="#arguments.dane['LOGIN - MOBILNY'][arguments.dane.currentRow]#" cfsqltype="cf_sql_varchar" />,
						haslo = <cfqueryparam value="#arguments.dane['HASŁO'][arguments.dane.currentRow]#" cfsqltype="cf_sql_varchar" />
					where idStoreAudio = <cfqueryparam value="#szukaj.idStoreAudio#" cfsqltype="cf_sql_integer" />
				</cfquery>
			<cfelse>
				<cfquery name="wstaw" datasource="#get('loc').datasource.intranet#">
					insert into store_audio (mpk, login, loginMobilny, haslo) values (
						<cfqueryparam value="#arguments.dane['MPK'][arguments.dane.currentRow]#" cfsqltype="cf_sql_varchar" />,
						<cfqueryparam value="#arguments.dane['LOGIN'][arguments.dane.currentRow]#" cfsqltype="cf_sql_varchar" />,
						<cfqueryparam value="#arguments.dane['LOGIN - MOBILNY'][arguments.dane.currentRow]#" cfsqltype="cf_sql_varchar" />,
						<cfqueryparam value="#arguments.dane['HASŁO'][arguments.dane.currentRow]#" cfsqltype="cf_sql_varchar" />
						
					);
				</cfquery>
			</cfif>
			<cfset sklepy++ />
		</cfloop>
		
		<cfreturn sklepy />
	</cffunction>
	
	<cffunction name="pobierzAudioSklepu" output="false" access="public" hint="">
		<cfargument name="sklep" type="string" required="true" />
		
		<cfset var audio = "" />
		<cfquery name="audio" datasource="#get('loc').datasource.intranet#" cachedwithin="#createTimespan(0, 1, 0, 0)#">
			select mpk, login, loginMobilny, haslo 
			from store_audio
			where mpk = <cfqueryparam value="#arguments.sklep#" cfsqltype="cf_sql_varchar" />
		</cfquery>
		
		<cfreturn audio />
	</cffunction>
</cfcomponent>