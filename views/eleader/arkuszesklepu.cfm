<!---<cfdump var="#punktacjaAktywnosciSklepu#" />
<cfabort />--->

<cfprocessingdirective pageencoding="utf-8" />
	
<tr class="expand-child">
	<td class="leftBorder bottomBorder fioletowy">&nbsp;</td>
	<td colspan="17" class="leftBorder rightBorder bottomBorder jasnoFioletowy">
		
		<table class="uiTable aosTable tablesorter-child">
			<thead>
				<tr>
					<th rowspan="2" class="leftBorder topBorder bottomBorder czerwony">&nbsp;</th>
					<th rowspan="2" class="leftBorder topBorder rightBorder bottomBorder czerwony"><span>Data kontroli</span></th>
					<th rowspan="2" class="topBorder bottomBorder rightBorder czerwony"><span>Ilość pkt ujemnych</span></th>
					<th rowspan="2" class="topBorder bottomBorder czerwony"><span>Nazwisko kontrolującego</span></th>
					<th colspan="<cfoutput>#ccount#</cfoutput>" class="topBorder bottomBorder leftBorder czerwony"><span>Ilość punktów odjętych</span></th>
					<th rowspan="2" class="topBorder bottomBorder leftBorder rightBorder czerwony"><span title="Suma uzyskanych punktów">Razem</span></th>
					<th rowspan="2" class="topBorder bottomBorder rightBorder czerwony"><span>Czy jest odwołanie</span></th>
				</tr>
				<tr>
					<cfset nrKolumny = 0 />
					<cfoutput query="listaZagadnien">
						<cfset nrKolumny += 1 />
						<th class="leftBorder bottomBorder czerwony"><span title="#nazwazadania#">#nrKolumny#</span></th>
						<!---<th class="leftBorder bottomBorder">#nazwazadania#</th>--->
					</cfoutput>
				</tr>
			</thead>
			<tbody>
				<cfset indeks = 0 />
				<cfloop query="punktacjaAktywnosciSklepu">
					<cfset indeks += 1 />
					<tr>
						<td class="leftBorder bottomBorder czerwony">
							<a href="javascript:void(0);" onclick="pobierzOdpowiedziArkusza('<cfoutput>#idaktywnosci#</cfoutput>', $(this))" title="Pobierz odpowiedzi arkusza" class="extend">
							<span>&nbsp;</span>
							</a>
						</td>
						<td class="leftBorder rightBorder bottomBorder r jasnoCzerwony
						<cfif structKeyExists(structOdwolaniaPoAktywnosci, "#idaktywnosci#")>odwolaniaPps</cfif>
						">
							<!---<a href="javascript:void(0);" onclick="pobierzOdpowiedziArkusza('<cfoutput>#idaktywnosci#</cfoutput>', $(this))" title="Pobierz odpowiedzi arkusza">--->
							<cfoutput>#DateFormat(datautworzenia, "yyyy/mm/dd")#</cfoutput>
							<!---</a>--->
						</td>
						<!--- Sumuje punkty ujemne --->
						<td class="rightBorder bottomBorder r jasnoCzerwony sum_row_value_total
						<cfif structKeyExists(structOdwolaniaPoAktywnosci, "#idaktywnosci#")>odwolaniaPps</cfif>
						">
							<cfset sumaPunktowUjemnych = 0 />
							<cfset sumaPunktow = 0 />
							<cfset tmpWersja = wersja />
							<cfloop query="listaZagadnien">
								<cfif wersja NEQ tmpWersja>
									<cfcontinue />
								</cfif>
								
								<cfset sumaPunktowUjemnych += (iif( Len(sum) EQ 0, 0, sum ) - iif( Len(punktacjaAktywnosciSklepu["#IDDEFINICJIZADANIA#"][indeks]) EQ 0, 0, punktacjaAktywnosciSklepu["#IDDEFINICJIZADANIA#"][indeks])) />
								<cfset sumaPunktow += iif( Len(punktacjaAktywnosciSklepu["#IDDEFINICJIZADANIA#"][indeks]) EQ 0, 0, punktacjaAktywnosciSklepu["#IDDEFINICJIZADANIA#"][indeks]) />
							</cfloop>
							<!---<cfoutput>#sumaPunktowUjemnych#</cfoutput>--->
						</td>
						<td class="bottomBorder l jasnoCzerwony
						<cfif structKeyExists(structOdwolaniaPoAktywnosci, "#idaktywnosci#")>odwolaniaPps</cfif>
						"><cfoutput>#imiepartnera# #Left(nazwiskopartnera, 1)#</cfoutput></td>
						
						<cfset tmpWersja = wersja /> <!--- Wersja arkusza --->
						<cfloop query="listaZagadnien">
						
							<cfset doUzyskania = structListaZagadnienWersjami[tmpWersja]["#nazwazadania#"] />
						

							<cfset iloscPunktowUjemnych = iif(Len(doUzyskania) EQ 0, 0, doUzyskania) - iif(Len(punktacjaAktywnosciSklepu["#IDDEFINICJIZADANIA#"][indeks]) EQ 0, 0, punktacjaAktywnosciSklepu["#IDDEFINICJIZADANIA#"][indeks]) />
							<td class="leftBorder bottomBorder r jasnoCzerwony sum_row_values">
								<cfif iloscPunktowUjemnych GT 0>
									<!---<span class="redText"><cfoutput>#iloscPunktowUjemnych#</cfoutput></span>--->
									<span class=""><cfoutput>#iloscPunktowUjemnych#</cfoutput></span>
								<cfelse>
									<!---<cfoutput>#iloscPunktowUjemnych#</cfoutput>--->
								</cfif>
							</td>
						</cfloop>
						<td class="leftBorder rightBorder bottomBorder r jasnoCzerwony ">
							<!---<cfoutput>#sumaPunktow#</cfoutput>--->
							
							<!---<cfset tmpWersja = wersja /> <!--- Wersja arkusza --->
							<cfset tmpWszystkiePunkty = 0 /> 
							<cfset doUzyskania = 0 />
							<cfloop query="listaZagadnien">
								<cfif wersja NEQ tmpWersja>
									<cfcontinue />
								</cfif>
								
								<cfset tmpWszystkiePunkty += iif(Len(punktacjaAktywnosciSklepu["#IDDEFINICJIZADANIA#"][indeks]) EQ 0, 0, punktacjaAktywnosciSklepu["#IDDEFINICJIZADANIA#"][indeks]) />
								
								<cfset doUzyskania += structListaZagadnienWersjami[wersja]["#nazwazadania#"] />
								
							</cfloop>
							<cfoutput>#doUzyskania-tmpWszystkiePunkty#</cfoutput>--->
							<!---
								Aby otrzymać sumę uzyskanych punktów muszę najpierw zsumować
								możliwe wszystkie punkty do uzyskania a następnie odjąć
								punkty odjęte.
							--->
							<cfset tmpWersja = wersja />
							<cfset doUzyskania = 0 /> <!--- Ilość punktów możliwa do uzyskania --->
							<cfloop collection="#structListaZagadnienWersjami["#tmpWersja#"]#" item="i" >
								<cfset doUzyskania += structListaZagadnienWersjami[tmpWersja]["#i#"] />
							</cfloop>
							
							<cfset sumaUzyskanych = 0 /> <!--- Ilość uzyskanych punktów --->
							<cfloop query="listaZagadnien">
								<cfset sumaUzyskanych += iif(Len(punktacjaAktywnosciSklepu["#IDDEFINICJIZADANIA#"][indeks]) EQ 0, 0, punktacjaAktywnosciSklepu["#IDDEFINICJIZADANIA#"][indeks]) />
							</cfloop>
							
							<cfoutput>#sumaUzyskanych#</cfoutput>
							
							
						</td>
						<td class="rightBorder bottomBorder l jasnoCzerwony">
							<cfif structKeyExists(structOdwolaniaPoAktywnosci, "#idaktywnosci#")>
								TAK
							</cfif>
						</td>
					</tr>
				</cfloop>
			</tbody>
			<tfoot>
				<tr>
					<th colspan="17" class="leftBorder bottomBorder rightBorder czerwony"></th>
				</tr>
			</tfoot>
		</table>
		
	</td>
</tr>