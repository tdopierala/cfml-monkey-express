<cfoutput>

	<cfloop query="emails">
	
		<cfif userid eq 38>
		
			<cfcontinue />
			
		</cfif>
		
		<cftry>
		
		<cfmail 
			to="#email#"
			from="Monkey<intranet@monkey.xyz>"
			replyto="intranet@monkey.xyz"
			bcc="intranet@monkey.xyz"
			subject="Obieg dokumentów"
			type="html"> 
	        
		<cfif FileExists(ExpandPath("images")&"/logo.png")>
			<cfset myImage = ImageRead(ExpandPath("images")&"/logo.png") /> 
			<cfset ImageWriteBase64(myImage, "ram:///Base64.txt", "png", "yes") />
			<cffile action = "read" file = "ram:///Base64.txt" variable = "Message" />
			<img src="#Message#" />
		</cfif>
		
		<h2>Obieg dokumentów</h2>
		
		Witaj #givenname# #sn#,<br/>
		<cfif workflows eq 1>
		
		W #linkTo(text="Intranecie",href="http://intranet.monkey.xyz")# znajduje się <b>#workflows# dokument</b> w obiegu przypisany do Twojego konta.
		
		<cfelse>
		
		W #linkTo(text="Intranecie",href="http://intranet.monkey.xyz")# znajdują się <b>#workflows# dokumenty</b> w obiegu przypisane do Twojego konta.
		
		</cfif>
		
		<br/><br/>
		Aby przejść do obiegu dokumentów proszę wejść na stronę #linkTo(text="http://intranet.monkey.xyz",href="http://intranet.monkey.xyz")#. Dane do logowania to <b>Twój login i hasło jak do komputera</b>.
		<br/>
		Po zalogowaniu proszę wybrać opcję <b>mój profil / Moje aktywne dokumenty (ikonka)</b>.
		<br/><br/>
		Wiadomość wysłana #DateFormat(Now(), "dd/mm/yyyy")# o godzinie #TimeFormat(Now(), "HH:mm")# na adres #email#.
		
		<br/><br/>
		Pozdrawiamy,<br/>
		Monkey Group
	
		</cfmail>
		
		<cfcatch type="any" >
			
			<cfmail 
					to="admin@monkey.xyz"
					from="BŁĄD - Monkey<intranet@monkey.xyz>"
					replyto="intranet@monkey.xyz"
					subject="Nie można wysłać powiadomienia z obiegu dokumentów"
					type="html"> 

					<cfdump var="#arguments#" />
					<cfdump var="#email#" />

				</cfmail>
			
		</cfcatch> 
		
		</cftry>
		
	</cfloop>

</cfoutput>