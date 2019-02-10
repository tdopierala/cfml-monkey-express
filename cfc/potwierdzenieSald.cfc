<cfcomponent displayName="potwierdzenieSald" output="false" hint="">
	
	<cfproperty name="dsn" type="string" default="WIN_APP" />
	<cfproperty name="dsnIntranet" type="string" default="intranet" />
	
	<!--- PSEUDO-CONSTRUCTOR --->
	<cfscript>
		variables = {
			dsn = "WIN_APP",
			dsnIntranet = "intranet"
		};
	</cfscript>
	
	<cffunction name="init" output="false" access="public" hint="">
		<cfargument name="dsn" type="string" required="false" />
		<cfargument name="dsnIntranet" type="string" required="false" />
		
		<cfscript>
			setDsn(arguments.dsn);
			setDsnIntranet(arguments.dsnIntranet);
		</cfscript>
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setDsn" output="false" access="public" hint="">
		<cfargument name="dsn" type="string" required="true" />
		<cfset variables.dsn = arguments.dsn />
	</cffunction>
	
	<cffunction name="setDsnIntranet" output="false" access="public" hint="">
		<cfargument name="dsn" type="string" required="true" />
		<cfset variables.dsnIntranet = arguments.dsn />
	</cffunction>
	
	<cffunction name="getDsn" output="false" access="public" hint="" returntype="string">
		<cfreturn variables.dsn />
	</cffunction>
	
	<cffunction name="getDsnIntranet" output="false" access="public" hint="" returntype="string">
		<cfreturn variables.dsnIntranet />
	</cffunction>
	
	<cffunction name="pobierzSaldaZBazy" output="false" access="public" hint="" returntype="Query">
		<cfargument name="limit" type="numeric" required="false" />
		
		<cfset var salda = "" />
		<cfquery name="salda" datasource="#variables.dsn#">
			select top 1000 Logo, Projekt, Symroz, DStart, NaDzien, Nasza_Kwota, Wasza_Kwota, Nasza_Suma, Wasza_Suma, Nasze_Saldo, Wasze_Saldo, Import
			from PotwierdzenieSald 
			where Import = 0; 
		</cfquery>
		<cfreturn salda />
	</cffunction> 
	
	
</cfcomponent>