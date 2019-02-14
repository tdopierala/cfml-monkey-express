<cfprocessingdirective pageencoding="utf-8" />

<cfdiv id="left_site_column">
	
	<div class="leftWrapper">
		<div class="headerArea">
			<div class="headerArea uiHeader">
				<h3 class="uiHeaderTitle">Arkusze oceny sklepu</h3>
			</div>
		</div>
		
		<div class="headerNavArea">
			<div class="headerNavArea uiHeaderNavArea">
				<cfform name="eleader_aos_filtr_formularz"
						action="index.cfm?controller=eleader&action=aos-sklepu&t=true" >
					<ol class="filters" style="height:65px;line-height:25px;">
						<li>
							<cfinput type="text" 
									 name="sklep" 
									 class="input" 
									 placeholder="Kod sklepu"
									 value="#session.aosSklepu.sklep#" /> 
						</li>
						<li>
							<cfinput type="datefield" 
								 name="aosSklepuOd" 
								 class="input"
								 placeholder="Data od"
								 validate="eurodate" 
								 mask="dd/mm/yyyy"
								 value="#DateFormat(session.aosSklepu.aosSklepuOd, "dd/mm/yyyy")#" /> 
						</li>
						<li>
							<cfinput type="datefield" 
									 name="aosSklepuDo"
									 class="input"
									 placeholder="Data do"
									 validate="eurodate"
									 mask="dd/mm/yyyy"
									 value="#DateFormat(session.aosSklepu.aosSklepuDo, "dd/mm/yyyy")#" />
						</li>
						<li>
							<select name="kosEmail" class="select_box">
								<option value="">[Nazwisko KOS]</option>
								<cfoutput query="kos">
									<option value="#mail#" <cfif mail EQ session.aosSklepu.kosEmail>selected="selected"</cfif>>#usr#</option>
								</cfoutput>
							</select>
						</li>
						<li class="clear">
							<input type="radio" name="odwolania" value="1" <cfif session.aosSklepu.odwolania EQ 1>checked="checked"</cfif>/> TAK
							<input type="radio" name="odwolania" value="0" <cfif session.aosSklepu.odwolania EQ 0>checked="checked"</cfif>/> NIE 
							<input type="radio" name="odwolania" value="-1" <cfif session.aosSklepu.odwolania EQ -1>checked="checked"</cfif>/> WSZYSTKIE 
						</li>
						<li>Aktualna wersja AOS
							<input type="radio" name="wersja" value="<cfoutput>#session.aosSklepu.maxWersja#</cfoutput>" <cfif session.aosSklepu.wersja EQ session.aosSklepu.maxWersja>checked="checked"</cfif> />
						</li>
						<li>Poprzednia wersja AOS
							<input type="radio" name="wersja" value="<cfoutput>#session.aosSklepu.maxWersja-1#</cfoutput>" <cfif session.aosSklepu.wersja EQ session.aosSklepu.maxWersja-1>checked="checked"</cfif> />
						</li>
						<li>Poprzednia poprzedniej wersji AOS
							<input type="radio" name="wersja" value="<cfoutput>#session.aosSklepu.maxWersja-2#</cfoutput>" <cfif session.aosSklepu.wersja EQ session.aosSklepu.maxWersja-2>checked="checked"</cfif> />
						</li>
						<li><cfinput type="submit" class="admin_button green_admin_button" name="eleader_aos_filter_formularz_submit" value=">>"/></li>
					</ol>
				</cfform>
			</div>
		</div>
		
		<div class="contentArea">
			<div class="contentArea uiContent">

				<div class="uiNavigation">
					<a href="index.cfm?controller=eleader&action=raport-aos-sklepu" title="Pobierz raport AOS" target="_blank" class="web-button web-button--with-hover">Eksportuj do Excela</a>
					
					<a href="##" title="Pobierz raport AOS" class="web-button web-button--with-hover strikethrough">Eksportuj do PDF</a>
				</div>

				<table class="uiTable aosTable" id="mainAosTable">
					<thead>
						<tr>
							<th rowspan="2" class="leftBorder topBorder rightBorder bottomBorder">&nbsp;</th>
							<th rowspan="2" class="rightBorder topBorder bottomBorder"><span>Data kontroli</span></th>
							<th rowspan="2" class="rightBorder topBorder bottomBorder"><span>Nazwisko kontrolującego</span></th>
							<th rowspan="2" class="topBorder bottomBorder l"><span>Sklep</span></th>
							<th colspan="<cfoutput>#ccount#</cfoutput>" class="leftBorder topBorder bottomBorder"><span>Ilość uzyskanych punktów</span></th>
							<th rowspan="2" class="leftBorder topBorder rightBorder bottomBorder"><span>Odwołania</span></th>
							<th rowspan="2" class="topBorder bottomBorder rightBorder"><span>Punkty z odwołań</span></th>
						</tr>
						<tr>
							<cfset nrKolumny = 0 />
							<cfoutput query="listaZagadnien">
								<cfset nrKolumny += 1 />
								<th class="leftBorder bottomBorder"><span title="#nazwazadania#">#nrKolumny#</span></th>
								<!---<th class="leftBorder bottomBorder">#nazwazadania#</th>--->
							</cfoutput>
						</tr>
					</thead>
					<tbody>
						<cfset indeks = 0 />
						<cfloop query="arkuszeDlaSprzedazy">
							<cfset indeks += 1 />
							<tr>
								<td class="leftBorder bottomBorder rightBorder">
									<a href="javascript:void(0)" onclick="pobierzWszystkieOdpowiedziArkusza('<cfoutput>#idaktywnosci#</cfoutput>', $(this))" title="Pobierz odpowiedzi" class="extend">
										<span>&nbsp;</span>
									</a>
								</td>
								<td class="rightBorder bottomBorder r"><cfoutput>#DateFormat(datautworzenia, "yyyy/mm/dd")#</cfoutput></td>
								<td class="rightBorder bottomBorder l"><cfoutput>#imiepartnera# #Left(nazwiskopartnera, 1)#</cfoutput></td>
								<td class="bottomBorder l"><cfoutput>#kodsklepu#</cfoutput></td>
								<cfloop query="listaZagadnien">
									<td class="leftBorder bottomBorder r">
										<cfoutput>#arkuszeDlaSprzedazy["#IDDEFINICJIZADANIA#"][indeks]#</cfoutput>
									</td>
								</cfloop>
								
								<td class="leftBorder bottomBorder rightBorder r">
									<cfif iloscodwolan NEQ 0>
										<cfoutput>
										<a href="javascript:ColdFusion.navigate('index.cfm?controller=eleader&action=pobierz-odwolanie&idaktywnosci=#idaktywnosci#', 'odwolaniaAos')" class="" title="Pokaż odwołanie">
											#iloscodwolan#
										</a>
										</cfoutput>
									<cfelse>
										
									</cfif>
								</td>
								<td class="bottomBorder rightBorder r">
									<cfoutput>#punktyzodwolan#</cfoutput>
								</td>
							</tr>
						</cfloop>
						
					</tbody>
				</table>
				
			</div><!-- /end contentArea uiContent -->
		</div> <!-- /end contentArea -->
		
		<div class="footerArea">
			
			<cfdiv id="odwolaniaAos"></cfdiv>
			
		</div> <!-- /end footerArea -->
	
	</div>

</cfdiv>

<cfset ajaxOnLoad("sortowanie") />

<script type="text/javascript">
$(function(){
	
	var len = $('script').filter(function () {
		return /^.*intranet\/javascripts\/ajaximport\/initEleader.*/.test( $(this).attr('src') );
	}).length;
	
	if (len === 0) {
		$.getScript("javascripts/ajaximport/initEleader.js");
	}
});
</script>
