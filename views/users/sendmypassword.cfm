	<cfmail
		to="#user.mail#"
		from="Pomoc Monkey Express <pomoc@monkey.xyz>"
		replyto="pomoc@monkey.xyz"
		subject="Hasło do systemu Intranet"
		type="html">
				
			<html>
				<head>
					<title>Pomoc Monkey Express</title>
					<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
			
					<style type="text/css"> 
						body { background: transparent url("../images/page.png"); font: normal 12px "Lucida Sans Unicode", sans-serif; color: ##444; }
						a { color: ##3B5998; text-decoration: none; }
						.clear { float: none; clear: both; }
						h2 { font-size: 14px; }
					</style>
			
				</head>
		
				<body>
					<p>Witaj <cfoutput>#user.givenname# #user.sn#</cfoutput><br />
					
					poniżej znajduje się hasło do logowania w systemie intranet<br/><br/>
					
					<strong><cfoutput>#Decrypt(user.password, get('loc').intranet.securitysalt)#</cfoutput></strong>
					
					<br/><br/>
					Aby zalogować się do systemu proszę wejść na stronę <cfoutput>#linkTo(text="http://intranet.monkey.xyz",href="http://intranet.monkey.xyz")#</cfoutput>..
					
					<br/><br/>
					Wiadomość wysłana <cfoutput>#DateFormat(Now(), "dd-mm-yyyy")#</cfoutput> o godzinie <cfoutput>#TimeFormat(Now(), "HH:mm")#</cfoutput> na adres <cfoutput>#user.mail#</cfoutput>.
					
					<br/><br/>
					Pozdrawiamy,<br/>
					Monkey Group
				</body>
			<html>
	</cfmail>