<cfprocessingdirective pageencoding="utf-8" />

<cfdiv id="left_site_column">

	<div class="leftWrapper">
		<div class="headerArea">
			<div class="headerArea uiHeader">
				<h3 class="uiHeaderTitle">Zestawienie paragonów</h3>
			</div>
		</div>
		
		<div class="headerNavArea">
			<div class="headerNavArea uiHeaderNavArea">
				
				<cfform action="index.cfm?controller=paragony&action=raport"
						name="paragony_formularz_filtrowania">
					<ol class="filters" style="height:25px;line-height:25px;">
						<li><input type="radio" name="days" value="3" <cfif session.paragony.days EQ 3> checked="checked"</cfif>/> 3 dni </li>
						<li><input type="radio" name="days" value="7" <cfif session.paragony.days EQ 7> checked="checked"</cfif>/> 7 dni </li>
						<li><input type="radio" name="days" value="14" <cfif session.paragony.days EQ 14> checked="checked"</cfif>/> 14 dni </li>
						<li><input type="radio" name="days" value="0" <cfif session.paragony.days EQ 0> checked="checked"</cfif>/> wszystkie </li>
						<li><input type="submit" name="paragony_formularz_filtrowania_submit" class="admin_button green_admin_button" value="Filtruj" /> </li>
					</ol>
				</cfform>
				
			</div>
		</div>
		
		<div class="contentArea">
			<div class="contentArea uiContent">
				
				<a href="index.cfm?controller=paragony&action=xls" target="_blank">Exsport do pliku Excel</a>
				
				<table class="uiTable aosTable">
					<thead>
						<tr>
							<th rowspan="2" class="leftBorder topBorder rightBorder bottomBorder"><span>Sklep</span></th>
							<th rowspan="2" class="topBorder rightBorder bottomBorder"><span>PPS</span></th>
							<th colspan="3" class="topBorder rightBorder bottomBorder"><span>Konkurencja</span></th>
							<th rowspan="2" class="topBorder rightBorder bottomBorder"><span>Data paragonu</span></th>
							<th rowspan="2" class="topBorder rightBorder bottomBorder"><span>Ilość klientów</span></th>
						</tr>
						<tr>
							<th class="bottomBorder rightBorder"><span>Nazwa sklepu</span></th>
							<th class="bottomBorder rightBorder"><span>Miasto</span></th>
							<th class="bottomBorder rightBorder"><span>Adres</span></th>
						</tr>
					</thead>
					<tbody>
						<cfoutput query="raport">
							<tr>
								<td class="leftBorder rightBorder bottomBorder l">#login#</td>
								<td class="rightBorder bottomBorder l">#givenname# #sn#</td>
								<td class="rightBorder bottomBorder l">#nazwasklepu#</td>
								<td class="rightBorder bottomBorder l">#miasto#</td>
								<td class="rightBorder bottomBorder l">#adres#</td>
								<td class="rightBorder bottomBorder r">#DateFormat(dataparagonu, "yyyy/mm/dd")#</td>
								<td class="rightBorder bottomBorder r">#iloscklientow#</td>
							</tr>
						</cfoutput>
					</tbody>
				</table>
				
			</div>
		</div>
	</div>

</cfdiv>

<script type="text/javascript">
$(function(){
	$("table").tablesorter({selectorHeaders: '> thead > tr > th'});
});
</script>