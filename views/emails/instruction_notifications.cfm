<cfoutput>
	
	<cfloop query="arguments.user" >
	
		<cftry>
		
			<cfmail 
				to="#mail#"
				from="Monkey<intranet@monkey.xyz>"
				replyto="intranet@monkey.xyz"
				bcc="intranet@monkey.xyz"
				subject="Wewnętrzne akty prawne"
				type="html"> 
	      
	    
			    <html>
				<head>
					<title>WEWNĘTRZNE AKTY PRAWNE - Monkey</title>
					<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
			
					<style type="text/css"> 
						body { background: transparent url("../images/page.png"); font: normal 12px "Lucida Sans Unicode", sans-serif; color: ##444; }
						a { color: ##3B5998; text-decoration: none; } 
						.clear { float: none; clear: both; }

						dl { margin: 0; }
						dl dt { background: ##d7d7d7; color: ##000; font-weight: normal; float: left; padding: 5px; width: 150px; clear: both; margin: 0 10px 0 0; }
						dl dd { float: left; padding: 5px 0; margin: 0 0 1px 10px; }
						dl .header { font-weight: bold; }
					</style>
			
				</head>
		
				<body>
		
					Witaj #sn# #givenname#,<br />
			
					W systemie Intranet pojawił się nowy dokument w Wewnętrznych Aktach Prawnych. Aby się z nim zapoznać, przejdź na adres http://intranet.monkey.xyz lub skorzystaj z poniższego odnośnika (dla zalogowanych).

					<br />
					<br />
					
					<a href="http://intranet.monkey.xyz/intranet/index.cfm?controller=instructions&action=preview&key=#arguments.instruction.id#">#arguments.instruction.instruction_number#</a>
					
					<div class="clear"></div>
			
					<br /><br />
					W razie pytań odnośnie Intranetu prosimy o kontakt pod adresem intranet@monkey.xyz.
					<br /><br />
			
					Pozdrawiamy,<br />
					Monkey Group
		
				</body>
				</html>

			</cfmail>
	
			<cfcatch type="any" >
			
				<cfmail 
					to="admin@monkey.xyz"
					from="BŁĄD - Monkey<intranet@monkey.xyz>"
					replyto="intranet@monkey.xyz"
					subject="Nie można wysłać powiadomienia o nowym akcie prawnym"
					type="html"> 
	
					<cfdump var="#CFCATCH#" />
					<cfdump var="#arguments#" />
					<cfdump var="#mail#" />

				</cfmail>
			
			</cfcatch>
		
		</cftry>

	</cfloop>

</cfoutput>