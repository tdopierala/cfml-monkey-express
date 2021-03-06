<cfoutput>
		
	<cfmail 
		to="#arguments.user.mail#"
		from="Monkey<intranet@monkey.xyz>"
		replyto="intranet@monkey.xyz"
		bcc="intranet@monkey.xyz"
		subject="Komentarz przy nieruchomości"
		type="html"> 
	      
	    
	    <html>
		<head>
			<title>KOMENTARZ PRZY NIERUCHOMOŚCI - Monkey</title>
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
			
			<style type="text/css"> 
				body { background: transparent url("../images/page.png"); font: normal 12px "Lucida Sans Unicode", sans-serif; color: ##444; }
				a { color: ##3B5998; text-decoration: none; } 
				.clear { float: none; clear: both; }

				dl { margin: 0; }
				dl dt { background: ##d7d7d7; color: ##000; font-weight: normal; float: left; padding: 5px; width: 150px; clear: both; margin: 0 10px 0 0; }
				dl dt.long { width: 300px; }
				dl dd { float: left; padding: 5px 0; margin: 0 0 1px 10px; }
				dl .header { font-weight: bold; }
			</style>
			
		</head>
		
		<body>
		
			Witaj #arguments.user.givenname#,<br />
			
			W nieruchomości, którą wprowadziłeś do <a href="http://intranet.monkey.xyz">http://intranet.monkey.xyz</a> pojawił się komentarz.

			<br />
			<br />
			
			<div class="clear"></div>
			
			<dl class="workflow">
			
				<dt>Treść komentarza</dt>
				<dd>#arguments.comment#</dd>
				
			</dl>
			
			<br /><br />
			
			<div class="clear"></div>
		
			<br /><br />
			
			<dl class="workflow">
			
				<dt class="long">Ulica</dt>
				<dd>#my_instance.street#</dd>
				
				<dt class="long">Numer doku / mieszkania</dt>
				<dd>#my_instance.streetnumber# / #my_instance.homenumber#</dd>
				
				<dt class="long">Kod pocztowy i miasto</dt>
				<dd>#my_instance.postalcode#, #my_instance.city#</dd>
				
			</dl>
			
			<br /><br />
			
			<div class="clear"></div>
			
			<br /><br />
			
			<div class="clear"></div>
			
			Pozdrawiamy,<br />
			Monkey Group
		
		</body>
		</html>

	</cfmail>

</cfoutput>