<cfcomponent 
	displayname="exchange"
	output="false" 
	hint="Komponent realizujący połączenie z serwerem Exchange i 
			prostymi operacjami na poczcie i kalendarzach">
			
	<cfproperty
		name="exchangeServer"
		type="string" />
	
	<cfproperty
		name="exchangeConnectionName"
		type="string" />
	
	<cfset This.exchangeServer = "10.99.9.1" />
	<cfset This.exchangeConnectionName = "mc" />
	
	<!---<cfset variables.instance = {
		exchangeServer = "10.99.9.1",
		exchangeConnectionName = "mc"
	} />--->
	
	<cffunction
		name="init"
		output="false" >
		
		<!---<cfset This.exchangeServer = "10.99.9.1" />--->
		<!---<cfset This.exchangeConnectionName = "mc" />--->
	
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
			username="admin"
			password="B1cko4s95pCGu"
			formbasedauthentication="true"
			formBasedAuthenticationURL="https://poczta.monkey.xyz/owa/auth/logon.aspx?replaceCurrent=1&url=https%3a%2f%2fpoczta.monkey.xyz%2fowa%2f" >
			
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