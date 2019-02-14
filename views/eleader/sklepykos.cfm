<cfsilent>

	<cfquery name="sklepyKosaZDanymi" dbtype="query">
		select * 
		from sklepyKosa, sklepyKosaIntranet
		where sklepyKosa.kodsklepu = sklepyKosaIntranet.projekt
		order by kodsklepu asc;
	</cfquery>

	<!--- 
	Tworzę strukturę z danymi zawierającą informacje o PPS, adresie sklepu i 
	przeprowadzonych kontrolach.
	--->
	<!---<cfset strukturaSklepyKos = structNew() />--->
	<cfset strukturaSklepyKos = arrayNew(1) />
	
	<cfloop query="sklepyKosaZDanymi">
		<cfset tmpStruct = structNew() />
		<cfset tmpStruct.kodsklepu = KODSKLEPU />
		<cfset tmpStruct.miasto = MIASTO />
		<cfset tmpStruct.ulica = ULICA />
		<cfset tmpStruct.nazwaajenta = NAZWAAJENTA />
		<cfset tmpStruct.ilosckontroli = 0 />
		<cfset tmpStruct.iloscwszystkichkontroli = ILOSCKONTROLI />
		<cfset tmpStruct.ilosckontrolicentrali = ILOSCKONTROLICENTRALI />
		
		<!---
			Mając listę sklepów KOS pobieram ostatnią kontrole DKiN dla
			każdego sklepu, i ostatnią kontrolę KOS.
			
			Zbudowanie tabelki do prezentowania danych jest o tyle kłopotliwe,
			że muszę wyciągnąć ostatnią kontrole DKiN i KOS i porównać, która 
			jest nowsza.
			
			Najpierw dodaje w osobne pola kontrole DKiN i KOS.
			Ostatnia kontrola DKIN
		--->
		<cfquery name="kontrolaDKIN" dbtype="query">
			select * from ostatniaKontrolaDkin
			where kodsklepu = <cfqueryparam value="#sklepyKosaZDanymi.KODSKLEPU#" cfsqltype="cf_sql_varchar" />;
		</cfquery>
		<cfset tmpStruct.ostatniakontroladkin = kontrolaDKIN />
		
		<!--- Ostatnia kontrola KOS --->
		<cfquery name="kontrolaKOS" dbtype="query">
			select * from ostatniaKontrolaKos
			where kodsklepu = <cfqueryparam value="#sklepyKosaZDanymi.KODSKLEPU#" cfsqltype="cf_sql_varchar" />;
		</cfquery>
		<cfset tmpStruct.ostatniakontrolakos = kontrolaKOS />
	
		<cfset arrayAppend(strukturaSklepyKos, tmpStruct) />

	</cfloop>
	
</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />
<tr class="expand-child">
	<td class="leftBorder rightBorder bottomBorder zielony"></td>
	<td colspan="<cfoutput>#5+ccount#</cfoutput>" class="rightBorder bottomBorder jasnoZielony">
		
