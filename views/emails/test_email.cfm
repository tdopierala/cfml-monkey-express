<cfmail 
	to="#to#"
	from="#from#"
	replyto="#replayto#"
	
	subject="#subject#"
	type="html">
	<!--- bcc="#bbc#" --->
		
		<html>
				<head>
					<title>TEST - Monkey</title>
					<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
					
					<style type="text/css"> 
						body { background: transparent url("../images/page.png"); font: normal 12px "Lucida Sans Unicode", sans-serif; color: ##444; }
						a { color: ##3B5998; text-decoration: none; }
						.clear { float: none; clear: both; }
					</style>
					
				</head>
				
				<body>
				
					Witaj #username#,<br />
					
					#message#
					
					<br />
					<br />
					
					Wiadomość testowa!!!111oneone
					
					<div class="clear"></div>
					
					<br /><br />
					W razie pytań odnośnie Intranetu prosimy o kontakt pod adresem intranet@monkey.xyz.
					<br /><br />
					
					Pozdrawiamy,<br />
					Monkey Group
					
				</body>
				</html>
	<cfsilent>
		<cfloop query="attachments">
			<cfset filepath = ExpandPath("/intranet" & src) />
			<cfmailparam file="#filepath#">
		</cfloop>
	</cfsilent>
</cfmail>