<cfoutput>

<cfloop query="emails">
	
	<cfif userid eq 38>
		
		<cfcontinue />
			
	</cfif>

	<cfmail 
		to="#email#"
		from="Monkey<intranet@monkey.xyz>"
		replyto="intranet@monkey.xyz"
		subject="Wnioski do akceptacji"
		type="html"> 
        
	<cfif FileExists(ExpandPath("images")&"/logo.png")>
		<cfset myImage = ImageRead(ExpandPath("images")&"/logo.png") /> 
		<cfset ImageWriteBase64(myImage, "ram:///Base64.txt", "png", "yes") />
		<cffile action = "read" file = "ram:///Base64.txt" variable = "Message" />
		<img src="#Message#" />
	</cfif>
	
	<h2>Wnioski do akceptacji</h2>
	
	Witaj #givenname# #sn#,<br/>
	<cfif proposalscount eq 1>
	
	W #linkTo(text="Intranecie",href="http://intranet.monkey.xyz")# znajduje się <b>#proposalscount# wniosek</b>, który czeka na Twoją akceptację.
	
	<cfelse>
	
	W #linkTo(text="Intranecie",href="http://intranet.monkey.xyz")# znajdują się <b>#proposalscount# wnioski</b>, które czekają na Twoją akceptację.
	
	</cfif>
	
	<br/><br/>
	Aby przejść do akceptacji wniosków proszę wejść na stronę #linkTo(text="http://intranet.monkey.xyz",href="http://intranet.monkey.xyz")#. Dane do logowania to <b>Twój login i hasło jak do komputera</b>.
	<br/>
	Po zalogowaniu proszę wybrać opcję <b>mój profil / Wnioski do akceptacji (ikonka klawiatury)</b>.
	<br/><br/>
	Wiadomość wysłana #DateFormat(Now(), "dd/mm/yyyy")# o godzinie #TimeFormat(Now(), "HH:mm")# na adres #email#.
	
	<br/><br/>
	Pozdrawiamy,<br/>
	Monkey Group
	
	</cfmail>

</cfloop>

</cfoutput>