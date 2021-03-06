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
			Nieruchomość, w obiegu której bierzesz udział, zmieniła etap. Aby dowiedzieć się szczegółów proszę zalogować się na http://intranet.monkey.xyz i przejść do zakładki Nieruchomości.
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
			
			<dl class="workflow">
		
				<dt>Komentarz do etapu</dt>
				<dd>#arguments.myworkflow.workflownote#</dd>
				<dt>Nowy etap</dt>
				<dd>
					
					<cfif isStruct(new)>
						#new.stepname#
					<cfelse>
						&nbsp;
					</cfif>
					
				</dd>
				
			</dl>
			
			<div class="clear"></div>
		
			<br /><br />
			
			Pozdrawiamy,<br />
			Monkey Group
		
		</body>
		</html>

	</cfmail>

</cfloop>