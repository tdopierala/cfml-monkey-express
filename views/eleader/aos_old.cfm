<cfprocessingdirective pageencoding="utf-8" />

<cfsilent>
	<cfset ostatniaKontrola = {} />
	
<!---	<cfset sumaOdjetychPunktow = {} />
	<cfset sumaMozliwychDoUzyskaniaPunktow = {} />
	<cfset sklepyKosa = {} />
	<cfset sklepyKosaIntranet = {} />--->
	
	<cfset sumaOdjetychPunktow = {} />
	<cfset sumaMozliwychDoUzyskaniaPunktow = {} />
	
	<cfloop query="listaKos">
		<cfset mailKos = LCase(mail) />
		<cfset listaSklepowKos = "" />
		<cfset ostatniaKontrola["#mailKos#"] = {} />
		
		<cfinvoke component="cfc.eleader" method="sklepyKosaIntranet" returnvariable="listaSklepowKos">
			<cfinvokeargument name="email" value="#mailKos#" />
		</cfinvoke>
		
		<cfset ostatniaKontrola["#mailKos#"]["iloscsklepow"] = listaSklepowKos.RecordCount />
		
		<cfloop query="listaSklepowKos">
			<cfset ostatniaKontrola["#mailKos#"]["DANE"][PROJEKT] = {} />
			
			<cfinvoke component="cfc.eleader" method="pobierzOstatniaKontroleNaSklepie" returnvariable="ostatniaKontrolaDkin" >
				<cfinvokeargument name="sklep" value="#PROJEKT#" />
				<cfinvokeargument name="email" value="%monkey.xyz" />
				<cfinvokeargument name="kos" value="#mailKos#" />
				<cfinvokeargument name="interval" value="2" />
			</cfinvoke>
			<cfset ostatniaKontrola["#mailKos#"]["DANE"][PROJEKT]["DKIN"] = ostatniaKontrolaDkin />
			
			<cfinvoke component="cfc.eleader" method="pobierzOstatniaKontroleNaSklepie" returnvariable="ostatniaKontrolaKos" >
				<cfinvokeargument name="sklep" value="#PROJEKT#" />
				<cfinvokeargument name="email" value="%monkey.xyz" />
				<cfinvokeargument name="kos" value="#mailKos#" />
				<cfinvokeargument name="interval" value="2" />
			</cfinvoke>
			<cfset ostatniaKontrola["#mailKos#"]["DANE"][PROJEKT]["KOS"] = ostatniaKontrolaKos />
			
		</cfloop>
		
		<!---<cfset sumaOdjetychPunktow["#LCase(mail)#"] = {} />
		<cfset sumaMozliwychDoUzyskaniaPunktow["#LCase(mail)#"] = {} />--->
		
		
		<!---<cfset maksymalnieDoUzyskania = {} />
		<cfset sumaOdjetychPunktow["#LCase(mail)#"] = {} />
		<cfset sumaMozliwychDoUzyskaniaPunktow["#LCase(mail)#"] = {} />
		<cfset sklepyKosa["#LCase(mail)#"] = {} />
		<cfset sklepyKosaIntranet["#LCase(mail)#"] = {} />
		
		<cfinvoke component="cfc.eleader" method="sklepyKosa" returnvariable="tmp1" >
			<cfinvokeargument name="email" value="#LCase(mail)#" />
			<cfinvokeargument name="interval" value="#session.eleader.interval#" />
		</cfinvoke>
		
		<cfinvoke component="cfc.eleader" method="sklepyKosaIntranet" returnvariable="tmp2" >
			<cfinvokeargument name="email" value="#LCase(mail)#" />
		</cfinvoke>
		
		<cfquery name="sklepyKosaZDanymi" dbtype="query">
			select * 
			from tmp1, tmp2
			where tmp1.kodsklepu = tmp2.projekt
			order by kodsklepu asc;
		</cfquery>
		
		<cfset strukturaSklepyKos = arrayNew(1) />
		
		<cfloop query="sklepyKosaZDanymi">
			<cfset tmpStruct = structNew() />
			<cfset tmpStruct.kodsklepu = KODSKLEPU />
			<cfset tmpStruct.ilosckontroli = ILOSCKONTROLI />
			<cfset tmpStruct.iloscodwolan = ILOSCODWOLAN />
			<cfset tmpStruct.ilosckontrolicentrali = ILOSCKONTROLICENTRALI />
			
			<!---
			Dodaje definicje zagadnień AOS.
			--->
			<cfset tmpStruct["AOS"] = structNew() />
			<cfloop query="listaZagadnien">
				<cfset tmpStruct["AOS"][IDDEFINICJIZADANIA] = 0 />
			</cfloop>
			
			<cfset arrayStruct = structNew() />
			<cfset arrayStruct.kodsklepu = KODSKLEPU />
			<cfset arrayStruct.dane = tmpStruct />
			<cfset arrayStruct.iloscKontroli = 0 />
			
			<cfset arrayAppend(strukturaSklepyKos, arrayStruct) />
		</cfloop>
		
		<cfinvoke component="cfc.eleader" method="punktacjaAktywnosciDlaKos" returnvariable="tmp" >
			<cfinvokeargument name="email" value="#LCase(mail)#" />
			<cfinvokeargument name="interval" value="#session.eleader.interval#" />
		</cfinvoke>
		
		<cfloop query="listaZagadnien">
			<cfset maksymalnieDoUzyskania["#IDDEFINICJIZADANIA#"] = 0 />
		</cfloop>
		
		<cfset index = 0 />
		<cfloop query="tmp">
			<cfset index += 1 />
			<cfset tmpKodSklepu = KODSKLEPU />
			<cfset tmpWersja2 = wersja />
			
			<!--- Przechodzę przez listę zagadnień aby pobrać ilości punktów --->
			<cfloop query="listaZagadnien">
				
				<!--- 
					Aby idiota dostał posortowane wyniki po sklepach trzeba zrobić to w tabeli,
					bo tylko tabela trzyma kolejność rekordów. Struktura ich nie trzyma. 
					Pewnie wszechwiedzący o tym wiedział, on wszystko wie.
				---> 
				<cfloop array="#strukturaSklepyKos#" index="i">
					<cfif i.KODSKLEPU eq tmpKodSklepu>
						<cfset i["DANE"]["AOS"]["#IDDEFINICJIZADANIA#"] += iif(Len(tmp["#IDDEFINICJIZADANIA#"][index]) EQ 0, 0, tmp["#IDDEFINICJIZADANIA#"][index]) />
						
						<cfquery name="tmpDoUzyskania" dbtype="query">
							select sumadouzyskania, iddefinicjizadania, wersja from wszystkieZagadnienia
							where wersja = #tmpWersja2# and iddefinicjizadania = '#IDDEFINICJIZADANIA#';
						</cfquery>
						
						<cfset maksymalnieDoUzyskania["#iddefinicjizadania#"] += tmpDoUzyskania.sumadouzyskania  />
						
						<cfcontinue />
					</cfif>
				</cfloop>
				
						
			</cfloop>
			
		</cfloop>
	
		<cfset sumaOdjetychPunktow["#LCase(mail)#"] = strukturaSklepyKos />
		<cfset sumaMozliwychDoUzyskaniaPunktow["#LCase(mail)#"] = maksymalnieDoUzyskania />
	--->
	</cfloop>
	
	<!---
		Przechodze przez wszystkie sklepy KOSa i sumuje odjęte punkty i 
		możliwe do uzyskania.
	--->
	<cfloop collection="#ostatniaKontrola#" item="kos">
		<cfif structKeyExists(ostatniaKontrola["#kos#"], "DANE")>
			<cfset toLoop = ostatniaKontrola["#kos#"]["DANE"] />
			<cfset kosMail = kos />
			
			<cfset sumaOdjetychPunktow["#kosMail#"] = {} />
			<cfset sumaMozliwychDoUzyskaniaPunktow["#kosMail#"] = {} />
			
			<cfloop query="listaZagadnien">
				<cfset sumaOdjetychPunktow["#kosMail#"]["#iddefinicjizadania#"] = 0 />
				<cfset sumaMozliwychDoUzyskaniaPunktow["#kosMail#"]["#iddefinicjizadania#"] = 0 />
			</cfloop>
			
			
			<cfset kontrolaDoDodania = "" />
		
			<cfloop collection="#toLoop#" item="kontrola" >
				<cfif toLoop["#kontrola#"]["DKIN"].RecordCount EQ 1>
					<cfset kontrolaDoDodania = toLoop["#kontrola#"]["DKIN"] />
				<cfelseif toLoop["#kontrola#"]["KOS"].RecordCount EQ 1>
					<cfset kontrolaDoDodania = toLoop["#kontrola#"]["DKIN"] />
				</cfif>
				
				<cfset tmpWersja = kontrolaDoDodania.wersja />
				
				<!--- Dodaje do wszystkich uzyskanych punktów --->
				<cfloop query="listaZagadnien">
					<cfset sumaOdjetychPunktow["#kosMail#"]["#IDDEFINICJIZADANIA#"] += iif(Len(kontrolaDoDodania["#IDDEFINICJIZADANIA#"][1]) EQ 0, 0, kontrolaDoDodania["#IDDEFINICJIZADANIA#"][1]) />
					
					<cfquery name="tmpDoUzyskania" dbtype="query">
						select sumadouzyskania, iddefinicjizadania, wersja from wszystkieZagadnienia
						where wersja = #iif(Len(tmpWersja) EQ 0, 2, tmpWersja)# and iddefinicjizadania = '#IDDEFINICJIZADANIA#';
					</cfquery>
						
					<cfset sumaMozliwychDoUzyskaniaPunktow["#kosMail#"]["#iddefinicjizadania#"] += tmpDoUzyskania.sumadouzyskania  />
					
				</cfloop>
				
			</cfloop>
		</cfif>
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
						<cfloop query="listaKos">
							<cfset tmpMail = LCase(mail) />
							
							<cfif not structKeyExists(sumaOdjetychPunktow, "#tmpMail#")>
								<cfcontinue />
							</cfif>
							
							<!---
								Liczę ilość odwołań od aos
							--->
							<cfset iloscOdwolan = 0 />
							
							<tr>
								<td class="leftBorder rightBorder bottomBorder zielony">
									<a href="javascript:void(0)" onclick="pobierzSklepyKos('<cfoutput>#mail#</cfoutput>', $(this))" title="Pobierz arkusze" class="extend">
										<span>&nbsp;</span>
									</a>
								</td>
								
								<td class="rightBorder bottomBorder jasnoZielony l <cfif iloscOdwolan NEQ 0> odwolaniaPps </cfif>">
									<cfoutput>#givenname# #Left(sn, 1)#</cfoutput>
								</td>
								
								<td class="bottomBorder rightBorder jasnoZielony r <cfif iloscOdwolan NEQ 0> odwolaniaPps </cfif>">
									
									
								</td>
								
								<td class="bottomBorder jasnoZielony r"><cfoutput>#iloscsklepow#</cfoutput></td>
								
								<cfset i = iloscsklepow />
								<cfloop query="listaZagadnien">
									<td class="leftBorder bottomBorder r jasnoZielony sum_row_values">
										<!---<cfoutput>#sumaMozliwychDoUzyskaniaPunktow["#tmpMail#"]["#IDDEFINICJIZADANIA#"]#</cfoutput>--->
										<!---<cfoutput>#sumaOdjetychPunktow["#tmpMail#"]["#IDDEFINICJIZADANIA#"]#</cfoutput>--->
										
										<cfset uzyskanych = (sumaMozliwychDoUzyskaniaPunktow["#tmpMail#"]["#IDDEFINICJIZADANIA#"]-sumaOdjetychPunktow["#tmpMail#"]["#IDDEFINICJIZADANIA#"])/i />
										<cfif uzyskanych NEQ 0>
										
											<span class="">
											<cfoutput>#NumberFormat(uzyskanych, "0.00")#</cfoutput>
										</span>
										
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
							<th colspan="17" class="leftBorder bottomBorder rightBorder zielony"></th>
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
			sumCount += parseInt($(this).html());
		});
		$(this).find('.sum_row_value_total').html(sumCount);
		
	});
	
});
</script>