<cfoutput>
	
	<cfloop index="idx" from="1" to="#ArrayLen(emails)#">
		
		<cfif ArrayIsDefined(emails, idx) and not ArrayIsEmpty(emails[idx])>
			
			<!---<cfif idx neq 345>
		
				<cfcontinue />
				
			</cfif>--->
			
			<cftry>
			
			<cfmail 
				to="#users[idx].email#"
				from="Monkey<intranet@monkey.xyz>"
				replyto="intranet@monkey.xyz"
				bcc="intranet@monkey.xyz"
				subject="Powiadomienie o indeksach"
				type="html">
					
				<html>
				<head>
					<title>Powiadomienie o indeksach z dnia #DateFormat(DateAdd('d', -1, Now()),'yyyy-mm-dd')# - Monkey</title>
					<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
			
					<style type="text/css"> 
						body { background: transparent url("../images/page.png"); font: normal 12px "Lucida Sans Unicode", sans-serif; color: ##444; }
						a { color: ##3B5998; text-decoration: none; }
						.clear { float: none; clear: both; }
						h2 { font-size: 14px; }
						table { border: 1px solid ##cccccc; }
						th { text-align: left; background: ##dddddd; padding: 3px 5px; border: 1px solid ##cccccc; }
						td { padding: 3px 5px; border: 1px solid ##cccccc; }

						dl { margin: 0; }
						dl dt { background: ##d7d7d7; color: ##000; font-weight: normal; float: left; padding: 5px; width: 150px; clear: both; margin: 0 10px 0 0; }
						dl dd { float: left; padding: 5px 0; margin: 0 0 1px 10px; }
						dl .header { font-weight: bold; }
					</style>
			
				</head>
		
				<body> 
		        
					<!---<cfif FileExists(ExpandPath("images")&"/logo.png")>
						<cfset myImage = ImageRead(ExpandPath("images")&"/logo.png") /> 
						<cfset ImageWriteBase64(myImage, "ram:///Base64.txt", "png", "yes") />
						<cffile action = "read" file = "ram:///Base64.txt" variable = "Message" />
						<img src="#Message#" />
					</cfif>--->
					
					<p>Witaj #users[idx].name#, <br />
					poniżej widnieje zestawienie zmian w indeksach z dnia #DateFormat(DateAdd('d', -1, Now()),'dd-mm-yyyy')#</p>

						<table border="0" cellpading="0" cellspacing="0">
							<thead>
								<tr>
									<th colspan="1">Zmiany w indeksach</th>
								</tr>
							</thead>
							<tbody>
								<cfloop array="#emails[idx]#" index="x">
									<tr>
										<td>
											#linkTo(
												text=x.message,
												host="intranet.monkey.xyz",
												controller="products",
												action="view",
												key=x.indexid,
												onlyPath=false)#
										</td>
									</tr>
								</cfloop>
							</tbody>
						</table>
					
					<br/><br/>
					Aby przejść do listy indeksów proszę wejść na stronę #linkTo(text="http://intranet.monkey.xyz",href="http://intranet.monkey.xyz")#. Dane do logowania to <b>Twój login i hasło jak do komputera</b>.
					
					<br/><br/>
					Wiadomość wysłana #DateFormat(Now(), "dd-mm-yyyy")# o godzinie #TimeFormat(Now(), "HH:mm")# na adres #users[idx].email#.
					
					<br/><br/>
					Pozdrawiamy,<br/>
					Monkey Group
			
				</body>
				</html>
		
			</cfmail>
			
			<cfcatch type="any" >
				
				<cfmail 
					to="admin@monkey.xyz"
					from="BŁĄD - Monkey<intranet@monkey.xyz>"
					replyto="intranet@monkey.xyz"
					subject="Nie można wysłać powiadomienia o nowych indeksach"
					type="html"> 
	
					<cfdump var="#cfcatch#" />
					<cfdump var="#emails#" />
					<cfdump var="#users#" />
	
				</cfmail>
					
				<cfmail 
					to="webmaster@monkey.xyz"
					from="BŁĄD - Monkey<intranet@monkey.xyz>"
					replyto="intranet@monkey.xyz"
					subject="Nie można wysłać powiadomienia o nowych indeksach"
					type="html"> 
	
					<cfdump var="#cfcatch#" />
					<cfdump var="#emails#" />
					<cfdump var="#users#" />
	
				</cfmail>
				
			</cfcatch> 
			
			</cftry>
				
		</cfif>
		
	</cfloop>
	
	<cfmail 
		to="webmaster@monkey.xyz"
		from="Monkey<intranet@monkey.xyz>"
		replyto="intranet@monkey.xyz"
		subject="Raport powiadomień o nowych indeksach"
		type="html"> 
	
			<cfdump var="#emails#" />
			<cfdump var="#users#" />
	
	</cfmail>
	
</cfoutput>