<cfprocessingdirective pageencoding="utf-8" />

<cfmail to="#sklep.projekt#@monkey.xyz" from="Monkey<intranet@monkey.xyz>"
		replyto="intranet@monkey.xyz" subject="Lista dostawców regionalnych" type="html">
	<cfoutput>
		<html>
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
			<style type="text/css"> 
				body { font: normal 12px "Lucida Sans Unicode", sans-serif; color: ##444; }
				a { color: ##3B5998; text-decoration: none; }
				.clear { float: none; clear: both; }
				.leftBorder { border-left: 1px solid ##e1e1e1; }
				.rightBorder { border-right: 1px solid ##e1e1e1; } 
				.bottomBorder { border-bottom: 1px solid ##e1e1e1; } 
				.topBorder { border-top: 1px solid ##e1e1e1; } 
				.uiTable { width: 100%; margin-bottom: 20px; }
				.uiTable tfoot tr th,
				.uiTable thead tr th { background-color: ##f5f5f5; padding: 3px 3px 3px 3px; color: ##16151a; font-weight: bold; }
				.uiTable tbody td { font-size: inherit; padding: 3px 3px 3px 3px; }
			</style>
		</head>
		<body>
			Dzień dobry #sklep.nazwaajenta#, <br /><br />
			Poniżej znajduje się lista Twoich dostawców regionalnych.<br /><br />
			<table class="uiTable">
				<thead>
					<tr>
						<th rowspan="2" class="bottomBorder">Nazwa dostawcy</th>
						<th rowspan="2" class="bottomBorder">Typ dowstawcy</th>
						<th colspan="2" class="">Godziny zamówień</th>
						<th rowspan="2" class="bottomBorder">Dni dostaw</th>
						<th rowspan="2" class="bottomBorder">Kontakt</th>
					</tr>
					<tr>
						<th>Od</th>
						<th>Do</th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="dostawcy">
						<tr>
							<td class="bottomBorder">#contractor_name#</td>
							<td class="bottomBorder">#type_name#</td>
							<td class="bottomBorder">#hour_from#</td>
							<td class="bottomBorder">#hour_to#</td>
							<td class="bottomBorder">#dni_dostaw#</td>
							<td class="bottomBorder">#contractor_telephone#</td>
						</tr>
					</cfloop>
				</tbody>
			</table>
			
			<br /><br />
			Pozdrawiamy,<br />
			Zespół Monkey Group
		</body>
		</html>
	</cfoutput>
</cfmail>

<cflocation url="http://intranet.monkey.xyz/intranet/index.cfm?controller=store_contractors&action=contractors" addtoken="false" statuscode="301" />