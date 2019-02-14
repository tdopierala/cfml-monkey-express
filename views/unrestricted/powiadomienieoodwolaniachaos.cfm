<cfprocessingdirective pageencoding="utf-8" />

<cfsilent>
	<cfset sumaOdwolan = 0 />
	<cfloop query="iloscOdwolan">
		<cfset sumaOdwolan += iloscodwolan />
	</cfloop>
	
</cfsilent>

<cfloop collection="#structUzytkownicy#" item="u" >
	
	<cfmail 
		to="#structUzytkownicy["#u#"]#"
		from="Monkey<intranet@monkey.xyz>"
		replyto="intranet@monkey.xyz"
		bcc="intranet@monkey.xyz"
		subject="Powiadomienie o odwolaniach"
		type="html">
					
		<html>
		<head>
			<title>Powiadomienie o odwołaniach z dnia #DateFormat(Now(), 'yyyy/mm/dd')# - Monkey</title>
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
			Witaj #u#, <br />
			W <a href="http://intranet.monkey.xyz" title="Intranet">Intranecie</a> czeka na Ciebie #sumaOdwolan# odwołań od AOS do rozpatrzenia.
			
			<br/><br/>
			Wiadomość wysłana #DateFormat(Now(), "yyyy/mm/dd")# o godzinie #TimeFormat(Now(), "HH:mm")# na adres #structUzytkownicy["#u#"]#.
					
			<br/><br/>
			Pozdrawiamy,<br/>
			Monkey Group
			
		</body>
		</html>
		
	</cfmail>
	
</cfloop>