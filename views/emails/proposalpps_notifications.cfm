<cfoutput>
	
	<cfloop query="arguments.user" >
	
		<cftry>
		
			<cfmail 
				to="#mail#"
				from="Monkey<intranet@monkey.xyz>"
				replyto="intranet@monkey.xyz"
				bcc="intranet@monkey.xyz"
				subject="Powiadomienie o nowych indeksach"
				type="html"> 
				
				<html>
				<head>
					<title>NOWY WNIOSEK - Monkey</title>
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
					
					#arguments.message#
					
					<br />
					<br />
					
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
					to="intranet@monkey.xyz"
					from="BŁĄD - Monkey<intranet@monkey.xyz>"
					replyto="intranet@monkey.xyz"
					subject="Nie można wysłać powiadomienia o nowym indeksie"
					type="html"> 
					
					<cfdump var="#cfcatch#" />
					<cfdump var="#arguments#" />
					<cfdump var="#session#" />
					
				</cfmail>
			
			</cfcatch>
		
		</cftry>
		
	</cfloop>
		
</cfoutput>