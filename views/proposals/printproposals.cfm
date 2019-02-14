<cfprocessingdirective pageencoding="utf-8" />
<cfsilent>
	<cfset plik = "#hash(dateFormat(Now(), 'yyyy/mm/dd'))#" />
	<cfset nazwaPliku = expandPath( "tmp" ) & "/#plik#.pdf" />
</cfsilent>

<cfdocument format="PDF" filename="#nazwaPliku#" overwrite="true" pagetype="A4" fontembed="true" localurl="true" >
	<cfoutput>
		<html>
			<head>
				<style type="text/css">
					body { font-family: Arial; margin: 0; padding: 0; font-size: 11px; font-weight: normal; }
					h1 { font-size: 13px; }
					table { width: 100%; border: 1px solid ##000000; font-size: 10px; font-weight: normal; }
					table tr td { padding: 3px; }
					table tr td.header { background-color: ##d1d1d1; border-bottom: 1px solid ##000000; }
					.bottomBorder { border-bottom: 1px solid ##000000; }
					div##stopka { margin-top: 50px; font-size: 11px; }
				</style>
			</head>
			<body>
				<h1>Wnioski pracowników</h1>
				<div id="container">
					
					<table cellpadding="0" cellspacing="0" border="0">
						<thead>
							<tr>
								<td class="header" width="180">Użytkownik</td>
								<td class="header" width="180">Departament</td>
								<td class="header" width="180">Stanowisko</td>
								<td class="header" width="180">Rodzaj wniosku</td>
								<td class="header">Dni</td>
								<td class="header">Zaakceptowany przez</td>
							</tr>
						</thead>
						<tbody>
							<cfloop query="wnioski">
								<tr>
									<td class="bottomBorder">#usergivenname#</td>
									<td class="bottomBorder">#departament#</td>
									<td class="bottomBorder">#stanowisko#</td>
									<td class="bottomBorder">
										<cfif Len(nazwa_wniosku)>
											#nazwa_wniosku#
										<cfelse>
											#proposaltypename#
										</cfif>
									</td>
									<td class="bottomBorder">#proposaldatefrom# - #proposaldateto#</td>
									<td class="bottomBorder">#managergivenname#</td>
								</tr>
							</cfloop>
						</tbody>
					</table>
					
				<div id="stopka">
					Dokument wygenerowano dnia #DateFormat(Now(), "yyyy/mm/dd")# o godzinie #TimeFormat(Now(), "HH:mm")#.<br />
					Adres IP komputera: #CGI.REMOTE_ADDR#
				</div>
			</body>
		</html>
	</cfoutput>
</cfdocument>

<cflocation url="tmp/#plik#.pdf" addtoken="false" />