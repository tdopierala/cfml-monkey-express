	<cfmail 
		to="admin@monkey.xyz,webmaster@monkey.xyz"
		from="BŁĄD - Monkey<intranet@monkey.xyz>"
		replyto="intranet@monkey.xyz"
		subject="Błąd systemu"
		type="html"> 
		
		<cfif IsDefined("cfcatch")>
			<cfdump var="#cfcatch#" />
		</cfif>	

		<cfif IsDefined("error")>
			<cfdump var="#error#" />
		</cfif>
		<cfdump var="#session.user#" showUDFs="false" />
		<cfdump var="#Request#" />
		<cfdump var="#url#" />
	
	</cfmail>