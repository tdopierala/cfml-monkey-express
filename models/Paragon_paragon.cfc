<cfcomponent displayname="Paragon_paragon" output="false" extends="Model">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("paragon_liczba_klientow") />
	</cffunction>
	
	<cffunction name="pobierzRaport" output="false" access="public" hint="Raport z dodanych paragonów">
		<cfargument name="days" type="numeric" required="false" />
		
		<cfset var raport = "" />
		<cfquery name="raport" datasource="#get('loc').datasource.intranet#">
			select a.dataparagonu, a.iloscklientow, b.miasto, b.adres, b.nazwasklepu, c.givenname, c.sn, c.login
			from paragon_liczba_klientow a
			inner join paragon_adresy b on a.adresid = b.id
			inner join users c on a.userid = c.id
			<cfif IsDefined("arguments.days") and arguments.days GT 0>
				where a.dataparagonu >= (CURDATE() - INTERVAL #arguments.days# day)
			</cfif>
		</cfquery>
		<cfreturn raport />
	</cffunction>
</cfcomponent>