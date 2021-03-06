<cfloop query="mymails" >

	<cfmail 
		to="#mail#"
		from="NIERUCHOMOŚCI - Monkey<intranet@monkey.xyz>"
		replyto="intranet@monkey.xyz"
		bcc="intranet@monkey.xyz"
		subject="Zmiana w nieruchomości"
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
		
			Witaj #givenname# #sn#,<br />
			Nieruchomość, w obiegu której bierzesz udział, została przeniesiona do archiwum. Aby dowiedzieć się szczegółów proszę zalogować się na http://intranet.monkey.xyz i przejść do zakładki Nieruchomości.
			<br />
			<br />
			
			<div class="clear"></div>
			
			<dl class="workflow">
			
				<dt>Ulica i numer</dt>
				<dd>#myinstance.street# #myinstance.streetnumber#</dd>
				
				<dt>Miasto i kod pocztowy</dt>
				<dd>#myinstance.postalcode# #myinstance.city#</dd>
				
				<dt>Dodane przez</dt>
				<dd>#myinstance.givenname# #myinstance.sn#</dd>
				
			</dl>
			
			<br />
			<br />
			<br />
			
			<div class="clear"></div>
			
			<br />
			<br />
			
			<!---<cfdump var="#arguments#" />
			<cfabort />--->
			
			<dl class="workflow">
		
				<dt class="header">Etap</dt>
				<dd class="header">Użytkownik</dd>
				<dd class="header">Powód</dd>
				<dd class="header">Komentarz do etapu</dd>
				
				<dt>#arguments.mystep.stepname#</dt>
				<dd>#myuser.givenname# #myuser.sn#</dd>
				<dd>
					<cfif isDefined("arguments.myreason.reasonname")>
						#arguments.myreason.reasonname#
					<cfelse>
						&nbsp;
					</cfif>
				</dd>
				<dd>#arguments.myworkflow.workflownote#</dd>
				
			</dl>
			
			<div class="clear"></div>
		
			<br /><br />
			
			Pozdrawiamy,<br />
			Monkey Group
		
		</body>
		</html>

	</cfmail>

</cfloop>