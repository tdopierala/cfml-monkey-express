<cfcomponent 
	displayname="exchange"
	output="false" 
	hint="Komponent realizujący połączenie z serwerem Exchange">
			
	<cfproperty
		name="exchangeServer"
		type="string" />
	
	<cfproperty
		name="exchangeConnectionName"
		type="string" />
	
	<cfset This.exchangeServer = "" />
	<cfset This.exchangeConnectionName = "" />
		
	<cffunction
		name="init"
		output="false" >
		
		<cfreturn self />
	
	</cffunction>
	
	<cffunction
		name="connect"
		hint="Połączenie z serwerem Exchange"
		access="package" >
			
		<cftry>
			
		<cfexchangeconnection 
			action="open" 
			connection="#this.exchangeConnectionName#" 
			server="#this.exchangeServer#"
			protocol="https" 
			username=""
			password=""
			formbasedauthentication="true"
			formBasedAuthenticationURL="" >
			
		<cfcatch type="any" >
			<cfdump var="#cfcatch#" />
			<cfabort />
		</cfcatch>
		</cftry>
			
	</cffunction>
	
	<cffunction
		name="disconnect"
		hint="Zamknięcie połączenia z serwerem Exchange"
		access="package" > 
	
		<cfexchangeconnection action="close" connection="#this.exchangeConnectionName#" />
	
	</cffunction>
	
	<cffunction
		name="listMails"
		hint="Listowanie katalogu Income">
		
		<cfset this.connect() />
		
		<cfexchangemail 
			action="get" 
			name="Income" 
			connection="#this.exchangeConnecionName#"> 

		</cfexchangemail> 
		
		<cfset this.disconnect() />
		
		<cfreturn Income />
			
	</cffunction>
	
</cfcomponent>