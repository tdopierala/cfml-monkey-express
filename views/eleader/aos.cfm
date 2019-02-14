<cfprocessingdirective pageencoding="utf-8" />
 
<cfsilent>
	<!---
		Wszystkie wyliczenia i przetwarzanie danych, które następnie
		są prezentowane w widoku.
	--->
	<cfset danePoKos = structNew() />
	
	<cfloop query="listaKos">
		<cfset MailKosa = LCase(mail) />
		<!---
			Mając email KOS pobieram sklepy KOSa z komponentu eleader.cfc
		--->
		<cfinvoke component="cfc.eleader" method="sklepyKosa" returnvariable="sklepyKosa">
			<cfinvokeargument name="email" value="#MailKosa#" />
			<cfinvokeargument name="interval" value="#session.eleader.interval#" />
		</cfinvoke>
		
		<cfinvoke component="cfc.eleader" method="sklepyKosaIntranet" returnvariable="sklepyKosaIntranet">
			<cfinvokeargument name="email" value="#MailKosa#" />
		</cfinvoke>
			
		<cfquery name="sklepyKosaZDanymi" dbtype="query">
			select * 
			from sklepyKosa, sklepyKosaIntranet
			where sklepyKosa.kodsklepu = sklepyKosaIntranet.projekt
			order by kodsklepu asc;
		</cfquery>
		
		<!---
			Pobieram ostatnie kontrole na sklepach KOS wykonaną przez pracownika
			centrali
		--->
		<cfinvoke component="cfc.eleader" method="pobierzOstatniaKontroleNaSklepie" returnvariable="ostatniaKontrolaDkin">
			<cfinvokeargument name="sklep" value="%" />
			<cfinvokeargument name="email" value="%monkey.xyz" />
			<cfinvokeargument name="kos" value="#MailKosa#" />
		</cfinvoke>
		
		<!---
			Pobieram ostatnie kontrole na sklepach KOS wykonaną przez KOS
		--->
		<cfinvoke component="cfc.eleader" method="pobierzOstatniaKontroleNaSklepie" returnvariable="ostatniaKontrolaKos">
			<cfinvokeargument name="sklep" value="%" />
			<cfinvokeargument name="email" value="%monkey.xyz" />
			<cfinvokeargument name="kos" value="#MailKosa#" />
		</cfinvoke>
		
		<!---
			Buduję strukturę dla każdego KOSa
		--->
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
			
			<!--- Dodaję do struktury ostatnią kontrole DKIN --->
			<cfquery name="kontrolaDKIN" dbtype="query">
				select * from ostatniaKontrolaDkin
				where kodsklepu = <cfqueryparam value="#sklepyKosaZDanymi.KODSKLEPU#" cfsqltype="cf_sql_varchar" />;
			</cfquery>
			<cfset tmpStruct.ostatniakontroladkin = kontrolaDKIN />
			
			<!--- Dodaję do struktury ostatnią kontrolę KOS --->
			<cfquery name="kontrolaKOS" dbtype="query">
				select * from ostatniaKontrolaKos
				where kodsklepu = <cfqueryparam value="#sklepyKosaZDanymi.KODSKLEPU#" cfsqltype="cf_sql_varchar" />;
			</cfquery>
			<cfset tmpStruct.ostatniakontrolakos = kontrolaKOS />
			
			<cfset arrayAppend(strukturaSklepyKos, tmpStruct) />
			
		</cfloop>

		<cfset danePoKos["#MailKosa#"] = strukturaSklepyKos />

	</cfloop>
	
</cfsilent>

