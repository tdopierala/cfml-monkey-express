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
						action="index.cfm?controller=eleader&action=pps&t=true" >
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
		
		<div class="contentArea">
			<div class="contentArea uiContent">
				
				
				
				<table class="uiTable aosTable" id="mainAosTable">
					<thead>
						<tr>
							<th rowspan="2" class="leftBorder topBorder rightBorder bottomBorder">&nbsp;</th>
							<th rowspan="2" class="rightBorder topBorder bottomBorder"><span>Data kontroli</span></th>
							<th rowspan="2" class="topBorder bottomBorder"><span>Nazwisko kontrolującego</span></th>
							<th colspan="<cfoutput>#ccount#</cfoutput>" class="leftBorder topBorder bottomBorder"><span>Ilość uzyskanych punktów</span></th>
							<th rowspan="2" class="leftBorder topBorder bottomBorder"><span>Ilość odjętych punktów</span></th>
							<th rowspan="2" class="leftBorder topBorder rightBorder bottomBorder"><span>Ilość uzyskanych punktów</span></th>
						</tr>
						<tr>
							<cfset nrKolumny = 0 />
							<cfoutput query="listaZagadnien">
								<cfset nrKolumny += 1 />
								<th class="leftBorder bottomBorder"><span title="#nazwazadania#">#nrKolumny#&nbsp;(#sum#)</span></th>
								<!---<th class="leftBorder bottomBorder">#nazwazadania#</th>--->
							</cfoutput>
						</tr>
					</thead>
					<tbody>
						<cfset indeks = 0 />
						<cfloop query="punktacjaAktywnosci">
							<cfset indeks += 1 />
							<tr>
								<td class="leftBorder rightBorder bottomBorder">
									<a href="javascript:void(0)" onclick="pobierzWszystkieOdpowiedziArkusza('<cfoutput>#idaktywnosci#</cfoutput>', $(this))" title="Pobierz odpowiedzi" class="extend">
										<span>&nbsp;</span>
									</a>
								</td>
								<td class="rightBorder bottomBorder r">
									<cfoutput>
										#DateFormat(datautworzenia, "yyyy/mm/dd")#
									</cfoutput>
								</td>
								<td class="bottomBorder l">
									<cfoutput>#imiepartnera# #Left(nazwiskopartnera, 1)#</cfoutput>
								</td>
								<cfset iloscPunktowUjemnych = 0 />
								<cfloop query="listaZagadnien">
									<td class="leftBorder bottomBorder r">
										<cfset iloscPunktowUjemnych += iif(Len(sum) EQ 0, 0, sum) - iif(Len(punktacjaAktywnosci["#IDDEFINICJIZADANIA#"][indeks]) EQ 0, 0, punktacjaAktywnosci["#IDDEFINICJIZADANIA#"][indeks]) />
										<cfoutput>#punktacjaAktywnosci["#IDDEFINICJIZADANIA#"][indeks]#</cfoutput>
									</td>
								</cfloop>
								<td class="leftBorder bottomBorder r"><cfoutput>#iloscPunktowUjemnych#</cfoutput></td>
								<td class="leftBorder rightBorder bottomBorder r"></td>
							</tr>
						</cfloop>
					</tbody>
				</table>
				
			</div>
		</div>
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