<table class="uiTable aosTable tablesorter-child">
	<thead>
		<tr>
			<th rowspan="2" class="leftBorder topBorder bottomBorder fioletowy">&nbsp;</th>
			<th rowspan="2" class="leftBorder topBorder rightBorder bottomBorder fioletowy"><span>Sklep</span></th>
			<th rowspan="2" class="topBorder bottomBorder fioletowy"><span>Miasto</span></th>
			<th rowspan="2" class="leftBorder topBorder rightBorder bottomBorder fioletowy"><span>Ulica</span></th>
			<th rowspan="2" class="topBorder bottomBorder fioletowy"><span>PPS</span></th>
			<th colspan="<cfoutput>#ccount#</cfoutput>" class="leftBorder topBorder bottomBorder fioletowy"><span>Ilość punktów odjętych</span></th>
			<th rowspan="2" class="topBorder rightBorder bottomBorder leftBorder fioletowy"><span title="Suma punktów odjętych">Razem</span></th>
			<th rowspan="2" class="topBorder rightBorder bottomBorder fioletowy"><span>Ilość kontroli</span></th>
		</tr>
		<tr>
			<cfset nrKolumny = 0 />
			<cfoutput query="listaZagadnien">
				<cfset nrKolumny += 1 />
				<th class="leftBorder bottomBorder fioletowy"><span title="#nazwazadania#">#nrKolumny# <!---(#sum#)---></span></th>
				<!---<th class="leftBorder bottomBorder">#nazwazadania#</th>--->
			</cfoutput>
		</tr>
	</thead>
	<tbody>
		<cfloop array="#strukturaSklepyKos#" index="element" >
			<cfif element["ILOSCWSZYSTKICHKONTROLI"] EQ 0>
				<cfcontinue />
			</cfif>
			<tr <cfif element["OSTATNIAKONTROLADKIN"].RecordCount EQ 0 and element["OSTATNIAKONTROLAKOS"].RecordCount EQ 1> class="redText"</cfif> >
				<td class="leftBorder bottomBorder fioletowy">
					<a href="javascript:void(0)" onclick="pobierzArkuszeSklepu('<cfoutput>#element["KODSKLEPU"]#</cfoutput>', $(this))" title="Pobierz arkusze sklepu" class="extend">
					<span>&nbsp;</span>
					</a>
				</td>
				<td class="leftBorder bottomBorder rightBorder l jasnoFioletowy">
					<!---<a href="javascript:void(0)" onclick="pobierzArkuszeSklepu('<cfoutput>#strukturaSklepyKos["#element#"]["kodsklepu"]#</cfoutput>', $(this))" title="Pobierz arkusze sklepu">--->
					<cfoutput>#element["KODSKLEPU"]#</cfoutput>
					<!---</a>--->
				</td>
				<td class="bottomBorder l jasnoFioletowy"><cfoutput>#element["MIASTO"]#</cfoutput></td>
				<td class="leftBorder rightBorder bottomBorder l jasnoFioletowy"><cfoutput>#element["ULICA"]#</cfoutput></td>
				<td class="bottomBorder l jasnoFioletowy
					<cfif StructKeyExists(structIloscOdwolan, "#element["KODSKLEPU"]#")>
						 odwolaniaPps
					</cfif>
				">
					<cfoutput>#element["NAZWAAJENTA"]#</cfoutput>
				</td>
				
				<!--- 
					Nie pokazuje już sumy odjętych punktów a odjęte punkty z 
					ostatniej kontroli DKIN. Jeżeli nie ma ostatniej kontroli 
					DKIN to pokazuję ostatnią kontrolę KOS.
				--->
				<cfset ostatniaKontrola = "" />
				<cfif element["OSTATNIAKONTROLADKIN"].RecordCount EQ 1>
					<cfset ostatniaKontrola = element["OSTATNIAKONTROLADKIN"] />
				<cfelseif element["OSTATNIAKONTROLAKOS"].RecordCount EQ 1>
					<cfset ostatniaKontrola = element["OSTATNIAKONTROLAKOS"] />
				</cfif>
				
				
				<!---
					Przechodzę przez wszystkie kontrole sklepów KOSA
				--->
				<cfset indeksZapytania = 1 />
				<cfset maksymalnieDoUzyskania = {} />
				<cfset sumaOdjetychPunktow = {} />
				<cfloop query="listaZagadnien">
					<cfset sumaOdjetychPunktow["#IDDEFINICJIZADANIA#"] = 0 />
					<cfset maksymalnieDoUzyskania["#IDDEFINICJIZADANIA#"] = 0 />
				</cfloop>
				
				<cfloop query="ostatniaKontrola">
					
					<!---
						Przechodzę przez wszystkie zagadnienia i sumuje
						uzyskane punkty dla każdej części
					--->
					<cfloop query="listaZagadnien">
						
						<cfset sumaOdjetychPunktow["#IDDEFINICJIZADANIA#"] += iif( Len(ostatniaKontrola["#IDDEFINICJIZADANIA#"][indeksZapytania]) EQ 0, 0, ostatniaKontrola["#IDDEFINICJIZADANIA#"][indeksZapytania] ) />
							
					</cfloop>
					
						
					<cfset tmpWersja2 = wersja />
					<cfloop collection="#structListaZagadnienWersjami["#tmpWersja2#"]#" item="i" >
						<cfquery name="tmpDoUzyskania" dbtype="query">
							select sumadouzyskania, iddefinicjizadania, wersja from wszystkieZagadnienia
							where wersja = #tmpWersja2# and nazwazadania = '#Trim(i)#';
						</cfquery>
						
						<cfif tmpDoUzyskania.RecordCount NEQ 0>
							
							<cfset maksymalnieDoUzyskania["#tmpDoUzyskania.iddefinicjizadania#"] += tmpDoUzyskania.sumadouzyskania  />
							
						</cfif>
							
					</cfloop>
						
								
				<cfset indeksZapytania++ />
				</cfloop>
				
				<cfloop query="listaZagadnien">
					 
					<td class="leftBorder bottomBorder r jasnoFioletowy sum_row_values">
						<cfif sumaOdjetychPunktow["#IDDEFINICJIZADANIA#"] GT 0>
							<cfset doWyswietlenia = maksymalnieDoUzyskania["#IDDEFINICJIZADANIA#"]-sumaOdjetychPunktow["#IDDEFINICJIZADANIA#"] />
							
							<cfif doWyswietlenia GT 0>
								<span class=""><cfoutput>#doWyswietlenia#</cfoutput></span>
							</cfif>
							<!---<span class=""><cfoutput>#sumaOdjetychPunktow["#IDDEFINICJIZADANIA#"]#</cfoutput></span>--->
							<!---<span class=""><cfoutput>#maksymalnieDoUzyskania["#IDDEFINICJIZADANIA#"]#</cfoutput></span>--->
						<cfelse>
							<!---<cfoutput>#iloscPunktowUjemnych#</cfoutput>--->
						</cfif>
					</td>
				
				</cfloop>
				
				<!---<cfset sumaPunktowUjemnych = 0 />
				<cfloop query="listaZagadnien">
					
					
					<cfset maxPunktow = iif( Len(sum) EQ 0, 0, sum ) />
					<cfset maxPunktowZAos = maxPunktow * element["DANE"]["ilosckontroli"] />
					<cfset iloscPunktowUjemnych = maxPunktowZAos - element["DANE"]["AOS"]["#IDDEFINICJIZADANIA#"] />
					<cfset sumaPunktowUjemnych += iloscPunktowUjemnych />
					<td class="leftBorder bottomBorder r jasnoFioletowy sum_row_values">
						<cfif iloscPunktowUjemnych GT 0>
							<!---<span class="redText"><cfoutput>#iloscPunktowUjemnych#</cfoutput></span>--->
							<span class=""><cfoutput>#iloscPunktowUjemnych#</cfoutput></span>
						<cfelse>
							<!---<cfoutput>#iloscPunktowUjemnych#</cfoutput>--->
						</cfif>
					</td>
				</cfloop>--->

				<td class="bottomBorder leftBorder rightBorder r jasnoFioletowy sum_row_value_total">
					<!---<cfoutput>#sumaPunktowUjemnych#</cfoutput>--->
					<!--- 
						Tutaj znajduje się sumowanie punktów ujemnych 
					--->
				</td>
				<td class="rightBorder bottomBorder r jasnoFioletowy"><cfoutput>#element["iloscwszystkichkontroli"]#</cfoutput></td>
			</tr>
		</cfloop>
	</tbody>
	<tfoot>
		<tr>
			<th colspan="18" class="fioletowy leftBorder bottomBorder rightBorder"></th>
		</tr>
	</tfoot>
</table>

	</td>
</tr>