<cfdiv id="left_site_column">

	<div class="leftWrapper">
		<div class="headerArea">
			<div class="headerArea uiHeader">
				<h3 class="uiHeaderTitle">Arkusz oceny sklepu</h3>
			</div>
		</div>
		
		<div class="headerNavArea">
			<div class="headerNavArea uiHeaderNavArea">
				<cfform name="eleader_aos_filtr_formularz"
						action="index.cfm?controller=eleader&action=aos" >
					<ol class="filters" style="height:25px;line-height:25px;">
						<li>
							<input type="radio" name="interval" value="2" <cfif session.eleader.interval EQ 2>checked="checked"</cfif> /> 2 miesiące
						</li>
						<li>
							<input type="radio" name="interval" value="3" <cfif session.eleader.interval EQ 3>checked="checked"</cfif>/> 3 miesiące
						</li>
						<li>
							<input type="radio" name="interval" value="6" <cfif session.eleader.interval EQ 6>checked="checked"</cfif>/> 6 miesięcy
						</il>
							<input type="radio" name="interval" value="12" <cfif session.eleader.interval EQ 12>checked="checked"</cfif>/> 12 miesiące 
						</li>
						<li><cfinput type="submit" class="admin_button green_admin_button" name="eleader_aos_filter_formularz_submit" value=">>"/></li>
					</ol>
				</cfform>
			</div>
		</div>
		
		<div class="headerNavArea">
			<div class="headerNavArea uiHeaderNavArea">
				Data ostatnio zaczytanego arkusza: <cfoutput>#DateFormat(ostatniArkusz.max, "yyyy/mm/dd HH:mm")#</cfoutput>
			</div>
		</div>
		
		<div class="contentArea">
			<div class="contentArea uiContent">
				
				<table class="uiTable aosTable" id="mainAosTable">
					<thead>
						<tr>
							<th rowspan="2" class="leftBorder topBorder rightBorder bottomBorder zielony">&nbsp;</th>
							<th rowspan="2" class="rightBorder topBorder bottomBorder zielony"><span>KOS</span></th>
							<th rowspan="2" class="rightBorder topBorder bottomBorder zielony"><span>Odwołania</span></th>
							<th rowspan="2" class="topBorder bottomBorder zielony"><span>Ilość sklepów</span></th>
							<th colspan="<cfoutput>#ccount#</cfoutput>" class="leftBorder topBorder bottomBorder zielony"><span>Ilość punktów odjętych</span></th>
							<th rowspan="2" class="leftBorder topBorder rightBorder bottomBorder zielony"><span title="Suma odjętych punktów">Razem</span></th>
							<th rowspan="2" class="topBorder rightBorder bottomBorder zielony"><span>Ilość kontroli KOS/DKiN</span></th>
						</tr>
						<tr>
							<cfset nrKolumny = 0 />
							<cfoutput query="listaZagadnien">
								<cfset nrKolumny += 1 />
								<th class="leftBorder bottomBorder zielony"><span title="#nazwazadania#">#nrKolumny# <!---(#sum#)---></span></th>
								<!---<th class="leftBorder bottomBorder">#nazwazadania#</th>--->
							</cfoutput>
						</tr>
					</thead>
					<tbody>
					
						<cfset maksymalnieDoUzyskania = {} />
						<cfset sumaOdjetychPunktow = {} />
					
						<cfloop query="listaKos">
							<cfif listaKos.ILOSCSKLEPOW EQ 0>
								<cfcontinue />
							</cfif>
							
							<cfset maksymalnieDoUzyskania["#LCase(listaKos.MAIL)#"] = {} />
							<cfset sumaOdjetychPunktow["#LCase(listaKos.MAIL)#"] = {} />
							
							<tr>
								<td class="leftBorder rightBorder bottomBorder zielony">
									<a href="javascript:void(0)" onclick="pobierzSklepyKos('<cfoutput>#LCase(listaKos.MAIL)#</cfoutput>', $(this))" title="Pobierz arkusze" class="extend">
										<span>&nbsp;</span>
									</a>
								</td>
								<td class="rightBorder bottomBorder jasnoZielony l">
									<cfoutput>#listaKos.GIVENNAME# #Left(listaKos.SN, 1)#</cfoutput>
								</td>
								<td class="rightBorder bottomBorder jasnoZielony r"></td>
								<td class="bottomBorder jasnoZielony r">
									<cfoutput>#listaKos.iloscsklepow#</cfoutput>
								</td>
								
								<cfloop query="listaZagadnien">
									<cfset sumaOdjetychPunktow["#LCase(listaKos.MAIL)#"]["#IDDEFINICJIZADANIA#"] = 0 />
									<cfset maksymalnieDoUzyskania["#LCase(listaKos.MAIL)#"]["#IDDEFINICJIZADANIA#"] = 0 />
								</cfloop>
								
								<cfloop array="#danePoKos['#LCase(listaKos.MAIL)#']#" index="element">
									<cfset ostatniaKontrola = "" />
									<cfif element["OSTATNIAKONTROLADKIN"].RecordCount EQ 1>
										<cfset ostatniaKontrola = element["OSTATNIAKONTROLADKIN"] />
									<cfelseif element["OSTATNIAKONTROLAKOS"].RecordCount EQ 1>
										<cfset ostatniaKontrola = element["OSTATNIAKONTROLAKOS"] />
									</cfif>
									
									<cfset indeksZapytania = 1 />
									<cfloop query="ostatniaKontrola">
										
										<cfloop query="listaZagadnien">
											<cfset sumaOdjetychPunktow["#LCase(listaKos.MAIL)#"]["#IDDEFINICJIZADANIA#"] += iif( Len(ostatniaKontrola["#IDDEFINICJIZADANIA#"][indeksZapytania]) EQ 0, 0, ostatniaKontrola["#IDDEFINICJIZADANIA#"][indeksZapytania] ) />
										</cfloop>
										
										<cfset tmpWersja2 = ostatniaKontrola.wersja />
										<cfloop collection="#structListaZagadnienWersjami["#tmpWersja2#"]#" item="i" >
											<cfquery name="tmpDoUzyskania" dbtype="query">
												select sumadouzyskania, iddefinicjizadania, wersja from wszystkieZagadnienia
												where wersja = #tmpWersja2# and nazwazadania = '#Trim(i)#';
											</cfquery>
											
											<cfif tmpDoUzyskania.RecordCount NEQ 0>
												
												<cfset maksymalnieDoUzyskania["#LCase(listaKos.MAIL)#"]["#tmpDoUzyskania.iddefinicjizadania#"] += tmpDoUzyskania.sumadouzyskania  />
												
											</cfif>
												
										</cfloop>
										
										<cfset indeksZapytania++ />
									</cfloop>
									
								</cfloop> 
								
								<cfloop query="listaZagadnien">
					 
									<td class="leftBorder bottomBorder r jasnoZielony sum_row_values">
										<cfif sumaOdjetychPunktow["#LCase(listaKos.MAIL)#"]["#IDDEFINICJIZADANIA#"] GT 0>
											<cfset doWyswietlenia = maksymalnieDoUzyskania["#LCase(listaKos.MAIL)#"]["#IDDEFINICJIZADANIA#"]-sumaOdjetychPunktow["#LCase(listaKos.MAIL)#"]["#IDDEFINICJIZADANIA#"] />
											
											<!---<cfif doWyswietlenia GT 0>--->
												<span class=""><cfoutput>#NumberFormat(Abs(doWyswietlenia/listaKos.ILOSCSKLEPOW), "0.00")#</cfoutput></span>
											<!---</cfif>--->

										<cfelse>
											<!---<cfoutput>#iloscPunktowUjemnych#</cfoutput>--->
										</cfif>
									</td>
								
								</cfloop>
								
								<td class="leftBorder rightBorder bottomBorder jasnoZielony r sum_row_value_total">
									<span class=""></span>
									<!-- Sumaryzna wartość odjętych punktów -->
								</td>
								<td class="rightBorder bottomBorder jasnoZielony r">
									<!-- Ilość kontroli -->
									
								</td>
								
							</tr>
							
						</cfloop>
					</tbody>
					<tfoot>
						<tr>
							<th colspan="<cfoutput>#ccount+6#</cfoutput>" class="leftBorder bottomBorder rightBorder zielony"></th>
						</tr>
					</tfoot>
				</table>
				
			</div>
		</div>
	</div>

<cfset ajaxOnLoad("sumRows") />

</cfdiv>

<script type="text/javascript">
$(function(){
	$("table").tablesorter({selectorHeaders: '> thead > tr > th'});
	
	var len = $('script').filter(function () {
		return /^.*intranet\/javascripts\/ajaximport\/initEleader.*/.test( $(this).attr('src') );
	}).length;
	
	if (len === 0) {
		$.getScript("javascripts/ajaximport/initEleader.js");
		
	} 
	
	$("table tbody tr").each(function() {
		var sumCount = 0;
		$(this).find('.sum_row_values span').each(function() {
			sumCount += parseFloat($(this).html());
		});
		$(this).find('.sum_row_value_total').html(sumCount.toFixed(2));
		
	});
	
});
</script>