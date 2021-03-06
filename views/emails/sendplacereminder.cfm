<cfloop collection="#arguments.emails#" item="i">

	<cfmail 
		to="#arguments.emails[i].mail#"
		from="NIERUCHOMOŚCI - Monkey<intranet@monkey.xyz>"
		replyto="intranet@monkey.xyz"
		bcc="intranet@monkey.xyz"
		subject="Zmiana statusu nieruchomości"
		type="html">

		<html>
		<head>
			<title>NIERUCHOMOŚCI - Monkey</title>
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
			
			<style type="text/css"> 
				body { background: transparent url("../images/page.png"); font: normal 12px "Lucida Sans Unicode", sans-serif; color: ##444; }
				a { color: ##3B5998; text-decoration: none; }
				.clear { float: none; clear: both; }

				dl { margin: 0; }
				dl dt { background: ##d7d7d7; color: ##000; font-weight: normal; float: left; padding: 5px; width: 150px; clear: both; margin: 0 10px 0 0; }
				dl dd { float: left; padding: 5px 0; margin: 0 0 1px 10px; width: 150px; }
				dl .header { font-weight: bold; }
			</style>
			
		</head>
		
		<body>
		
			Witaj #arguments.emails[i].givenname# #arguments.emails[i].sn#,<br />
			Nieruchomość, w obiegu której bierzesz udział, zmieniła status. Aby dowiedzieć się szczegółów proszę zalogować się na http://intranet.monkey.xyz i przejść do zakładki Baza nieruchomości / Moje nieruchomości.
			<br />
			<br />
			
			<div class="clear"></div>
			
			<dl class="workflow">
			
				<dt>Ulica i numer</dt>
				<dd>#place.address#</dd>
				
				<dt>Miasto</dt>
				<dd>#place.cityname#</dd>
				
				<dt>Województwo</dt>
				<dd>#place.provincename#</dd>
				
				<dt>Partner</dt>
				<dd>#place.user.givenname# #place.user.sn#</dd>
				
			</dl>
			
			<br />
			<br />
			<br />
			
			<div class="clear"></div>
			
			<br />
			<br />
			
			<dl class="workflow">
		
				<dt class="header">Osoba</dt>
				<dd class="header">Etap</dd>
				<dd class="header">Status</dd>
				<dd class="header">Data</dd>
				
				<cfloop query="placeworkflow">
					<dt>#givenname# #sn#</dt>
					<dd>#placestepname#</dd>
					<dd>#placestatusname#</dd>
					<dd>#DateFormat(placeworkflowstart, 'dd.mm.yyyy')# #TimeFormat(placeworkflowstart, 'HH:mm')#</dd>
					
					<cfif Len(placeworkflowstop)>
					
						<dt>#newgivenname# #newsn# </dt>
						<dd>#placestepname#</dd>
						<dd>#newplacestatusname#</dd>
						<dd>#DateFormat(placeworkflowstop, 'dd.mm.yyyy')# #TimeFormat(placeworkflowstop, 'HH:mm')#</dd>
					
					</cfif>
				</cfloop>
			</dl>
			
			<div class="clear"></div>
		
			<br /><br />
			
			Pozdrawiamy,<br />
			Monkey Group
		
		</body>
		</html>

	</cfmail>

</cfloop>